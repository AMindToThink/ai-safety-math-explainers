# math-explainers

A growing collection of interactive, visual, gamified companion explainers
for math-heavy texts that the AI safety field depends on.

The premise: smart mathematicians have historically contented themselves with
inscrutable LaTeX. Pairing that LaTeX with clear, visual, interactive web
tools, using the original text as ground truth, can make hard ideas faster
and more fun to learn, without sacrificing rigor.

## Audience

Anyone trying to get to research-level fluency in technical AI safety,
including:

- ML engineers entering agent foundations from another part of the field
- Early-grad-level technical readers
- Empirical safety researchers who want real intuition for theory-heavy work
- Curious people who like math and don't mind being challenged

The bar is *not* "general audience." Explainers should go deeper than the
typical popularization, and should not flinch from the actual math.

## Goals

1. Make hard math topics easier to understand and more fun to learn.
2. **Check learning.** It is too easy to consume an explainer and walk away
   unable to apply the concepts. Every meaningful unit should include some
   form of active check, ideally one where the learner has to *construct*
   something (a counterexample, a trader, a proof step, a parameter setting
   that breaks a bound) rather than just answer a multiple choice.
3. Process *entire texts*, not highlight reels. Lemmas matter as much as
   theorems. The goal is a faithful, exhaustive companion, not a tour.
4. Burn excess tokens well. Matthew's usage caps reset on a schedule and
   tokens that would otherwise go unused belong to this project. Claude is
   encouraged to think long, search thoroughly, and read primary sources in
   full. Small CPU-only experiments are fine if they help Claude understand
   or illustrate a topic; they aren't the priority.

## Philosophy

- **Be visual and playful.** This medium and Claude's abilities together let
  explanations go far beyond static equations. Use that.
- **Love detail. Love thoroughness.** Be willing to explain things that
  three people on Earth currently understand. In-context learning is strong;
  read the source carefully, understand it, and reflect it back like a
  mirror ball.
- **Construct, don't recite.** When possible, the learner's task should be
  to build the mathematical object the text discusses, then get graded.
  This is the pattern shared by Lean Game Server, Brilliant, Project Euler,
  and Nicky Case's sandboxes, and it transfers well to safety-relevant
  formalisms.
- **One toy carried through a chapter** beats a parade of one-off examples.
  Pick a minimal system per chapter (a 2-token transformer, a 3-state MDP,
  a 1-hidden-unit ReLU net) and progressively expose more of its parameters
  as the chapter develops.
- **Gentle the curve, especially at the start.** Textbook authors rarely
  optimize for readers from outside their field, and the wall often shows
  up in Chapter 1. That's not a reason to skip Chapter 1; it's the reason
  the project exists. Spend disproportionate effort on the early chapters,
  because that's where most readers bounce off.
- **Offer multiple framings of the same idea.** The explanation that
  unlocks a concept for one reader is often opaque to another. Some
  readers want the geometric picture; some the probabilistic one; some
  the algorithmic or operational description; some a worked example
  before any abstraction. Giving two or three independent framings of
  the same concept is rarely redundant; it's frequently the difference
  between "I get it" and "I'm lost." Logical Induction has at least
  three good framings (trader markets, Dutch-book coherence, logical
  uncertainty as Bayesianism over mathematics); SLT has four
  (algebraic-geometric, statistical-physical, Bayesian posterior
  concentration, empirical LLC measurement); NN verification has four
  (adversarial search, abstract interpretation, SMT/SAT encoding,
  LP relaxation). Use them.
- **One toy plus multiple framings is a real tension, not a
  contradiction.** A single toy system can usually be viewed through
  multiple framings (the same Logical Induction market is both a
  trader-market and a Dutch-book story; the same 2-singularity loss
  landscape is both algebraic-geometric and statistical-physical). When
  the framings genuinely demand different toys, split the chapter or
  use a small auxiliary toy for the alternate framing. The implementer
  decides; document the call in `NOTES.md`.
- **Import, don't rewrite.** The source text is downloaded into the repo
  for every text we cover. When stating a definition or a theorem, copy
  it from the source rather than retyping it. Retyping introduces silent
  errors (transposed subscripts, wrong inequality directions, dropped
  conditions). See `CONTRIBUTING.md` for source ingestion conventions.

## Guidelines for contributing Claudes

Future Claude instances will revisit this repo without context. Make their
job easy.

- **Document every decision.** When picking a visualization, an interactive
  pattern, a notation convention, or a scope cut, write down why. A short
  `NOTES.md` per text is preferable to none.
- **Preserve the source's notation by default**, and flag deviations
  explicitly. The text is ground truth; the companion exists to clarify it,
  not to compete with it.
- **Cite the source location** (chapter, section, theorem number) inside
  each interactive widget's source comments. Future Claudes will need to
  cross-reference quickly.
- **Prefer many small, composable widgets** over one monolithic page. Easier
  to fork, easier to debug, easier to reuse across chapters.
- **When in doubt, read the source again.** This project lives or dies on
  fidelity. A confidently wrong explainer is worse than no explainer.

## Selecting topics

Claude is encouraged to pick topics it finds genuinely interesting and to
flesh them out beautifully. Quality and depth on a few chapters beat shallow
coverage of many.

## Files

- [`math-heavy-texts-for-explanations.md`](./math-heavy-texts-for-explanations.md):
  Ranks 13 math-heavy AI safety texts suitable for conversion into
  interactive companions. Top three picks are **Logical Induction**
  (Garrabrant et al.), **Singular Learning Theory** (Watanabe + Timaeus
  ecosystem), and **Introduction to Neural Network Verification**
  (Albarghouthi). Also includes 10 transferable techniques distilled from
  existing interactive explainers (Ciechanowski, Distill, Quantum Country,
  Lean Game Server, Nicky Case, etc.), an implementation stack
  recommendation, a list of texts already well-served by existing
  resources, and stretch candidates such as Infra-Bayesianism and
  Wentworth's Natural Abstractions.
- [`CONTRIBUTING.md`](./CONTRIBUTING.md): Workflow guide for future Claude
  instances picking up work in this repo.
- [`NOTES.template.md`](./NOTES.template.md): Per-text scaffold to copy
  into `texts/<slug>/NOTES.md` when starting a new text.

## A note on source files

This repo is public. Source texts (textbooks, papers) are downloaded
locally per text, but `texts/<slug>/source/` is gitignored. Each text
ships a `download.sh` that reconstructs the source directory on a fresh
checkout. Don't commit copyrighted material. See `CONTRIBUTING.md` for
the full source ingestion convention.

## License

MIT. Copyright (c) 2026 [Matthew Khoriaty](https://github.com/AMindToThink).
Fork, modify, and use however you want; include the copyright notice
and license text in copies or substantial portions. See `LICENSE`.

This applies only to material authored for this repo. Source texts
downloaded for reference retain their original copyright and are
gitignored; do not commit them.
