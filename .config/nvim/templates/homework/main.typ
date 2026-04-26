#import "template.typ": *

#show: homework.with(
  course: "{{COURSE}}",
  assignment: "{{TITLE}}",
  name: "{{AUTHOR}}",
  due: "{{DATE}}",
)

#problem[
  Show that every subgroup of a cyclic group is cyclic.
]

#solution[
  Let $G = abr(g)$ be cyclic and $H <= G$. If $H = {e}$ we are done; otherwise
  let $m = min { k > 0 : g^k in H }$. Then $abr(g^m) subset.eq H$, and for any
  $g^n in H$ writing $n = q m + r$ with $0 <= r < m$ forces $r = 0$ by
  minimality. Hence $H = abr(g^m)$.
]

#problem("Lagrange's Theorem")[
  Prove that the order of any subgroup of a finite group divides the order of
  the group.
]

#solution[
  The cosets $g H$ partition $G$ and each has size $abs(H)$, so
  $abs(G) = [G : H] dot abs(H)$. #h(1fr)
]

#problem[
  Let $V, W$ be finite-dimensional vector spaces. Prove the following:
  #part[$dim Hom(V, W) = (dim V)(dim W)$.]
  #part[$Hom(V, W) iso V^* tensor W$ as vector spaces.]
  #part[The isomorphism in part (b) is natural in both arguments.]
]

#solution[
  *(a)* Choose bases of $V$ and $W$; matrix entries give the count.

  *(b)* Map $f tensor w mapsto (v mapsto f(v) w)$ and check it is bijective.

  *(c)* Naturality follows from chasing the diagram on basis elements.
]

#problem[
  Compute $Aut(ZZ slash 8 ZZ)$ explicitly.
]

#solution[
  Automorphisms are determined by $1 mapsto a$ for $a in (ZZ slash 8 ZZ)^times$,
  giving $Aut(ZZ slash 8 ZZ) iso (ZZ slash 8 ZZ)^times = {1, 3, 5, 7}$, the
  Klein four-group.
]
