import GameServer

/-! Common imports for every level of the Tensor Programs Game.

The game uses only Lean core + GameServer; no Mathlib dependency, since
the syntactic / algebraic content closes by `rfl`, `decide`, and `simp`
on the inductively defined `TP` AST.

If a later world needs Mathlib (e.g., for ℝ-valued limits or measure-
theoretic statements about the Master Theorem), import it here so the
inventory stays consistent across worlds.
-/
