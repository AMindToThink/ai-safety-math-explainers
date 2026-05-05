# DSLT 1 — The RLCT measures the effective dimension of neural networks

Chapter companion to Liam Carroll's
[**DSLT 1**](https://www.alignmentforum.org/posts/4eZtmwaqhAgdJQDEg/dslt-1-the-rlct-measures-the-effective-dimension-of-neural)
(Alignment Forum, 2023-06-17). Cross-references Carroll's
[MSc thesis](http://therisingsea.org/notes/MSc-Carroll.pdf) Chapter 2
for the full formal setup, and Watanabe (2009),
*Algebraic Geometry and Statistical Learning Theory*, Chapter 1, for
the underlying SLT theorems (Theorems 6.1, 7.1, 7.2 specifically).

## What this chapter is for

The chapter introduces the **Real Log Canonical Threshold** (RLCT,
$\lambda$), which generalises classical "dimension" to singular models
and is the central invariant of singular learning theory. Concretely
the chapter explains:

1. The Bayesian setup of SLT — the loss landscape $K(w)$, the set of
   true parameters $W_0$, the posterior, the partition function, the
   free energy.
2. Why classical Bayesian inference (asymptotic normality, the BIC)
   *breaks* when the Fisher information is degenerate, and why this
   is the rule rather than the exception for neural networks.
3. The geometric definition of the RLCT as a volume-scaling exponent:
   $V(\varepsilon) \propto \varepsilon^\lambda$ near a singularity.
4. How to read off $\lambda$ when $K(w)$ is in normal-crossing form,
   and how Hironaka's resolution of singularities lets us put any
   analytic $K$ into that form.
5. The free-energy correction
   $F_n = n L_n(w_0) + \lambda \log n + \cdots$ (the WBIC), in which
   $\lambda$ replaces $d/2$.

## Toy system

A family of real polynomial loss landscapes drawn from Carroll's
worked examples in DSLT 1 (and DSLT 2 §Example 1):

- $K(w) = w^2$ — the regular reference.
- $K(w) = w^4$ — same zero set, fractional dimension $2\lambda = 1/2$.
- $K(w_1, w_2) = w_1^2$ — Carroll Example 1.1, "minimally singular."
- $K(w_1, w_2) = \tfrac{1}{2}\, w_1^2 w_2^2$ — Carroll Example 1.2,
  the canonical non-trivial singularity.
- $K(w_1, w_2) = (w_1 + 1)^2\, w_1^4\, w_2^2$ — Carroll Example 1.5,
  multiple components meeting at distinct singular points.
- $K(w) = (w + 1)^2 (w - 1)^4$ — DSLT 2 §Example 1, the running
  example for the "lower RLCT wins" punchline that DSLT 1 sets up.

A 1-hidden-unit ReLU regressor appears as a forward-pointer in
`dslt1-fisher-degeneracy` so that the chapter connects to DSLT 3's
neural-network classification, but the core widgets stay in the
polynomial family for clarity.

## Modules

Status definitions match `texts/slt/NOTES.md`:

| # | Slug | Status |
|---|------|--------|
| 1 | [`dslt1-bayes-loss-landscape`](widgets/01-bayes-loss-landscape.html) | drafted |
| 2 | [`dslt1-singular-posterior`](widgets/02-singular-posterior.html) | drafted |
| 3 | [`dslt1-fisher-degeneracy`](widgets/03-fisher-degeneracy.html) | drafted |
| 4 | `dslt1-bic-derivation` | not started |
| 5 | `dslt1-volume-scaling-rlct` | not started |
| 6 | `dslt1-normal-crossing-game` | not started |
| 7 | `dslt1-resolution-primer` | not started |
| 8 | `dslt1-wbic-vs-bic` | not started |

See `texts/slt/NOTES.md` for the full breakdown table with toy systems
and active checks.

### Module 1 — `dslt1-bayes-loss-landscape`

[`widgets/01-bayes-loss-landscape.html`](widgets/01-bayes-loss-landscape.html)
is a single-file standalone widget (D3 + KaTeX from CDN; just open it
in a browser). It introduces $K(w)$ as the loss landscape and $W_0$ as
its zero set, walks the reader through seven worked examples (four 2D,
three 1D), and asks for a topology prediction on each. The reveal
explains the local form of $K$ near each singularity and quotes the
local RLCT, foreshadowing modules 5–6.

What this widget does *not* do (deliberately): it does not yet show
the posterior $p(w \mid D_n)$, the volume integral $V(\varepsilon)$,
or the free-energy formula. The posterior lands in module 2; the
volume integral and free-energy formula in modules 5 and 8.

### Module 2 — `dslt1-singular-posterior`

[`widgets/02-singular-posterior.html`](widgets/02-singular-posterior.html)
is the visceral "this is not your textbook Bayesian setting" widget.
Same toy K family as module 1, but the plot now shows
$p(w \mid D_n) \propto \varphi(w)\, e^{-n K(w)}$ (true mass-normalised
density in 1D, peak-normalised heatmap in 2D), with an interactive
slider on $n$. As $n$ grows, the regular cases collapse to a Gaussian;
the singular cases trail along $W_0$, refuse to be Gaussian, and (for
$K = (w+1)^2 (w-1)^4$) shift their mass toward the lower-RLCT zero,
with explicit $P(\text{near}\,\pm 1)$ readouts that converge to the
DSLT 2 §Animation 1 result of ${\sim}0.95$ vs ${\sim}0.05$.

The active check asks the reader to predict the asymptotic posterior
shape for each preset *before* dragging $n$ to the asymptote and
checking. The reveal text explains why each case behaves as it
does in terms of local RLCT.

### Module 3 — `dslt1-fisher-degeneracy`

[`widgets/03-fisher-degeneracy.html`](widgets/03-fisher-degeneracy.html)
makes the operational definition of "singular" tangible. The reader
picks a $K$ and a true parameter $w^{(0)} \in W_0$, predicts
$\mathrm{rank}(I(w^{(0)}))$, then sees the Hessian computed
symbolically, eigenvalues + determinant + rank reported, and a
*Fisher level set* drawn over the contours: a small ellipse for
positive-definite $I$, a degenerate strip for rank&nbsp;1, and an
empty plane for rank&nbsp;0.

The pedagogical fulcrum is Carroll Example 1.2: at $(0, 0)$ for
$K = \tfrac{1}{2}\, w_1^2 w_2^2$, every second derivative vanishes
and $I(0, 0) = 0$ &mdash; rank&nbsp;0, even though $K$ is plainly
nontrivial nearby. This is the moment that motivates the RLCT.
A 1-hidden-unit ReLU regressor (with target $0$ and $x \sim
\mathcal{N}(0, 1)$) appears as a final preset and recovers Example
1.2 verbatim, demonstrating the Carroll thesis Lemma 3.2 result that
ReLU networks are strictly singular.

## Pedagogical decisions

- **One widget per page.** Following CONTRIBUTING.md, each widget is
  a standalone `.html` file. The chapter README links them in
  reading order.
- **No build step.** Widgets use D3 and KaTeX from CDN, with all JS
  inline. Future Claudes (and Matthew) can fork a widget by
  duplicating the single file.
- **Predict-then-reveal as default active check.** For DSLT 1 the
  algebraic objects (singular sets, RLCTs) are easier to *recognise*
  than to *construct*; we use construction-shaped checks where the
  source material naturally invites it (e.g., `dslt1-normal-crossing-game`)
  and prediction-shaped checks where it doesn't.
- **Source notation preserved.** Every widget uses Carroll's notation
  ($K(w)$, $W_0$, $\lambda$, $w^{(0)}$ etc.). Deviations would be
  documented in the parent `NOTES.md` notation map.

## How to view the widgets

For the standalone HTML widgets in `widgets/`, open the file directly
in any modern browser:

```bash
open widgets/01-bayes-loss-landscape.html        # macOS
xdg-open widgets/01-bayes-loss-landscape.html    # Linux
```

No build, no server. The widgets fetch D3 and KaTeX from
`cdn.jsdelivr.net` on first paint.
