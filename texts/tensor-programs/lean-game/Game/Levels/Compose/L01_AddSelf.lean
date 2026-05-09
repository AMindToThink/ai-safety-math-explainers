import Game.Metadata
import Game.Basic

open TensorPrograms TensorPrograms.TP

World "Composition"
Level 1

Title "x + x as a LinComb"

Introduction "
The TP `addPair (Var \"x\") (Var \"x\")` is a coordinate-wise sum of a
vector with itself. By definition of `addPair`, this is the same as
`LinComb [1, 1] [Var \"x\", Var \"x\"]`.

(Mathematically, this also equals `LinComb [2] [Var \"x\"]`, but proving
that requires reasoning *up to* a TP-evaluation semantics, not just on
the AST. We come back to it later, once a `simplify` function is in
play.)
"

/-- The abbreviation `addPair` unfolds to the obvious `LinComb`. -/
Statement :
    addPair (Var "x") (Var "x")
      = LinComb [1, 1] [Var "x", Var "x"] := by
  Hint "`rfl`: `addPair` is *defined* as that `LinComb`."
  rfl

Conclusion "
You've shown that `x + x` written via `addPair` matches the explicit
linear combination.

Future levels in this world will introduce a `simplify` function on
`TP` and ask you to prove that, e.g.,
`LinComb [1, 1] [t, t] simplifies to LinComb [2] [t]` — the kind of
algebraic rewrite that the Master Theorem rides on.
"
