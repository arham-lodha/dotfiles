// =============================================================================
// figures.typ — figures and diagrams for this paper
// =============================================================================
// Define figures here as #let bindings, then reference them from main.typ:
//
//   #import "figures.typ" as figs
//   #figs.commutative-square
//
// Or call them as functions if they take parameters.
// =============================================================================

#import "@local/my-prelude:1.0.0": *

// Example: a labelled figure with a caption.
// Labels live inside the content block so they survive the import.
#let commutative-square = [
  #figure(
    caption: [A commutative square.],
    rect(inset: 16pt)[
      $ mat(delim: #none,
          A, arrow.r^f, B;
          arrow.b^g, , arrow.b^h;
          C, arrow.r^k, D) $
    ],
  ) <commutative-square>
]

// Example: a function form — useful when you want to parameterize a figure.
#let triangle-diagram(caption: [A triangle.]) = figure(
  caption: caption,
  rect(inset: 16pt)[
    $ mat(delim: #none,
        A, arrow.r^f, B;
        , , arrow.b^g;
        , , C) $
  ],
)

// Add more figures below following the same pattern.
