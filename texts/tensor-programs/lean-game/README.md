# Tensor Programs Game (Lean 4 + GameServer)

A small browser game where the learner constructs Tensor Programs —
the tiny language Greg Yang's [TP IV](https://arxiv.org/abs/2011.14522)
uses to write neural-network computations — and Lean type-checks the
construction.

Companion to the **Tensor Programs** explainer in `texts/tensor-programs/`.

## Status

**Bootstrap scaffold (autonomous session 2026-05-09).** The lakefile,
toolchain pin, the `TP` inductive type in `Game/Basic.lean`, and two
worlds with four levels between them are in place. **The build has not
been verified in this session** because the autonomous sandbox does
not have `elan` installed and toolchain installation was outside the
session's authorization scope. The next session (or anyone with `elan`
on their local machine) should run `lake update -R && lake build` to
confirm everything compiles.

If the build fails, common fixes:

- The `lean-toolchain` pin is `leanprover/lean4:v4.23.0`, matching the
  GameSkeleton template at the time of writing. If GameServer has
  moved on, bump this to whatever the current
  [GameSkeleton's `lean-toolchain`](https://github.com/hhu-adam/GameSkeleton)
  says.
- The lakefile is the verbatim template from
  [`hhu-adam/GameSkeleton`](https://github.com/hhu-adam/GameSkeleton/blob/main/lakefile.lean).
- All current levels close by `rfl`. If a future level fails to
  elaborate via `decide`, swap to `native_decide`.

## Design rationale (read this before adding levels)

Tensor Programs' headline theorems (the Master Theorem, the abc-
classification, μP uniqueness) lean on Gaussian conditioning,
polynomial-growth nonlinearities, and almost-sure convergence in
width. Formalising them in Lean is a research project, not a game.

This game makes a deliberate choice: **the AST and its algebraic
identities are formalised; the Master Theorem is an oracle.** The
learner builds and rewrites TP terms; Lean checks that the
constructions are well-formed and that algebraic identities hold by
`rfl` / `decide` / `simp` on the inductive type. The chapter prose
(in `texts/tensor-programs/chapters/`) explains what the Master
Theorem says about each TP term the learner constructs.

This mirrors the project's pattern: Lean game for the symbolic /
construction layer, browser widgets for the quantitative layer (coord
checks, abc-cube exploration, μTransfer at three widths).

## What's here

```
lean-game/
├── README.md                       # this file
├── lean-toolchain                  # leanprover/lean4:v4.23.0
├── lakefile.lean                   # verbatim from GameSkeleton + GameServer dep
├── Game.lean                       # title, intro, world graph, MakeGame
└── Game/
    ├── Metadata.lean               # imports for every level
    ├── Basic.lean                  # TP inductive type + helpers
    └── Levels/
        ├── Syntax.lean             # World 1 entry
        ├── Syntax/
        │   ├── L01_Var.lean        # Var "x" = Var "x"
        │   ├── L02_Nonlin.lean     # applyNonlin "relu" t = Nonlin "relu" [t]
        │   └── L03_OneLayer.lean   # oneLayerForward = relu(Wx + b)
        ├── Compose.lean            # World 2 entry
        └── Compose/
            └── L01_AddSelf.lean    # addPair x x = LinComb [1,1] [x,x]
```

## How the levels map to the papers

| Level | Maps to | What the proof shows |
|-------|---------|----------------------|
| Syntax / L1 | TP IV §2.1 (declaration of input vectors) | A `Var` term is well-formed. |
| Syntax / L2 | TP IV §2.1, the Nonlin operation | The unary-nonlin abbreviation expands correctly. |
| Syntax / L3 | TP IV §2.2 / canonical 1-layer MLP example | One MLP layer is expressible as a TP. |
| Compose / L1 | TP IV §2.3 algebraic structure | `addPair` is a `LinComb` on the nose. |

Together, World 1 establishes that the learner can *write any forward
pass* as a TP. World 2 (currently a stub with one level) is where the
algebraic / rewrite-rule content goes — the next session should add:

- `simplify : TP → TP` that combines duplicate LinComb terms.
- A level proving `simplify (LinComb [1, 1] [t, t]) = LinComb [2] [t]`.
- A level proving `simplify` is idempotent.
- A level building the *backward pass* of one MLP layer as a TP.

## Building locally

You'll need [`elan`](https://github.com/leanprover/elan) to install
the right Lean toolchain automatically. From this directory:

```bash
lake update -R     # fetch GameServer at v4.23.0
lake build         # compile all worlds; warnings are OK
```

The `lake update -R` clears any local-game-server overrides; pass
`-Klean4game.local` instead if you have a `lean4game/` checkout
sitting next to this directory.

To run the game in a browser, follow
[`lean4game/doc/DOCUMENTATION.md`](https://github.com/leanprover-community/lean4game/blob/main/doc/DOCUMENTATION.md)
and point it at this directory.

## Future worlds (not in this scaffold)

Per `texts/tensor-programs/NOTES.md`, queued worlds:

- **abc-Parametrization.** Encode the (a, b, c) exponents and prove
  basic dimensional-analysis identities (e.g., "if a + b = something,
  the activations are width-stable").
- **Coord Checks.** Levels where the learner predicts the asymptotic
  scaling of a TP variable as width grows; correctness is checked by
  an axiomatised "Master Theorem oracle" defined in `Game/Basic.lean`.
- **Backward Pass.** Build the gradient of a 1-layer MLP as a TP,
  showing it stays inside the language (this is non-obvious — it's
  the content of TP III).

Add new worlds by creating `Game/Levels/<World>.lean` and a
`Game/Levels/<World>/L01_*.lean`, then importing from `Game.lean`.

## When to publish to the Lean Game Server

Per `CONTRIBUTING.md` ("Lean Game Server games"), once the game is
ready for the public server at `adam.math.hhu.de` it should move to
its own standalone GitHub repo. We're nowhere near that yet — this
scaffold is "compiles in principle" not "ready for players".
