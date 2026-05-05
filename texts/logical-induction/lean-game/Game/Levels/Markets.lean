import Game.Levels.Markets.L01_BuyShare
import Game.Levels.Markets.L02_SellShare
import Game.Levels.Markets.L03_NetWorth

World "Markets"
Title "Markets and Trades"

Introduction "
# Markets and Trades

A **market** lists prices for sentences. A **trade** on day $n$ buys or
sells some number of shares at the listed prices. A share of $\\varphi$
pays \\$1 (= 100¢) if $\\varphi$ is true and \\$0 if $\\varphi$ is false.

In this world we'll define the **net value** of a single trade in a
single world (truth assignment), and prove three small facts about it.
You'll learn `rfl`, `rw`, `decide`, and how to read a `Statement`.
"
