# Ch 4 — Logics and Satisfiability

Companion to Albarghouthi (2021) Ch 4,
*[Logics and Satisfiability](https://arxiv.org/pdf/2109.10317#page=33)*
(arXiv:2109.10317, fol.tex). The chapter is the Part-II hinge:
propositional logic, then the theory of *linear real arithmetic*
(LRA), then a brief tour of why SMT (and not pure SAT) is the right
backend for neural-network verification.

## Why this chapter matters for verification

The constraint-based verification pipeline of Part II turns every
neural-network correctness question into a SAT query on an LRA
formula. The plumbing looks like:

1. **Encode the network.** Every affine node becomes a linear
   equality. Every ReLU node becomes a piecewise-linear *case-split*
   — a disjunction $(a \ge 0 \wedge h = a) \vee (a < 0 \wedge h = 0)$.
   This is Ch 5.
2. **Encode the spec.** The Hoare triple $\{P\}\;r \gets f(\vec
   x)\;\{Q\}$ is *valid* iff the formula $P \wedge \mathrm{net}(\vec
   x, \vec r) \wedge \neg Q$ is **unsatisfiable**.
3. **Decide.** Hand the formula to an SMT solver (Ch 6 builds the
   DPLL(T) algorithm; Ch 7 specialises it to ReLU networks via
   Reluplex).

The translation between &ldquo;property holds&rdquo; and &ldquo;a
formula is unsat&rdquo; is the single most important fact in Part II.
A model of the encoded formula is exactly a *counterexample* to the
property: an input that satisfies the precondition but violates the
postcondition. So the geometric question &ldquo;is this conjunction
of half-spaces empty?&rdquo; *is* the question &ldquo;is the network
robust?&rdquo;

## Reading order

1. **§4.1 Propositional logic.** Variables, connectives,
   interpretations, evaluation rules, satisfiability, validity,
   equivalence (commutativity, De Morgan, distributivity), implication
   as $\neg A \vee B$.
2. **§4.2 Arithmetic theories.** SMT generalises SAT by extending
   propositional variables to *theory atoms* (e.g., linear
   inequalities, array reads, bit-vector operations).
3. **§4.2 Linear Real Arithmetic.** The atom $\sum_i c_i x_i + b
   \mathrel{\le} 0$ (or $<$). Models assign each variable a real number;
   the standard equivalences ($x \ge 0 \equiv -x \le 0$, $x = 0
   \equiv x \le 0 \wedge -x \le 0$) reduce everything to two atom
   forms. NP-completeness in general; cheap in practice.
4. **§4.2 Connections to MILP.** SMT(LRA) and MILP feasibility are
   inter-reducible. Verifiers that &ldquo;use Gurobi instead of an
   SMT solver&rdquo; are using this equivalence; the chapter explains
   why the SMT framing is preferred for theory combination
   (LRA + bit-vectors for floating-point precision; LRA + strings for
   parsing-then-classifying pipelines).

## Modules

| # | Module | Source | Status |
|---|--------|--------|--------|
| 1 | [`01-lra-sat-game.html`](widgets/01-lra-sat-game.html) | §4.1 propositional + §4.2 LRA, specialised to 2-variable formulas drawable as planar half-space arrangements | drafted |

## Toy systems

Two-variable LRA formulas, viewed as Boolean combinations of closed
half-spaces in $\mathbb{R}^2$. A conjunction is the intersection of
half-spaces (a polyhedron); a disjunction is their union; negation
flips a half-space (and turns $\le$ into $>$, important for
soundness). The model–as–point picture is the right mental
furniture for Ch 5–7; once internalised, the abstract domains of
Part III also become natural — they are over-approximations of these
exact polyhedra.

## Active check

A geometric SAT-or-UNSAT game. Each round the reader sees an LRA
formula and its half-space arrangement. They either:

- **Submit a model** by dragging a point onto a satisfying
  $(x_1, x_2) \in \mathbb{R}^2$. The site evaluates each atom at the
  point and grades whether the formula's truth-functional combination
  evaluates to $\top$.
- **Declare UNSAT.** The site checks against the precomputed truth.
  If correct, it reveals a *minimal contradicting set* — usually two
  or three atoms that have no common point, mirroring how Farkas-style
  certificates work in real LP solvers.

The two outcomes correspond exactly to the two outcomes of
verification in Ch 5–7: SAT means the verifier found a counterexample
to the network property; UNSAT means the property is proved.
