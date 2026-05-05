# NOTES — Singular Learning Theory

Per-text scaffold for the Singular Learning Theory (SLT) companion. Fill
out before writing chapter prose. Update as decisions evolve. Keep this
file authoritative for scope, notation, and status.

## Source

This companion treats SLT as a corpus rather than a single text. Two
Watanabe monographs are the spine; the Timaeus / DevInterp ecosystem
(Carroll's DSLT, Hoogland's free-energy posts, the `devinterp` library,
Furman's exercises, metauni seminars) supplies modern context, code, and
distillation passes that the Watanabe books deliberately omit.

### Primary sources

- **Title:** *Algebraic Geometry and Statistical Learning Theory*
  ("Grey Book")
  - **Author:** Sumio Watanabe
  - **Publisher / year:** Cambridge University Press, 2009
    (Cambridge Monographs on Applied and Computational Mathematics, vol. 25)
  - **Length:** ~250 pp
  - **License / reproduction terms:** Cambridge University Press
    copyright; not redistributable. Readers must obtain via library or
    purchase. PDF is gitignored.
  - **Link:** https://www.cambridge.org/core/books/algebraic-geometry-and-statistical-learning-theory/9C8FD1BDC817E2FC79117027B6B7CFD0

- **Title:** *Mathematical Theory of Bayesian Statistics* ("Green Book")
  - **Author:** Sumio Watanabe
  - **Publisher / year:** CRC Press / Chapman & Hall, 2018
  - **Length:** ~330 pp
  - **License / reproduction terms:** CRC Press copyright; not
    redistributable. Gitignored.
  - **Link:** https://www.routledge.com/Mathematical-Theory-of-Bayesian-Statistics/Watanabe/p/book/9780367734817

### Secondary / distillation sources (treated as ground truth alongside primaries)

- **DSLT 0–4** — Liam Carroll's *Distilling Singular Learning Theory*
  sequence on the Alignment Forum (2023). The clearest existing
  companion to Watanabe; a useful starting point for chapter framings
  and worked examples. Available as a public web sequence on LessWrong /
  Alignment Forum; HTML is freely viewable but the prose is CC-BY (LW
  default) — check per-post license at ingestion time.
  - https://www.alignmentforum.org/s/czrXjvCLsqGepybHC

- **`devinterp`** — Timaeus's open-source Python library for LLC
  estimation, SGLD samplers, and DevInterp experiment infrastructure.
  MIT-licensed; safe to clone into `source/`.
  - https://github.com/timaeus-research/devinterp

- **DevInterp papers** — series of arXiv preprints from Timaeus
  (e.g., Lau et al. on LLC, Hoogland et al. on developmental phases,
  Chen et al. on toy-model phase transitions). arXiv-licensed; safe to
  ingest LaTeX via `arxiv.org/e-print/<id>`.

- **Furman's exercises** — exercise sets accompanying the metauni SLT
  seminars. URL TBD at ingestion time.

- **Hoogland and others, free-energy / phase-transition posts** — set
  of LessWrong / Alignment Forum posts. To be enumerated during
  ingestion.

- **Watanabe's lecture notes / preprints** — when freely available on
  Watanabe's homepage, prefer those for any chunk that overlaps with
  the books, since they are redistributable. URL TBD.

## Source ingestion

`texts/slt/source/download.sh` is the lockfile for the SLT corpus. See
also `texts/slt/source/README.md` for the directory layout.

- **Format(s) downloaded:**
  - HTML for the Carroll DSLT 0–4 posts (LessWrong / AlignmentForum /
    GreaterWrong fallbacks) — converted to Markdown locally if
    `pandoc` is installed.
  - PDF for Carroll's MSc thesis (freely posted at
    `therisingsea.org`) plus a `pdftotext -layout` extraction.
  - `git clone` of `timaeus-research/devinterp` (MIT).
  - LaTeX e-prints for selected DevInterp arXiv papers via
    `arxiv.org/e-print/<id>`.
  - HTML mirror of the same content from the Timaeus / DevInterp blog
    (`timaeus.co` / `devinterp.com`), as backup and for the SLT
    exercises page.
- **Manually placed (not auto-downloaded):** Watanabe Grey Book and
  Green Book PDFs — see `source/watanabe/README.md` for expected file
  names. Cambridge / CRC copyright; not redistributable.
- **Reconstruction command:** `bash texts/slt/source/download.sh`
  (idempotent; tolerant of partial network failures).
- **Chosen authoritative format for imports:** order of preference for
  prose quotation is documented in `source/README.md`. Briefly:
  Carroll thesis `.txt` extraction or DSLT markdown for the
  distillation arc; arXiv LaTeX for DevInterp paper claims; Watanabe
  PDFs (page-numbered) for the canonical theorem statements.
- **Known extraction issues:**
  - `pdftotext` will mangle Watanabe's algebraic-geometry diagrams
    (resolution-of-singularities, blow-up illustrations); always keep
    the PDFs around for figures.
  - LessWrong HTML embeds MathJax; equations survive a `pandoc`
    conversion to GFM but inline math sometimes loses surrounding
    whitespace.
  - Sandbox network egress is intermittent across autonomous
    sessions: the 2026-05-05 ~12:00 session reported every source
    host (arxiv.org, lesswrong.com, alignmentforum.org,
    therisingsea.org, timaeus.co, devinterp.com) firewalled, while
    the 2026-05-05 ~05:54 session that follows confirmed full
    egress to all of them. Don't assume either profile; always run
    `download.sh` defensively.
  - **Timaeus blog slugs have drifted.** As of 2026-05-05, the
    `download.sh` URLs for `dslt-1` (`2023-06-17-dslt-1`) and
    `dslt-4` (`2023-06-22-dslt-4`) return 404 from `timaeus.co`
    *and* `devinterp.com`; the other DSLT mirrors (0, 2, 3) and
    the SLT exercises page resolve fine. The LessWrong copies are
    the authoritative source of record anyway, so this is not
    project-blocking — but if you need the Timaeus rendering
    specifically, browse `https://timaeus.co/blog/` for the current
    slug and update `download.sh`.
  - Required apt packages on a fresh sandbox:
    `apt-get install -y poppler-utils pandoc`. The script tolerates
    their absence (skipping `pdftotext` / `pandoc` post-processing)
    but the resulting `dslt/*.md` and `carroll-thesis/*.txt`
    extractions won't be there to grep.
- **Gitignored?** Yes. Repo-level `.gitignore` excludes
  `texts/*/source/*` except for `download.sh` and `README.md`. Nested
  READMEs inside subdirectories (e.g., `watanabe/README.md`,
  `metauni/README.md`) are written by `download.sh` itself on each
  run and stay gitignored — they're regenerated, not committed.

## Why this text matters for safety

SLT is the mathematical spine of the Timaeus / DevInterp research
program: the Local Learning Coefficient (LLC), Bayesian phase
transitions in deep learning, free-energy explanations of grokking and
emergent capability, and SLT-native developmental interpretability.
Anthropic, DeepMind, and OpenAI have engaged with this agenda; making
its core machinery (RLCT, free energy formula, WBIC, posterior
concentration) genuinely teachable to ML-literate but
algebraic-geometry-naive readers is the highest-leverage pedagogical
opportunity we currently see in formal alignment.

(Adapted from the entry in
`../../math-heavy-texts-for-explanations.md` — verify against source
before relying.)

## Prerequisites

To be sharpened per chapter. First-pass list, expected to be needed
before Chapter 1 of the Grey Book is tractable:

- Real and complex analysis through dominated convergence and
  holomorphic continuation.
- Measure-theoretic probability through conditional expectation,
  Radon–Nikodym, weak convergence.
- Differential geometry through manifolds, charts, smooth maps.
- Commutative algebra and elementary algebraic geometry: ideals,
  varieties, irreducible decomposition, blow-ups, normal-crossings
  divisors, resolution of singularities (Hironaka).
- Schwartz distributions and Mellin transforms (used in the
  zeta-function machinery for the RLCT).
- Empirical processes and basic large-deviations.

For ML-fluent readers without algebraic-geometry background, the
companion will need short primers on varieties, blow-ups, and the
Mellin transform; flag these for write-up.

## Scope

### In scope (initial plan; revise as we go)

Following the recommendation in
`math-heavy-texts-for-explanations.md`:

- **Grey Book** Chapters 1, 4, 6, 7 in depth. (The "boring compression"
  AG crash chapters may be supplemented with primers; we read them but
  do not necessarily build full module coverage.)
- **Green Book** WAIC and WBIC machinery.
- **DSLT 0–4** (Carroll) as the on-ramp; treated as a complement to,
  not replacement for, Watanabe.
- 2–3 DevInterp case studies (LLC estimation on toy models, a
  phase-transition reproduction, plausibly a `devinterp`-based grokking
  walk-through).

### Out of scope, with reasons

- The Grey Book's full algebraic-geometry compression chapters as a
  standalone module. Reason: the project is not the right venue to
  reteach AG from scratch; we instead cover the AG concepts on a
  just-in-time basis as they appear in the SLT chapters that need
  them.
- Watanabe's most recent papers post-Green-Book except where they're
  critical to a DevInterp result we cover.

### Open scope questions

- How much SGLD / sampler infrastructure to build into widgets vs.
  treat as opaque? Default: opaque, with a single explainer page on
  what SGLD is doing, since otherwise the reader gets lost in MCMC
  detail unrelated to SLT.
- Whether to include a Lean Game Server module. SLT's
  resolution-of-singularities content is theorem-heavy and Lean's
  Mathlib has nontrivial AG content; potentially natural, but not
  immediately a priority. Defer.

## Notation map

To populate as chapters are processed. Default is to keep Watanabe's
notation; deviations get rows here with a reason.

| Source | Companion | Reason |
|--------|-----------|--------|
|        |           |        |

## Module breakdown

The distillation arc (DSLT 0–4 by Liam Carroll) is the on-ramp; we
treat it as the project's "Chapter 1" for SLT, as recommended in
`math-heavy-texts-for-explanations.md`. Watanabe Grey/Green chapters
will be threaded in once the corresponding distillation modules exist.

**First batch (DSLT 1: "The RLCT Measures the Effective Dimension of
Neural Networks").** All rows below are proposed by the autonomous
session on 2026-05-05; see "Proposed for approval" in the next
SESSIONS.md entry. Each row's justification appears immediately below
the table. Toy system column lists the *primary* toy for the widget;
secondary toys are noted in the justification.

| Source location | Module slug | Toy system | Active check | Status | Human Review |
|-----------------|-------------|------------|--------------|--------|--------------|
| DSLT 1 §Preliminaries (Carroll thesis Ch 2) | `dslt1-bayes-loss-landscape` | 1D & 2D polynomial K(w) (Examples 1.1, 1.2) | Pan a 2D K(w); identify W₀; predict whether it is a point, a curve, or an intersecting arrangement | drafted | |
| DSLT 1 §Preliminaries + DSLT 2 §"Free Energy, Generalisation and Model Selection" / §"Animation 1" | `dslt1-singular-posterior` | Same polynomial K family from widget 1; slider on n | Drag n; predict the asymptotic posterior shape (Gaussian spike vs spread along W₀ vs preference for the lowest-local-RLCT singularity) | drafted | |
| DSLT 1 §"What is a singular model?" | `dslt1-fisher-degeneracy` | Same polynomial K family + a 1-hidden-unit ReLU regressor for contrast | Compute I(w₀); classify regular vs strictly singular by det I(w₀) = 0 | in progress | |
| DSLT 1 §"Classical Bayesian inference breaks down" | `dslt1-bic-derivation` | Comparison K = w² (regular) vs K = w⁴ (singular) | Step through the BIC derivation; pinpoint the line that fails under degenerate I(w₀) | not started | |
| DSLT 1 §"Dimensionality as a volume co-dimension" | `dslt1-volume-scaling-rlct` | 1D K(w) = w^(2k) and 2D normal-crossing K | Scrub ε; plot log V(ε) vs log ε; read slope = λ. Tune k so 2λ matches a target effective dimension | not started | |
| DSLT 1 §"The RLCT can be read off when K(w) is in normal crossing form" (one- and multi-dim cases) | `dslt1-normal-crossing-game` | Polynomial K in normal crossing form, 1D/2D | Game: given K(w) = ∏ w_i^(2k_i) (possibly with shifted critical points, à la Example 1.5), read off the local and global RLCT and multiplicity | not started | |
| DSLT 1 §"Resolution of Singularities" | `dslt1-resolution-primer` | Real plane curves V(xy), V(x²−y³), V(x²−y²) | Animated blow-up: see how (M, g) puts K(g(u)) into normal crossing form. Active: pick the blow-up centre that resolves a given singularity | not started | |
| DSLT 1 §"The RLCT measures the effective dimensionality" + WBIC | `dslt1-wbic-vs-bic` | Toy regular K = w² + w² vs toy singular K = w₁² w₂² | Side-by-side BIC vs WBIC as n grows; predict-then-reveal which model "wins" at each n | not started | |

### Module justifications

- `dslt1-bayes-loss-landscape` — anchors the chapter's notation
  (K(w), W₀, posterior, free energy) before any RLCT machinery. Lets
  the reader internalise that the loss landscape's *level sets*, not
  just its *minima*, carry the information.
- `dslt1-singular-posterior` — added 2026-05-05 at Matthew's
  request. The singular posterior is the most visceral "this is
  not your textbook Bayesian setting" demonstration: as $n \to
  \infty$, regular posteriors spike to a Gaussian, but singular
  posteriors trail along $W_0$ or split unevenly across
  singularities by RLCT. Reuses the toy K family from widget 1 so
  the reader's mental model of $K$ carries over directly. Borrows
  the n-slider framing from DSLT 2 §Animation 1 but puts it in
  Chapter 1's lap so the funkiness lands before the formal RLCT
  derivation does.
- `dslt1-fisher-degeneracy` — makes the operational definition of
  "singular" tangible: the reader computes a small Fisher matrix and
  reads off its rank. Includes a 1-hidden-unit ReLU example as a
  forward pointer to DSLT 3.
- `dslt1-bic-derivation` — Carroll's step-by-step BIC derivation
  becomes a guided walk-through where the reader has to identify the
  one step that requires det I(w₀) ≠ 0. This is the single most
  important "why does the classical theory fail?" moment in the
  chapter.
- `dslt1-volume-scaling-rlct` — the central widget for the chapter.
  V(ε) ∝ ε^λ is the cleanest construct-an-X check in DSLT 1 (target
  an effective dimension, find a polynomial K that achieves it). The
  geometric framing (volume scaling) and the algebraic framing
  (zeta-function poles, in Appendix 1) both flow from this widget.
- `dslt1-normal-crossing-game` — once the volume formula is in hand,
  monomial K(w) makes λ a *calculation* rather than an asymptotic.
  Lean-Game-Server-shaped: a sequence of small problems with
  progressively richer scoring (multiple critical points → global vs
  local RLCT, multiplicity).
- `dslt1-resolution-primer` — Hironaka's theorem is the conceptual
  bridge from "compute RLCT only for normal-crossing K" to "compute
  it for any analytic K". A short, visual primer on real blow-ups
  (no AG prerequisites assumed) earns its keep here.
- `dslt1-wbic-vs-bic` — closes DSLT 1 by replacing d/2 with λ in the
  free-energy formula and previewing DSLT 2's accuracy-complexity
  reading. Doubles as a sanity check that everything earlier in the
  chapter assembles into a single quantity.

### Notes on toys and framings

- **Default DSLT-1 toy family:** real polynomial K(w) drawn from
  Carroll's worked examples in DSLT 1 (w², w⁴, ½ w₁² w₂², (w+1)² w⁴,
  (w₁+1)² w₁⁴ w₂²). One toy family carried across the chapter, with
  the 1-hidden-unit ReLU network introduced as a forward-pointer
  contrast in `dslt1-fisher-degeneracy` only.
- **Framings used in DSLT 1:** algebraic-geometric (RLCT as a
  geometric invariant of W₀) and Bayesian (effective dimension as
  the rate at which the posterior concentrates). The
  statistical-physical framing (free energy as
  −log Z) is introduced but its weight lands in DSLT 2's `wbic`
  modules.

## Pedagogical decisions

- **Default toy systems** (carried across the corpus where possible):
  - 1-hidden-unit ReLU network (singular when the hidden weight is
    zero) — Watanabe's canonical example and a workhorse in DSLT.
  - Toy 2D varieties V(x²), V(x²−y³), V(xy), etc., for blow-up and
    normal-crossings demos.
  - Small Boltzmann machine / linear regression with rank-deficient
    design (singular regular models) for posterior-concentration
    demos.
- **Default visualization style:** D3 / Three.js for varieties and
  blow-ups, Plotly / Recharts for free-energy curves and posterior
  surfaces, `devinterp`-driven SGLD plots for LLC estimation, MathJax
  for prose.
- **Active checks:** "Construct an X" by default. Examples:
  construct a normal-crossings resolution of a given variety; identify
  the RLCT of a given polynomial loss landscape via Newton polyhedra;
  pick (n, β) so a particular phase wins under the free-energy
  formula. Predict-then-reveal for results not yet reachable by
  construction.
- **Framings (per project policy, ≥ 2 per central concept):**
  1. Algebraic-geometric (varieties, blow-ups, RLCT as a geometric
     invariant).
  2. Statistical-physical (free energy, partition functions, phase
     transitions in n).
  3. Bayesian posterior concentration (asymptotic posterior on a
     singular set, normal vs. anomalous fluctuation rates).
  4. Empirical / DevInterp (LLC measurements on real networks, where
     the theory makes verifiable predictions).
  Each central concept gets ≥ 2 of these; full set used at the level
  of the corpus.

## Secondary sources to build on

Listed above under "Secondary / distillation sources." Credits in
chapter intros once those chapters are written.

## Source issues

Empty for now. Populate as we encounter them.

## Status

- **Last updated:** 2026-05-05
- **Chapters complete:** 0
- **Currently being drafted:** Two DSLT 1 widgets shipped as
  single-file standalone HTML and marked drafted —
  `dslt1-bayes-loss-landscape` (module 1) and
  `dslt1-singular-posterior` (module 2). Six remaining DSLT 1
  modules still proposed and awaiting human approval.
- **Blockers:** none

## Cross-references

- *Logical Induction* (planned next text, slug `logical-induction`):
  shares the Bayesian / probability-over-mathematics setting, though
  the math machinery is disjoint.
- *Anthropic Mech-Interp cluster* and *Computational Mechanics for
  Transformers* both touch on phase-transitions / emergence framings
  that the SLT free-energy formula formalizes; expect cross-pointers
  once those texts are scaffolded.
