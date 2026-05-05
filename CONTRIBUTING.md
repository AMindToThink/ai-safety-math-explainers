# Contributing

Notes for future Claude instances (and any human collaborator) picking up
work in this repo. The goal is to make it easy to get oriented fast and to
keep the project's standards high without re-deriving them each time.

## Starting work on a new text

The first time you work on a text not yet in this repo, do this in order.

1. Read the entry for the text in
   [`math-heavy-texts-for-explanations.md`](./math-heavy-texts-for-explanations.md)
   if it has one. That file is itself a Claude research output (produced
   for this project), and captures the project's current view on why the
   text matters, what's pedagogically broken about it, and what the
   gamification opportunities are. Treat it as a starting point, not as
   ground truth — if your reading of the source disagrees, trust the
   source and update the ranking doc.
2. Read the source text itself. Not skim. Actually read it, including
   lemmas. If it is truly book-length, read at least the chapters you plan
   to work on plus their dependencies, end to end, before designing
   anything.
3. Read existing distillations and companions if any, and credit them in
   `NOTES.md`. Check the Alignment Forum, LessWrong, AXRP, and the relevant
   org's blog (Anthropic, Timaeus, MIRI, ARC).
4. Create a directory `texts/<short-slug>/` and copy in the
   [`NOTES.template.md`](./NOTES.template.md). Fill it out before writing
   any explainer code. The template forces decisions that are painful to
   change later.
5. Pick the first chapter to convert. **Default to Chapter 1**, especially
   if Chapter 1 is where the text becomes hopelessly hard for outsiders.
   That's usually exactly where the project's value is highest. The
   textbook author had reasons (often good ones) to write Chapter 1 the
   way they did, but those reasons typically don't include "ease the path
   for someone outside my subfield." That path is what the companion
   exists to build. Only deviate from Chapter 1 first if the text has a
   genuinely optional preface or a chapter that's logically prior to
   Chapter 1 in the source's own pedagogy.

## Source ingestion

Every text covered by this repo gets its source files downloaded into
`texts/<slug>/source/`. This serves three purposes:

1. **Grep and search.** Plain text and LaTeX are searchable in ways PDFs
   are not.
2. **Reliable import.** When a chapter explainer states a definition,
   theorem, or numerical example, the prose should be copied from the
   source rather than retyped. Retyping silently flips inequality signs,
   drops side-conditions, and transposes subscripts. Importing eliminates
   that class of error entirely.
3. **In-context loading.** Future Claude sessions can `view` the source
   directly rather than fetching from the web each time, which is faster
   and more reliable.

### Format preference

LaTeX > Markdown/HTML > plain text > PDF. LaTeX is the cleanest format
for math-heavy work and is what the AI environment in this repo handles
best. Always look for LaTeX first.

### Where to find LaTeX

- **arXiv papers and books.** Every arXiv paper has its LaTeX source
  available as a tarball at `https://arxiv.org/e-print/<arxiv-id>`. This
  works for abstracts (`/abs/`), PDFs (`/pdf/`), and HTML versions
  (`/html/`). Most people don't know this URL pattern. Examples:
  - Logical Induction: `arxiv.org/e-print/1609.03543`
  - Albarghouthi NN Verification: `arxiv.org/e-print/2109.10317`
  - Carlsmith Scheming AIs: `arxiv.org/e-print/2311.08379`
- **Author GitHub repos.** Many open textbooks (e.g., MARL book, Peters
  /Janzing/Schölkopf, parts of `devinterp`) live in GitHub repos with
  raw LaTeX or Markdown. Search before assuming PDF-only.
- **Distill / transformer-circuits.pub posts.** HTML with embedded
  LaTeX. Either scrape to markdown with `pandoc` or fetch the raw HTML
  and keep it.
- **Alignment Forum / LessWrong sequences.** Use the `?format=html`
  endpoint or scrape with `pandoc` from rendered HTML. Equations are
  embedded as MathJax/KaTeX and survive the conversion.

### Where LaTeX is not available

- **Cambridge / MIT Press / Now Publishers books** (e.g., Watanabe's
  Grey and Green books, the published version of Albarghouthi).
  Workflow: download the PDF, run `pdftotext -layout` for searchable
  body text, keep the original PDF for figures and any math the
  extractor mangles. Where good secondary distillations exist in
  LaTeX/Markdown form (Carroll's DSLT for SLT, Demski's posts for
  Logical Induction), download those alongside and treat them as
  complementary sources.

### Copyright and gitignore

**This repo is public.** That makes copyright handling load-bearing
rather than cautious. Most published material is not redistributable,
and committing it to a public repo is a real problem.

The repo's pattern:

- `texts/<slug>/source/` is gitignored unconditionally. The text lives
  on the local machine, not in the commit history.
- `texts/<slug>/source/download.sh` is committed and contains the
  commands a future Claude (or Matthew on a new machine) needs to
  reconstruct `source/`. This is the "lockfile" for the source.
- arXiv content is freely redistributable under arXiv's license, and
  could in principle be committed, but default to the gitignore
  pattern anyway for consistency.

If a particular text is unambiguously freely-licensed under terms that
explicitly permit redistribution (CC0, CC-BY, public domain) and you
have a reason to commit it directly, note the license, the reason, and
the source URL in `NOTES.md`. Default is still gitignore.

### Importing into explainers

When a widget or prose section quotes the source, the reference
implementation is:

```markdown
> **Definition 4.2** (from source). [Verbatim copy from source.]
```

with a comment in the widget source pointing to the file and line range
in `texts/<slug>/source/`. Future Claudes verifying the explainer should
be able to grep the source and find the original in seconds.



For each chapter inside a text already underway:

1. Re-read the chapter from the source. Notation and definitions drift
   between chapters in some texts, so don't trust earlier notes.
2. List the math objects introduced. For each object, decide whether it is
   visualizable, interactive, gamifiable, or none of those. Most objects
   are "none," and that's fine.
3. For the chapter's central concept(s), list two or three distinct
   framings (geometric, algorithmic, probabilistic, operational,
   physical, dual/Dutch-book, etc.) and decide which to use. The default
   is at least two. Don't fall in love with the first framing you find.
   When a section fails to land, the fix is usually a different framing
   rather than more words. Note the chosen framings in `NOTES.md` under
   "Pedagogical decisions."
4. Pick one toy system that will be carried through the entire chapter,
   and reuse it across widgets. If the chapter naturally needs more than
   one, that's a sign the chapter should be split.
5. Identify the chapter's "construct an X" task, if any, and design the
   active check around it. If the chapter has no constructive content,
   write a small set of prediction prompts so the reader has to commit
   before the page reveals the answer.
6. Draft the prose. Then build the widgets. Then revise the prose to
   reference the widgets specifically. Prose written before the widgets
   exist tends to over-explain things the widget makes obvious.

## Widget conventions

- Each widget should run standalone. Future Claudes will fork them.
- At the top of each widget's source, include a comment block with the
  source citation (text, chapter, section, theorem or definition number),
  the toy system the widget uses, and a one-sentence statement of what
  the widget is checking or showing.
- Prefer many small widgets over one large widget. Easier to debug, easier
  to reuse, easier for future Claudes to extend.
- A widget that lets the reader manipulate parameters should also expose a
  "reset to canonical example" button, where the canonical example matches
  the worked example in the source.
- Where the source uses a specific numerical example, the widget should
  reproduce it exactly. Do not silently round.

## Notation and citation

- Use the source's notation by default. Companions exist to clarify the
  source, not to compete with it.
- When the source's notation is genuinely confusing or conflicts with
  notation a reader will see in adjacent literature, deviate, but flag the
  deviation in `NOTES.md` under "Notation map." Do not silently rename.
- Every theorem, lemma, definition, or numerical claim in the explainer
  prose should cite the source location. A reader who wants to verify a
  claim should be able to find the original in seconds.
- When you build on a secondary distillation (Demski's Logical Induction
  guide, Carroll's DSLT, Shimi's Infra-Bayesianism Unwrapped, etc.),
  credit it explicitly in `NOTES.md` and in the chapter's intro.

## Verifying correctness

Confidently wrong explainers are worse than no explainers. Before
publishing a chapter, do these checks.

- Cross-check every theorem statement and proof sketch against the source.
- For widgets that compute things, verify that the canonical example
  reproduces the source's stated values.
- For widgets that visualize a phase transition, scaling law, or any
  other empirical claim, run a sanity check. Small CPU experiments are
  fine and encouraged when they would catch a bug.
- If a result depends on a result from another text, verify that
  dependency too. Don't trust training data on math.
- If you have a hunch that the source might be wrong, do not silently
  "correct" it in the explainer. Note the apparent issue in `NOTES.md`
  under "Source issues" and flag it for Matthew.

## Voice and pedagogy

- Direct, technically precise, willing to say "this is hard," willing to
  say "I don't know." No flattery toward the reader, no "great question!"
  energy.
- Use formulas freely. The audience can read them. Show derivations.
  Don't simplify away notation.
- When stating a probability or confidence in the explainer's own voice,
  make it explicit. Use `$_{p}$` if the surrounding stack supports it,
  or `(~p%)` otherwise.
- When the reader is likely confused, say so out loud. Inferential
  distance is real and the explainer benefits from naming it.
- Don't pad. If a section is short because the source is short, the
  section is short.

## When the source is wrong, unclear, or contested

Some of the texts in this project's scope have contested results,
drifting notation across versions, or known errata. Handle this honestly.

- Cite the specific revision or version you read.
- If a critique exists (Soares on Wentworth, the Reflective Altruism
  series on Turner's power-seeking, etc.), link it from `NOTES.md` and
  consider whether the explainer should engage with it directly.
- If you discover an apparent error, do not paper over it. Note it in
  `NOTES.md` under "Source issues" and open a GitHub issue tagged
  `source-issue`. Until resolved, present the result as the source
  states it with a flag pointing to the issue.

## Scope discipline

- The default ambition is "process the entire text." When that is
  infeasible inside a reasonable build, cut by chapter, not by lemma. A
  chapter covered in full is more useful than three chapters covered
  partially.
- Document every scope cut in `NOTES.md` so future Claudes know what's
  intentionally missing versus accidentally missing.
- Don't expand scope beyond what `NOTES.md` declares without updating
  `NOTES.md` first.

## File layout

```
math-explainers/
├── README.md
├── CONTRIBUTING.md
├── NOTES.template.md
├── math-heavy-texts-for-explanations.md
└── texts/
    └── <text-slug>/
        ├── NOTES.md
        ├── source/                 (gitignored; source text downloaded here)
        │   └── download.sh         (committed; reconstructs source/)
        ├── chapters/
        │   └── <chapter-slug>/
        │       ├── README.md       (chapter prose)
        │       ├── widgets/        (one file per widget)
        │       └── assets/
        ├── lean-game/              (optional; Lean Game Server project)
        └── shared/                 (toy models, utilities reused across chapters)
```

This is a default, not a law. If a text wants a different shape, document
the deviation in its `NOTES.md`.

## Tech stack notes

The
[texts ranking doc](./math-heavy-texts-for-explanations.md)
discusses options at length. Briefly, D3 or Observable Framework for
visualization, Manim Community Edition for pre-rendered transformations,
Andy Matuschak's Orbit for spaced repetition, Lean 4 Game Server for
theorem-proving exercises, Pyodide or WebPPL for editable code, LOOPY for
causal and system modeling. All ship permissive licenses. Pick whichever
fits the chapter; don't standardize prematurely.

For Claude artifacts specifically, single-file React with Tailwind core
classes and the libraries listed in the artifact docs (Recharts, MathJS,
d3, Three.js, Plotly, Tone, etc.) is usually enough. When the artifact
sandbox isn't enough, drop into a static site under `texts/<slug>/site/`.

## Lessons accumulated across sessions

Situational tech notes (widget-build gotchas, headless-test recipes,
source-ingestion surprises, sandbox quirks) live in
[`LESSONS.md`](./LESSONS.md). Skim that file *only* when you are
about to do work in one of those areas; you do not need to read it
every session.

## Subagent policy

**Use subagents for context management. Spawn one whenever a task
would otherwise clog the parent's context with output it doesn't need
to see.**

All subagents are Opus. We're not token-constrained, and capability
tiering would just complicate the policy.

### When to spawn a subagent

Bulk or noisy mechanical work whose output the parent needs only in
summarized form:

- Source ingestion: downloading arXiv tarballs, running `pdftotext` or
  `pandoc`, organizing `texts/<slug>/source/`, writing `download.sh`.
  Subagent produces a clean directory; parent reviews the layout but
  doesn't see the megabytes of stdout.
- Scaffolding: creating directory trees, copying `NOTES.template.md`,
  creating empty widget files at specified paths.
- Repo-wide searches: "find every reference to Lemma 4.2 across all
  chapters", "list every TODO comment in widget source files."
  Subagent returns a clean list.
- Link checking and other validation that produces lots of HTTP output.
- `SESSIONS.md` entries from the template (parent dictates the content;
  subagent formats and appends).
- Lean lakefile setup and `lake build` runs (the infrastructure and
  build noise, not the proofs).

### What the parent does itself

Anything where the parent's own context is what makes the work good:

- Reading the source for understanding. The parent is the one writing
  the explainer; delegating reading defeats the purpose.
- Writing or revising explainer prose.
- Designing widgets, including choosing what to visualize and how the
  visualization maps to the math. Design draws on chapter-level context
  (the toy system, prior widgets, the chosen framings) that lives in
  the parent's working state.
- Verifying that a widget reproduces a source's worked example.
- Choosing framings, picking toy systems, making scope decisions.
- Resolving ambiguity in source notation.
- Implementing widgets where the implementation touches the math.
- Lean proofs and Lean Game Server level pedagogy.

### Anti-patterns

Two patterns to avoid:

1. **Subagent summarizes source content for the parent to read.** The
   parent reads the source itself. The whole project depends on the
   parent's deep understanding of the source; delegating reading
   produces a lossy summary the parent then writes from, which is
   exactly the failure mode we're avoiding.

2. **Subagent designs widgets.** Design depends on chapter-level
   context (the toy system, prior widgets, the framings already in
   use) that the parent has and the subagent doesn't. Subagents
   implement designs the parent has fully specified; they don't make
   them.

### Handoff discipline

When spawning a subagent:

1. Write a *self-contained* prompt. The subagent doesn't share the
   parent's context, so specify the task, inputs, and success criteria
   explicitly.
2. Specify what the subagent should report back. Default: paths of
   files created or modified plus any non-trivial decisions made.
3. Review the output before committing. Spot-check files; verify the
   directory structure matches what was asked. Subagent confidence is
   not a substitute for verification.

If review surfaces an issue, fix it directly when cheap, or re-spawn
with a corrected prompt.

## Git workflow

- **Commit early, commit often.** A commit per finished widget, per
  finished section, per non-trivial `NOTES.md` update is the right
  cadence. If you're about to make a significant change, commit first
  so the prior state is preserved.
- **Matthew's Claudes commit directly to `main`.** Autonomous sessions
  scheduled by Matthew, and Matthew's own interactive Claude sessions,
  go straight onto `main`. No branches. Branches would multiply faster
  than they can be reviewed when many autonomous sessions are running.
- **External contributors should branch and open a PR.** If you (a
  human or a Claude not authorized by Matthew) want to contribute,
  follow the standard fork-or-branch workflow and open a pull request
  against `main`. Matthew reviews and merges.
- **Push after committing.** Don't accumulate uncommitted or unpushed
  work locally. The remote is the source of truth, not any one
  session's filesystem.
- **Commit messages describe the change concretely.** Good messages:
  "Add Logical Induction Ch 1 trader-construction widget", "Fix
  Theorem 4.6.2 reference in SLT Ch 5 prose", "Update NOTES module
  breakdown for SLT Ch 4 with two new framings". Bad messages:
  "Updates", "Changes", "WIP".

## GitHub Issues for human review

Claude works autonomously and most of the time will not need human
input. When you do need Matthew's eyes (a notation conflict in a
source you can't resolve, a scope decision that should be his, an
apparent error in a source that needs interpretation, a finished
module you'd like reviewed for style or pedagogy), open a GitHub
issue rather than blocking the session.

Issue conventions:

- **Title format**: `[<text-slug>] <short description>`. Example:
  `[logical-induction] Notation conflict in §4.2 between paper and
  Demski's distillation`.
- **Body**: enough context that Matthew (or a future Claude) can
  address the issue without re-deriving the situation. Source
  locations, repo file paths, what you tried, and what you'd want
  resolved.
- **Labels**: `review` for review-of-implementation requests,
  `source-issue` for apparent problems in the source text, `scope`
  for scope decisions, `notation` for notation conflicts, `blocker`
  for things that prevent further work. Create labels as needed.
- **Cross-reference from `NOTES.md`**: when an issue concerns a
  specific module, put the issue link in the module's "Human Review"
  cell in the breakdown. When it concerns a chapter or text more
  broadly, link from `NOTES.md` under "Source issues" or "Open scope
  questions."

Before opening an issue, check whether a relevant open issue already
exists; don't duplicate.

Closing issues: Claude may close an issue once Matthew has responded
and the resolution is implemented. If unsure whether the resolution
is what Matthew wanted, leave the issue open and add a comment
describing what was done. Don't reopen closed issues casually; open a
new one if there's a follow-up.

The "Human Review" column in the Module breakdown is the canonical
pointer for module-level review state. Empty means no issue exists. A
link points to the issue, whose open/closed status tells you where
review stands.

## Lean Game Server games

Lean Game Server games are explicitly encouraged. If a chapter has
theorem-proving content that fits the format (a sequence of small
proof obligations the reader works through with progressively richer
tactics), building a game out of it is one of the best forms this
project can take.

If you take this on, follow the official Lean Game Server structure so
the game can be added to the public server at `adam.math.hhu.de` rather
than living as a one-off.

- The canonical guide is `doc/create_game.md` in the
  [`leanprover-community/lean4game`](https://github.com/leanprover-community/lean4game)
  repo. Read it before designing levels.
- A game is a Lean 4 project with a `lakefile` that depends on
  `GameServer`. Levels are Lean files that use the `Statement`,
  `Tactic`, `TacticDoc`, `Hint`, `Branch` (and related) commands from
  `GameServer.Commands`. The whole game compiles via `MakeGame`.
- Default location in this repo: `texts/<slug>/lean-game/`. When a
  game is ready to be published to the official server, it needs to
  live in its own standalone GitHub repo. Move it out at that point
  and link the new repo from `NOTES.md`.
- Test locally per `lean4game/doc/DOCUMENTATION.md` (typically
  `lake update -R` and `lake build`).
- Reference implementations to study for structure: the Natural Number
  Game (NNG4), Set Theory Game, and Robo. All are linked from the
  server homepage and have public source repos.

A natural target for the first game in this repo is the Logical
Induction trader-construction skill ("construct a trader that exploits
this incoherent market"), since those obligations are intrinsically
proof-shaped and the source paper has lots of small lemmas that are
exactly Lean Game Server-sized.
