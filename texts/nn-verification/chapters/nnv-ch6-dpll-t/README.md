# Ch 6 — DPLL Modulo Theories

Companion to Albarghouthi (2021) Ch 6,
*[DPLL Modulo Theories](https://arxiv.org/pdf/2109.10317#page=53)*
(arXiv:2109.10317, dp.tex). The chapter introduces the algorithmic
heart of every modern SMT solver: DPLL on the Boolean *abstraction*
of an LRA formula, with a *theory solver* called every time DPLL
proposes a Boolean model, and *clause learning* whenever the theory
solver rejects a model.

## Why this chapter matters for verification

Ch 5 reduced verification to satisfiability of an LRA formula. Ch 6
is the first chapter that tells you how to *decide* such formulas in
practice. Three load-bearing ideas:

1. **Boolean abstraction.** Replace each unique linear inequality
   with a fresh propositional variable; if the resulting CNF is
   UNSAT, the original is UNSAT (Albarghouthi §6.3 abstraction
   lemma). The converse fails — abstraction is *sound but not
   complete* — and the gap is where the theory solver lives.
2. **Lazy DPLL(T).** DPLL on the abstraction proposes a Boolean
   model $I$. The theory solver checks $I^T$ — the conjunction of
   inequalities encoded by $I$. If theory-SAT, return; if
   theory-UNSAT, learn the *blocking clause* $\neg I$ and re-solve
   the abstraction. The loop terminates because each iteration rules
   out at least one Boolean assignment.
3. **Tseitin's transformation.** DPLL needs CNF input. Naive
   distribution causes exponential blow-up; Tseitin's transformation
   converts any formula to CNF in linear size by introducing one
   fresh variable per subformula and clauses encoding $t_i \iff
   (\ell \circ \ell')$.

The whole pipeline is the engine that Ch 7 specialises (Reluplex
adds a ReLU-aware case-split rule to the theory solver) and that
α,β-CROWN strips down (it replaces the SMT layer with branch-and-bound
on bounds). Either way, the &ldquo;Boolean SAT layer + theory layer&rdquo;
split is what makes neural-network verification tractable for nets
with thousands of ReLUs.

## Reading order

1. **§6.1 Conjunctive Normal Form (CNF).** Clauses, literals, the
   shape DPLL expects.
2. **§6.2 The DPLL algorithm.** Boolean Constant Propagation (BCP)
   on unit clauses; recursive search with variable selection;
   partial models; the standard pseudocode.
3. **§6.3 DPLL Modulo Theories.** Boolean abstraction
   $\varphi^B$, the soundness gap (abstraction can lose
   contradictions), the lazy DPLL(T) loop with `block-and-repeat`.
4. **§6.4 Tseitin's transformation.** NNF-pushdown of $\neg$, then
   one fresh variable per subformula, then CNF-friendly biconditional
   encodings of $t_i \iff (\ell \circ \ell')$.

## Modules

| # | Module | Source | Status |
|---|--------|--------|--------|
| 1 | [`01-dpll-t-trace.html`](widgets/01-dpll-t-trace.html) | §6.2–§6.3, illustrated by stepping through three small LRA examples | drafted |

## Toy systems

Three small LRA formulas chosen to surface the three qualitative
behaviours of the DPLL(T) loop:

- **E1 — Direct contradiction (UNSAT).**
  $x \ge 10 \wedge x \le 0$. Boolean abstraction is trivially SAT
  ($p \wedge q$ has model $\{p, q\}$); the theory solver rejects;
  the learned clause $\neg p \vee \neg q$ refutes the only abstract
  model and the loop terminates UNSAT.
- **E2 — Albarghouthi's running example (SAT after one refinement).**
  $x \ge 10 \wedge (x < 0 \vee y \ge 0)$. The first abstract model
  $\{p, q\}$ is theory-rejected; learning $\neg p \vee \neg q$
  forces the next abstract model into $\{p, \neg q, r\}$, which is
  theory-SAT with the witness $\{x \mapsto 10, y \mapsto 0\}$.
- **E3 — Theory-vacuous SAT (no learning needed).**
  $x \le 5 \wedge (y \ge 0 \vee y \le -5)$. The first abstract model
  $\{p, q\}$ is already theory-SAT; no learned clauses, immediate
  return with the LRA model.

## Active check

A step-through trace stepper. The reader sees the algorithm state
laid out — original formula, Boolean abstraction, current iteration's
abstraction (with learned clauses appended), current Boolean model,
theory-check result, final verdict — and presses *Next step* to
advance the DPLL(T) loop one beat at a time. Each step is annotated
with what just happened and *why* (which §6.2/§6.3 rule fired).

The widget's contribution over reading the chapter is rhythm: it
makes the loop's structure tangible. Once a reader has clicked
&ldquo;theory-check&rdquo; → &ldquo;learn $\neg I$&rdquo; → &ldquo;BCP forces a different
model&rdquo; a couple of times, Reluplex's case-split rule (Ch 7) lands
as &ldquo;just one more theory-side rule that the theory solver can apply
before declaring UNSAT.&rdquo;
