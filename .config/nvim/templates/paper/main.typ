#import "template.typ": *
#import "figures.typ" as figs

#show: paper.with(
  title: "{{TITLE}}",
  authors: (
    (name: "{{AUTHOR}}", affiliation: "Your Institution", email: "you@example.com"),
  ),
  abstract: [
    Write your abstract here. State the problem, the contribution, and the
    main result in 4–8 sentences.
  ],
  keywords: ("keyword1", "keyword2"),
  bibliography-file: "refs.bib",
)

= Introduction

Open with motivation and context. Reference earlier work like @doe2020 and
state the contributions of this paper.

= Preliminaries

#definition("Group")[
  A *group* $(G, dot)$ is a set with a binary operation that is associative,
  has an identity element, and has inverses.
]

#notation[
  Throughout, $G$ denotes a finite group, and all rings are commutative
  with unity.
]

= Main Results

#theorem("Main")[
  Let $G$ be a finite group of order $n$. Then for every prime $p$ dividing $n$,
  there exists an element of order $p$ in $G$.
]

#proof[
  Sketch the proof here. Use full sentences and label numbered equations:
  $ sum_(g in G) chi(g) = abs(G) dot.c [chi : 1]. $ <main-eq>
  See @commutative-square for an illustration of the relevant diagram.
]

#figs.commutative-square

#corollary[A direct consequence of the main theorem.]

#lemma[A useful intermediate result.]

#proof[Brief justification. #h(1fr)]

= Examples and Discussion

#example[
  Take $G = ZZ slash 6 ZZ$. Then $G$ has elements of order $2$ and $3$,
  illustrating the theorem.
]

#remark[A side observation that didn't fit in the main flow.]

= Conclusion

Summarize and point to future directions.
