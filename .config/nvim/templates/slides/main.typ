#import "template.typ": *

#show: slides.with(
  title: "{{TITLE}}",
  subtitle: "An invitation",
  author: "{{AUTHOR}}",
  affiliation: "Your Institution",
)

#section("Preliminaries")

#slide("Setting the stage")[
  Today's question:

  #v(0.5em)
  #align(center)[
    *What can we say about finite groups by counting?*
  ]

  #v(1em)
  Throughout, $G$ is a finite group and $abs(G) = n$.
]

#slide("A first definition")[
  #definition("Group action")[
    A *group action* of $G$ on a set $X$ is a homomorphism
    $rho: G arrow.r Sym(X)$.
  ]

  #v(0.4em)
  Equivalently, a map $G times X arrow.r X$ satisfying:
  - $e dot x = x$
  - $(g h) dot x = g dot (h dot x)$
]

#section("Main results")

#slide("Lagrange's theorem")[
  #theorem("Lagrange")[
    If $H <= G$ is a subgroup of a finite group $G$, then $abs(H)$ divides $abs(G)$.
  ]

  #v(0.6em)
  *Strategy.* The cosets of $H$ partition $G$ into pieces of size $abs(H)$.
]

#slide("Cauchy's theorem")[
  #theorem("Cauchy")[
    If $p$ is a prime dividing $abs(G)$, then $G$ contains an element of order $p$.
  ]

  #v(0.5em)
  Counts of fixed points under a clever $ZZ slash p$-action do the trick.
]

#section("Closing")

#slide("Takeaways")[
  - Counting cosets is the start of group theory.
  - Sylow's theorems generalize Cauchy.
  - Representation theory is "linearized" group theory.
]

#slide(none)[
  #v(2fr)
  #align(center)[
    #text(size: 48pt, weight: 700)[Thank you.]
    #v(0.5em)
    #text(size: 18pt, fill: rgb("#666"))[Questions?]
  ]
  #v(2fr)
]
