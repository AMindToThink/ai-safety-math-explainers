import Game.Metadata
import Game.Basic
import Game.Levels.Syntax.L02_Nonlin

open TensorPrograms TensorPrograms.TP

World "Syntax"
Level 3

Title "One MLP layer as a Tensor Program"

Introduction "
The forward pass of one MLP layer is `relu(W x + b)`. Written as a
Tensor Program:

* `MatMul \"W\" (Var \"x\")` — the matmul `W x`.
* `addPair (MatMul \"W\" (Var \"x\")) (Var \"b\")` — add the bias `b`,
  using the abbreviation `addPair a b = LinComb [1, 1] [a, b]`.
* `applyNonlin \"relu\" (...)` — apply ReLU coordinate-wise.

The full term is exactly `oneLayerForward \"W\" \"b\" \"x\"` in
`Game/Basic.lean`. Show that this equals the spelled-out construction.
"

/-- `oneLayerForward` unfolds to the explicit `relu(Wx + b)` TP. -/
Statement :
    oneLayerForward "W" "b" "x"
      = Nonlin "relu" [LinComb [1, 1] [MatMul "W" (Var "x"), Var "b"]] := by
  Hint "`rfl` again: every abbreviation in `Game.Basic` unfolds
        definitionally to the right-hand side."
  rfl

Conclusion "
You've written one MLP layer as a Tensor Program.

This single tree is enough to invoke the Master Theorem: declare
`Var \"x\"` and `Var \"b\"` to be Gaussian inputs and `\"W\"` to be a
random Gaussian matrix with a chosen scaling, and the Master Theorem
returns the limiting distribution of every node as width $N \\to \\infty$.

In World 2 (**Composition**) we'll see the algebraic identities that
let you rewrite TP terms into equivalent forms — the rules that make
the Master Theorem compositional.
"

NewDefinition TensorPrograms.TP.addPair TensorPrograms.TP.oneLayerForward
