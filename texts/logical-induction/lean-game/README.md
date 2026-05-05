# Logical Induction Game (Lean 4 + GameServer)

A small browser game where the learner constructs traders that
exploit mispriced markets, and Lean verifies the construction.

Companion to [Garrabrant et al. (2016) *Logical Induction*](https://arxiv.org/abs/1609.03543),
specifically §3.5 "Exploitation". The natural learner-action of
the paper — *be a trader who exploits a market* — is exactly the
game's gameplay.

## Status

**Bootstrap scaffold (autonomous session 2026-05-05).** The lakefile,
toolchain pin, world structure, and two worlds with five levels
between them are in place. **The build has not been verified in
this session** because the autonomous sandbox does not have `elan`
installed and installing toolchains was outside the session's
authorization scope. The next session (or anyone with `elan` on
their local machine) should run `lake update -R && lake build` to
confirm everything compiles.

If the build fails, common fixes:

- The `lean-toolchain` pin is `leanprover/lean4:v4.23.0`, matching
  the GameSkeleton template at the time of writing. If GameServer
  has moved on, bump this to whatever version the current
  GameSkeleton's `lean-toolchain` says.
- The lakefile is the verbatim template from
  [`hhu-adam/GameSkeleton`](https://github.com/hhu-adam/GameSkeleton/blob/main/lakefile.lean);
  cross-check against that repo if `lake update` complains.
- `decide`-based proofs may need `Decidable.decide` or `native_decide`
  on some toolchains. If a level fails to elaborate, swap `decide`
  for `native_decide` as the first remediation.

## What's here

```
lean-game/
├── README.md                       # this file
├── lean-toolchain                  # leanprover/lean4:v4.23.0
├── lakefile.lean                   # verbatim from GameSkeleton + GameServer dep
├── Game.lean                       # title, intro, MakeGame
└── Game/
    ├── Metadata.lean               # imports for every level
    └── Levels/
        ├── Markets.lean            # World 1 entry
        ├── Markets/
        │   ├── L01_BuyShare.lean   # buyValue true 90 = 10
        │   ├── L02_SellShare.lean  # sellValue false 5 = 5
        │   └── L03_NetWorth.lean   # combined exploit nets 15
        ├── Exploits.lean           # World 2 entry
        └── Exploits/
            ├── L01_NDayBuy.lean    # nDayBuy true 90 n = 10n  (induction)
            └── L02_BoundedBelow.lean # nDayBuy false 90 8 = -720
```

## How the levels map to the paper

| Level | Maps to | What the proof shows |
|-------|---------|----------------------|
| Markets / L1 | §3.4 worked example, Table 1 row 1 | A single buy at the right price has the right net value. |
| Markets / L2 | §3.4 Table 1 row 2 | A single sell at the right price has the right net value. |
| Markets / L3 | §3.5 combined exploits | Combining two clean exploits is still an exploit. |
| Exploits / L1 | §3.5, the canonical "buy φ each day" | Linear growth = unbounded above. |
| Exploits / L2 | §3.5, the bounded-loss pre-resolution argument | Worst-case loss is finite = bounded below. |

Together L1 and L2 of World 2 deliver the two halves of
[Definition 3.5.1](https://arxiv.org/pdf/1609.03543v3.pdf#page=22):
*bounded below + unbounded above = exploitation*. The market in
the game is therefore not a logical inductor.

## Building locally

You'll need [`elan`](https://github.com/leanprover/elan) to install
the right Lean toolchain automatically. From this directory:

```bash
lake update -R     # fetch GameServer at v4.23.0
lake build         # compile all worlds; should print warnings only if a
                   #   level uses an undefined lemma
```

The `lake update -R` clears any local-game-server overrides; pass
`-Klean4game.local` instead if you have a `lean4game/` checkout
sitting next to this directory.

To run the game in a browser, follow [`lean4game/doc/DOCUMENTATION.md`](https://github.com/leanprover-community/lean4game/blob/main/doc/DOCUMENTATION.md)
and point it at this directory.

## Future levels (not in this scaffold)

Per `texts/logical-induction/NOTES.md`, the queued worlds are:

- **Continuity.** Why discontinuous strategies break the
  fixed-point construction in §5.
- **Arbitrage without resolution.** The (φ ∨ ψ) trade that
  exploits without any single sentence ever paying out.
- **Limit coherence.** The three Gaifman conditions, each
  enforced by an explicit trader.

Add new worlds by creating `Game/Levels/<World>.lean` and a
`Game/Levels/<World>/L01_*.lean`, then importing from `Game.lean`.

## When to publish to the Lean Game Server

Per `CONTRIBUTING.md` ("Lean Game Server games"), once the game is
ready for the public server at `adam.math.hhu.de` it should move
to its own standalone GitHub repo. We're nowhere near that yet —
this scaffold is "compiles in principle" not "ready for players".
