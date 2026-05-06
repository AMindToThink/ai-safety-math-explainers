# Ch 10 — Neural Polyhedron Abstraction (DeepPoly)

Companion to Albarghouthi (2021) Ch 10,
*[Neural Polyhedron Abstraction](https://arxiv.org/pdf/2109.10317#page=104)*
(arXiv:2109.10317, polyhedra.tex). The chapter introduces the
*polyhedral* abstract domain — every quantity carries a system of
linear inequalities relating it to fresh and shared generator
variables. For ReLU, the polyhedral domain admits the *triangle
relaxation* that is the most precise sound convex over-approximation
on a single unstable unit.

This is the **headline chapter**. The polyhedral domain is what
DeepPoly (Singh et al., POPL 2019), CROWN (Zhang et al., NeurIPS
2018), and α,β-CROWN propagate; the triangle relaxation is the
&ldquo;LP relaxation of the convex outer adversarial polytope&rdquo;
of Wong & Kolter (ICML 2018). The active check below is the
companion's *headline* widget: an
*adversarial-or-certificate verification game*.

## Why this chapter matters for verification

Three load-bearing improvements over Ch 8/9:

1. **Triangle relaxation for ReLU.** When $a$ has bounds
   $l < 0 < u$, the DeepPoly relaxation is
   $h \ge 0$, $h \ge a$, $h \le \frac{u}{u - l}(a - l)$.
   The first two are *exact*: $\mathrm{ReLU}$'s output is
   $\ge 0$ and $\ge a$ on the unstable region. The third is the
   tightest linear *upper* bound. The triangle is the smallest
   convex polyhedron that contains the ReLU graph on $[l, u]$,
   and tightening any further loses convexity (e.g., curving the
   top face inward).
2. **Affine layers compose by substitution.** The polyhedral
   domain *back-substitutes* affine layers symbolically: an
   affine $y = w \cdot h + b$ written in terms of $h$, then
   substitute the $h$-bounds back into $y$, gives a tighter
   linear bound on $y$ than the per-node interval/zonotope
   passes. This is the &ldquo;reverse-mode CROWN&rdquo; idea — the
   cheap matrix-vector workhorse of α,β-CROWN.
3. **Bounds are LP-feasibility checks.** Computing
   $\min$/$\max$ of an output dimension over the polyhedron is
   linear programming. For the toy net here we only have at most
   four generators, so we can solve LPs by enumerating polytope
   vertices analytically — but at scale (thousands of ReLUs) you
   need a proper LP solver, which is where Marabou/MILP and
   α,β-CROWN's branch-and-bound come in.

## Reading order

1. **§10.1 Convex polyhedra.** Generalising zonotopes to allow
   arbitrary linear constraints over generators; the triangle
   shape that approximates ReLU on $[l, u]$.
2. **§10.2 Computing upper and lower bounds.** Bounds are LP
   problems on the constraint system — polynomial time but no
   longer linear-time as in zonotopes.
3. **§10.3 Abstract transformers.** Affine (same as zonotope, but
   now the constraint set $\varphi$ travels along); ReLU
   triangle (three new constraints per unstable unit).
4. **§10.4 Abstractly interpreting neural networks.** Same
   recursion as Ch 8/9, but conjoining constraints across
   incoming edges so multi-input nodes preserve the relation
   between their incoming polyhedra.

## Modules

| # | Module | Source | Status |
|---|--------|--------|--------|
| 1 | [`01-adversarial-or-certificate.html`](widgets/01-adversarial-or-certificate.html) | §10.3 (ReLU triangle) + §10.4 (network pass), realised as the verification arena | drafted |

## Toy system

Same 2-input, 2-hidden-ReLU, 1-output net. The polyhedral
abstract pass produces, for each unstable ReLU, the three
constraints from §10.3, and back-substitution then yields a
single *certified linear upper bound* on $y$ as a function of
$x_1, x_2$ — valid over the entire $\varepsilon$-ball. The max
of that linear bound over the box is then a closed-form
certified upper bound on $y$.

For the toy net, with $a_1 = x_1 + x_2$ and $a_2 = x_1 - x_2$:

- If both ReLUs are stable on the box, the certified upper bound
  on $y$ is *exact* — same as true.
- If one or both are unstable, the certified bound uses
  $\lambda_j = u_{a_j} / (u_{a_j} - l_{a_j})$ as the slope of the
  triangle's top face, giving
  $\bar y(x_1, x_2) = \sum_j \lambda_j (a_j(x_1, x_2) - l_{a_j})$,
  whose max over the box is computed analytically.

This polyhedral upper bound is *strictly tighter* than the zonotope
bound in §9.4 on the &ldquo;cross&rdquo; preset that broke the
zonotope domain — because the triangle excludes negative ReLU
outputs that the zonotope parallelogram admitted.

## Active check — the headline game

A *verification arena* with two interaction modes available
simultaneously:

- **Attacker.** Drag a marker in the input plane. The marker is
  constrained to the $\varepsilon$-ball. The site shows the
  network's $y$ at the marker. If $y > M$, the marker is a
  concrete adversary and the spec is *refuted*.
- **Defender.** The site continuously displays the DeepPoly
  certified upper bound $\bar y_{\text{poly}}$ on $y$ over the
  whole ball. If $\bar y_{\text{poly}} \le M$, the spec is
  *certified*: no adversary exists, period.

The site shows three numbers — current $y$ at the marker,
$\bar y_{\text{poly}}$ (the certificate), and $M$ (the threshold)
— and reports a verdict from $\{$refuted, certified,
inconclusive$\}$. The third option matters: when the polyhedral
bound is loose enough that $\bar y_{\text{poly}} > M$ but no
attacker has found a counterexample, neither side has won. This
is the *real* state of practical verifiers — neither
&ldquo;robust&rdquo; nor &ldquo;non-robust&rdquo; but
&ldquo;sound bounds say maybe.&rdquo; α,β-CROWN's branch-and-bound
loop is built precisely to drive this case to a decision by
splitting unstable ReLUs.

The widget closes Part III as Ch 5 closed Part II: a single
arena where the reader sees the trade-offs of the entire chapter
play out in seconds of clicking.
