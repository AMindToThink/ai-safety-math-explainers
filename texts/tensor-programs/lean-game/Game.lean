import Game.Levels.Syntax
import Game.Levels.Compose

Title "Tensor Programs Game"

Introduction "
# The Tensor Programs Game

Companion to the **Tensor Programs** explainer in
[ai-safety-math-explainers](https://github.com/AMindToThink/ai-safety-math-explainers).

A **Tensor Program** is a tiny language for writing neural-network
computations: just three operations — matrix multiplication, linear
combination, and coordinate-wise nonlinearity. Greg Yang's [Tensor Programs
IV](https://arxiv.org/abs/2011.14522) shows that almost any deep-learning
computation (forward pass, backward pass, an entire training run) can be
written as a Tensor Program, and that the **Master Theorem** then mechanically
gives you the limit of every variable as the width $N \\to \\infty$.

In this game you'll **construct** Tensor Programs — building forward passes,
recognising algebraic identities, and composing layers — and Lean will
type-check your constructions.

The game has two worlds:

1. **Syntax.** The language itself: building TP terms for vectors,
   linear combinations, matrix multiplications, and nonlinearities.

2. **Composition.** Algebraic identities that let you rewrite TPs into
   equivalent forms — the structural rules the Master Theorem rides on.

Each level is a small Lean proof. New tactics unlock as you go.

Click on a world to start.
"

Info "
Built for the autonomous companion to *Tensor Programs* by Greg Yang et al.
Source repo: <https://github.com/AMindToThink/ai-safety-math-explainers>.

Game-server framework: [Lean Game Server](https://adam.math.hhu.de/) by
the Düsseldorf Lean group.

The game uses only Lean core + GameServer (no Mathlib) so it builds
fast and runs everywhere. The Master Theorem itself appears as an
oracle, not a proved theorem — formalising it is a research project,
not a level.
"

Languages "en"
CaptionShort "Tensor Programs"
CaptionLong "Build Tensor Programs — the tiny language for infinite-width neural network limits — and have Lean type-check your constructions."

MakeGame
