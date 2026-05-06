# Ch 2 — The Logical Induction Criterion

Companion to [Garrabrant et al. (2016) §3](https://arxiv.org/pdf/1609.03543v3.pdf#page=18),
*The Logical Induction Criterion*. This chapter introduces the four
moving parts of the criterion (markets, deductive processes, traders,
exploitation) and the criterion itself.

## Reading order

1. **§3.1 Markets** — what counts as a "belief sequence" we can hold
   the criterion to. Pricings, markets, belief states, computable
   belief sequences.
2. **§3.2 Deductive processes** — a slow ground-truth oracle that
   eventually reveals theorems. Worlds, propositional consistency,
   $\mathcal{T}$-completeness.
3. **§3.3 Efficient computability** — polynomial-time as the gating
   criterion for "what counts as a trader".
4. **§3.4 Traders** — affine combinations of sentences with
   continuous coefficients. The Table&nbsp;1 worked example. Why
   continuity matters.
5. **§3.5 Exploitation** — Definition 3.5.1. The "buy 1 share of
   $\varphi$ each day" exploit. The $(\varphi \lor \psi)$-arbitrage.
6. **§3.6 Main result** — the criterion itself; Theorem 3.6.2.

## Modules

The chapter is split into seven modules, in source order. Each
widget is self-contained single-file HTML; open in a browser, no
build step. See the [per-text NOTES.md](../../NOTES.md#module-breakdown)
for the table of statuses.

| # | Module | Source | Status |
|---|--------|--------|--------|
| 1 | [`01-market-trader-sandbox.html`](widgets/01-market-trader-sandbox.html) | §3.1, §3.4 (Table 1), §3.5 | drafted |
| 2 | [`02-deductive-process.html`](widgets/02-deductive-process.html) | §3.2 | drafted |
| 3 | [`03-continuity-paradox.html`](widgets/03-continuity-paradox.html) | §3.4 (continuity discussion, χ paradox) | drafted |
| 4 | `04-exploit-or-not.html` | §3.5 | proposed |
| 5 | `05-arbitrage-pair.html` | §3.5 (the $\varphi$ vs $\neg\neg\varphi$ example) | proposed |

(Modules 4, 5 are stubs in the breakdown; the chapter README
lists them so future Claudes have a roadmap.)

## Running the smoke test

```bash
uv run scripts/widget-smoke-test.py texts/logical-induction/chapters/ch2-the-criterion/widgets/*.html
```

Catches the "deferred KaTeX never ran" / "undefined LINK constant"
class of bug. See [`LESSONS.md`](../../../../LESSONS.md#widget-build-notes)
for context.

## Toy system

The chapter's toy system is the **three-sentence market** from
Table 1 of the paper:

- $\varphi := \quot{1+1=2}$ priced at 90¢
- $\psi := \quot{1+1 \ne 2}$ priced at 5¢
- $\chi := \quot{\text{Goldbach's conjecture}}$ priced at 98¢

with a PA-fragment deductive process $\overline{D}$ that resolves
$\varphi$ and refutes $\psi$ on day $t = 8$ but never settles $\chi$
within the simulation horizon $n \le 30$. This single market is
reused across all five widgets in this chapter.
