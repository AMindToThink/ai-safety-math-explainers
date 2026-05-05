import Game.Metadata
import Game.Levels.Markets.L01_BuyShare
import Game.Levels.Markets.L02_SellShare

namespace LogicalInduction

/-- Net value (in cents) of a portfolio that buys one share of `phi` at price
    `p_phi` and sells one share of `psi` at price `p_psi`, evaluated in the
    world `(W_phi, W_psi)`. -/
def portfolioValue
    (W_phi W_psi : World) (p_phi p_psi : Int) : Int :=
  buyValue W_phi p_phi + sellValue W_psi p_psi

end LogicalInduction

open LogicalInduction

World "Markets"
Level 3

Title "Combine: buy φ and sell ψ"

Introduction "
Your trader takes both clean exploits at once: buy 1 share of $\\varphi$
at 90¢ **and** sell 1 share of $\\psi$ at 5¢.

In the (unique) plausible world that survives the deductive process —
$W(\\varphi) = \\mathtt{true}$, $W(\\psi) = \\mathtt{false}$ — what's the net?

The definition is
`portfolioValue true false 90 5 = buyValue true 90 + sellValue false 5`,
which by Levels 1 and 2 is `10 + 5 = 15`.

Use `decide` (one shot), or chain `rfl`-rewrites if you want to see
each arithmetic step.
"

/-- Combined exploit nets 15¢ per round in the surviving plausible world. -/
Statement : portfolioValue true false 90 5 = 15 := by
  Hint "`decide` closes this in one shot. Or: unfold `portfolioValue`,
        `buyValue`, `sellValue`, `payout`, and the result is
        `100 - 90 + (5 - 0) = 15`."
  decide

Conclusion "
Once both clean exploits combine, every round nets 15¢ — and crucially
this is the value in **every** plausible world that survives the
deductive process, not just an optimistic best case.

This is the trader-side counterpart of the Logical Induction Criterion
itself: a market that lets a polynomial-time trader construct unbounded
guaranteed value is not a logical inductor. In World 2 we'll iterate
this trade for $n$ days and watch the lower bound grow linearly in $n$.
"
