import GameServer

/-! Common imports for every level of the Logical Induction Game.

The game uses only Lean core + GameServer; no Mathlib dependency, since
all the arithmetic in the trader-construction levels is over `Int` and
goes through with `decide` / `omega` / `rfl` / `rw`.

If a level needs Mathlib later (e.g., for `Rat`-valued prices or
sequence convergence), import it here so the inventory is consistent
across worlds.
-/
