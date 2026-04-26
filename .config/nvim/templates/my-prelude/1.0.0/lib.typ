// =============================================================================
// my-prelude — Pure-math Typst prelude (self-contained, no external deps)
// =============================================================================
// Imported in templates as:
//   #import "@local/my-prelude:1.0.0": *
//
// Provides:
//   * Theorem environments (theorem, lemma, proposition, corollary, definition,
//     example, remark, conjecture, exercise, notation) and a proof block.
//   * Number-set shortcuts (NN, ZZ, QQ, RR, CC, FF, HH, KK, ...).
//   * Common operators (Hom, End, Aut, GL, SL, ker, im, coker, span, ...).
//   * Paired delimiters (norm, abs, inner, set-builder, floor, ceil, ...).
//   * Logic shortcuts (st, To, MapsTo, into, onto, iso).
//   * Categories (Set, Grp, Ring, Mod, Top, Vect, ...).
//   * Calligraphic / Fraktur letter aliases (cA..cZ, fA..fZ).
//
// Usage in template.typ:
//   #show: thm-init  // wires up the heading-tied numbering reset
// =============================================================================

// -----------------------------------------------------------------------------
// COLORS
// -----------------------------------------------------------------------------
#let theorem-color      = rgb("#1e88e5")
#let definition-color   = rgb("#43a047")
#let lemma-color        = rgb("#5e35b1")
#let proposition-color  = rgb("#fb8c00")
#let corollary-color    = rgb("#00897b")
#let example-color      = rgb("#8e24aa")
#let remark-color       = rgb("#616161")
#let conjecture-color   = rgb("#d81b60")
#let exercise-color     = rgb("#3949ab")

// -----------------------------------------------------------------------------
// THEOREM ENVIRONMENTS
// -----------------------------------------------------------------------------
// Numbering style: <section>.<n>, e.g. "Theorem 2.3".
// Theorems, lemmas, propositions, corollaries, definitions, conjectures share
// the same counter so they're sequenced together (this is the math convention).
// Examples, remarks, exercises, and notation each get their own counter.

#let _thm-shared = counter("thm-shared")
#let _thm-example = counter("thm-example")
#let _thm-remark = counter("thm-remark")
#let _thm-exercise = counter("thm-exercise")
#let _thm-notation = counter("thm-notation")

#let _is-formal = state("my-prelude-formal", false)

// Reset the shared counter at every level-1 heading.
#let thm-init(formal: false, body) = {
  show heading.where(level: 1): it => {
    _thm-shared.update(0)
    _thm-example.update(0)
    _thm-remark.update(0)
    _thm-exercise.update(0)
    _thm-notation.update(0)
    it
  }
  _is-formal.update(formal)
  body
}

// Generic theorem block with colored frame.
// Call as either #theorem[body] or #theorem("Optional Name")[body].
// You can also pass a name via the named arg: #theorem(name: "...")[body].
#let _thm-boxed(label, color, counter-ref) = (..args) => {
  let pos = args.pos()
  let body = pos.last()
  let name = if pos.len() >= 2 { pos.at(0) } else {
    args.named().at("name", default: none)
  }
  counter-ref.step()
  let num = context {
    let h = counter(heading).at(here()).at(0, default: 0)
    let n = counter-ref.at(here()).at(0)
    [#h.#n]
  }
  context {
    if _is-formal.get() {
      block(
        width: 100%,
        breakable: true,
        inset: (top: 4pt, bottom: 4pt),
        [
          #text(weight: "bold")[#label #num]#if name != none [ #text(weight: "bold")[ (#name)]]*.* #h(0.3em)#emph(body)
        ]
      )
    } else {
      block(
        width: 100%,
        fill: color.lighten(92%),
        stroke: (left: color + 2pt),
        inset: (x: 10pt, y: 8pt),
        radius: 2pt,
        breakable: true,
        [
          #text(weight: "bold", fill: color)[#label #num]#if name != none [ #text(weight: "bold")[ (#name)]]*.* #h(0.3em)#body
        ],
      )
    }
  }
}

// Plain (un-boxed) theorem-like env — for things that don't need a frame.
#let _thm-plain(label, color, counter-ref) = (..args) => {
  let pos = args.pos()
  let body = pos.last()
  let name = if pos.len() >= 2 { pos.at(0) } else {
    args.named().at("name", default: none)
  }
  counter-ref.step()
  let num = context {
    let h = counter(heading).at(here()).at(0, default: 0)
    let n = counter-ref.at(here()).at(0)
    [#h.#n]
  }
  context {
    if _is-formal.get() {
      block(
        width: 100%,
        inset: (top: 4pt, bottom: 4pt),
        breakable: true,
        [
          #text(weight: "bold")[#label #num]#if name != none [ #text(weight: "bold")[ (#name)]]*.* #h(0.3em)#body
        ],
      )
    } else {
      block(
        width: 100%,
        inset: (top: 4pt, bottom: 4pt),
        breakable: true,
        [
          #text(weight: "bold", fill: color)[#label #num]#if name != none [ #text(weight: "bold")[ (#name)]]*.* #h(0.3em)#body
        ],
      )
    }
  }
}

#let theorem     = _thm-boxed("Theorem",     theorem-color,     _thm-shared)
#let lemma       = _thm-boxed("Lemma",       lemma-color,       _thm-shared)
#let proposition = _thm-boxed("Proposition", proposition-color, _thm-shared)
#let corollary   = _thm-boxed("Corollary",   corollary-color,   _thm-shared)
#let definition  = _thm-boxed("Definition",  definition-color,  _thm-shared)
#let conjecture  = _thm-boxed("Conjecture",  conjecture-color,  _thm-shared)

#let example  = _thm-plain("Example",  example-color,  _thm-example)
#let remark   = _thm-plain("Remark",   remark-color,   _thm-remark)
#let exercise = _thm-plain("Exercise", exercise-color, _thm-exercise)
#let notation = _thm-plain("Notation", remark-color,   _thm-notation)

// Proof environment — italic intro, QED tombstone right-aligned at end.
// Call as #proof[body] or #proof("of Lagrange's theorem")[body].
#let proof(..args) = {
  let pos = args.pos()
  let body = pos.last()
  let name = if pos.len() >= 2 { pos.at(0) } else {
    args.named().at("name", default: none)
  }
  context {
    if _is-formal.get() {
      block(
        width: 100%,
        inset: (top: 4pt, bottom: 4pt),
        breakable: true,
        [
          #emph[Proof#if name != none [ (#name)].]
          #h(0.3em)#body
          #h(1fr) #box($square.stroked$)
        ],
      )
    } else {
      block(
        width: 100%,
        inset: (top: 4pt, bottom: 4pt),
        breakable: true,
        [
          #emph[Proof#if name != none [ (#name)]:]
          #h(0.3em)#body
          #h(1fr) #box($square.stroked$)
        ],
      )
    }
  }
}


// -----------------------------------------------------------------------------
// MATH: PAIRED DELIMITERS
// -----------------------------------------------------------------------------
// Use as #abs($x$), #norm($v$), #inner($u$, $v$), #setof($x$, $P(x)$).

#let inner(u, v)  = $lr(chevron.l #u\, #v chevron.r)$
#let abr(x)       = $lr(chevron.l #x chevron.r)$    // generated by, ideal, etc.
#let setof(x, p)  = $lr({ #x : #p })$
#let pair(x, y)   = $lr(\( #x\, #y \))$
#let inv(x)       = $#x^(-1)$
#let conj(x)      = $overline(#x)$
#let cl(x)        = $overline(#x)$                  // closure
#let interior(x)  = $#x^circle.small$
#let bdry(x)      = $diff #x$
#let restr(f, A)  = $lr(#f|_(#A))$

// -----------------------------------------------------------------------------
// MATH: OPERATORS
// -----------------------------------------------------------------------------
// All declared as math.op so they typeset upright like sin, cos, log.

#let id      = math.op("id")
#let im      = math.op("im")
#let coker   = math.op("coker")
#let coim    = math.op("coim")
#let rk      = math.op("rk")
#let rank    = math.op("rank")
#let nullity = math.op("nullity")
#let sgn     = math.op("sgn")
#let tr      = math.op("tr")
#let diag    = math.op("diag")
#let supp    = math.op("supp")
#let dom     = math.op("dom")
#let codim   = math.op("codim")
#let charr   = math.op("char")
#let spann   = math.op("span")
#let ord     = math.op("ord")
#let lcm     = math.op("lcm")
#let res     = math.op("res")
#let proj    = math.op("proj")
#let ev      = math.op("ev")

// Limits (display style)
#let argmax  = math.op("arg max", limits: true)
#let argmin  = math.op("arg min", limits: true)
#let esssup  = math.op("ess sup", limits: true)
#let essinf  = math.op("ess inf", limits: true)
#let colim   = math.op("colim", limits: true)

// Algebra
#let Hom   = math.op("Hom")
#let End   = math.op("End")
#let Aut   = math.op("Aut")
#let Inn   = math.op("Inn")
#let Out   = math.op("Out")
#let Ext   = math.op("Ext")
#let Tor   = math.op("Tor")
#let Sym   = math.op("Sym")
#let Alt   = math.op("Alt")
#let Stab  = math.op("Stab")
#let Orb   = math.op("Orb")
#let Fix   = math.op("Fix")
#let Spec  = math.op("Spec")
#let Proj  = math.op("Proj")
#let Frac  = math.op("Frac")
#let Quot  = math.op("Quot")
#let Gal   = math.op("Gal")
#let GL    = math.op("GL")
#let SL    = math.op("SL")
#let PGL   = math.op("PGL")
#let PSL   = math.op("PSL")
#let SO    = math.op("SO")
#let SU    = math.op("SU")
#let Mat   = math.op("Mat")
#let Lie   = math.op("Lie")

// Topology / analysis
#let Var   = math.op("Var")
#let Cov   = math.op("Cov")
#let Cor   = math.op("Cor")
#let dist  = math.op("dist")
#let diam  = math.op("diam")
#let osc   = math.op("osc")
#let vol   = math.op("vol")
#let area  = math.op("area")
#let grad  = math.op("grad")
#let curl  = math.op("curl")
#let divv  = math.op("div")
#let Hess  = math.op("Hess")
#let Jac   = math.op("Jac")

// -----------------------------------------------------------------------------
// MATH: CATEGORIES (bold sans-serif, by tradition)
// -----------------------------------------------------------------------------
#let _cat(name) = math.bold(math.upright(name))

#let Set    = _cat("Set")
#let Grp    = _cat("Grp")
#let Ab     = _cat("Ab")
#let Ring   = _cat("Ring")
#let CRing  = _cat("CRing")
#let Field  = _cat("Field")
#let Mod    = _cat("Mod")
#let RMod   = _cat("R-Mod")
#let Vect   = _cat("Vect")
#let Top    = _cat("Top")
#let Met    = _cat("Met")
#let Meas   = _cat("Meas")
#let Ban    = _cat("Ban")
#let Hilb   = _cat("Hilb")
#let Sch    = _cat("Sch")
#let Man    = _cat("Man")
#let Sh     = _cat("Sh")
#let CCat   = _cat("Cat")

// -----------------------------------------------------------------------------
// MATH: LOGIC / SHORTHAND
// -----------------------------------------------------------------------------
#let st       = $space "s.t." space$
#let To       = math.arrow.r.long
#let MapsTo   = math.arrow.r.bar
#let into     = math.arrow.r.hook
#let onto     = math.arrow.r.twohead
#let iso      = math.tilde.equiv
#let teq      = math.colon.eq
#let dteq     = math.eq.colon

// Tensor product. Typst's symbol for ⊗ is `times.circle`; alias for readability.
#let tensor   = sym.times.circle
#let oplus    = sym.plus.circle      // ⊕
#let ominus   = sym.minus.circle     // ⊖
#let odot     = sym.dot.circle       // ⊙
#let otimes   = sym.times.circle     // ⊗ (alternate name)

// -----------------------------------------------------------------------------
// MATH: SCRIPT / CALLIGRAPHIC LETTERS  (cA..cZ)
// -----------------------------------------------------------------------------
#let cA = math.cal("A"); #let cB = math.cal("B"); #let cC = math.cal("C")
#let cD = math.cal("D"); #let cE = math.cal("E"); #let cF = math.cal("F")
#let cG = math.cal("G"); #let cH = math.cal("H"); #let cI = math.cal("I")
#let cJ = math.cal("J"); #let cK = math.cal("K"); #let cL = math.cal("L")
#let cM = math.cal("M"); #let cN = math.cal("N"); #let cO = math.cal("O")
#let cP = math.cal("P"); #let cQ = math.cal("Q"); #let cR = math.cal("R")
#let cS = math.cal("S"); #let cT = math.cal("T"); #let cU = math.cal("U")
#let cV = math.cal("V"); #let cW = math.cal("W"); #let cX = math.cal("X")
#let cY = math.cal("Y"); #let cZ = math.cal("Z")

// -----------------------------------------------------------------------------
// MATH: FRAKTUR  (fA..fZ for ideals, sheaves, Lie algebras)
// -----------------------------------------------------------------------------
#let fA = math.frak("A"); #let fB = math.frak("B"); #let fC = math.frak("C")
#let fD = math.frak("D"); #let fE = math.frak("E"); #let fF = math.frak("F")
#let fG = math.frak("g"); #let fH = math.frak("h"); #let fI = math.frak("i")
#let fM = math.frak("m"); #let fN = math.frak("n"); #let fO = math.frak("O")
#let fP = math.frak("p"); #let fQ = math.frak("q"); #let fR = math.frak("R")
#let fS = math.frak("S"); #let fT = math.frak("T"); #let fU = math.frak("U")

// -----------------------------------------------------------------------------
// HELPERS
// -----------------------------------------------------------------------------
// Soft callout (left-bar) for non-theorem highlighted text.
#let callout(title, body, color: rgb("#455a64")) = block(
  fill: color.lighten(92%),
  stroke: (left: color + 2pt),
  inset: (x: 10pt, y: 8pt),
  radius: 2pt,
  width: 100%,
  [*#title.* #body],
)

// Today's date, ISO-formatted.
#let today-iso() = datetime.today().display("[year]-[month]-[day]")
