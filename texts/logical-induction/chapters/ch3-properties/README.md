# Ch 3 — Properties of Logical Inductors

Companion to [Garrabrant et al. (2016) §4](https://arxiv.org/pdf/1609.03543v3.pdf#page=29),
*Properties of Logical Inductors*. This chapter unfolds the
twelve theorem-bundles that follow from the criterion: the limit
exists, the limit is coherent, beliefs become reasonable in a
timely manner, and so on.

## Reading order

1. **§4.1 Convergence and Coherence** — the limit
   $\mathbb{P}_\infty(\varphi)$ exists, and its restriction to
   sentences is a coherent probability measure on completions of
   $\mathcal{T}$.
2. **§4.2 Timely Learning** — provability induction: for any
   efficiently computable sequence of theorems $(\varphi_n)$,
   $\mathbb{P}_n(\varphi_n) \to 1$.
3. **§4.3 Statistical Patterns** — pseudorandom sequences get the
   right base rate (10% for $\pi$-digits).
4. **§4.4 Calibration and Unbiasedness** — bedrock-property side
   of timely learning.
5. **§§4.5–4.12** — non-dogmatism, conditionals, expectations,
   self-trust, and so on.

The chapter's pedagogical signature is "every property is enforced
because its violation is exploitable." Each module's active check
is the same shape: the reader picks a violation, the widget builds
the exploiting trader and shows them earning unbounded profit.

## Modules

See the [per-text NOTES.md](../../NOTES.md#module-breakdown) for
the table of statuses across the whole companion. The Ch 3
modules in source order:

| # | Module | Source | Status |
|---|--------|--------|--------|
| 1 | [`01-convergence.html`](widgets/01-convergence.html) | §4.1 Theorem 4.1.1 (Convergence) | drafted |
| 2 | [`02-limit-coherence.html`](widgets/02-limit-coherence.html) | §4.1 Theorem 4.1.2 (Limit Coherence) | drafted |
| 3 | `03-provability-induction.html` | §4.2 Theorem 4.2.1 (Provability Induction) | proposed |
| 4 | `04-pi-statistical.html` | §4.3 Statistical-pattern learning | proposed |
| 5 | `05-calibration-cluster.html` | §4.4 Calibration + correlated clusters | proposed |
| 6 | `06-self-trust.html` | §4.12 Self-Trust (stretch) | proposed |

## Running the smoke test

```bash
uv run scripts/widget-smoke-test.py texts/logical-induction/chapters/ch3-properties/widgets/*.html
```

## Toy systems

Different modules use different toys; each widget's header comment
documents its toy. Recurring patterns:

- The 3-prime toy from Ch 2 (1+1=2; 1+1=3; Goldbach), reused for
  convergence and limit-coherence.
- The π-digit family from Ch 1, reused for statistical-pattern
  learning.
- A small EC sequence of theorems for provability-induction
  (Ramanujan/Hardy analogue).
