# NOTES — <Text title>

Per-text scaffold. Fill out before writing chapter prose. Update as
decisions evolve. Keep this file authoritative for scope, notation, and
status.

## Source

- **Title:**
- **Author(s):**
- **Year / version read:**
- **Link:**
- **Length:**
- **License / reproduction terms:**

## Source ingestion

Record what's in `texts/<slug>/source/` and how to rebuild it.

- **Format(s) downloaded:** (LaTeX from arXiv? PDF? HTML scraped via
  pandoc? Markdown from a GitHub repo?)
- **Reconstruction command(s):** (Or a pointer to `source/download.sh`.)
- **Chosen authoritative format for imports:** When prose quotes the
  source, which file should it be copied from? Ideally LaTeX; PDF only
  if no other option.
- **Known extraction issues:** PDF math that came through garbled,
  notation that the LaTeX uses non-standard macros for, etc.
- **Gitignored?** Default yes; explain if no.

## Why this text matters for safety

One paragraph. What safety research depends on this text, what becomes
easier if a researcher actually understands it. Borrow from
`math-heavy-texts-for-explanations.md` if there's already an entry, but
verify the claims against the actual source before relying on them.

## Prerequisites

What a reader needs going in. Be specific (e.g., "measure-theoretic
probability through conditional expectation," not "probability"). If a
prerequisite is itself underexplained in standard sources, note it and
consider whether to write a short primer.

## Scope

### In scope

List the chapters or sections this companion will cover.

### Out of scope, with reasons

List what's deliberately omitted and why. Future Claudes need to know
whether a missing chapter is an opportunity or a deliberate cut.

### Open scope questions

Anything Matthew has not yet decided.

## Notation map

Source notation → companion notation. Default is to keep the source's
notation. Document every deviation here, with the reason. If the source's
notation conflicts with conventions in adjacent literature the reader
will encounter, note that too.

| Source | Companion | Reason |
|--------|-----------|--------|
|        |           |        |

## Module breakdown

Map source structure to companion modules. One row per planned module.
Claude autonomously picks plans from this table and implements them;
there is no plan-approval gate. The "Human Review" column points to
the GitHub issue tracking human review of the implementation, when one
exists. An empty cell means no issue has been opened. A link
(e.g., `#42`) points to the issue, whose open/closed status indicates
where review stands. See `CONTRIBUTING.md` for issue conventions.

| Source location | Module slug | Toy system | Active check | Status | Human Review |
|-----------------|-------------|------------|--------------|--------|--------------|
|                 |             |            |              |        |              |

## Pedagogical decisions

- Toy systems carried across the text, if any.
- Default visualization style.
- How active checks work in this text. Construct-an-object games?
  Predict-then-reveal? Lean-style proof puzzles? Other?
- Framings used for the central concepts, and which reader profile each
  serves. (Example for Logical Induction: trader-market framing for
  algorithmic/CS readers; Dutch-book coherence framing for
  decision-theory readers; Bayesianism-over-mathematics framing for
  rationalist/probability readers.) At least two framings per central
  concept by default.
- Anything specific to this text's pedagogy that future Claudes should
  preserve.

## Secondary sources to build on

Existing distillations, blog posts, lecture notes, podcasts, code
repositories that the companion borrows from or links to. Credit them.

## Source issues

Known errata, apparent errors, contested results, version drift. Each
entry should cite the location and link the critique if one exists.
Decide per issue whether the companion engages or just flags.

## Status

- **Last updated:**
- **Chapters complete:**
- **Currently being drafted:**
- **Blockers:**

## Cross-references

Other texts in this repo that share material with this one (e.g.,
infra-Bayesianism ↔ Kosoy's learning-theoretic agenda ↔ Davidad). Helps
future Claudes find related work.
