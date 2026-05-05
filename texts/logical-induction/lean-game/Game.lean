import Game.Levels.Markets
import Game.Levels.Exploits

Title "Logical Induction Game"

Introduction "
# The Logical Induction Game

Companion to the **Logical Induction** explainer in
[ai-safety-math-explainers](https://github.com/AMindToThink/ai-safety-math-explainers).

You'll learn the central skill of [Garrabrant et al. (2016)](https://arxiv.org/abs/1609.03543)
by **constructing it**: build traders that exploit mispriced markets,
and prove they actually exploit by Lean type-checking your trades.

The game has two worlds:

1. **Markets and Trades.** Warm-up: how a single buy or sell on a single day
   contributes to a trader's plausible net worth.

2. **Persistent Mispricing.** The §3.5 exploit: buy 1 share of $\\varphi$
   each day at 90¢ — guaranteed +10¢ per share once the deductive process
   resolves $\\varphi$. Construct the trader; Lean checks your bookkeeping.

Each level is a small Lean proof. New tactics are unlocked as you go.

Click on a world to start.
"

Info "
Built for the autonomous companion to *Logical Induction* by Garrabrant et al.
Source repo: <https://github.com/AMindToThink/ai-safety-math-explainers>.

Game-server framework: [Lean Game Server](https://adam.math.hhu.de/) by
the Düsseldorf Lean group.

The game uses only Lean core + GameServer (no Mathlib), so it builds
fast and runs everywhere.
"

Languages "en"
CaptionShort "Logical Induction"
CaptionLong "Construct traders that exploit mispriced logical-uncertainty markets, and have Lean verify your construction."

MakeGame
