# NOTES — Introduction to Neural Network Verification

Per-text scaffold for the Albarghouthi neural-network verification
companion. Authoritative for scope, notation, and status. Update as
decisions evolve.

## Source

A single self-contained textbook, freely hosted by the author. The
textbook is the spine; a small set of tooling-and-tutorial sources are
treated as complementary because they pin down the empirical/algorithmic
state-of-the-art that the text deliberately keeps at conceptual level
(α,β-CROWN, auto_LiRPA, Marabou, VNN-COMP).

### Primary source

- **Title:** *Introduction to Neural Network Verification*
- **Author:** Aws Albarghouthi (University of Wisconsin–Madison)
- **Year / version read:** 2021 (first edition; arXiv:2109.10317).
  Pin v1 (2021-09) for citation consistency.
- **Length:** ~150 pages; three parts:
  - Part I — A foundation for verification: NNs as graphs, basic
    properties (robustness, safety), correctness specifications.
  - Part II — Constraint-based verification: encoding NNs as logical
    constraints, MILP, SAT/SMT (Reluplex), incomplete vs. complete.
  - Part III — Abstraction-based verification: abstract interpretation,
    intervals, zonotopes, polyhedra (DeepPoly / CROWN family),
    abstract training.
- **Link:** https://verifieddeeplearning.com/
  (arXiv: https://arxiv.org/abs/2109.10317;
  LaTeX e-print: https://arxiv.org/e-print/2109.10317)
- **License / reproduction terms:** Author hosts the PDF for free
  download. The book is also published in the Foundations and Trends in
  Programming Languages series (Now Publishers). arXiv version is under
  the standard arXiv non-exclusive license. Per project policy, source
  is still gitignored.

### Secondary / complementary sources

- **α,β-CROWN tutorial + paper** (Wang et al., NeurIPS 2021, "Beta-CROWN";
  Xu et al., 2021, "Fast and Complete: Enabling Complete Neural Network
  Verification with Rapid and Massively Parallel Incomplete Verifiers").
  The current SOTA complete verifier and VNN-COMP winner; pins down what
  branch-and-bound + CROWN bounds look like in practice. Repo:
  https://github.com/Verified-Intelligence/alpha-beta-CROWN.
- **auto_LiRPA** (Xu et al., NeurIPS 2020) — the linear-relaxation
  perturbation analysis library underlying CROWN-family bounds. Useful
  for widget-backing computations of LP/dual bounds on small networks.
  Repo: https://github.com/Verified-Intelligence/auto_LiRPA.
- **Reluplex / Marabou** (Katz et al., CAV 2017 / CAV 2019). The
  reference SMT-style complete verifier. Useful for the constraint-based
  framing in Part II. Repo: https://github.com/NeuralNetworkVerification/Marabou.
- **VNN-COMP** (the annual neural-network verification competition).
  Benchmarks, rules, and tool reports; the field's empirical pulse.
  https://sites.google.com/view/vnn2024/.
- **DeepPoly** (Singh et al., POPL 2019) — the polyhedra-based abstract
  interpreter that the book's Part III follows closely.
- **Eric Wong & Zico Kolter — "Provable defenses via the convex outer
  adversarial polytope"** (ICML 2018). The LP-relaxation /
  dual-bound construction that motivates CROWN.

### Existing companions (for credit and differentiation)

There is no structured interactive companion to NN verification as of
writing. Pedagogical resources are:

- The α,β-CROWN repo's tutorials (code-level, no theory scaffolding).
- The auto_LiRPA notebooks (also code-first).
- VNN-COMP tool-report PDFs (per-tool, not pedagogical).
- A handful of CMU / MIT lecture-note sets in PL-flavored verification
  classes (slide-form).

The companion's job is to fill the interactive gap: a verification game
(prove robustness OR find an adversarial counterexample, graded both
ways), an abstract-interpretation visualizer (zonotope / polyhedron
propagation through ReLU layers), a branch-and-bound playground, a
spec-writing exercise set, and a Lyapunov-NN controller chapter
connecting verification to "Guaranteed Safe AI."

## Source ingestion

`texts/nn-verification/source/download.sh` is the lockfile. Default is
arXiv LaTeX (preferred) plus the author's hosted PDF (fallback for
figures); a couple of GitHub repos for the SOTA tooling.

- **Format(s) downloaded:**
  - LaTeX e-print of arXiv:2109.10317, unpacked into `source/book/`.
  - Hosted PDF from verifieddeeplearning.com as a fallback into
    `source/book/`.
  - α,β-CROWN repo (shallow clone) into `source/alpha-beta-CROWN/`.
  - auto_LiRPA repo (shallow clone) into `source/auto_LiRPA/`.
  - Marabou repo (shallow clone) into `source/marabou/`.
- **Reconstruction command:** `bash texts/nn-verification/source/download.sh`.
  Idempotent; survives partial network failures.
- **Chosen authoritative format for imports:** `source/book/main.tex`
  for definitions, theorems, and worked examples. Fall back to
  `source/book/2109.10317.txt` (pdftotext output) for portions where
  the LaTeX uses macros that obscure the math.
- **Known extraction issues:** TBD — fill in after first run of
  `download.sh`.
- **Gitignored?** Yes (project default).

## Why this text matters for safety

Formal neural-network verification is the foundation of the
"Guaranteed Safe AI" research agenda — Davidad's ARIA Safeguarded AI
programme, Tegmark/Bengio's provable-safety proposals, Lyapunov-stability
arguments for learned controllers, and any ambitious safety case that
wants to *prove* a network does not produce an unsafe output for any
input in some specification region. The verification community's
infrastructure (α,β-CROWN, Marabou, VNN-COMP) is the closest thing
alignment has to a working tool chain for "we have checked that this
network cannot do X." Albarghouthi's book is the only textbook-form
introduction to the area; it is also the cleanest pedagogical bridge
between abstract interpretation, MILP/SMT encodings, and the modern
linear-relaxation bounds that VNN-COMP runs on. Everything downstream
(verifying RL controllers, certifying robustness for safety-critical
deployments, formal arguments for "the model can't deceive in this
input region") inherits its language.

## Prerequisites

- **Linear algebra**: matrix-vector arithmetic, norms (ℓ₂, ℓ∞), rank,
  linear maps. Not eigen-heavy.
- **Basic logic and SAT/SMT**: propositional and first-order logic,
  what a satisfying assignment is, what an SMT solver does. The book
  introduces just enough; readers without prior exposure will want a
  one-page primer.
- **Convex analysis (gentle)**: convex hulls, polytopes, half-spaces,
  the LP relaxation of an integer program. Enough to follow CROWN's
  linear-bound construction.
- **Abstract interpretation (none assumed)**: the book introduces it
  from scratch in Part III. A reader with PL background will move
  faster, but it isn't a prerequisite.
- **Neural networks**: feed-forward, ReLU activations, what a forward
  pass computes. No training-theory needed.
- **No measure theory, no probability beyond elementary.**

## Scope

### In scope (default plan)

- **Part I — Foundations.** Specifications, robustness, safety
  properties; NN-as-DAG formal semantics. Default: cover in full
  (~3 chapters of explainer pages).
- **Part II — Constraint-based verification.** MILP encoding of ReLU
  networks, SAT/SMT (Reluplex), completeness/incompleteness trade-off.
  Default: cover in full (~3 chapters).
- **Part III — Abstraction-based verification.** Abstract
  interpretation primer, intervals, zonotopes, polyhedra (DeepPoly /
  CROWN), abstract training. Default: cover in full (~4 chapters), and
  add a SOTA bridge chapter on α,β-CROWN that the book pre-dates.

### Out of scope, with reasons

- **Probabilistic verification (PROVERO-style).** Mentioned briefly in
  the book, but a different tool chain; defer.
- **Verification of recurrent / transformer architectures.** Active
  research; the book is feed-forward-focused, and trying to extend
  here would multiply scope.
- **Formal proof-of-correctness for the verifiers themselves**
  (Coq/Lean meta-verification of Marabou). Interesting but a
  separate project.

### Open scope questions

- Whether to add a Lyapunov-NN / safe-RL controller chapter as a
  capstone bridging to Davidad's programme. Leaning yes; defer
  decision until after Part III is drafted.
- Whether the verification game ships as a Lean Game Server project
  (per CONTRIBUTING.md's encouragement) or as an in-browser
  React/D3 widget. Leaning React/D3 because the math is
  numerical (LP bounds, counterexamples) rather than proof-shaped,
  but a small Lean-game side-project on the soundness theorems for
  CROWN is plausible.

## Notation map

Default is to keep Albarghouthi's notation. Document deviations as
they arise.

| Source | Companion | Reason |
|--------|-----------|--------|
|        |           |        |

## Module breakdown

Map source structure to companion modules. One row per planned module.
Claude autonomously picks plans from this table and implements them;
there is no plan-approval gate. The "Human Review" column points to
the GitHub issue tracking human review of the implementation, when one
exists. Empty cell = no issue opened.

Drafted after reading the ingested source (`source/book/extracted/fnt/*.tex`)
in this session. One row per planned chapter, mirroring Albarghouthi's
own chapter breakdown plus a bridging α,β-CROWN module that the 2021
book pre-dates. Toy systems and active checks are *initial proposals*
to be refined by whichever Claude takes the chapter.

| Source location | Module slug | Toy system | Active check | Status | Human Review |
|-----------------|-------------|------------|--------------|--------|--------------|
| Ch 1 `beginning.tex` (A New Beginning) | `nnv-ch1-motivation` | Stop-sign-vs-cupboard adversarial photo; ACAS-Xu collision-avoidance spec | Predict-then-reveal: which Turing 1948/1949 paper seeded which thread? + drag-the-perturbation widget on a 2D toy classifier | not started | |
| Ch 2 `semantics.tex` (Neural Networks as Graphs) | `nnv-ch2-nn-as-dag` | 2-input, 1-hidden-layer (2 ReLU) → 1-output ReLU net; reused throughout the companion | Construct-the-DAG: drag affine + ReLU nodes onto canvas, site verifies the resulting `outs(·)` matches a target piecewise-linear function | not started | |
| Ch 3 `correctness.tex` (Correctness Properties) | `nnv-ch3-specs` | Same 2-2-1 ReLU net + an MNIST-3vs5 micro-classifier | Spec-writing exercise: translate an English property (robustness, monotonicity, ACAS-Xu turn-right) into a `{P}f{Q}` Hoare-style triple; site checks against a reference encoding | not started | |
| Ch 4 `fol.tex` (Logics and Satisfiability) | `nnv-ch4-fol-lra` | 3-variable LRA formulas; the 2-2-1 net's encoding | SAT-or-counterexample: given a small LRA formula, click "SAT" with a model or "UNSAT" with a short proof outline | not started | |
| Ch 5 `encodings.tex` (Encodings of Neural Networks) | `nnv-ch5-encoding` | 2-2-1 ReLU net; single ReLU node | Construct the MILP/LRA encoding of a node, then of a 2-layer net; site grades by SMT-equivalence on a small input grid | not started | |
| Ch 6 `dp.tex` (DPLL Modulo Theories) | `nnv-ch6-dpll-t` | A 4-clause CNF + a tiny LRA theory atom set | Step-through DPLL(T) trace: pick the next decision/propagation/backjump; site validates each step | not started | |
| Ch 7 `specialized.tex` (Neural Theory Solvers — Simplex / Reluplex) | `nnv-ch7-reluplex` | Simplex tableau on 3 vars; Reluplex case-split on a 2-2-1 net | Reluplex case-splitter game: pick which ReLU to split next, watch the SAT search tree shrink/explode | not started | |
| Ch 8 `absint.tex` (Neural Interval Abstraction) | `nnv-ch8-intervals` | 2-2-1 ReLU net under interval bounds on a 2D ε-ball input | Drag the ε-ball, watch the interval bounds propagate; predict whether the output bound certifies robustness before the site reveals | not started | |
| Ch 9 `numerical.tex` (Neural Zonotope Abstraction) | `nnv-ch9-zonotopes` | Same 2-2-1 net; zonotope of generators visualized in 2D | Construct-the-ReLU-transformer: pick the linear lower bound for the [l,u] ReLU case-split that minimizes the upper bound's area; site grades against the optimal | not started | |
| Ch 10 `polyhedra.tex` (Neural Polyhedron Abstraction / DeepPoly) | `nnv-ch10-deeppoly` | Same 2-2-1 net; polyhedron viewed as a system of half-spaces | Adversarial-or-certificate verification game (the headline widget): given a 2-input net + ε-ball, the reader either constructs an adversarial input *or* a CROWN-style linear bound proving robustness; site grades both | not started | |
| Ch 11 `absver.tex` (Verifying with Abstract Interpretation) | `nnv-ch11-end-to-end` | 2-2-1 net + a tiny MNIST-3vs5 with both ℓ∞ and ℓ₂ adversaries | End-to-end verification arena: pick a domain (interval / zonotope / polyhedra), watch precision-vs-runtime trade-off on a benchmark suite; predict-then-reveal on which domain certifies which spec | not started | |
| Ch 12 `absintnn.tex` (Abstract Training) | `nnv-ch12-abstract-training` | Same 2-2-1 net; trained vs. abstract-trained side by side on a 2D dataset | Slider over (clean loss, robust loss) Pareto frontier; reader picks training schedule and watches certified accuracy on held-out ε-balls | not started | |
| (Bridge — book pre-dates this) α,β-CROWN + branch-and-bound | `nnv-bridge-ab-crown` | Larger 5-input ReLU net; α/β tightening parameters as sliders | Pick splitting heuristics in branch-and-bound, race α,β-CROWN's defaults on a small VNN-COMP-style benchmark leaderboard | not started | |
| Epilogue (`epilogue.tex`) — Lyapunov-NN / Safeguarded-AI capstone (open scope question) | `nnv-capstone-lyapunov` | Learned controller for a 2D inverted pendulum; Lyapunov function as a small NN | Construct a candidate Lyapunov NN, verifier checks the decreasing-along-trajectories condition via Part-III machinery | not started | |

## Pedagogical decisions

- **Toy systems carried across the text.** Default candidate: a
  2-input, 1-hidden-layer (2 ReLU units), 1-output network that the
  reader sees in every chapter — first as a graph (Part I), then as a
  set of MILP constraints (Part II), then as an abstract-domain
  propagation (Part III). Reusing the same network through every
  framing is the whole point.
- **Default visualization style.** 2D input space (because
  ε-balls and adversarial regions are visualizable), with the network's
  decision boundary and the certified region drawn as overlays.
- **Active checks.** Verification is *natively adversarial*. Default
  active check: given a small network and a specification (∀ x in
  ε-ball, output class = c), the reader either (a) constructs an
  adversarial x ∈ ε-ball with output ≠ c, or (b) constructs a
  CROWN-style linear bound that proves no such x exists. The site
  grades both branches. Predict-then-reveal is a fallback for
  non-constructive content.
- **Framings.** At least two per central concept:
  - *Constraint-based* (MILP / SMT — the network is a logical formula).
  - *Geometric* (input space + decision regions + abstract domains as
    over-approximations).
  - *Optimization* (LP relaxations and dual bounds).
  - *Adversarial* (attacker vs. verifier game).
- **Spec-writing emphasis.** A recurring weak point in the
  verification literature is that students can verify but cannot
  *write* useful specifications. Each chapter ends with a short
  spec-writing exercise that translates an English safety property
  into a ∀∃ formula on the network.

## Secondary sources to build on

- α,β-CROWN, auto_LiRPA, Marabou — see ingestion section.
- VNN-COMP rulebooks (the annual benchmark suite).
- Wong & Kolter's "convex outer adversarial polytope" paper, for the
  LP-relaxation framing.
- Davidad's Safeguarded AI public materials (ARIA programme docs) for
  the safety motivation in chapter intros.

## Source issues

Known errata, apparent errors, contested results, version drift. Each
entry should cite the location and link the critique if one exists.

- *(none recorded yet)*

## Status

- **Last updated:** 2026-05-05
- **Chapters complete:** none
- **Currently being drafted:** none yet. Module breakdown drafted in
  this session after reading Part I in full from the ingested LaTeX
  source plus skimming Parts II–III chapter headings. Awaiting human
  approval on the row set before any chapter is started.
- **Blockers:** none.

## Cross-references

- **Albarghouthi ↔ SLT:** verification of *trained* networks vs. SLT's
  understanding of *training*. Both end up caring about the geometry
  of the function the network computes; verification cares about
  worst-case input behaviour, SLT about typical-case posterior
  behaviour. Worth a single cross-link from each side.
- **Albarghouthi ↔ Logical Induction:** both have a "constructive
  game" pedagogical core (build a trader / build an adversarial
  counterexample). The Lean-game pattern transfers if we ever decide
  to add a soundness-proofs side-project.
- **Albarghouthi ↔ Davidad's Open Agency Architecture / Safeguarded
  AI:** verification is a load-bearing component of the
  Guaranteed-Safe-AI agenda. When that text enters the repo (it's a
  stretch candidate today), this companion's Part III will be a
  prerequisite for it.
