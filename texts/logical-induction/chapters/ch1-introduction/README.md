# Ch 1 — Introduction

Companion to [Garrabrant et al. (2016) §1](https://arxiv.org/pdf/1609.03543v3.pdf#page=2),
*Introduction*. This chapter motivates the entire paper: why
classical probability theory cannot model uncertainty about
mathematical statements, and what set of desiderata a good
substitute would meet.

## Reading order

1. **§1 Introduction (paragraphs 1–4).** Empirical vs logical
   uncertainty; the π-digit thought experiment; why a perfect
   Bayesian is forced into 100% on $\quot{\pi[n]=7}$ via the
   inequality chain $1 = P(\quot{1+1=2}) \le P(\varphi)$.
2. **§1.1 Desiderata.** Seventeen formal candidates (Computable
   Approximability, Coherence, Approximate Coherence, Statistical
   Patterns, Calibration, Non-Dogmatism, Uniform Non-Dogmatism,
   Universal Inductivity, Approximate Bayesianism, Introspection,
   Self-Trust, Approximate Inexploitability, Gaifman Inductivity,
   Efficiency, Decision Rationality, Counterpossibles, Old
   Evidence). Many are jointly incompatible.
3. **§1.2 Related Work.** Inspirations and contrasts.
4. **§1.3 Overview.** A road map of the rest of the paper.

## Modules

| # | Module | Source | Status |
|---|--------|--------|--------|
| 1 | [`01-pi-digit-paradox.html`](widgets/01-pi-digit-paradox.html) | §1 ¶3 (the π[87,653]=7 example) | drafted |
| 2 | `02-desiderata-tour.html` | §1.1 (the 17 desiderata as a compatibility graph) | proposed |

(Module 2 is a stub in the breakdown; see
[`NOTES.md`](../../NOTES.md#module-breakdown) for the table of
statuses.)

## Toy system

The chapter's toy is the **π-digit family**: sentences of the form
$\varphi_{n,k} := \quot{\pi[n] = k}$ for $n \in \{1, \ldots, 100\}$
and $k \in \{0, \ldots, 9\}$. Widget 1 specialises to $k = 7$ and
lets the reader scan $n$ from 1 to 100, comparing a Bayesian's
forced probability (always 0 or 1 by ground truth) with a logical
inductor's price (floats at the empirical-frequency prior 0.1 until
the deductive process resolves the digit).
