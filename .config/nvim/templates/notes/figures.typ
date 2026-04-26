// =============================================================================
// figures.typ — figures and diagrams for these notes
// =============================================================================

#import "@local/my-prelude:1.0.0": *

// A simple labelled figure example.
#let example-square = [
  #figure(
    caption: [A commutative square.],
    rect(inset: 16pt)[
      $ mat(delim: #none,
          A, arrow.r^f, B;
          arrow.b^g, , arrow.b^h;
          C, arrow.r^k, D) $
    ],
  ) <example-square>
]

// Add more figures below.
