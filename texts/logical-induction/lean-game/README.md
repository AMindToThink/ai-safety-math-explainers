# Logical Induction Game (Lean 4 + GameServer)

A small browser game where the learner constructs traders that
exploit mispriced markets, and Lean verifies the construction.

Companion to [Garrabrant et al. (2016) *Logical Induction*](https://arxiv.org/abs/1609.03543),
specifically §3.5 "Exploitation". The natural learner-action of
the paper — *be a trader who exploits a market* — is exactly the
game's gameplay.

## Status

**Playable locally** as of 2026-05-09. `lake build` succeeds against
`leanprover/lean4:v4.23.0` and the `MakeGame` step writes the
`.lake/gamedata/` JSON the lean4game server reads. Five levels across
two worlds.

The game has not been published to `adam.math.hhu.de` yet — that
requires moving it to its own GitHub repo per `CONTRIBUTING.md`.
For now it runs in a local lean4game instance (instructions below).

## Quick start (everything from scratch)

These steps were verified end-to-end on 2026-05-09 on Linux aarch64.
Run them from the repo root (`ai-safety-math-explainers/`).

### 1. Install `elan` (Lean toolchain manager)

```bash
curl -sSfL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh \
  | sh -s -- -y --default-toolchain none --no-modify-path
export PATH="$HOME/.elan/bin:$PATH"   # add to ~/.bashrc / ~/.zshrc to make permanent
```

`elan` will install `leanprover/lean4:v4.23.0` (the version pinned in
`lean-toolchain`) on first `lake` invocation.

### 2. Build the game

```bash
cd texts/logical-induction/lean-game
lake update -R       # fetch GameServer + transitive deps
lake build           # ~1 minute on a warm cache; writes .lake/gamedata/
```

If the build prints info-level messages about "Missing Definition
Documentation" / "Missing Tactic Documentation" — that's expected
and harmless. Look for **`Build completed successfully (52 jobs).`**

### 3. Set up the lean4game browser server

The lean4game server is a sibling of each game on disk; it discovers
games by scanning its parent directory. Clone it at the repo root and
make a sibling symlink to this game folder:

```bash
cd <repo-root>                                    # ai-safety-math-explainers/
git clone https://github.com/leanprover-community/lean4game.git
ln -sfn texts/logical-induction/lean-game logical-induction-game
```

After this, the directory layout that lean4game expects is:

```
ai-safety-math-explainers/
├── lean4game/                       # the server
├── logical-induction-game -> texts/logical-induction/lean-game
└── tensor-programs-game   -> texts/tensor-programs/lean-game   (if using both)
```

(Both the `lean4game/` clone and the symlinks are in `.gitignore`.)

### 4. Install Node dependencies

You need Node ≥18 (tested on 22.22.2) and `npm`. **Python 3.12 will
break `npm install`** because one transitive dep (`@parcel/watcher`)
builds via `node-gyp`, which still imports the removed `distutils`
module. Use Python ≤3.11:

```bash
# Easiest: a Python 3.11 throwaway via uv
uv venv --python 3.11 /tmp/py311
PATH="/tmp/py311/bin:$PATH" PYTHON=/tmp/py311/bin/python \
  npm --prefix lean4game install --python=/tmp/py311/bin/python
```

Without `uv`, install Python 3.11 some other way (pyenv, system
package manager, etc.) and point `PYTHON` at it before `npm install`.

### 5. Apply the local lean4game patches (one-time)

Two upstream issues need patching for a smooth local setup. Both are
captured in `scripts/lean4game-local-fixes.patch` — apply with:

```bash
( cd lean4game && git apply ../scripts/lean4game-local-fixes.patch )
```

What the patch does:

1. **`relay/src/index.ts`** — local-game discovery iterates entries
   whose `isDirectory()` is true and skips everything else, including
   symlinks. The patch adds `|| entry.isSymbolicLink()` so the sibling
   symlinks created in step 3 show up on the landing page. (If you'd
   rather clone the games as real sibling directories, you can skip
   this hunk.)
2. **`relay/src/websocket.ts`** — `startObservedGame` null-derefs on
   `gameSession.process` when `startGame` returns `undefined` (which
   it does for malformed WebSocket URLs). One stray probe — e.g. from
   a security scanner or a typo'd URL — takes the whole relay down,
   and nodemon doesn't restart it because it only watches `*.mjs`.
   The patch closes the socket cleanly with code 1008 and returns
   early, so the relay keeps serving everyone else.

Both fixes are good upstream-PR candidates for
[`leanprover-community/lean4game`](https://github.com/leanprover-community/lean4game).

If you skip the symlink patch, your game still loads when you visit
its URL directly (`/#/g/local/logical-induction-game`), but it won't
appear on the lean4game landing page's local-games list.

### 6. Start the server

```bash
cd lean4game
PATH="$HOME/.elan/bin:/tmp/py311/bin:$PATH" npm start
```

`npm start` runs three concurrent processes (build:server, relay,
client). Wait until you see `Server listening on 8080` and Vite's
`ready in …ms`. Then open:

- Landing page: <http://localhost:3000/>
- Direct link to this game: <http://localhost:3000/#/g/local/logical-induction-game>

Both work; the direct link is more reliable if you skipped the
symlink-discovery patch in step 5.

## Iterating on the game

After editing any `.lean` file under `Game/`:

```bash
cd texts/logical-induction/lean-game
lake build
```

Then refresh your browser. The `npm start` process does **not** need
to restart — only `lake build` does, because the relay re-reads the
JSON from `.lake/gamedata/` each time it spawns a Lean session.

## Common build failures

- **`unexpected token 'World'`** — usually means a level `open`s a
  namespace whose contents shadow GameServer's `World` macro keyword.
  Rename the offending identifier (we did this for `World → LIWorld`
  in `Markets/L01_BuyShare.lean` on 2026-05-09).
- **`unexpected token 'show'; expected command` on `NewTactic …`** —
  some Lean keywords (notably `show`) can't be listed verbatim on a
  `NewTactic` line. Drop them or wrap them differently.
- **`'show' tactic failed, pattern is not definitionally equal`** —
  the `show` tactic only succeeds when the printed pattern matches
  the goal up to definitional equality. If `Int`/`Nat` coercions are
  fighting you, replace `show …; …` with `simp [defs]; omega`.
- **GameServer compatibility drift.** The `lean-toolchain` pin is
  `leanprover/lean4:v4.23.0`. If GameServer has moved on, bump it to
  whatever version the current
  [GameSkeleton's `lean-toolchain`](https://github.com/hhu-adam/GameSkeleton/blob/main/lean-toolchain)
  says.

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
to its own standalone GitHub repo.
