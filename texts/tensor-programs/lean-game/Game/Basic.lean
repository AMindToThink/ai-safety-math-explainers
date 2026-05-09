import Game.Metadata

namespace TensorPrograms

/-- A **Tensor Program** is a finite syntactic expression built from three
    operations:

    * `Var s`              — a named input vector (e.g. `Var "x"`).
    * `MatMul A t`         — multiply the result of `t` by a named random
                             Gaussian matrix `A` (e.g. `MatMul "W" t`).
    * `LinComb cs ts`      — a linear combination of TP results, with
                             integer coefficients `cs` matched up against
                             a list of subterms `ts`.
    * `Nonlin f ts`        — apply a named coordinate-wise nonlinearity
                             `f` (e.g. `"relu"`, `"tanh"`) to a list of
                             TP results, all coordinate-wise simultaneously.

    This is the AST view of Greg Yang's Tensor Programs language
    ([TP IV §2](https://arxiv.org/abs/2011.14522)). The "width" of a
    program is intentionally implicit: the AST captures the *structure* of
    the computation, and the Master Theorem (an oracle, not formalised
    here) reads off the limiting distribution of each variable as
    width N → ∞.
-/
inductive TP : Type
  | Var      : String → TP
  | MatMul   : String → TP → TP
  | LinComb  : List Int → List TP → TP
  | Nonlin   : String → List TP → TP
  deriving DecidableEq, Repr

namespace TP

/-- `applyNonlin f t` is shorthand for `Nonlin f [t]` — the common case
    of applying a unary nonlinearity to a single subterm. -/
def applyNonlin (f : String) (t : TP) : TP := Nonlin f [t]

/-- `addPair a b` is shorthand for `LinComb [1, 1] [a, b]` — the
    coordinate-wise sum of two TP results. -/
def addPair (a b : TP) : TP := LinComb [1, 1] [a, b]

/-- `oneLayerForward W b x` is the TP for a single MLP layer
    `relu(W x + b)`. This is the toy system the game and the chapters
    return to repeatedly. -/
def oneLayerForward (W b x : TP) : TP :=
  applyNonlin "relu" (addPair (MatMul W x) b)

end TP

end TensorPrograms
