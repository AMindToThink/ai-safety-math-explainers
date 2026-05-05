# Logical Induction — source corpus layout

This directory is gitignored. `download.sh` reconstructs it.

```
source/
├── download.sh
├── README.md                 # this file
├── paper/                    # arXiv:1609.03543 (Garrabrant et al., 2016)
│   ├── extracted/            # raw extraction of the e-print tarball
│   ├── main.tex              # promoted top-level tex (if e-print is multi-file)
│   ├── 1609.03543v3.pdf      # rendered PDF (fallback / figures)
│   └── 1609.03543v3.txt      # pdftotext extraction (greppable)
├── scherlis/                 # arXiv:2205.12879 (Scherlis, 2022)
│   ├── extracted/
│   ├── main.tex
│   ├── 2205.12879.pdf
│   └── 2205.12879.txt
├── scherlis-code/            # epistax-is/logical-induction (MIT)
├── demski/                   # Demski's distillation posts
│   ├── *.html                # raw LessWrong / AF HTML
│   └── *.md                  # pandoc gfm conversion (if pandoc installed)
└── embedded-agency/          # Demski + Garrabrant context
```

## Authoritative-format order for prose imports

When a widget or chapter quotes the source, copy verbatim from:

1. **`paper/main.tex`** (or, if the e-print didn't promote cleanly,
   `paper/extracted/<file>.tex`). This is the primary citation source
   for definitions, theorems, lemmas in the paper.
2. **`paper/1609.03543v3.txt`** for plain-text grep when LaTeX
   markup gets in the way; cross-check against `main.tex` for
   anything load-bearing.
3. **`scherlis/main.tex`** for algorithmic detail (LIA pseudocode).
4. **`demski/*.md`** for prose intuition and the Dutch-book framing.

## Apt deps

Run once on a fresh sandbox before `download.sh`:

```bash
sudo apt-get install -y poppler-utils pandoc
```

`poppler-utils` provides `pdftotext`; `pandoc` is needed for HTML →
Markdown conversion. The script tolerates absence of either, but
the `.txt` and `.md` extractions are usually what you want for
grep / quote-by-line.
