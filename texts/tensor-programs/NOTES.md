# NOTES — Tensor Programs

Companion to Greg Yang's **Tensor Programs** series (2019–2023) and the
**Maximal Update Parametrization (μP)** / **μTransfer** line of work.

## Source

- **Title:** Tensor Programs (TP I–VI) and adjacent papers
- **Author(s):** Greg Yang, with various coauthors (Edward Hu, Etai
  Littwin, Dingli Yu, Chen Zhu, Soufiane Hayou, James Simon)
- **Year / version read:** TP IV (2021), TP V (2022), TP VI (2023),
  Spectral Condition (2023), TP IVb (2023). TP I (2019) read for
  framing.
- **Link:**
  - TP I: https://arxiv.org/abs/1910.12478
  - TP IIb: https://arxiv.org/abs/2105.03703
  - TP IV: https://arxiv.org/abs/2011.14522
  - TP IVb: https://arxiv.org/abs/2308.01814
  - TP V (μTransfer): https://arxiv.org/abs/2203.03466
  - TP VI (Depth-μP): https://arxiv.org/abs/2310.02244
  - Spectral Condition: https://arxiv.org/abs/2310.17813
- **Length:** ~700 pages of papers in aggregate; TP IV alone is ~70
  pages. The "core" pedagogical content is roughly TP IV §§1–4 + TP V
  §§1–3 + the Spectral Condition reformulation (~80 pages).
- **License / reproduction terms:** arXiv standard license. LaTeX
  source freely redistributable; per repo policy still gitignored.

## Source ingestion

- **Format(s) downloaded:** LaTeX from arXiv via `arxiv.org/e-print/<id>`.
- **Reconstruction command(s):** `bash texts/tensor-programs/source/download.sh`.
- **Chosen authoritative format for imports:** LaTeX from `source/arxiv/<paper>/`.
- **Known extraction issues:** TP papers use heavy custom macros (Yang's
  bra-ket notation in TP IVb in particular). Definitions should be
  imported with their `\newcommand` context or explicitly translated.
- **Gitignored?** Yes (default).

## Why this text matters for safety

μP is the parametrization underlying **predictable scaling** of frontier
training runs at Anthropic, OpenAI, xAI, Cerebras, EleutherAI. The
deeper TP framework gives the only systematic theory of which infinite-
width limits *learn features* (i.e., the embedding evolves during
training) versus which collapse to fixed-kernel behavior. This matters
for safety in three ways: (1) μTransfer makes large-model behavior
*forecastable* from small-model sweeps, which is load-bearing for
scaling-policy commitments; (2) the feature-learning vs. kernel
dichotomy (TP IV's "dynamical dichotomy") tells you *whether* a model
is learning representations interpretability work could find — NTK-
regime models in principle can't; (3) the Spectral Condition gives a
clean diagnostic (coord-checks) for when training is in a regime where
classical analyses apply.

## Prerequisites

- Linear algebra through random Gaussian matrices; spectral norm and
  operator-norm bounds at the Marchenko–Pastur level.
- Probability through almost-sure convergence; multivariate Gaussians;
  conditional Gaussian distributions ("Gaussian conditioning trick").
- Working familiarity with neural network training (forward + backward
  pass, SGD, Adam at the algorithmic level).
- Comfort with sequences indexed by a width parameter N → ∞.
- Optional but helpful: Neural Tangent Kernel (Jacot et al. 2018);
  classical mean-field results (Mei–Montanari–Nguyen, Chizat–Bach).

## Scope

### In scope

Likely first chapters (subject to revision after deeper reads):

- The Tensor Program language: syntax, the three operations, what
  "compiling a network into a TP" means.
- The Master Theorem informally: how you read off the limiting
  distribution of a TP variable as N → ∞.
- abc-parametrizations: the (a, b, c) cube and where NTK, mean-field,
  standard, and μP live in it.
- The dynamical dichotomy: feature-learning regimes vs. kernel regimes.
- Coord checks as a practical diagnostic.
- μTransfer: what HPs transfer, what doesn't, why.
- The Spectral Condition reformulation.

### Out of scope, with reasons

- Full proof of the Master Theorem (uses Gaussian conditioning + free
  probability; a research-level formalization).
- TP IVb's bra-ket notation and Adam-specific machinery (defer until
  the SGD-only story is in place).
- TP VI Depth-μP (defer; depthwise scaling is a second chapter at
  earliest).
- TP I/IIb's NTK universality theorems (background, cite-and-link
  rather than reproduce).

### Open scope questions

- Whether to include a chapter on classical mean-field shallow nets
  (Mei–Montanari–Nguyen) as background, or assume readers go elsewhere
  for it. Leaning include-as-an-appendix.

## Notation map

| Source | Companion | Reason |
|--------|-----------|--------|
|        |           | (filled out per chapter) |

## Module breakdown

| Source location | Module slug | Toy system | Active check | Status | Human Review |
|-----------------|-------------|------------|--------------|--------|--------------|
| TP I §2 + TP IV §2 | tp-ch1-language | 2-layer MLP at width N ∈ {64, 256, 1024} | Lean-game World 1 (Syntax): construct TP terms for forward/backward pass | not started | |
| TP IV §§3–4 | tp-ch2-abc-plane | same | Interactive abc-cube widget; place a point, see coord-check plot | not started | |
| TP IV §§5–6 + Spectral Condition | tp-ch3-feature-learning | same | Lean-game World 2 (Compose): rewrite identities; coord-check oracle | not started | |
| TP V §§1–3 | tp-ch4-mutransfer | nanoGPT-mup at three widths | μTransfer demo: tune at small width, transfer, observe | not started | |

Initial scaffolding adds Chapter 1 placeholder + Lean game scaffold
(Worlds 1–2 stubs). Chapters/widgets to be drafted in subsequent
sessions per the autonomous loop.

## Pedagogical decisions

- **Toy system:** A 2-layer MLP `f(x) = V σ(Wx)` with width N. Reused
  across every chapter and every widget. Coord-check plots at three
  widths are the universal visual.
- **Default visualization style:** Linked views — one slider drives
  (a) coord-check plot, (b) abc-cube position, (c) loss curve. Phase
  diagrams are 2D slices of the abc-cube colored by regime.
- **Active check:**
  - Lean game for the *symbolic* layer ("write this network as a TP";
    "rewrite this TP using these identities"). Master Theorem appears
    as an axiom/oracle, not a proved theorem. See `lean-game/README.md`
    for the design rationale.
  - Browser widgets for the *quantitative* layer (coord checks, abc-
    cube exploration, μTransfer at three widths).
- **Framings per central concept:**
  - TP language: (a) AST / programming-language framing for CS
    readers; (b) random-variable / Gaussian-process framing for
    probability readers.
  - abc-parametrization: (a) cube of design choices; (b) phase
    diagram with regimes labeled NTK / mean-field / μP / standard.
  - μTransfer: (a) "find the optimum on the small model, the same
    setting works at scale"; (b) "scale-invariance under width".

## Secondary sources to build on

- **EleutherAI × Cerebras "Practitioner's Guide to μP"**:
  https://blog.eleuther.ai/mutransfer/ — best practical exposition;
  reference implementation in `nanoGPT-mup`.
- **Microsoft Research μTransfer blog** (2022) — original public
  splash, definitive coord-check plots.
- **Greg Yang's lecture series** (Simons Institute, MIT CSAIL) —
  long-form whiteboard treatments, useful for chapter framings.
- **Sohl-Dickstein NN-GP demos** and **Rajat Vadiraj Dwaraknath's NTK
  posts** — adjacent visual material for the kernel-regime side.

## Source issues

None known yet. TP papers have minor erratum threads on OpenReview;
will be enumerated as chapters are drafted.

## Status

- **Last updated:** 2026-05-09
- **Chapters complete:** 0
- **Currently being drafted:** none (scaffold only)
- **Blockers:** none

## Cross-references

- `texts/slt/` — both texts speak to "what does a trained network
  represent." SLT's free-energy story and TP's feature-learning story
  are not yet reconciled in the literature; a future cross-text
  module could attempt this.
- `texts/nn-verification/` — abstract interpretation on infinite-width
  limits is unexplored territory; mention in passing only.
