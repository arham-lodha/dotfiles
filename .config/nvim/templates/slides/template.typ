// =============================================================================
// Slides template — self-contained math presentation deck (16:9)
// =============================================================================
// Lightweight beamer-style slides with section dividers and a title slide.
// No external dependencies; uses our prelude for theorem environments.
//
// Usage:
//   #import "template.typ": *
//   #show: slides.with(
//     title: "On Finite Groups",
//     subtitle: "An invitation",
//     author: "Arham Lodha",
//     affiliation: "Your Institution",
//     date: datetime.today(),
//   )
//
//   #section("Preliminaries")
//   #slide("Definitions")[
//     #definition("Group")[ ... ]
//   ]
// =============================================================================

#import "@local/my-prelude:1.0.0": *

#let _accent = rgb("#1e88e5")

#let slides(
  title: "Untitled Talk",
  subtitle: none,
  author: "Arham Lodha",
  affiliation: none,
  formal: false,
  date: datetime.today(),
  body,
) = {
  set document(title: title, author: author)

  // 16:9 aspect ratio at 720px height-equivalent.
  set page(
    paper: "presentation-16-9",
    margin: (x: 0.6in, y: 0.6in),
    fill: white,
    header: context {
      let p = counter(page).get().first()
      if p > 1 [
        #set text(size: 9pt, fill: rgb("#888"))
        #title #h(1fr) #author #h(0.6em) #sym.bullet #h(0.6em) #counter(page).display() / #context counter(page).final().first()
      ]
    },
  )

  set text(
    font: ("New Computer Modern Sans", "Inter", "Helvetica", "Arial"),
    size: 22pt,
    lang: "en",
  )
  show math.equation: set text(font: ("New Computer Modern Math", "Latin Modern Math"))
  set par(leading: 0.7em)

  show heading.where(level: 1): it => block(below: 0.7em)[
    #text(size: 28pt, weight: 700, fill: _accent, it.body)
    #v(-0.3em)
    #line(length: 100%, stroke: 1.5pt + _accent)
  ]

  show: thm-init.with(formal: formal)

  // ---- Title slide ----
  page(numbering: none, header: none)[
    #v(2fr)
    #align(center)[
      #text(size: 36pt, weight: 700, fill: _accent, title)
      #v(0.4em)
      #if subtitle != none [
        #text(size: 22pt, emph(subtitle))
        #v(0.6em)
      ]
      #text(size: 20pt, author)
      #v(0.1em)
      #if affiliation != none [
        #text(size: 16pt, fill: rgb("#666"), affiliation)
        #v(0.4em)
      ]
      #text(size: 14pt, fill: rgb("#888"), date.display("[month repr:long] [day], [year]"))
    ]
    #v(2fr)
  ]

  body
}

// A single content slide. Title is optional.
#let slide(title, body) = {
  pagebreak(weak: true)
  if title != none and title != "" {
    heading(level: 1, title)
  }
  body
}

// A divider between major sections of the talk.
#let section(title, subtitle: none) = {
  pagebreak(weak: true)
  page(header: none, fill: _accent)[
    #set text(fill: white)
    #v(2fr)
    #align(center)[
      #text(size: 38pt, weight: 700, title)
      #if subtitle != none [
        #v(0.3em)
        #text(size: 22pt, emph(subtitle))
      ]
    ]
    #v(2fr)
  ]
}
