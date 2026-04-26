#import "template.typ": *
#import "figures.typ" as figs

#show: notes.with(
  title: "{{TITLE}}",
  author: "{{AUTHOR}}",
  course: "Course Name and Number",
  instructor: "Prof. Instructor",
  bibliography-file: "refs.bib",
)

= Preliminaries

These notes follow the lectures of Prof. Instructor in the Spring 2026 term.
All errors are my own; corrections welcome.

== Conventions

#notation[
  All groups are written multiplicatively unless otherwise specified.
  Rings are commutative with unity.
]

== Prerequisites

Familiarity with basic point-set topology and linear algebra is assumed.

= First Topic

== Definitions and basic properties

#definition("Topological space")[
  A *topological space* is a pair $(X, tau)$ where $tau subset.eq cP(X)$ is
  closed under arbitrary unions, finite intersections, and contains both
  $emptyset$ and $X$.
]

#example[
  $(RR, tau_"std")$ where $tau_"std"$ is the collection of unions of open
  intervals.
]

== A first theorem

#theorem("Tube lemma")[
  Let $X$ be any space and $Y$ compact. If $N subset.eq X times Y$ is open
  and contains the slice $\{x_0\} times Y$, then $N$ contains a tube
  $U times Y$ for some open $U in.rev x_0$.
]

#proof[
  For each $y in Y$, choose a basic open $U_y times V_y subset.eq N$
  containing $(x_0, y)$. By compactness of $Y$ extract a finite subcover
  $\{V_(y_1), dots, V_(y_n)\}$ and set $U = sect.big_(i=1)^n U_(y_i)$.
  Then $U times Y subset.eq N$.
]

#corollary[The product of finitely many compact spaces is compact.]

== Examples and exercises

#exercise[
  Prove that the projection $pi: X times Y -> X$ is a closed map whenever
  $Y$ is compact.
]

#exercise[
  Find a non-Hausdorff space in which singletons are not closed.
]

= Second Topic

#remark[
  Each chapter starts on a new page automatically thanks to the template's
  level-1 heading rule. The shared theorem counter restarts as well, so this
  chapter's first theorem will be numbered $2.1$.
]

#proposition[Statement of a result in chapter 2.]

#proof[Argument. #h(1fr)]
