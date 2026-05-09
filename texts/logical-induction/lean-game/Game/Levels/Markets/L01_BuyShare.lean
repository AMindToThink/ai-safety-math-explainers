import Game.Metadata

namespace LogicalInduction

/-- A `LIWorld` for a single sentence is just its truth value (a `Bool`). -/
abbrev LIWorld := Bool

/-- Payout of one share of a sentence in a given world: 100¢ if true, 0¢ if false. -/
def payout (W : LIWorld) : Int := if W then 100 else 0

/-- Net value (in cents) of buying one share at price `p` in world `W`.
    Cash flow is `-p`; share is worth `payout W`. So net = payout W - p. -/
def buyValue (W : LIWorld) (p : Int) : Int := payout W - p

end LogicalInduction

open LogicalInduction

World "Markets"
Level 1

Title "Buy a share at the right price"

Introduction "
You're staring at a market that prices $\\varphi := \\quot{1+1=2}$ at 90¢.
Your trader buys **one share** of $\\varphi$ on day 1.

In a plausible world where $\\varphi$ is **true** ($W = \\mathtt{true}$),
the share pays out 100¢. You paid 90¢, so your net is +10¢.

`buyValue` is defined as `payout W - p`, where `payout true = 100`.
Lean can compute `100 - 90 = 10` directly. The `decide` tactic does this
for goals where every quantifier is over a finite type and every
proposition is `Decidable` — for closed `Int`-arithmetic equalities,
`decide` works.
"

/-- After buying one share of $\varphi$ at 90¢ in a world where $\varphi$ is true,
    your net is +10¢. -/
Statement : buyValue true 90 = 10 := by
  Hint "Try `decide`. (Lean evaluates `buyValue true 90` to `100 - 90`,
        and `100 - 90 = 10` is decidable.)"
  decide

Conclusion "
You bought a share for 90¢ and it's worth 100¢. **Net: +10¢.**

If the market prices $\\varphi$ at 90¢ on every day for $n$ days, and
$\\varphi$ is provable, you've just constructed the start of an exploit:
each day you guarantee yourself another 10¢. We'll formalise this in
World 2.
"

NewDefinition LogicalInduction.LIWorld LogicalInduction.payout LogicalInduction.buyValue
NewTactic decide
