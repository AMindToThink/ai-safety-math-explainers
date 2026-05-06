# Ch 5 — Encodings of Neural Networks

Companion to Albarghouthi (2021) Ch 5,
*[Encodings of Neural Networks](https://arxiv.org/pdf/2109.10317#page=43)*
(arXiv:2109.10317, encodings.tex). The chapter cashes in the LRA
primer of Ch 4: every node of a piecewise-linear neural network
becomes an LRA fragment, every edge becomes a wiring equality, and a
correctness property becomes a *verification condition* — the LRA
formula

$$
\bigl(P \;\wedge\; \varphi_G(\vec x, \vec r)\bigr) \;\Longrightarrow\; Q
$$

whose validity is the property's truth value.

## Why this chapter matters for verification

This is the chapter where verification becomes a *concrete algorithm*.
The pipeline:

1. **Affine nodes** become equalities. A node $a = w_1 x_1 + w_2 x_2
   + b$ contributes the conjunct $\mathrm{out}_a = w_1 \cdot
   \mathrm{in}_{a,1} + w_2 \cdot \mathrm{in}_{a,2} + b$.
2. **ReLU nodes** become *disjunctions* — and this is where all the
   action of Part II lives. A ReLU node $h = \mathrm{ReLU}(a)$
   contributes
   $$
   \bigl(\mathrm{in} > 0 \;\Rightarrow\; \mathrm{out} =
   \mathrm{in}\bigr) \;\wedge\; \bigl(\mathrm{in} \le 0
   \;\Rightarrow\; \mathrm{out} = 0\bigr).
   $$
   Each ReLU doubles the number of *activation patterns* the verifier
   must consider. With $k$ ReLUs there are up to $2^k$ patterns; on
   each pattern the network is purely linear and the VC reduces to LP
   feasibility. The whole story of Reluplex (Ch 7) and α,β-CROWN is
   how to avoid actually enumerating all $2^k$.
3. **Edges** become equalities $\mathrm{in}_{v,j} = \mathrm{out}_{v_j}$
   that wire the per-node formulas into a graph.
4. **Specs** translate atom-by-atom: $|\cdot|$ unfolds to two
   inequalities, $\ell_\infty$ balls to conjunctions of box
   constraints, classification predicates to scalar comparisons.

A model of the VC's negation $(P \wedge \varphi_G \wedge \neg Q)$ is
*by construction* a counterexample: the model assigns to each input
node a value that satisfies $P$ but lies outside $Q$ when run through
the network. UNSAT means no such input exists — i.e., the property
is verified.

## Reading order

1. **§5.1 Encoding nodes.** Single-input affine; multi-input affine;
   the general piecewise-linear node template; soundness +
   completeness of the per-node encoding.
2. **§5.2 Encoding a neural network.** Per-node and per-edge
   formulas; the conjunction $\mathrm{NODES}(G) \wedge
   \mathrm{EDGES}(G)$; size of the encoding (linear in the network).
3. **§5.3 Handling non-linear activations.** Sigmoid /tanh by
   piecewise rectangular over-approximation. Sound but not complete:
   we keep proofs of correctness; we lose counterexamples.
4. **§5.4 Encoding correctness properties.** The verification
   condition $(P \wedge \varphi_G) \Rightarrow Q$. Connecting input
   and output variables. The closing soundness/completeness statement
   (LRA-encodable functions ⇒ both proofs and counterexamples
   recoverable).

## Modules

| # | Module | Source | Status |
|---|--------|--------|--------|
| 1 | [`01-encode-and-verify.html`](widgets/01-encode-and-verify.html) | §5.1–§5.4, specialised to the canonical 2-2-1 ReLU toy network | drafted |

## Toy system

The canonical 2-input, 2-hidden-ReLU, 1-output network from Ch 2:
$y(x_1, x_2) = \mathrm{ReLU}(x_1 + x_2) + \mathrm{ReLU}(x_1 - x_2)$.
With two ReLUs there are exactly $2^2 = 4$ activation patterns. The
hidden affine values $a_1 = x_1 + x_2$ and $a_2 = x_1 - x_2$ split
$\mathbb{R}^2$ into four open half-spaces, each a sign combination of
$(\mathrm{sign}(a_1), \mathrm{sign}(a_2))$:

| Pattern | $a_1 = x_1 + x_2$ | $a_2 = x_1 - x_2$ | Reduced $y(x_1, x_2)$ |
|---------|-------------------|-------------------|-----------------------|
| $(+, +)$ | $\ge 0$ | $\ge 0$ | $2 x_1$ |
| $(+, -)$ | $\ge 0$ | $< 0$  | $x_1 + x_2$ |
| $(-, +)$ | $< 0$  | $\ge 0$ | $x_1 - x_2$ |
| $(-, -)$ | $< 0$  | $< 0$  | $0$ |

The widget materialises these four regions as colored polytopes in
the input plane. Verification on a robustness query reduces to four
LP-feasibility checks — once for each pattern — exactly the
case-split tree that Reluplex (Ch 7) explores branch-and-bound style.

## Active check

A *verify-or-counterexample arena*. The reader sets a robustness
query (anchor $\vec c$, $\ell_\infty$ radius $\varepsilon$, output
upper bound $M$). The site:

1. Displays the LRA encoding of every node and the verification
   condition that results.
2. Draws the four ReLU activation regions on the input plane,
   shading the $\varepsilon$-ball, and within each region's
   intersection with the ball, hatching the $\{y > M\}$ violation
   set.
3. On press of *Verify*, samples each pattern's intersection of
   pre-condition and violation set; reports SAT with a concrete
   counterexample, or UNSAT (verified) if all four patterns are
   empty.

The two outcomes correspond to the two outcomes of constraint-based
verification in §5.4: a model of $(P \wedge \varphi_G \wedge \neg Q)$
is a counterexample; UNSAT is a proof. The four-region picture is
also the picture that the abstract domains in Part III approximate
(Ch 8 with intervals, Ch 9 with zonotopes, Ch 10 with polyhedra) —
they trade exactness for the ability to handle networks where
$2^k$ is uncomfortably large.
