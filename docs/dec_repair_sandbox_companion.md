# Companion — the DEC sandbox: a structure-preserving discrete-NS chain complex (discrete.rtfd part 2)

**2026-06-01.** The legitimate discrete direction from the Desktop `discrete.rtfd`
exploration, built honestly and used to test — *in the real chain-complex setting* — the
two claims the "dual-closure uplift" rests on, and to complete the open item from the
field/Hodge experiment (`repair_cost_under_stretching.jl`, part 1): the explicit **2-chain
(Seifert-surface) repair cost** of a material filament 1-cycle. **Scope: discrete model on
𝕋³. NOT the 3D-NS PDE. `:proved` = 0; distance to the prize UNTOUCHED.** Confirms **NS-020**.

## §1 — Computational basis

- **Source (new):** `scripts/dec_repair_sandbox.jl` (+ `.out.txt`). Std-lib Julia
  (`SparseArrays`, `LinearAlgebra`, `Printf`); no deps.
- **The substrate.** The periodic cubical chain complex on 𝕋³: vertices `C₀` (N³),
  edges `C₁` (3N³), faces `C₂` (3N³), cubes `C₃` (N³), with boundary operators
  `∂₁,∂₂,∂₃` built via the **Serre (tensor) formula** — faces use the two non-normal
  directions in increasing order; cube boundary carries sign `(-1)^{d-1}`. The Serre
  construction *guarantees* `∂∂=0`, so it doubles as the correctness gate.
- **CHAIN_CONVENTION:** canonical-cubical (periodic 3-torus lattice).
- **Run:** `julia scripts/dec_repair_sandbox.jl`.

## §2 — Results

**(1) Structure preservation (the mimetic property + correctness gate).**
`max|∂₁∂₂| = max|∂₂∂₃| = 0.0e+00` at N=2,3,4. The operators are exactly structure-preserving
— this is a legitimate DEC/mimetic discrete-NS substrate.

**(2) Betti numbers of 𝕋³ vs mesh resolution (the core of NS-020).**

| N | b₀ | b₁ | b₂ | b₃ | Euler χ |
|---|---|---|---|---|---|
| 3 | 1 | 3 | 3 | 1 | 0 |
| 4 | 1 | 3 | 3 | 1 | 0 |
| 6 | 1 | 3 | 3 | 1 | 0 |

`dim H₁ = 3` at **every** resolution. Refinement does **not** manufacture new 1-cycle
classes — on a fixed topology `b₁` is **pinned**. The document's "refinement proliferates
non-bounding cycles" is false *on the actual mesh*. (Confirms NS-020, structurally.)

**(3) The real 2-chain repair cost** `Cost(c₁)=min{‖z₂‖ : ∂₂z₂=c₁}` (the discrete Seifert
surface; minimal-`L²` filling via the SVD pseudoinverse), N=6:

| filament 1-cycle | ‖z‖₂ (total) | ‖z‖∞ (peak label) | fillable? |
|---|---|---|---|
| 1×1 planar loop | 0.815 | 0.664 | yes |
| 2×2 planar loop | 1.424 | 0.507 | yes |
| 3×3 planar loop | 1.880 | 0.438 | yes |
| 4×4 planar loop | 2.168 | 0.377 | yes |
| 𝕋³-wrapping loop (generator) | ∞ | ∞ | NO (H₁ class) |

The **peak repair label `‖z‖∞` does not overflow — it _decreases_** as the loop grows
(0.66→0.38): the minimal-norm filling diffuses over the torus, the exact opposite of the
document's `|a_f|→∞` criterion. The `L²` **total grows only sub-linearly** (0.82, 1.42,
1.88, 2.17 — *below* √area = k), and is bounded under volume-preserving stretching (a
longer filament is thinner, so the enclosed area does not blow up). The only infinite-cost
cycles are the **3 fixed H₁ generators** — not a proliferating family.

## §3 — Verification

**Type — algebraic + computed.**
- *Algebraic (exact):* the Serre tensor construction makes `∂∂=0` an identity (confirmed to
  machine zero); the Betti numbers of the periodic cubical 𝕋³ are `(1,3,3,1)` by
  construction, recovered here via integer-matrix ranks (`rank` over SVD).
- *Computed:* ranks → `b₁=3` at N=3,4,6 (Euler χ=0 each); the repair-cost solves are the SVD
  pseudoinverse minimal-norm fillings, with the fillability decided by the residual
  `‖∂₂z−c₁‖` (`<1e-8` ⇒ fillable; the wrapping generator has residual `>0` ⇒ unfillable).
- *Asserted outputs:* `∂∂=0` to `<1e-12`; `b=(1,3,3,1)`; peak label monotone-decreasing;
  total sub-linear; the H₁ generator unfillable.

**Honest note.** The printed verdict in an earlier draft said the total "grows like √area=k";
the data show it grows *slower* than that and the peak label *shrinks* — corrected before
commit (the real behavior is even more adverse to "overflow" than first written).

## §4 — Spec impact

No new entry. **Completes the NS-020 picture from both sides:** part 1 (`repair_cost_under_stretching.jl`)
refuted the field/Hodge `L²`-repair "grows" claim; part 2 here refutes the explicit 2-chain
(Seifert-surface) version *and* demonstrates "b₁ pinned under refinement" on the actual mesh.
Net: the discrete substrate is real and worth keeping as a sandbox, but it does **not**
support the `discrete.rtfd` "dual-closure uplift / the PDE is the wrong model" claim.
NS-020 status unchanged (`:falsified`); this records the discrete confirmation and the
adjudication of the external proposal.

*Firewall: discrete model on 𝕋³; not the PDE; exact chain-complex identities + integer-rank
homology + minimal-norm fillings. `:proved` = 0; distance to the prize UNTOUCHED.
Metabolized by Claude, 2026-06-01.*
