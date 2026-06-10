# Companion — literal 2D Boussinesq Hou–Luo wall: validated solver, honest NULL on corner-focusing

**Date:** 2026-06-10. **`Scope: 2D Boussinesq pseudospectral DNS truncation` — NOT the NS PDE.**
**`:proved`=0; distance to the Clay prize UNTOUCHED.** The literal-2D-wall step gated by the HL-model work:
point the calibrated two-scale instrument at the *spatially-resolved* Hou–Luo wall-stagnation flow. Outcome:
the **faithful inviscid wall solver is validated**, but a **generic parity-respecting smooth IC does NOT
reach the corner self-similar regime** — an honest null, reported as-is (no IC-fishing).

## §1 — Computational basis

- **File:** `scripts/ns050_boussinesq_wall.jl` (Julia, std-lib; reuses the validated 2D Boussinesq solver of
  `ns050_boussinesq_2d.jl`). Output `ns050_boussinesq_wall.out.txt`. Periodic `[0,2π]²`, N=128.
- **Faithful Hou–Luo setup:** `ω_t + u·∇ω = ∂_{x₁}ρ`, `ρ_t + u·∇ρ = 0`, `u=∇^⊥ψ`, `Δψ=ω`. Wall at `x₂=0`
  realized as a **symmetry plane** — which enforces no-penetration (`u₂=0`) **exactly**, the correct BC for
  the inviscid Hou–Luo/Euler scenario. Derived consistent parities (each verified preserved by the
  advection): **ω odd-odd, ρ even-in-x₁/odd-in-x₂, ψ odd-odd**; `x₁=0` & `x₂=0` are symmetry/wall planes;
  the Hou–Luo blow-up point is the corner `(0,0)`.
- **IC (generic, parity-respecting):** `ω₀ = 0.5 sin(x₁)sin(x₂)` (odd-odd, a hyperbolic-flow seed),
  `ρ₀ = cos(x₁)sin(x₂)` (even-x₁/odd-x₂). `ν=κ=2e-4`.

## §2 — Results

**(V) Validation — the faithful wall BC is correctly enforced (the solid deliverable):**
- div-free `max|∇·u| = 1.1e-14` ✓;
- **no-penetration: `max|u₂|` on the wall `x₂=0` = `3.3e-17`** ✓ (exact, by the symmetry-plane parity);
- inviscid `∫ρ²` drift `3.5e-11` over T=4 ✓ (faithful transport);
- **ω parity (odd in x₁) preserved to `8.4e-13`** ✓ (the Hou–Luo symmetry is conserved).

**(S) Evolution — honest NULL on corner-focusing:**

| t | ‖ω‖∞ | peak (x₁,x₂) | ℓ | tail | |
|---|---|---|---|---|---|
| 0 | 0.50 | (1.57,1.57) | 1.08 | — | off-corner |
| 4 | 2.22 | (0.64,1.42) | 0.44 | 7e-5 | off-corner |
| 6 | 7.77 | (6.19,2.41) | 0.098 | 8e-3 | off-corner |
| 8 | 17.2 | (6.23,1.67) | 0.049 | 8e-3 | off-corner |
| 9 | 19.1 | (6.23,1.23) | 0.049 | **4.5e-2** | UNDER-RESOLVED (gate) |

`‖ω‖∞` grows (0.5→19) and the structure sharpens (`ℓ` 1.08→0.049), but the peak **migrates to the symmetry
axis `x₁≈0`** (x₁=6.19–6.23 ≈ 2π ≡ 0) at **mid-height `x₂≈1.2–2.4`, NOT the wall corner `(0,0)`**. Zero
corner-focusing resolved samples ⇒ **no β measured. Honest NULL.**

## §3 — Verification

**Evidence type: example-tested (within-truncation).** Two distinct outcomes, both honest:
- **PASS (validated):** the faithful inviscid Hou–Luo wall BC (no-penetration by symmetry parity) and the
  ω/ρ parities are enforced to machine precision, and inviscid `∫ρ²` is conserved — a sound, reusable
  faithful-wall 2D Boussinesq solver.
- **NULL (honest):** a *generic* parity-respecting smooth IC sharpens on the **symmetry axis at mid-height**,
  **not** at the Hou–Luo wall corner. Right BC + right symmetry is **not sufficient** to land in the basin
  of the corner self-similar blow-up — that requires the *tuned* Chen–Hou numerically-constructed
  near-self-similar profile (which this generic IC does not approximate). This is consistent with *why* the
  Chen–Hou proof needed a carefully-built IC, and it is recorded as a finding, not hidden.

**No IC-fishing.** I did not tune the IC to force corner-focusing — that would be p-hacking toward a desired
result. The null with a principled generic IC is the honest report.

**Vacuity caps.** Within-truncation, resolution-gated at t=9 — **cannot reach the singular limit** (Chen–Hou
needed rigorous numerics). 2D Boussinesq, not the Clay NS. `:proved`=0.

## §4 — Spec impact

- **No NS-ID upgrade; no `SPEC.md`/`dashboard.md` status change.** Feeds `NS-050`; `:open`,
  `Scope: PDE-analysis`, `:proved`=0.
- **What it earns:** a *validated faithful-wall* 2D Boussinesq solver (the inviscid no-penetration Hou–Luo
  BC, enforced exactly by symmetry parity, with the conserved ω/ρ symmetries) — and an honest finding that
  **corner-focusing requires the tuned IC, not just the right symmetry/BC**. The 1D HL model
  (`ns050_houluo_hl.jl`, β=2.47 ∈ proven (2,4.53)) remains the calibrated β-validated reference for the
  instrument.
- **Gated next step (if pursued):** reconstruct the Chen–Hou near-self-similar profile as the IC (a
  dynamic-rescaling fixed-point search à la their rigorous numerics) so the solver actually lands at the
  corner self-similar regime; then the two-scale instrument could read the *spatial* Hou–Luo exponent.
  Substantial; deferred. Until then the honest position is: faithful wall solver ✓, corner blow-up basin
  not reached with a generic IC.

**Pointers:** `ns050_houluo_hl_companion.md` (the 1D HL reference, β-validated),
`ns050_boussinesq_2d_companion.md` (the reused solver, c2), `ns050_twoscale_and_control_companion.md` (c1/c3).
