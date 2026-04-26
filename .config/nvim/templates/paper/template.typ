// =============================================================================
// Paper / Article template
// =============================================================================
// Usage in main.typ:
//   #import "template.typ": *
//   #show: paper.with(
//     title: "Your Title",
//     authors: ((name: "Arham Lodha", affiliation: "...", email: "...")),
//     abstract: [Your abstract...],
//     bibliography-file: "refs.bib",
//   )
// =============================================================================

// Re-exports the prelude so main.typ only needs to import this template file.
#import "@local/my-prelude:1.0.0": *

#let paper(
  title: "Untitled Paper",
  authors: (("Arham Lodha"),),
  abstract: none,
  keywords: (),
  formal: false,
  date: datetime.today(),
  bibliography-file: none,
  body,
) = {
  // ---- Document metadata ----
  set document(title: title, author: authors.map(a => if type(a) == dictionary { a.name } else { a }))

  // ---- Page setup ----
  set page(
    paper: "us-letter",
    margin: (x: 1.25in, y: 1in),
    numbering: "1",
    number-align: center,
  )

  // ---- Typography ----
  // New Computer Modern is bundled with Typst; the rest are graceful fallbacks
  // if it's ever unavailable.
  set text(
    font: ("New Computer Modern", "Latin Modern Roman", "Libertinus Serif"),
    size: 11pt,
    lang: "en",
  )
  show math.equation: set text(font: ("New Computer Modern Math", "Latin Modern Math"))
  set par(justify: true, leading: 0.7em, first-line-indent: 1.5em)
  show heading: set block(above: 1.4em, below: 0.8em)
  set heading(numbering: "1.1")

  // ---- Theorem counter reset ----
  show: thm-init.with(formal: formal)

  // ---- Title block ----
  align(center)[
    #block(text(weight: 700, size: 18pt, title))
    #v(0.5em)
    #block(text(size: 10.5pt)[
      #authors.map(a => {
        if type(a) == dictionary {
          let line = strong(a.at("name", default: ""))
          if "affiliation" in a [#line \ #emph(a.affiliation)]
          else { line }
          if "email" in a [\ #raw(a.email)]
        } else {
          strong(a)
        }
      }).join(h(2em))
    ])
    #v(0.4em)
    #text(size: 10pt, date.display("[month repr:long] [day], [year]"))
  ]

  v(1em)

  // ---- Abstract ----
  if abstract != none {
    align(center)[
      #block(width: 85%)[
        #align(left)[
          #text(weight: "bold")[Abstract.] #abstract
        ]
      ]
    ]
    v(1em)
  }

  // ---- Keywords ----
  if keywords.len() > 0 {
    align(center)[
      #text(size: 10pt)[*Keywords:* #keywords.join(", ")]
    ]
    v(0.5em)
  }

  // ---- Body ----
  body

  // ---- Bibliography ----
  if bibliography-file != none {
    pagebreak(weak: true)
    bibliography(bibliography-file, title: "References", style: "ieee")
  }
}
