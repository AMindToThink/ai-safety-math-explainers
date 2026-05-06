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

- **Kōshin Alex Flint — *Logical Induction* (Python implementation)**
  https://github.com/monasticacademy/logical-induction. MIT license,
  © 2022 Kōshin Alex Flint. A deliberately simplicity-over-efficiency
  port of §5.4.1 of Garrabrant et al. 2016: `LogicalInductor.update`,
  `combine_trading_algorithms` (TradingFirm, §5.3.2),
  `compute_budget_factor` (Budgeter, §5.2), brute-force
  `find_credences` (MarketMaker via rational enumeration). The
  closer-to-the-paper companion to Scherlis's higher-level pseudocode;
  uses the §A.2 trading-formula ADT (Constant, Price, Sum, Product,
  Max, Min, SafeReciprocal) directly. `examples/` contains four
  end-to-end runs including `uniform_digits_of_pi.py` and
  `unbudgeted_digits_of_pi.py` — the right ground truth for the
  ch1 π-digit widget's "price converges to ≈0.1" claim. Accompanies
  an unpublished "Logical Induction for Software Engineers" article.
  - License: MIT. Code can be ported with attribution
    ("Adapted from Kōshin Alex Flint, monasticacademy/logical-induction"),
    no copyleft constraint on this repo.
  - Cross-check completed 2026-05-05 in
    [issue #12](https://github.com/AMindToThink/ai-safety-math-explainers/issues/12).

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
  - `git clone` of `epistax-is/logical-induction` (Scherlis's code)
    into `source/scherlis-code/`. As of 2026-05 this repo does not
    resolve; the clone may fail and the Scherlis arXiv source is
    treated as authoritative for that pseudocode.
  - `git clone` of `monasticacademy/logical-induction` (Flint's
    Python LIA, MIT 2022) into `source/flint-code/`. The
    closer-to-the-paper of the two implementations.
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

**First batch (Chapters 1–3 of the paper: motivation + the
criterion + properties).** Rows below are proposed by the
autonomous session on 2026-05-05; see "Proposed for approval" in
the corresponding `SESSIONS.md` entry. The Toy system column lists
the *primary* toy for the widget; secondaries appear in the
justification. Section/page references are to arXiv:1609.03543v3.

| Source location | Module slug | Toy system | Active check | Status | Human Review |
|-----------------|-------------|------------|--------------|--------|--------------|
| §1 Introduction (motivation, π-digit) | `li-ch1-pi-digit-paradox` | Bayesian forced into `P(π[87653]=7) ≥ P(1+1=2)` | Predict-then-reveal: pick the inequality the laws of probability force; build a logical inductor whose price for π[87653]=7 floats below 1 | drafted | [#11](https://github.com/AMindToThink/ai-safety-math-explainers/issues/11) |
| §1.1 of desiderata | `li-ch1-desiderata-tour` | The 17 desiderata as a clickable compatibility chip grid (Sawin impossibility, etc.) | Click any subset of desiderata; widget reports whether the subset is achievable, and if not, names the impossibility result | drafted | [#13](https://github.com/AMindToThink/ai-safety-math-explainers/issues/13) |
| §3.1 Markets + Table 1 (worked bets) | `li-ch2-market-trader-sandbox` | The §3.5 market: prices on `1+1=2`, `1+1≠2`, "Goldbach" | Design a trader (linear combination of buy/sell features); widget steps through n days, animates net worth in plausible worlds | drafted | [#9](https://github.com/AMindToThink/ai-safety-math-explainers/issues/9) |
| §3.2 Deductive processes | `li-ch2-deductive-process` | Tiny PA-fragment deductive process; `dt_n` as theorems-provable-in-≤n-chars | Drag n; predict which p.c.-worlds get ruled out at each step; identify the day at which `dt_n` rules out an irrational world | drafted | [#15](https://github.com/AMindToThink/ai-safety-math-explainers/issues/15) |
| §3.4 Traders (continuity + the χ paradox) | `li-ch2-continuity-paradox` | The paradoxical sentence χ := "I am true iff my price < 50¢" | Toggle continuous vs discontinuous trading strategies; show the no-fixed-point failure for discontinuous, the fixed-point existence (Brouwer) for continuous | drafted | [#14](https://github.com/AMindToThink/ai-safety-math-explainers/issues/14) |
| §3.5 Exploitation | `li-ch2-exploit-or-not` | Four traders on the same toy market; plot of plausible-net-worth band over n | Tab through traders, classify each as exploits / anti-exploits / bounded / unbounded-both based on the band's asymptotic shape | drafted | [#16](https://github.com/AMindToThink/ai-safety-math-explainers/issues/16) |
| §3.5 Exploitation + arbitrage example | `li-ch2-arbitrage-pair` | RH ∨ ¬RH provable disjunction; trader buys 10 of each at 20¢/30¢ each day | Slider for t★ (day D emits the disjunction); reader predicts whether the trader exploits regardless of t★ | drafted | [#17](https://github.com/AMindToThink/ai-safety-math-explainers/issues/17) |
| §4.1 Convergence theorem | `li-ch3-convergence` | A market that oscillates `p_n(φ) ∈ [0.3, 0.7]` indefinitely | Sketch the buy-low/sell-high trader (the convergence proof); watch its net worth tend to ∞; conclude the market cannot be a logical inductor | drafted | [#18](https://github.com/AMindToThink/ai-safety-math-explainers/issues/18) |
| §4.1 Limit coherence (the three Gaifman conditions) | `li-ch3-limit-coherence` | Three minimal counterexamples: T⊢φ but p<1; T⊢¬φ but p>0; T⊢¬(φ∧ψ) but linearity broken | Tabbed scenario picker per Gaifman condition; ε-amplitude slider; trader earns ε/day post D-proof in each | drafted | [#19](https://github.com/AMindToThink/ai-safety-math-explainers/issues/19) |
| §4.2 Provability induction (Ramanujan/Hardy) | `li-ch3-provability-induction` | 20 EC theorems with proof-length f(n); side-by-side heatmaps for the no-LI vs LI Hardy | Pick f-growth (linear/quadratic/cubic); identify whether LI's trust-threshold N★ depends on f | drafted | [#20](https://github.com/AMindToThink/ai-safety-math-explainers/issues/20) |
| §4.4 Calibration + correlated-cluster example | `li-ch3-calibration-cluster` | The `clusters_n` sequence with cluster sizes 1, 10, 100, 1000, ... | Drag cluster ratios; observe that empirical-frequency calibration oscillates eternally; the inductor's *marginal* p_n stays at 50% throughout — the right answer | proposed | |
| §4.3 Statistical-pattern learning | `li-ch3-pi-statistical` | π-digit prediction; `(π[Ack(n,n)]=7)_n` | Compare three hypothetical reasoners' price trajectories; predict the limit price (≈ 0.1) of the inductor when digits are pseudorandom | drafted | _pending_ |
| §5.1–§5.4 LIA construction (MarketMaker → Budgeter → TradingFirm → LIA) | `li-ch4-lia-walkthrough` | Tiny PA-fragment + 3-trader enumeration | Step-through animator: pick a day, see MarketMaker's fixed-point search, Budgeter cap, TradingFirm aggregation, and the resulting belief state | proposed | |
| §6.12 Self-trust (Löb-shaped) | `li-ch3-self-trust` | "$\\mathbb{P}_n(\\phi) \\to \\mathbb{P}_n(\\mathbb{P}_m(\\phi))$" trust statements | Predict-then-reveal: which Löb-style fixed-point obstructs naive self-reference, and how does an inductor route around it? Stretch module — depends on §6.10/§6.12 read. | proposed | |

### Module justifications

- `li-ch1-pi-digit-paradox` — anchors Chapter 1's central claim:
  classical probability *forces* a perfect Bayesian to be at least
  as confident in `π[87653]=7` as in `1+1=2`, because in fact
  `(1+1=2) ⇒ π[87653]=7`. Most readers do not feel the bite of
  this until they see it as a forced inequality. Builds the
  Bayesianism-over-mathematics framing and exposes the logical-
  uncertainty problem before any new formalism appears.
- `li-ch1-desiderata-tour` — the introduction lists 17 desiderata
  (Computable Approximability, Coherence, Approximate Coherence,
  Statistical Patterns, Calibration, Non-Dogmatism, Uniform
  Non-Dogmatism, Universal Inductivity, Approximate Bayesianism,
  Introspection, Self-Trust, Approximate Inexploitability,
  Gaifman Inductivity, Efficiency, Decision Rationality,
  Counterpossibles, Old Evidence). Many are jointly incompatible
  (Sawin: 1+6+13+weak-2 are inconsistent). A clickable
  "compatibility graph" lets the reader feel which desiderata LI
  actually meets and why a few must be dropped. Exits the
  introduction with an honest map of the design space.
- `li-ch2-market-trader-sandbox` — *the* central widget for the
  paper. The Table 1 toy market (φ:=1+1=2 at 90¢, ψ:=1+1≠2 at 5¢,
  χ:="Goldbach" at 98¢) is exactly the worked example in §3.4
  (paper p. 19). Reader writes a trading strategy as a small
  affine combination of price features and watches realized value
  evolve in plausible worlds. This widget is where the
  trader-market framing lands; reused by exploitation / arbitrage
  / convergence widgets downstream. One toy carried across the
  chapter, per project policy.
- `li-ch2-deductive-process` — `D` is one of two new objects in
  §3 (the other is the trader). A small PA-fragment example with
  `dt_n` = theorems-provable-in-≤n-characters lets the reader
  *see* `pcworlds(dt_n)` shrink. Sets up the "exploitation
  relative to a deductive process" framing used later.
- `li-ch2-continuity-paradox` — the paragraph at p. 18 about the
  paradoxical χ := "I am true iff my price < 50¢" is one of the
  most frequently misunderstood corners of the paper. A widget
  that lets the reader toggle continuous vs discontinuous trading
  and see the no-fixed-point failure / Brouwer success makes the
  motivation for the continuity constraint visceral. Connects
  forward to §6.11 introspection.
- `li-ch2-exploit-or-not` — multiple-choice with verification; a
  good warm-up before the sandbox. Three candidate traders, one
  market; learner picks the exploiting trader; widget runs each
  and animates plausible-world bounds. Active-check pattern from
  the project's pedagogy section.
- `li-ch2-arbitrage-pair` — the (φ ∨ ψ)-but-neither-decidable
  example on p. 22 is the cleanest demonstration that
  exploitation does *not* require any sentence to ever resolve.
  Widget shows two prices drifting until provability of (φ ∨ ψ)
  collapses the bound. Gateway to limit-coherence intuition.
- `li-ch3-convergence` — the convergence theorem's proof sketch
  (p. 24) is the cleanest "exploit the inefficiency" argument in
  the paper. Animating an oscillating market and showing the
  buy-low/sell-high trader earning ε every cycle nails the
  pedagogical pattern that recurs throughout §4: every property
  is enforced because its violation is exploitable.
- `li-ch3-limit-coherence` — the three Gaifman conditions
  (T⊢φ→p_∞=1; T⊢¬φ→p_∞=0; T⊢¬(φ∧ψ)→linearity) each have a clean
  exploit-on-violation. Build all three traders, watch them earn,
  conclude the prices must be coherent in the limit. Three
  framings of one theorem reinforces the project's
  "multiple-framings" rule.
- `li-ch3-provability-induction` — §4.2 Theorem `provind` is the
  paper's signature result. Ramanujan/Hardy is the right
  metaphor; the `prg(n)∈{0,1,2}` example is the right toy.
  Reader tunes the runtime of `prg`; the inductor's diagonal
  `p_n(φ_n)` rises to 1 ahead of the deductive process. The
  "outpacing deduction" claim becomes visceral.
- `li-ch3-calibration-cluster` — the `clusters_n` example on
  p. 35 is the paper's most pedagogically valuable demonstration
  of a counter-intuitive fact: you can be *correct* (assigning
  50% to coin-flip-like sequences) while being *miscalibrated*
  in the empirical-frequency sense. Drag the cluster ratio;
  watch calibration oscillate between 1 and 0; the inductor's
  marginal stays right.
- `li-ch3-pi-statistical` — §4.3 Theorem `prand` is the paper's
  formal statement of "if a sequence is pseudorandom relative
  to all polynomial-time predictors of comparable complexity,
  the inductor will price it at the empirical frequency." The
  π-Ackermann-digit example is the running canonical case; this
  widget makes the convergence to 0.1 visible.
- `li-ch4-lia-walkthrough` — the construction chapter (§5) is
  the algorithmic heart of the paper. Most readers stall here
  because MarketMaker, Budgeter, and TradingFirm are introduced
  in tight succession without a worked example. A
  step-through-an-animator widget on a tiny PA-fragment + 3
  enumerated traders earns its keep more than any other module.
  Capstone for chapter 4.
- `li-ch3-self-trust` — Stretch. §6.12 introduces a Löb-shaped
  self-trust statement that has its own decade-long literature.
  Worth a widget eventually, but only after §4 + §5 are in.
  Marked proposed so the row exists; implementation deferred.

### Lean Game Server module (`lean-game/`)

Per Matthew's explicit ask this session: scaffold a Lean 4 +
GameServer project where the central skill is "construct a trader
that exploits a Dutch-bookable market." Initial level slate:

- **World 1: Buying and selling (warm-up).** Net cash + share value
  is invariant under "fair" trades at the listed prices. Reader
  proves the basic conservation law for a single trade.
- **World 2: Persistent mispricing.** The 1+1=2 market priced at
  50¢ forever. Reader constructs an explicit trader that earns
  unbounded plausible value, and Lean checks the proof.
- **World 3: Arbitrage.** Reader constructs the φ vs ¬¬φ
  arbitrage trader and proves it has bounded losses but
  unbounded gains.
- **World 4: Coherence enforcement.** Reader proves that if a
  market satisfies p(φ) + p(¬φ) = 1 in the limit, no naive
  arbitrage trader of the kind built in World 3 can exploit it.
  (Optional / stretch.)

Lean game lives at `texts/logical-induction/lean-game/` until it's
ready to publish on `adam.math.hhu.de`, at which point it moves
to its own GitHub repo per `CONTRIBUTING.md`.

### Notes on toys and framings

- **Default chapter-level toys:**
  - **π-digit toy:** the `(π[n]=k)` family (and its Ackermann
    cousin for the pseudorandom-statistics modules). Used in
    `li-ch1-pi-digit-paradox`, `li-ch3-pi-statistical`, and a
    cameo in `li-ch3-provability-induction`.
  - **PA-fragment toy:** a small Peano-arithmetic-fragment
    deductive process where `dt_n` = theorems-provable-in-≤n-chars.
    Used in `li-ch2-deductive-process`, `li-ch2-market-trader-
    sandbox`, `li-ch3-convergence`, `li-ch4-lia-walkthrough`.
- **Framings used in this batch:**
  1. **Trader-market** (algorithmic) — ch2-market-trader-sandbox,
     ch2-exploit-or-not, ch2-arbitrage-pair, ch3-convergence,
     ch3-limit-coherence (each "exploit the violation"
     construction), ch4-lia-walkthrough.
  2. **Dutch-book / coherence** (decision-theoretic) —
     ch1-desiderata-tour (Approximate Inexploitability),
     ch3-limit-coherence.
  3. **Probability over mathematics** —
     ch1-pi-digit-paradox (the "P(A) ≤ P(B) when A ⇒ B" trap),
     ch3-pi-statistical, ch3-calibration-cluster.
  4. **Untrollability / robustness** — ch2-continuity-paradox,
     ch3-self-trust.
  All four framings are exercised in the first batch. Per project
  policy each central concept gets ≥ 2; the central concept
  here ("the LI criterion") gets all four.

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

## Things to consider porting from Flint

Surfaced by the issue-#12 cross-check against
`monasticacademy/logical-induction` (MIT, © 2022 Kōshin Alex Flint).
Attribution string for any port: *"Adapted from Kōshin Alex Flint,
monasticacademy/logical-induction"*.

- **`worlds_consistent_with` (`inductor.py`).** Tighter than our
  ad-hoc `plausibleWorlds` — handles arbitrary propositional
  observations rather than a hardcoded `decided(n)` table. Useful
  when a future widget admits arbitrary observation sentences.
- **`find_credences` + `rationals_between` (`inductor.py`,
  `enumerator.py`).** A ~30-line MarketMaker over rational
  enumeration. Direct fit for `li-ch4-lia-walkthrough`'s step-through
  animator. Caveat: the paper describes MarketMaker as a fixed-point
  search, not enumeration; check equivalence on multi-trader markets
  with irrational fixed points before claiming it *is* the LIA's
  MarketMaker.
- **`make_s_curve` / `trade_on_probability` (`examples/uniform_digits_of_pi.py`,
  `unbudgeted_digits_of_pi.py`).** The "trade hard when price differs
  from $p$" pattern — slope-10 sigmoid clipped to $[-1, 1]$. Would
  upgrade `01-pi-digit-paradox.html` from a hardcoded-snap toy to a
  real (small-scale) inductor. Worth a follow-up widget rather than
  retro-fitting the existing one.
- **`combine_trading_algorithms` (TradingFirm, §5.3.2).** ~60 lines;
  the cleanest existing implementation. Backs `li-ch4-lia-walkthrough`.
- **`SafeReciprocal` / budget-factor pattern.** `1 / max(1, x)`,
  the cleanest one-liner for the budgeter; expose as a sidebar
  in any §5.2 widget.
- **Lean game gap.** Our scaffold (Markets, Exploits) has no
  analogue for the budgeter / market-maker / trading-firm trio.
  Add a third world (`Aggregation` or `TradingFirm`) when §5
  chapters land. Natural sub-levels: (a) compute `quantity_bound`
  for an affine trading expression; (b) compute the budget divisor
  for one consistent world; (c) sum two trading policies
  sentence-wise; (d) prove the aggregate exploits whenever any
  constituent does.

Open questions to resolve before any port:

- `find_credences` enumerates *rational* credences. Equivalent to
  the paper's fixed-point MarketMaker on multi-trader markets with
  irrational fixed points? (Single-sentence continuous-trader case
  should converge for both; multi-trader case is unclear.)
- Flint uses `1e-7` / `1e-8` epsilons in `compute_budget_factor`;
  the paper does not. Numerical-stability fudges. Match the values
  or document the choice if we deviate.

## Source issues

Empty for now. Populate as we encounter them. The paper has
multiple arXiv revisions; we pin v3 (2020-09) for citation.

## Status

- **Last updated:** 2026-05-05
- **Chapters complete:** 0
- **Currently being drafted:** scaffold + module proposal landed;
  `li-ch2-market-trader-sandbox` (the centerpiece widget for §3)
  shipped as a single-file standalone widget at
  `chapters/ch2-the-criterion/widgets/01-market-trader-sandbox.html`,
  with a five-trader catalogue (canonical $\varphi$-buy exploit;
  $\psi$-sell exploit; $\chi$-Goldbach bet that does not exploit;
  combined exploits; combined exploit-plus-bet that ruins the
  exploit). Smoke-tested clean.

  **Lean Game Server scaffold landed** at
  `texts/logical-induction/lean-game/` with `lakefile.lean` (verbatim
  GameSkeleton template), `lean-toolchain` pinned to
  `leanprover/lean4:v4.23.0`, `Game.lean`, two worlds, and five
  levels: Markets/L1 buy-share warm-up, Markets/L2 sell-share,
  Markets/L3 combined-net-worth, Exploits/L1 n-day buy with
  induction, Exploits/L2 bounded-loss pre-resolution. **Build
  not verified** in the autonomous sandbox (no `elan`); next
  session or any local checkout should run `lake update -R && lake
  build`. See `lean-game/README.md` for status notes.
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
