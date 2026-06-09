# `formalization/lean-mathlib/` — universal Lean theorems (Mathlib-backed)

The Mathlib upgrade of Rung 0: the scaling-criticality calculus proved for **ALL**
parameters (`∀ α p q : ℚ`), not just at exemplar triples. Complements — does not
replace — the hermetic, zero-dependency `../lean/Scaling.lean` (which proves the
concrete instances by `native_decide`, no Mathlib).

`:proved` = 0 for the PDE, and stays 0: these are theorems about the **scaling
exponents** (criticality bookkeeping), the algebra the analysis stands on — not the
inequalities/theorems.

## What is proved (`ScalingUniversal.lean`)
- **`lebExp_critical_iff (α p q : ℚ)`** — the norm `‖|x₃|^α u^θ‖_{L^q_t L^p_x}` is
  scale-invariant iff `2/q + 3/p = 1 − α` (the WHWY criticality), for **all** α,p,q.
- **`sobExp_critical_iff (s : ℚ)`** — Ḣ^s critical iff `s = 1/2`, for all s.
- **`energy_supercritical`** — `[L²] < 0` (NS-002), and `lebExp_eq` / `energy_gap`
  give the exact algebraic form and the σ=−1 vs σ=0 gap.
Proofs: `linarith` / `norm_num` over ℚ (the criticality iff is a linear rearrangement
in the atoms {α, 3/p, 2/q}).

## Verification status
**Verified** by `lake env lean ScalingUniversal.lean` against the built Mathlib of the
TCE `src/lean4-cv` project (Mathlib rev `5d69f04…`, toolchain `v4.30.0-rc2`). A
deliberately-false variant (`= 2−α` in place of `1−α`) was correctly **rejected** by
`linarith` — confirming Mathlib genuinely loaded and the checker is sound, not
rubber-stamping.

## Reproduce standalone
```
cd formalization/lean-mathlib
lake exe cache get      # fetch the prebuilt Mathlib oleans for the pinned rev (no rebuild)
lake build              # exits 0 iff ScalingUniversal type-checks
```
Pinned (lockfile discipline): `lean-toolchain` (v4.30.0-rc2) + `lake-manifest.json`
(Mathlib `5d69f04…` + transitive deps), mirroring TCE `src/lean4-cv` so the populated
global Mathlib cache (`~/.cache/mathlib`) is reused.

## Rung 1 universal (`AxisymUniversal.lean`) — ✅ done
The load-bearing axisymmetric structural identities proved for **ALL fields**
(`∀ u : MvPolynomial (Fin 3) ℚ`, vars r=X0, z=X1, t=X2), via `pderiv` + `ring`:
- **`gamma_source_free_operator`** — the Γ source-free operator identity (maximum-principle basis);
- **`gamma_transport`** — the Γ transport identity (with the above ⇒ `∂_tΓ+b·∇Γ−νL_ΓΓ=0`);
- **`omega_operator_transform`** — the `Ω=ω^θ/r` transform: the **`(3/r)∂_r` emerges**, `1/r²` cancels;
- **`source_chain`** (`∂_z(Γ²)=2Γ∂_zΓ`) + **`z_indep_r_power`** (`∂_z(rᵏf)=rᵏ∂_zf`) ⇒ the source
  `S=(1/r⁴)∂_z(Γ²)=∂_z(u₁²)`, `u₁=Γ/r²`.

- **`pderiv_comm`** — mixed partials commute (proved by induction on the polynomial), and the corollary
  **`pressure_elimination`** (`∂_z∂_r p = ∂_r∂_z p` ⇒ the curl kills `∇p`);
- **`biot_savart`** — the Stokes stream function relation `ω^θ = −(∂_r²+(1/r)∂_r−1/r²+∂_z²)ψ`, cleared `×r²`.

**Denominator-clearing:** the `1/r`,`1/r²` structural identities are stated in their `×rᵏ` polynomial
form — equivalent to the `1/r` form wherever `r≠0`, and `∀`-quantified over the polynomial ring (the
formal differential-algebraic content; the `native_decide` file checks only a monomial grid). **Soundness
sanity:** a false variant (`2/r ∂_r` for the correct `3/r`) was correctly rejected — `ring` reduced the
true side to coefficient 3. The full Rung-1 operator structure (incl. pressure elimination + Biot–Savart)
is now universal.

Verified by `lake env lean AxisymUniversal.lean` against the same built Mathlib. `:proved`=0 for the PDE.

## Rung 2 — the inequalities (started bite-by-bite) — `WeakLp.lean`
A 2026-06-08 survey corrected an earlier over-estimate: much of the substrate is already formalized
(Sobolev + Gagliardo–Nirenberg–Sobolev in Mathlib core; De Giorgi–Nash–Moser regularity, Armstrong–Kempe
2026; Fefferman's NS Millennium statement). Remaining gaps are discrete library additions. **First bite:**
- **`WeakLp.lean`** — the **weak-Lᵖ (Lorentz `L^{p,∞}`) quasinorm** `wnorm`, the membership predicate
  `MemWLp`, and theorems: the foundational **`Lᵖ ⊆ L^{p,∞}` embedding** `wnorm_le_eLpNorm` (from Mathlib's
  Chebyshev–Markov `mul_meas_ge_le_pow_eLpNorm'`); **monotonicity** `wnorm_mono`; the
  **quasi-triangle inequality** `wnorm_add_le` (`‖f+g‖_{p,∞} ≤ 2(‖f‖_{p,∞}+‖g‖_{p,∞})` for `1≤p<∞` —
  weak-Lᵖ is a *quasi*-normed space; via the `t/2`-split + `ENNReal.rpow_add_le_add_rpow`); the
  **distribution-function bound** `meas_le_wnorm_div_rpow` (`μ{s ≤ ‖f‖ₑ} ≤ (‖f‖_{p,∞}/s)^p`); and the
  **Marcinkiewicz core** — **`eLpNorm_lt_top_of_wnorm` / `MemWLp.memLp`**: `f` in weak-Lᵖ ∩ weak-L^q with
  `0<p<r<q<∞` lies in `Lʳ`. Proof: the `‖·‖ₑ`→real bridge (`enorm` is never `∞`) + Mathlib's layer-cake
  `lintegral_rpow_eq_lintegral_meas_lt_mul` + the **two-tail split at `t=1`** (the `p`-tail integrable at
  `0` since `r>p`, the `q`-tail integrable at `∞` since `r<q`, via `intervalIntegrable_rpow'` /
  `integrableOn_Ioi_rpow_of_lt`). **Soundness sanity:** a false exponent variant (`r−e+1` for `r−e−1`)
  is correctly rejected. A confirmed Mathlib gap (no `wnorm`/`weakLp`/`MemWLp`); load-bearing (weak-`L³`
  = where Ożański–Palasek's double-log rate lives). Upstreamable. Next: the operator form of
  Marcinkiewicz (sublinear `T`, weak-(p,p)+(q,q) ⇒ strong-(r,r)) → Besov/Littlewood–Paley → Carleman.
