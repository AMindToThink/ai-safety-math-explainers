# Ch 3 — Correctness Properties

Companion to Albarghouthi (2021) Ch 3,
*[Correctness Properties](https://arxiv.org/pdf/2109.10317#page=24)*
(arXiv:2109.10317, correctness.tex). The chapter introduces a
specification language for neural networks that takes the shape of a
Hoare triple

$$
\{P\} \;\; \vec r \gets f(\vec x) \;\; \{Q\}
$$

where the precondition $P$ is a predicate over the inputs, the
middle is a sequence of network calls, and the postcondition $Q$ is a
predicate over both inputs and outputs. The triple is read &ldquo;for
any inputs satisfying $P$, the postcondition $Q$ holds of the outputs
returned by the network calls.&rdquo;

## Why this chapter matters for verification

Verification has two halves: writing a property down precisely, then
deciding whether it holds. The literature talks almost exclusively
about the second half — Albarghouthi explicitly flags this in §3.3
(*&ldquo;the hard part is asking the right questions&rdquo;*). Three
specification mistakes show up over and over downstream:

1. **Conflating &ldquo;the network never outputs the wrong class&rdquo;
   with &ldquo;the network's output never differs from a reference
   image's output by more than ε&rdquo;.** The first is a global
   property (almost always false); the second is local robustness
   around an anchor and is what verifiers actually attack (Ch 8–10).
2. **Writing strict inequalities where the verifier needs
   non-strict ones.** SMT-style verifiers (Ch 6–7) and abstract
   domains (Ch 8–10) reason about closed half-spaces; a strict
   inequality is the *complement* of a closed half-space and turns
   a sound certificate into vacuous noise.
3. **Picking the wrong norm.** Brightness perturbations live in the
   $\ell_\infty$ ball; rotations and Instagram filters do not. The
   verification literature mostly does $\ell_\infty$ because it is
   what abstract domains track; if your safety property genuinely
   needs $\ell_2$ or perceptual distance, the verifier will fail
   silently or solve a different problem.

## Reading order

1. **§3.1 Properties, informally.** Image-recognition robustness,
   NLP synonym-robustness, malware-classifier evasion, controller
   safety. Builds intuition for the precondition / postcondition
   split before any notation is introduced.
2. **§3.2 A specification language.** The Hoare-triple notation.
   Multi-network specs (e.g., $f$ vs. $g$ equivalence). The
   counterexample concept; the &ldquo;not Hoare logic, but
   close&rdquo; aside on deduction rules.
3. **§3.3 More examples of properties.** Equivalence of two
   classifiers, ACAS-Xu collision avoidance, conservation-of-energy
   for a learned pendulum simulator, NLP synonym replacement,
   monotonicity. Each example gives the formal triple and walks
   through what the precondition / postcondition encode.

## Modules

| # | Module | Source | Status |
|---|--------|--------|--------|
| 1 | [`01-translate-the-property.html`](widgets/01-translate-the-property.html) | §3.1–§3.3 (English property → Hoare triple) on the canonical 2-2-1 ReLU toy network | drafted |

## Toy system

The same 2-input, 2-hidden-ReLU, 1-output network from Ch 2,

$$
y(x_1, x_2) = \mathrm{ReLU}(x_1 + x_2) + \mathrm{ReLU}(x_1 - x_2).
$$

Case-splitting on the signs of $x_1 \pm x_2$ gives four linear
pieces: $y = 2x_1$ when $x_1 \ge |x_2|$; $y = x_1 + x_2$ when
$x_2 > x_1 \ge -x_2$; $y = x_1 - x_2$ when $-x_2 > x_1 \ge x_2$;
$y = 0$ when $x_1 \le -|x_2|$. Reusing this network across chapters
lets the reader carry intuition: the four ReLU activation patterns
from Ch 2 reappear in Ch 3 as the four input-region cases on which
spec satisfaction must be checked.

## Active check

Spec-writing is *not* a multiple-choice exercise — the literature's
complaint is precisely that good specifications cannot be picked from
a list. The widget approximates the constructive task with two
phases per property:

- **Encode.** The reader chooses precondition and postcondition by
  selecting from a structured palette of atoms (norm balls, equality,
  monotone-pair conditions, output bounds, etc.) and combinators (∧,
  numeric thresholds). The site grades by sampling: does the reader's
  predicate agree with the reference predicate on every gridded
  $(x, x', y, y')$ point?
- **Verify.** Once the encoding is correct, the site checks whether
  the resulting Hoare triple holds on the toy network. It does this
  by gridded counterexample search; if the spec fails, the reader
  sees a concrete $(x_1, x_2)$ that violates the postcondition.

The two phases mirror the chapter's own structure: §3.1–§3.2 are
about *getting the spec right*, §3.3 + the rest of the book is about
*deciding whether the spec holds*. The widget keeps them visually
separate so the reader notices when a "spec fails" outcome is the
network's fault and when it is the spec writer's.
