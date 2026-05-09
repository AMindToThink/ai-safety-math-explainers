import Game.Levels.Syntax.L01_Var
import Game.Levels.Syntax.L02_Nonlin
import Game.Levels.Syntax.L03_OneLayer

World "Syntax"
Title "The Tensor Program Language"

Introduction "
# The Tensor Program Language

A **Tensor Program (TP)** is a finite expression built from three
operations on width-$N$ vectors:

* **Var** — a named input vector, like `Var \"x\"`.
* **MatMul** — multiply by a named (random Gaussian) matrix:
  `MatMul \"W\" t`.
* **LinComb** — a linear combination of subterms with integer
  coefficients: `LinComb [1, 1] [a, b]` is `a + b` coordinate-wise.
* **Nonlin** — apply a named coordinate-wise nonlinearity to a list of
  subterms: `Nonlin \"relu\" [t]` is `relu(t)` coordinate-wise.

In Lean we represent these as constructors of an inductive type `TP`.
A TP value *is* the syntax tree — Lean checks that the tree is
well-formed and lets you reason about equalities of trees.

In this world you'll get used to building TP terms and seeing that
small structural identities are proved by `rfl` (because they hold by
definition of the constructors).
"
