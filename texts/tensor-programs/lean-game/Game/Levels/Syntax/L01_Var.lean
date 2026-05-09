import Game.Metadata
import Game.Basic

open TensorPrograms TensorPrograms.TP

World "Syntax"
Level 1

Title "Name an input vector"

Introduction "
The simplest TP is a single named input vector: `Var \"x\"`.

There's nothing to *do* yet — the input vector is what every Tensor
Program starts from. But we should warm up by checking that two ways
of writing the same TP really are the same.

`rfl` (\"reflexivity\") closes goals of the form `a = a` when the two
sides are *definitionally* equal — i.e., they reduce to the same
normal form by unfolding definitions.
"

/-- A `Var` term is equal to itself. (Warm-up.) -/
Statement : (Var "x" : TP) = Var "x" := by
  Hint "Try `rfl`. The two sides are syntactically identical."
  rfl

Conclusion "
You've named your input vector. Every neural network's forward pass
starts with one of these.

In the next level we'll **apply a nonlinearity** to it.
"

NewDefinition TensorPrograms.TP
NewTactic rfl
