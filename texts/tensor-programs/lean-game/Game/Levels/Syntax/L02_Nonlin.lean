import Game.Metadata
import Game.Basic
import Game.Levels.Syntax.L01_Var

open TensorPrograms TensorPrograms.TP

World "Syntax"
Level 2

Title "Apply a nonlinearity"

Introduction "
A nonlinearity in a TP is `Nonlin f ts` — apply `f` coordinate-wise to
every entry of every term in `ts`, simultaneously.

The unary case (one subterm) is so common we abbreviate it:
`applyNonlin f t = Nonlin f [t]`.

Show that the abbreviation matches its expansion.
"

/-- The abbreviation `applyNonlin` unfolds to a singleton `Nonlin`. -/
Statement : applyNonlin "relu" (Var "x") = Nonlin "relu" [Var "x"] := by
  Hint "`rfl` works: `applyNonlin` is defined as `fun f t => Nonlin f [t]`,
        so the two sides reduce to each other definitionally."
  rfl

Conclusion "
You've built `relu(x)` as a Tensor Program.

In the standard parametrization at infinite width, this term has a
limiting distribution given by `relu` of a Gaussian — the well-known
NN-GP correspondence ([Lee et al. 2018](https://arxiv.org/abs/1711.00165)).
The Master Theorem tells you this *automatically* once `Var \"x\"` is
declared Gaussian and `relu` is declared a pseudo-Lipschitz nonlinearity.
"

NewDefinition TensorPrograms.TP.applyNonlin
