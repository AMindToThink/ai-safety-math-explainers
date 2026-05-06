# Ch 9 — Neural Zonotope Abstraction

Companion to Albarghouthi (2021) Ch 9,
*[Neural Zonotope Abstraction](https://arxiv.org/pdf/2109.10317#page=92)*
(arXiv:2109.10317, numerical.tex). The chapter introduces the
*relational* abstract domain that fixes the path-sharing problem
flagged at the end of Ch 8: a zonotope is a center $c_0$ plus
contributions $\sum c_i \varepsilon_i$ from a shared set of
*generator variables* $\varepsilon_i \in [-1, 1]$, and propagating
zonotopes through affine layers preserves the linear relations that
intervals throw away.

## Why this chapter matters for verification

Three ideas that downstream chapters and tools depend on:

1. **Generators carry relations.** When two quantities $a$ and $b$
   are written $a = c_{a0} + c_{a1} \varepsilon_1$, $b = c_{b0} +
   c_{b1} \varepsilon_1$ with the *same* $\varepsilon_1$, the
   abstract domain remembers that $a$ and $b$ co-vary. Affine
   transformers preserve this: $a + b = (c_{a0} + c_{b0}) +
   (c_{a1} + c_{b1}) \varepsilon_1$, exact even though intervals
   would slop here.
2. **ReLU shears the box into a parallelogram.** When a ReLU is
   unstable ($l < 0 < u$), the tightest sound zonotope
   over-approximation is the parallelogram with slope $\lambda =
   u/(u - l)$ and vertical half-width $\eta = u(1 - \lambda)/2$.
   The output zonotope reuses the input generators *plus* a fresh
   one for the vertical width; reusing inputs is what makes the
   zonotope strictly more precise than the interval domain on
   any chain that passes through the unstable ReLU.
3. **Bounds are linear-time.** The upper / lower bound of a
   zonotope dimension is computed in one pass over the generator
   coefficients (set $\varepsilon_i = \mathrm{sign}(c_i)$). This is
   what makes zonotope verification GPU-friendly — the workhorse
   in the auto_LiRPA / α,β-CROWN tool family is a generalised form
   of the same idea.

## Reading order

1. **§9.1 What the heck is a zonotope?** Generators
   $\varepsilon_i \in [-1, 1]$; 1-D zonotopes are intervals; 2-D
   examples (box, line segment, parallelogram, hexagon).
2. **§9.2 Compact notation.** $(\langle c_{1i} \rangle_i,
   \ldots, \langle c_{ni} \rangle_i)$; computing per-dimension
   bounds via signs of coefficients.
3. **§9.3 Basic abstract transformers.** Addition (sum
   coefficients pointwise — exact); affine; multiplication
   (loses precision and is rare in NNs).
4. **§9.4 Activation functions.** Stable ReLUs are exact; for
   unstable ReLUs, the parallelogram with slope $\lambda$
   introduces *one new generator* per ReLU and adds a vertical
   width term $\eta$.
5. **§9.5 Abstractly interpreting neural networks.** Same
   recursion as Ch 8 with the new transformers.
6. **§9.6 Limitations.** Zonotopes are still an over-approximation
   — they are *parallel-faced* convex bodies, so they cannot
   represent non-parallel polytopes (the gap that Ch 10's
   polyhedral domain closes).

## Modules

| # | Module | Source | Status |
|---|--------|--------|--------|
| 1 | [`01-zonotope-vs-interval.html`](widgets/01-zonotope-vs-interval.html) | §9.4 (ReLU transformer) + §9.5 (network pass), illustrated by side-by-side propagation on the 2-2-1 toy net with a parallelogram visualisation in $(h_1, h_2)$-space | drafted |

## Toy system

Same 2-input, 2-hidden-ReLU, 1-output net. Input zonotope on the
$\varepsilon$-ball: $x_1 = c_1 + \varepsilon \cdot \varepsilon_1$,
$x_2 = c_2 + \varepsilon \cdot \varepsilon_2$ — two generators
shared across all subsequent computation. Affine nodes:

$$
a_1 = (c_1 + c_2) + \varepsilon \varepsilon_1 + \varepsilon \varepsilon_2,
\qquad
a_2 = (c_1 - c_2) + \varepsilon \varepsilon_1 - \varepsilon \varepsilon_2.
$$

Note that $a_1$ and $a_2$ share $\varepsilon_1$ — the relation
that intervals lost. ReLUs may add new generators
$\varepsilon_3, \varepsilon_4$ when unstable. The output:

$$
y = h_1 + h_2 = (\text{sum of centers}) + (\text{sum of generator coefficients}) \cdot (\varepsilon_1, \varepsilon_2, \varepsilon_3, \varepsilon_4).
$$

The headline observation: when both ReLUs are *stable*, the
zonotope output is exactly $y = 2 (c_1 + \varepsilon \varepsilon_1)$
because the $\varepsilon_2$ contributions cancel. Width =
$2 \cdot 2 \varepsilon = 4 \varepsilon$? No — width = $2 \cdot
\varepsilon$. (Compare Ch 8's path-sharing slop of $4 \varepsilon$
on the same input.) The widget shows this side-by-side.

## Active check

A *drag-the-ε-ball* widget (compatible with Ch 8's controls), with
two new outputs:

- A 1-D number line for $y$, showing **three** ranges stacked:
  interval bound (loosest), zonotope bound (intermediate or tight),
  true range (tightest).
- A 2-D plot in $(h_1, h_2)$-space showing the *interval
  rectangle* $[l_{h_1}, u_{h_1}] \times [l_{h_2}, u_{h_2}]$
  versus the *zonotope parallelogram* — the parallelogram is
  visibly thinner along the $h_1 = h_2$ direction whenever
  the network's path-sharing is at work.

The pedagogical reveal has *two parts*:

- **Path-sharing recovered exactly.** When both ReLUs are stable,
  the zonotope output range equals the true range — the
  $\varepsilon_2$ contributions in $h_1$ and $h_2$ cancel because
  the abstract domain remembers their relation. The interval
  domain's $4 \varepsilon$ slop on this case becomes the
  zonotope's $0$ slop. (See the &ldquo;single-region&rdquo;
  preset.)
- **Zonotopes are *incomparable* to intervals on unstable ReLUs.**
  Albarghouthi explicitly flags this in §9.4: the parallelogram
  approximation has smaller area than the interval rectangle, but
  it admits *negative* values for the ReLU output, which the
  interval pass does not. On networks where one ReLU is heavily
  asymmetric ($|l| \gg |u|$ or vice versa), the parallelogram's
  negative excursion can compound downstream and produce a
  *looser* output bound than the interval pass. The
  &ldquo;cross&rdquo; preset exhibits this — interval bound 4.0,
  zonotope bound 4.375. Real verifiers (DeepPoly, CROWN) keep
  this in mind by computing *both* and taking the intersection;
  the chapter walks the pure-zonotope version first because it
  is the cleanest entry point to relational domains, and Ch 10
  presents the polyhedral domain that subsumes both.

This decomposition is what makes the zonotope domain the entry
point — but not the endpoint — of relational neural-network
verification.
