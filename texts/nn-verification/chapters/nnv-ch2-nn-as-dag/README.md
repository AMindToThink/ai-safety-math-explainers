# Ch 2 — Neural Networks as Graphs

Companion to Albarghouthi (2021) Ch 2,
*[Neural Networks as Graphs](https://arxiv.org/pdf/2109.10317#page=15)*
(arXiv:2109.10317, semantics.tex). The chapter formalises a neural
network as a directed acyclic graph $G = (V, E)$ in which every
non-input node $v$ carries a function $f_v : \mathbb{R}^{n_v} \to
\mathbb{R}$, and the network's value at any node is given by the
recursive definition

$$
\mathrm{outs}(v) = f_v(\mathrm{outs}(v_1), \ldots, \mathrm{outs}(v_{n_v}))
$$

with $\mathrm{outs}(v_i) = x_i$ on input nodes. Affine nodes do the
linear bookkeeping; ReLU nodes inject the non-linearity that makes
verification interesting (and hard).

## Why this chapter matters for verification

Every later chapter — the MILP/SMT encodings of Part II, the
interval/zonotope/polyhedra abstract domains of Part III, the headline
adversarial-or-certificate game in Ch 10 — operates on this DAG. Three
properties of the formalism do real work downstream:

1. **Each non-input node is a function $\mathbb{R}^{n_v} \to
   \mathbb{R}$.** Verification techniques attack the network
   *node-by-node*. The SMT encoding in Ch 5 introduces one variable
   per node; the abstract-interpretation pass in Ch 8 propagates one
   bound per node.
2. **Affine and ReLU split is preserved on separate nodes.** The book
   refuses to fold the affine map into the activation. This is the
   single decision that makes the case-split structure of Reluplex
   (Ch 7) and the linear-bound construction of DeepPoly (Ch 10) clean.
3. **Networks compute piecewise-linear functions.** A ReLU network is
   a finite case-split over linear pieces, indexed by the activation
   pattern of every ReLU. The verification problem reduces to
   reasoning about that case-split.

## Reading order

1. **§2.1 The neural building blocks.** Affine nodes vs. activation
   nodes; ReLU and sigmoid; why we keep them on separate nodes.
2. **§2.2 Layers and layers and layers.** MLP architecture; softmax
   and `class(·)` for classifiers.
3. **§2.3 Convolutional layers.** Kernel-as-shared-node intuition.
   (Skim — verification literature treats CNNs as MLPs with extra
   structure; nothing here changes the formalism.)
4. **§2.4 Where are the loops?** RNNs as unrolled DAGs. Sets up the
   "feed-forward only" scope of Parts II–III.
5. **§2.5 Structure and semantics of neural networks.** The formal
   DAG definition: $G = (V, E)$, input/output node sets, structural
   well-formedness conditions, and the recursive `outs(·)` semantics.
   This is the load-bearing section.
6. **§2.6 Properties of functions.** Differentiability,
   piecewise-linearity, monotonicity. The properties that downstream
   verifiers exploit.

## Modules

| # | Module | Source | Status |
|---|--------|--------|--------|
| 1 | [`01-construct-the-dag.html`](widgets/01-construct-the-dag.html) | §2.5 (DAG semantics) + §2.6 (piecewise-linearity), specialised to the canonical 2-2-1 ReLU toy network | drafted |

## Toy system

The chapter pins down a single network that every later chapter
reuses. Two input nodes $x_1, x_2$; two affine hidden nodes
$a_1, a_2$ feeding into two ReLU nodes $h_1 = \mathrm{ReLU}(a_1)$,
$h_2 = \mathrm{ReLU}(a_2)$; one affine output node $y$:

$$
\begin{aligned}
a_1 &= \phantom{-}1 \cdot x_1 + 1 \cdot x_2 + 0, &
h_1 &= \mathrm{ReLU}(a_1), \\
a_2 &= \phantom{-}1 \cdot x_1 - 1 \cdot x_2 + 0, &
h_2 &= \mathrm{ReLU}(a_2), \\
y   &= 1 \cdot h_1 + 1 \cdot h_2 + 0.
\end{aligned}
$$

This network computes $y(x_1, x_2) = \mathrm{ReLU}(x_1 + x_2) +
\mathrm{ReLU}(x_1 - x_2)$ — equal to $|x_1| + |x_2|$ when $x_1 \ge 0$
and to $|x_1 - x_2|$ in two of the four ReLU activation regions, etc.
It is the smallest network that

- exhibits genuine 2-D piecewise-linearity (four pieces, one per
  ReLU activation pattern),
- has a visualisable input space (so $\varepsilon$-balls are drawable),
- supports the full Part-III pipeline (intervals, zonotopes, polyhedra
  all give *different* answers on it), and
- supports a non-trivial adversarial-or-certificate game (Ch 10).

## Active check

The widget is a *construct-the-DAG* exercise. The reader is shown the
target piecewise-linear function as a heatmap on the 2-D input
$[-2, 2]^2$ and asked to recover the network: pick the two affine
weight-vectors for the hidden layer and the output mixing
coefficients. The site evaluates `outs(·)` on a fine grid and grades
by whether the reader's network agrees with the target on every grid
point (up to floating-point tolerance).

The grading is deliberately *constructive*, matching the verification
chapters that follow: the reader does not pick from a list, they
build the function and the site checks it.
