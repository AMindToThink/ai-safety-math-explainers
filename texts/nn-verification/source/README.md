# `texts/nn-verification/source/` — pinned layout

This directory is **gitignored** except for `download.sh` and this
`README.md`. Run `download.sh` from the repo root to populate it.

```
source/
  book/                  # arXiv:2109.10317 LaTeX e-print + PDF + .txt
    extracted/           # raw tarball contents
    main.tex             # promoted top-level .tex with \documentclass
    2109.10317.pdf       # arXiv PDF (figures + reference rendering)
    2109.10317.txt       # pdftotext -layout output (searchable body)
    verifieddeeplearning.pdf  # author-hosted PDF (fallback)
  alpha-beta-CROWN/      # Verified-Intelligence/alpha-beta-CROWN (shallow clone)
  auto_LiRPA/            # Verified-Intelligence/auto_LiRPA      (shallow clone)
  marabou/               # NeuralNetworkVerification/Marabou     (shallow clone)
```

## Authoritative format for imports

When chapter prose quotes a definition, theorem, or worked example, copy
verbatim from `book/main.tex`. Fall back to `book/2109.10317.txt`
(pdftotext output) only for portions where LaTeX macros obscure the
math. Do **not** retype.

## Why each piece is here

- **`book/`** — Albarghouthi (2021), *Introduction to Neural Network
  Verification*. The textbook; the spine of the companion.
- **`alpha-beta-CROWN/`** — Current SOTA complete verifier and the
  reference implementation of branch-and-bound + CROWN-family bounds.
  Pins down what Part III's algorithms look like in practice.
- **`auto_LiRPA/`** — The library underlying CROWN bounds. Useful for
  widget-backing computations of LP / dual bounds on small networks.
- **`marabou/`** — Reluplex's successor and the canonical SMT-style
  complete verifier. Pins down Part II's constraint-based framing.

See `../NOTES.md` for scope, notation, secondary sources, and module
breakdown.
