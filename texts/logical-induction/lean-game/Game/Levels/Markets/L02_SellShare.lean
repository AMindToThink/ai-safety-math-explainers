import Game.Metadata
import Game.Levels.Markets.L01_BuyShare

namespace LogicalInduction

/-- Net value of selling one share at price `p` in world `W`: collect `p`,
    owe `payout W`. So net = p - payout W. -/
def sellValue (W : LIWorld) (p : Int) : Int := p - payout W

end LogicalInduction

open LogicalInduction

World "Markets"
Level 2

Title "Sell a share that's about to be refuted"

Introduction "
The same market prices $\\psi := \\quot{1+1\\ne 2}$ at 5¢. You **sell**
one share of $\\psi$.

Selling is the opposite of buying: you collect 5¢ in cash, but you owe
the buyer the share's payout. In a world where $\\psi$ is **false**
($W = \\mathtt{false}$), the payout is 0, so you keep the 5¢ and owe
nothing.

Use `decide` again — `sellValue false 5` computes to `5 - 0 = 5`.
"

/-- After selling one share of $\psi$ at 5¢ in a world where $\psi$ is false,
    your net is +5¢. -/
Statement : sellValue false 5 = 5 := by
  Hint "`decide` will close this. `sellValue false 5 = 5 - payout false = 5 - 0 = 5`."
  decide

Conclusion "
You sold $\\psi$-shares for 5¢ each, and once the deductive process refutes
$\\psi$, every plausible world agrees those shares are worth 0. **Net: +5¢
per share.**

This is the second clean exploit from §3.5 of the paper.
"

NewDefinition LogicalInduction.sellValue
