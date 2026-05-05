# NOTES — Logical Induction

Per-text scaffold for the Logical Induction (LI) companion. Fill out
before writing chapter prose. Update as decisions evolve. Keep this
file authoritative for scope, notation, and status.

## Source

A single ~100-page arXiv paper is the spine; a small set of public
distillations are treated as complementary sources because they pin
down algorithmic detail and intuition that the paper deliberately
keeps abstract.

### Primary source

- **Title:** *Logical Induction*
- **Authors:** Scott Garrabrant, Tsvi Benson-Tilsen, Andrew Critch,
  Nate Soares, Jessica Taylor (MIRI)
- **Year / version read:** Original v1 posted 2016-09-12
  (arXiv:1609.03543), latest v3 dated 2020-09. Pin v3 for citation
  consistency.
- **Length:** ~108 pp main text + appendices.
- **Link:** https://arxiv.org/abs/1609.03543
  (LaTeX e-print: https://arxiv.org/e-print/1609.03543)
- **License / reproduction terms:** arXiv default — author retains
  copyright, redistribution permitted under arXiv's non-exclusive
  license. Safe to ingest but, per project policy, source still
  gitignored.

### Secondary / distillation sources (treated as complementary, not replacement)

- **Abram Demski — *An Intuitive Guide to Logical Induction*** (2017,
  Alignment Forum / LessWrong). The clearest existing prose
  walk-through of the trader-market intuition. Useful for the
  Dutch-book framing and for guidance on what a "good" trader looks
  like before any formalism. CC-BY (LW default).
  - https://www.lesswrong.com/posts/Zi7nmBSGdsdfBxgWE/an-untrollable-mathematician-illustrated
    (untrollable mathematician illustrated; companion piece)
  - https://www.alignmentforum.org/posts/3SG4WbNPoP8fsuZgs/an-intuitive-guide-to-logical-induction-1

- **Adam Scherlis — *Logical Induction for Software Engineers***
  (arXiv:2205.12879, 2022) plus accompanying Python code at
  https://github.com/epistax-is/logical-induction. Pseudocode-level
  description of LIA that is genuinely runnable. Goldmine for
  widget-backing simulations and for sanity-checking algorithmic
  claims against the paper.
  - License: arXiv non-exclusive; code is MIT (verify on ingest).

- **Demski + Garrabrant — *Embedded Agency*** (2019).
  Background motivation for why LI matters in agent foundations.
  Not load-bearing for the math, but useful for chapter intros.

- **AXRP / podcast appearances** — Scott Garrabrant has discussed
  LI in multiple long-form interviews. Useful for orientation but
  not a citation source.

### Existing companions (for credit and differentiation)

There is **no interactive companion** to LI as of writing.
Pedagogical resources are:

- Demski's *Intuitive Guide* (prose only)
- Scherlis's *for Software Engineers* (prose + Python, no UI)
- Selected LessWrong tutorials (e.g., the "untrollable
  mathematician illustrated")
- Garrabrant's MIRI tech talks (slide-form, not interactive)

The companion's job is to fill the interactive gap: trader-market
sandbox, market-maker price-trajectory animator, self-reference
puzzles, calibration/coherence dashboard, π-digit canonical example.

## Source ingestion

`texts/logical-induction/source/download.sh` is the lockfile.

- **Format(s) downloaded:**
  - LaTeX e-print of arXiv:1609.03543 (the paper), unpacked into
    `source/paper/`.
  - LaTeX e-print of arXiv:2205.12879 (Scherlis), unpacked into
    `source/scherlis/`.
  - `git clone` of `epistax-is/logical-induction` into
    `source/scherlis-code/`.
  - HTML of Demski's *Intuitive Guide* posts from Alignment
    Forum / LessWrong, converted to Markdown via `pandoc`.
- **Reconstruction command:** `bash texts/logical-induction/source/download.sh`
  (idempotent; tolerant of partial network failures, per LESSONS.md).
- **Chosen authoritative format for imports:**
  - For paper definitions, theorems, lemmas: the LaTeX in
    `source/paper/main.tex` (or whichever file the e-print
    extracts to). Quote verbatim.
  - For algorithmic detail (LIA): cross-check the paper's §5.4
    with Scherlis's pseudocode. When they conflict, the paper is
    authoritative; flag the conflict in "Source issues."
  - For prose / intuition: Demski's posts and Scherlis's
    introduction.
- **Known extraction issues:** TBD on first ingestion run.
- **Gitignored?** Yes; repo-level `.gitignore` excludes
  `texts/*/source/*` except for `download.sh` and `README.md`.

## Why this text matters for safety

Logical Induction is the foundational result on reasoning under
*logical* uncertainty — uncertainty about mathematical statements
that an unbounded reasoner could in principle settle but a bounded
one cannot. It underwrites a research program covering bounded
rationality, Vingean reflection, embedded decision theory,
self-trust, untrollable priors, and Demski's Radical Probabilism.
The paper's central object — a market of polynomial-time traders
that collectively assign coherent and well-calibrated probabilities
to logical sentences — is the natural mathematical object for
*reasoning agents that don't have time to be Bayesian*, which is
all real agents.

The "construct a trader who exploits this market" task is built
into the formalism. That makes LI an unusually clean fit for
gamification: the mathematical object the reader needs to
understand is exactly the object they are asked to build.

## Prerequisites

- Probability through countable additivity and conditional
  expectation.
- Mathematical logic at the level of Mendelson chapters 1–3:
  propositional and first-order logic, soundness, completeness,
  Peano arithmetic, the Gödel sentence (helpful but not strictly
  required).
- Polynomial-time computability and basic complexity theory.
- Martingales / Dutch-book arguments at the level of a one-semester
  decision theory course.
- Light real analysis: limsup/liminf, Cesàro means, convergence
  rates.
- A code-reading muscle for the algorithmic chapters.

The paper itself supplies most of the formal background it needs,
but a reader without working comfort with **logical syntax**
(formulas as syntactic objects with their own enumeration) and
**martingale reasoning** will struggle independently of any
companion.

## Scope

### In scope (initial plan; revise as we go)

The companion's default ambition is **the entire paper**.
Working module families, in source order:

1. **§1 Introduction.** Motivation, the four desiderata
   (calibration, coherence, self-trust, etc.), worked examples
   (π-digit, Riemann hypothesis, prime gaps).
2. **§2–§3 Logical inductors and traders.** Definitions of
   logical inductors, deductive processes, trading formulas,
   markets, exploitation.
3. **§4 The Logical Induction Criterion.** The "no exploitation"
   theorem and its consequences.
4. **§5 The Logical Induction Algorithm.** LIA proper:
   Garrabrant series budget, MarketMaker, the construction of
   sentences and their prices.
5. **§6 Properties of logical inductors.** Calibration,
   convergence, coherence, learning, generalised induction,
   self-knowledge, self-trust.
6. **§7 Limit coherence and other limit-properties.**
7. **§8 Computability and complexity.** Why polynomial-time
   matters; uniform schemes; the unbounded computational power
   of the inductor relative to its traders.
8. **Appendices** as supplementary widgets where they materially
   change a reader's understanding (the appendices in this paper
   are unusually load-bearing — Appendix A's preliminaries are
   genuinely useful).

### Out of scope (initial)

- Follow-on papers (Asymptotic LIDT, untrollable mathematician,
  Demski's Radical Probabilism corpus). Cross-link from chapter
  intros, but don't replicate.
- Re-deriving Gödel's incompleteness theorems. Cite, don't re-prove.
- Full implementation of LIA. We will run *toy* logical inductors
  on small deductive processes (Scherlis-style); the paper's full
  LIA is exponential in the number of sentences and not practical
  to run interactively beyond very small cases.

### Open scope questions

- **Lean Game Server module.** Matthew explicitly asked. The
  trader-construction skill is intrinsically proof-shaped and is
  exactly the natural target. Plan: a small Lean 4 + GameServer
  project under `lean-game/` covering, at minimum:
  - "Construct a trader that exploits a Dutch-bookable market."
  - "Show that uniform-coherent prices are Dutch-book-immune."
  - A few warm-up levels on rational-valued buying/selling.
  Whether this lands fully in one session or develops over many
  is itself an open question; current plan is to scaffold it
  early and grow it alongside the prose modules.

## Notation map

To populate as chapters are processed. Default is to keep the
paper's notation; deviations get rows here with a reason.

| Source | Companion | Reason |
|--------|-----------|--------|
|        |           |        |

## Module breakdown

Map source structure to companion modules. Claude autonomously
picks plans from this table and implements them; there is no
plan-approval gate. The "Human Review" column points to the GitHub
issue tracking human review of the implementation, when one exists.
See `CONTRIBUTING.md` for issue conventions.

| Source location | Module slug | Toy system | Active check | Status | Human Review |
|-----------------|-------------|------------|--------------|--------|--------------|
|                 |             |            |              |        |              |

(Module rows will be proposed after the §1–§3 read.)

## Pedagogical decisions

- **Default toy system across the text:** a "π-digit" deductive
  process and a small fragment of Peano arithmetic that resolves
  one new sentence per timestep. This matches the paper's
  canonical example (the inductor that prices "the n-th digit of
  π is k" and watches calibration emerge as digits are computed)
  and is small enough to animate end-to-end. A secondary toy is
  a "Riemann-hypothesis-shaped" sentence whose proof never lands
  inside the simulation horizon; this exposes the limit-coherence
  machinery.
- **Default visualization style:** D3 + KaTeX from CDN, single-file
  standalone HTML. Reuse the SLT widget pattern in
  `texts/slt/chapters/dslt1-rlct-effective-dimension/widgets/01-bayes-loss-landscape.html`.
  A market is a stream — the price-trajectory animator is the
  canonical pattern for almost every chapter.
- **Active checks:** "Construct a trader" by default, in two
  flavours:
  1. *Sandbox:* the learner writes a small expression for a
     trader's strategy in a textarea, the widget evaluates it
     against a chosen market history, and reports realised value.
  2. *Multiple-choice with verification:* the learner picks
     among three candidate traders to find the one that
     exploits a particular market; the widget runs each and
     shows realised value over n.
  Predict-then-reveal is used for results that are not yet
  reachable by construction (limit-coherence, self-trust).
- **Framings (per project policy, ≥ 2 per central concept):**
  1. **Trader-market** (algorithmic / CS framing). Polynomial-time
     traders trying to exploit a price stream; "no trader gets
     unboundedly rich" as the central criterion.
  2. **Dutch-book / coherence** (decision-theoretic framing).
     The market's prices are coherent in the limit because no
     bookie can construct an arbitrage against them.
  3. **Logical-uncertainty-as-Bayesianism-over-mathematics**
     (probability framing). LI as an answer to "what is the
     right prior over mathematical statements when you have
     bounded compute?".
  4. **Untrollability / robustness** (operational framing).
     The inductor cannot be exploited by an adversary who
     chooses the deductive process to confuse it.
  Each central concept gets ≥ 2 framings; the full set is used
  at the level of the corpus.
- **Lean Game Server.** See "Open scope questions." Trader
  construction is the natural Lean game target.

## Secondary sources to build on

Listed above under "Secondary / distillation sources." Credits in
chapter intros once those chapters are written.

## Source issues

Empty for now. Populate as we encounter them. The paper has
multiple arXiv revisions; we pin v3 (2020-09) for citation.

## Status

- **Last updated:** 2026-05-05
- **Chapters complete:** 0
- **Currently being drafted:** scaffold only — `NOTES.md`,
  `source/download.sh`. First module will land after a §1–§3
  read.
- **Blockers:** none

## Cross-references

- *Singular Learning Theory* (`texts/slt`): both texts are
  Bayesian-flavoured but the math machinery is disjoint. Where
  LI's "logical uncertainty" framing meets SLT's "posterior over
  weights" framing, cross-link in the relevant chapter intro.
- *Embedded Agency* (Demski + Garrabrant): the broader research
  program LI sits inside. Cross-link from §1 Introduction.
- *Cartesian Frames* (Garrabrant, planned future text):
  Garrabrant's other major formal contribution. Worth a
  cross-reference when CF is scaffolded.
