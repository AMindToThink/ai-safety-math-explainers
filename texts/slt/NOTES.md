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
  - Some sandboxed environments (e.g., the autonomous Claude session
    that scaffolded this directory) firewall lesswrong.com,
    arxiv.org, and the Timaeus blog. Run `download.sh` from a
    machine with general internet egress to populate fully.
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

To populate after Chapter 1 of the Grey Book has been read end-to-end.
Initial empty state; first concrete rows will land in the next session
or two.

| Source location | Module slug | Toy system | Active check | Status | Human Review |
|-----------------|-------------|------------|--------------|--------|--------------|
|                 |             |            |              |        |              |

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
- **Currently being drafted:** none — scaffold only
- **Blockers:** none

## Cross-references

- *Logical Induction* (planned next text, slug `logical-induction`):
  shares the Bayesian / probability-over-mathematics setting, though
  the math machinery is disjoint.
- *Anthropic Mech-Interp cluster* and *Computational Mechanics for
  Transformers* both touch on phase-transitions / emergence framings
  that the SLT free-energy formula formalizes; expect cross-pointers
  once those texts are scaffolded.
