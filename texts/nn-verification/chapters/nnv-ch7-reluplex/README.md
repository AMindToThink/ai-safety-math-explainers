# Ch 7 — Neural Theory Solvers (Simplex + Reluplex)

Companion to Albarghouthi (2021) Ch 7,
*[Neural Theory Solvers](https://arxiv.org/pdf/2109.10317#page=64)*
(arXiv:2109.10317, specialized.tex). The chapter closes Part II by
specialising the theory-solver layer of DPLL(T) in two stages:
*Simplex* for pure LRA, then *Reluplex* — a Simplex extension that
treats ReLU constraints natively rather than as disjunctions.

## Why this chapter matters for verification

Ch 6 established that DPLL(T) calls a theory solver on every
abstract Boolean model. The theory solver is the bottleneck.
Two refinements:

1. **Simplex.** Built from Dantzig's 1947 method. Simplex form
   rewrites a conjunction $\bigwedge \sum c_{ij} x_j \ge b_i$ as
   equalities $s_i = \sum c_{ij} x_j$ plus bounds $s_i \ge b_i$.
   Maintain $I$ that satisfies all equalities; whenever a basic
   variable's bound is violated, *pivot* with a non-basic variable
   that can fix the violation; if no such non-basic exists, the
   formula is UNSAT (the famous &ldquo;Bland's rule&rdquo; certificate).
2. **Reluplex.** Each ReLU node $h = \mathrm{ReLU}(a)$ becomes a
   disjunction in Ch 5. Naive DPLL(T)+Simplex case-splits the
   disjunction *inside* the SAT layer, leading to up to $2^k$
   theory-solver calls. Reluplex hoists the ReLU into the theory
   solver and tries to fix violated ReLU constraints by *local*
   updates (pivots, then `I(x_i) <- ReLU(I(x_j))` or `I(x_j) <-
   I(x_i)`). Only when the same ReLU has been visited more than
   $\tau$ times — a sign of looping — does Reluplex finally
   case-split on it, branching into the *active* and *inactive*
   sub-problems.

The empirical payoff: Reluplex won the original ACAS-Xu
verification competition (Katz et al., CAV 2017) and is the
direct ancestor of Marabou. The *idea* — keep ReLU case-splits
out of the SAT layer; treat them as a theory-internal branching
step — is also the seed of α,β-CROWN's branch-and-bound (Ch
&ldquo;bridge&rdquo;): both algorithms factor verification into a
&ldquo;cheap bound-tightening pass + occasional case-split.&rdquo;

## Reading order

1. **§7.1 Theory solving and normal forms.** The Simplex form
   (equalities + bounds + slack variables); the rewriting
   procedure that gets you there from $\sum c_{ij} x_j \ge b_i$.
2. **§7.2 The Simplex algorithm.** Bland's rule; basic vs.
   non-basic variables; pivot operations; the running 2-D example
   $x + y \ge 0$, $-2x + y \ge 2$, $-10x + y \ge -5$ illustrated
   with $I_0 = (0, 0) \to I_1 = (-1, 0) \to I_2 = (-2/3, 2/3)$.
3. **§7.3 The Reluplex algorithm.** Reluplex form (Simplex form +
   ReLU constraints); the local-update rules; the case-split
   trigger threshold $\tau$.
4. **§7.4 Case splitting.** Why Reluplex *must* eventually split
   to terminate; the binary tree structure and the equivalence
   $\varphi \equiv (\varphi \wedge \varphi_{\text{active}}) \vee
   (\varphi \wedge \varphi_{\text{inactive}})$.

## Modules

| # | Module | Source | Status |
|---|--------|--------|--------|
| 1 | [`01-reluplex-case-split-tree.html`](widgets/01-reluplex-case-split-tree.html) | §7.3–§7.4, the case-split tree on the 2-2-1 toy net under a robustness query | drafted |

## Toy system

The canonical 2-2-1 ReLU net from Ch 2,
$y = \mathrm{ReLU}(a_1) + \mathrm{ReLU}(a_2)$ with
$a_1 = x_1 + x_2$, $a_2 = x_1 - x_2$. With two ReLUs, Reluplex's
case-split tree has at most $2^2 = 4$ leaves — exactly the four
activation patterns that Ch 5 plotted as colored regions. On each
leaf, the network is purely linear and the verification condition
reduces to LP feasibility, which Simplex closes in a few pivots.

## Active check

A *case-split tree explorer*. Set a robustness spec (anchor
$\vec c$, $\ell_\infty$ radius $\varepsilon$, output bound $M$).
The widget draws the Reluplex tree:

- **Root:** the full Reluplex problem (formula + ReLU constraints).
- **Internal nodes:** &ldquo;case-split on $h_1$&rdquo; or
  &ldquo;case-split on $h_2$&rdquo;.
- **Leaves:** an activation pattern $(\sigma_1, \sigma_2) \in
  \{+, -\}^2$ pinning each ReLU to active or inactive. The leaf's
  *reduced linear network* is shown, plus the LP feasibility
  result (closed-as-UNSAT or open-with-counterexample) computed
  by a small in-browser Simplex pass.

Each leaf can be expanded to show its formula, its Simplex
trace, and (if SAT) a concrete counterexample input. Once all
four leaves close, the overall verdict is UNSAT (verified). If
any leaf is SAT, that's the Reluplex counterexample — the
specific activation pattern under which the network exhibits the
violation.

The widget makes vivid the central trade-off of constraint-based
verification: Reluplex (and α,β-CROWN, and Marabou) burn
exponential effort in $k$ ReLUs — but most of that effort is
spent closing leaves that turn out to be infeasible polytopes,
which is what makes the empirical scaling much better than the
worst-case bound.
