# `texts/slt/source/`

Local source corpus for the Singular Learning Theory companion. **This
directory is gitignored** except for `download.sh` and this README:
copyrighted material must not enter the public commit history. See
`CONTRIBUTING.md` ("Source ingestion") for the project-wide convention.

## Reconstruction

```bash
bash texts/slt/source/download.sh
```

`download.sh` is idempotent and tolerant of partial network failures.
Re-run it whenever you want to refresh.

It produces this layout:

```
source/
├── download.sh                # committed; reconstruction recipe
├── README.md                  # committed; this file
├── watanabe/                  # PLACE PDFs MANUALLY (see watanabe/README.md)
├── dslt/                      # Carroll DSLT 0–4 (HTML, optionally Markdown)
├── carroll-thesis/            # Carroll MSc 2021 PDF + .txt extraction
├── timaeus-blog/              # Timaeus / DevInterp mirror of DSLT + exercises
├── devinterp/                 # git clone of timaeus-research/devinterp (MIT)
├── arxiv/                     # selected DevInterp arXiv preprints (LaTeX)
└── metauni/                   # pointer notes (no download)
```

## What is and isn't downloaded

- **Auto-downloaded:** Carroll DSLT posts (HTML), Carroll MSc thesis
  (PDF), Timaeus blog mirror (HTML), `devinterp` library (git clone),
  selected arXiv DevInterp papers (LaTeX e-prints).
- **Manual placement:** Watanabe Grey Book and Green Book PDFs.
  Cambridge / CRC copyright; obtain via library or purchase. See
  `watanabe/README.md` for the expected file names.
- **Not pinned:** metauni seminar videos (too large), Watanabe
  homepage (frequently updated, not stable enough to lock).

## Sandbox / firewall caveat

If you are running the script inside a sandboxed environment
(autonomous Claude session, CI, etc.) some of the source hosts may be
firewalled (lesswrong.com, alignmentforum.org, therisingsea.org,
arxiv.org all unblocked on most networks but some sandboxes block
them). The script logs each `FAILED:` line and continues; partial
populations are valid for downstream chapter work as long as the
pieces you need are present.

GitHub-hosted material (the `devinterp` clone) tends to be reachable
in even restrictive sandboxes; the rest assumes general internet
egress.

## Adding new arXiv papers

Edit `download.sh`'s `ARXIV_PAPERS` array. Each entry is
`"<arxiv-id> <local-folder-name>"`. The script fetches
`https://arxiv.org/e-print/<id>` (the LaTeX tarball most arXiv users
don't know about) and extracts it.

## Format-of-record for citations

When prose in `texts/slt/chapters/.../README.md` quotes a definition
or theorem, prefer in this order:

1. Watanabe LaTeX (only if Watanabe ever posts a TeX preprint of the
   relevant book chapter; usually no — fall through).
2. `carroll-thesis/MSc-Carroll.txt` (extracted from the freely posted
   PDF; LaTeX would be better but isn't published).
3. `dslt/<post>.md` or `timaeus-blog/<post>.html` for DSLT-specific
   distillations.
4. `arxiv/<paper>/main.tex` for DevInterp paper claims.
5. As a last resort, the Watanabe PDFs (use page numbers, not section
   numbers, since pdftotext occasionally drops headings).

Cite the exact source location in the widget's source comments per
`CONTRIBUTING.md`.
