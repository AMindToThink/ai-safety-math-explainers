# Tensor Programs Game (Lean 4 + GameServer)

A small browser game where the learner constructs Tensor Programs —
the tiny language Greg Yang's [TP IV](https://arxiv.org/abs/2011.14522)
uses to write neural-network computations — and Lean type-checks the
construction.

Companion to the **Tensor Programs** explainer in `texts/tensor-programs/`.

## Status

**Playable locally** as of 2026-05-09. `lake build` succeeds against
`leanprover/lean4:v4.23.0` and the `MakeGame` step writes the
`.lake/gamedata/` JSON the lean4game server reads. Four levels across
two worlds (World 2 currently has one stub level — see "Future worlds"
below for the queued additions).

## Quick start (everything from scratch)

For the full setup procedure (installing `elan`, cloning lean4game,
patching it to follow symlinks, and the Python-3.12 `npm install`
gotcha) see
[`texts/logical-induction/lean-game/README.md`](../../logical-induction/lean-game/README.md#quick-start-everything-from-scratch).
The exact same setup serves both games — lean4game discovers any
sibling directory of itself with a `.lake/gamedata/game.json`, so once
you have the server running for the logical-induction game, the
tensor-programs game appears next to it.

The minimum-effort version, run from the repo root
(`ai-safety-math-explainers/`):

```bash
# 1. elan + Lean toolchain
curl -sSfL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh \
  | sh -s -- -y --default-toolchain none --no-modify-path
export PATH="$HOME/.elan/bin:$PATH"

# 2. Build this game
cd texts/tensor-programs/lean-game
lake update -R
lake build                               # expect: "Build completed successfully (52 jobs)."
cd -

# 3. lean4game server, sibling-symlink, patch, npm install (one-time)
git clone https://github.com/leanprover-community/lean4game.git
ln -sfn texts/tensor-programs/lean-game tensor-programs-game
# Patch lean4game/relay/src/index.ts: see logical-induction README §5
uv venv --python 3.11 /tmp/py311
PATH="/tmp/py311/bin:$PATH" PYTHON=/tmp/py311/bin/python \
  npm --prefix lean4game install --python=/tmp/py311/bin/python

# 4. Run
cd lean4game
PATH="$HOME/.elan/bin:/tmp/py311/bin:$PATH" npm start
```

Open <http://localhost:3000/#/g/local/tensor-programs-game>.

## Iterating on the game

After editing any `.lean` file under `Game/`:

```bash
cd texts/tensor-programs/lean-game
lake build
```

Then refresh the browser tab. `npm start` does not need to restart.

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

## Common build failures

- **`None of the deriving handlers for class 'DecidableEq' applied to 'TP'`** —
  Lean's auto-derivation can't handle `DecidableEq` on inductive
  types with nested `List Self` constructors (here, `LinComb` and
  `Nonlin` both take `List TP`). The fix in `Game/Basic.lean` is to
  drop `DecidableEq` from `deriving` (we keep `Repr`); levels close
  by `rfl` regardless. If a future level needs decidable equality
  on `TP`, write the instance manually.
- **`Application type mismatch: expected String got TP` on `MatMul`** —
  `MatMul` is `String → TP → TP` (the matrix is named, like an input
  declaration in TP IV §2.1; the operand is a sub-TP). On 2026-05-09
  we changed `oneLayerForward` to `(W b x : String) → TP` accordingly,
  so callers can write `oneLayerForward "W" "b" "x"`.
- **GameServer compatibility drift.** The `lean-toolchain` pin is
  `leanprover/lean4:v4.23.0`. If GameServer has moved on, bump it to
  whatever the current
  [GameSkeleton's `lean-toolchain`](https://github.com/hhu-adam/GameSkeleton)
  says.

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
its own standalone GitHub repo.
