# Ch 8 — Neural Interval Abstraction

Companion to Albarghouthi (2021) Ch 8,
*[Neural Interval Abstraction](https://arxiv.org/pdf/2109.10317#page=80)*
(arXiv:2109.10317, absint.tex). The chapter opens Part III: instead
of asking *the exact question* "does the network ever output a value
violating $Q$ on inputs satisfying $P$?", we ask a *cheaper* question
on an over-approximation. The interval abstract domain is the
simplest such over-approximation — every quantity is tracked by a
real-valued box $[l, u]$ — and it is the one every other Part III
domain inherits from.

## Why this chapter matters for verification

Part II's constraint-based pipeline is exact but expensive: $2^k$
worst-case ReLU case-splits. Part III trades exactness for
parallelism: an abstract pass through the network costs the same as
two forward passes (one for lower bounds, one for upper bounds),
which is hugely faster but produces a *superset* of true output
values. Three load-bearing facts:

1. **Soundness.** For any abstract transformer $f^a$ and any input
   set $S$ representable in the domain, $f^s(S) \subseteq f^a(S)$.
   Soundness is one-directional: certified robustness from the
   abstract pass really holds; refuted robustness might be a
   false positive.
2. **The abstract transformer compiles.** Affine nodes propagate
   intervals via $[l_i', u_i']$ with $l_i' = \min(c_i l_i, c_i u_i)$
   etc.; ReLU (monotone) propagates as $[\mathrm{ReLU}(l),
   \mathrm{ReLU}(u)]$. Composition gives a node-by-node pass over
   the network.
3. **Intervals lose relations.** The interval domain is *non-relational*:
   it cannot represent $\{(x, x) : x \in [0, 1]\}$ except as the
   square $[0, 1]^2$. The two pathological networks in §8.4
   ($f(x) = x + (-x)$ that should output $\{0\}$ but
   over-approximates to $[-1, 1]$, and the "branching"
   network that emits $(x, x)$ approximated as $[0, 1]^2$) are the
   warning signs that motivate Ch 9 (zonotopes) and Ch 10 (polyhedra).

## Reading order

1. **§8.1 Set semantics and verification.** The lifting $f^s :
   \mathcal{P}(\mathbb{R}^n) \to \mathcal{P}(\mathbb{R}^m)$ and
   why we cannot compute it directly.
2. **§8.2 The interval domain.** Concrete vs. abstract
   transformers; soundness; the (in)equality
   $f^s([l, u]) \subseteq f^a([l, u])$; non-relational
   limitation.
3. **§8.3 Basic abstract transformers.** Addition (cleanly tight);
   multiplication ($\min, \max$ over the four corners — the first
   place precision is lost when signs straddle).
4. **§8.4 General abstract transformers.** Affine; monotonic
   activations $f^a([l, u]) = [f(l), f(u)]$; composition.
5. **§8.5 Abstractly interpreting neural networks.** Recursive
   `outs^a(v)` — the same recursion as Ch 2's concrete `outs(v)`
   but lifted to intervals.
6. **§8.6 Limitations.** The two pathological examples that
   motivate Ch 9–10.

## Modules

| # | Module | Source | Status |
|---|--------|--------|--------|
| 1 | [`01-interval-propagation.html`](widgets/01-interval-propagation.html) | §8.5 (network interpretation), illustrated on the 2-2-1 toy net with a draggable ε-ball; §8.6 limitations made tangible by side-by-side comparison with the true output range | drafted |

## Toy system

The canonical 2-input, 2-hidden-ReLU, 1-output network from Ch 2.
The interval pass produces, for each node, an interval
$[l_v, u_v]$ obtained by composing per-operation transformers:

- $a_1 = x_1 + x_2$: $[\,l_{x_1} + l_{x_2}, \;u_{x_1} + u_{x_2}\,]$.
- $a_2 = x_1 - x_2$: $[\,l_{x_1} - u_{x_2}, \;u_{x_1} - l_{x_2}\,]$.
- $h_1 = \mathrm{ReLU}(a_1)$: $[\,\max(l_{a_1}, 0), \;\max(u_{a_1}, 0)\,]$.
  When $l_{a_1} < 0 < u_{a_1}$ — *the unstable case* — the lower
  bound is forced to $0$; this is where intervals diverge from the
  exact answer.
- $h_2$: same shape.
- $y = h_1 + h_2$: addition transformer, sum of bounds.

The chapter's headline pathology — that intervals over-approximate
because they cannot track the relation between two propagated
quantities — appears as a measurable gap whenever an
$\varepsilon$-ball straddles either ReLU activation boundary
$x_1 + x_2 = 0$ or $x_1 - x_2 = 0$.

## Active check

A *drag-the-ε-ball* widget. Move the anchor of an
$\ell_\infty$ ball over the input plane; the site:

1. Re-runs interval propagation through every node and prints
   $[l_v, u_v]$ on each edge of the DAG.
2. Re-samples the true output range $[\min y, \max y]$ over the
   ball on a fine grid.
3. Draws both intervals on a 1-D number line so the
   overapproximation gap (interval-bound width minus true-range
   width) is visible at a glance.

The pedagogical reveal: the gap has *two* sources, both visible
in the widget:

1. **Path-sharing.** Even when both ReLUs are stable (so the
   network is locally a single linear function $y = 2 x_1$),
   intervals widen the bound from the true width $2\,\varepsilon$
   to $4\,\varepsilon$. The interval pass cannot represent the
   fact that $h_1$ and $h_2$ both depend on $x_1$ with coefficient
   $+1$; it adds their widths instead of cancelling them. This is
   exactly Albarghouthi's $f(x) = x + (-x)$ pathology in §8.6,
   which over-approximates to $[-2\varepsilon, 2\varepsilon]$
   instead of $\{0\}$.
2. **Unstable ReLUs.** When $a_j$ straddles $0$, the abstract
   ReLU $[\max(l, 0), \max(u, 0)]$ promotes the lower bound to
   $0$ even though most points in the box give a non-zero output,
   widening the interval by roughly $|l|$ each.

That is why Ch 9 (zonotopes) and Ch 10 (polyhedra) buy precision
by tracking *linear combinations* across the boundary instead of
independent intervals: zonotopes fix path-sharing exactly;
polyhedra additionally tighten the unstable-ReLU relaxation.
