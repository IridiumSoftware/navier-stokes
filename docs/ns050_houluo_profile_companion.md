# Companion — Chen–Hou HL profile reconstruction: an HONEST NEGATIVE (forward-collapse is gate-limited)

**Date:** 2026-06-10. **`Scope: 1D-model + pseudospectral truncation` — NOT the NS PDE.** **`:proved`=0;
distance to the Clay prize UNTOUCHED.** Attempt to reconstruct the tuned Chen–Hou self-similar profile of the
1D Hou–Luo model and use it as a (tuned) IC. **Outcome: a recorded negative** — the forward-collapse method
does *not* reconstruct the profile within the resolution-gated window, and the genuine method needs
machinery this periodic-Fourier toolkit doesn't have. Recorded per the program's negative-results discipline
(and as a witness-discipline catch — see §3).

## §1 — Computational basis

- **File:** `scripts/ns050_houluo_profile.jl` (Julia, std-lib; HL solver reused from `ns050_houluo_hl.jl`).
  Output `ns050_houluo_profile.out.txt`. N=8192.
- **Method attempted — forward-collapse + re-injection:** (A) from the forward HL blow-up, extract the
  normalized profile `Ω(η)=ω/A` (η=(x−x₀)/ℓ) at amplitudes A=4,8,16 and test whether they **collapse**
  (overlap ⇒ self-similar). (B) re-inject the extracted `Ω₁₆,Θ₁₆` as a fresh IC and test **self-consistency**
  (a true attractor blows up immediately self-similarly).

## §2 — Results (negative)

**STEP A — collapse FAILED:** `‖Ω₈−Ω₄‖₂ = 0.165 → ‖Ω₁₆−Ω₈‖₂ = 0.414` — **increasing**, not decreasing; the
θ-profile mismatch `‖Θ₁₆−Θ₈‖₂ = 2.8`. The profiles do **not** collapse onto a single self-similar shape in
the available window. Cause: the resolved window A=4→16 is **short and pre-asymptotic**, the A=16 snapshot is
already near the resolution gate (tail≈9e-3), and the focusing center drifts — so the forward solution has
not entered the asymptotic self-similar regime before the resolution wall.

**STEP B — INCONCLUSIVE:** the re-injected IC is **scale-inconsistent** — built at `ℓ₀=0.30`, but the noisy
A=16 profile re-extracts at `ℓ≈0.002` (a ~100× too-steep shape), giving `‖U−Ω₁₆‖₂=1.8` at `t=0`; it then
gates almost immediately. Not a clean self-consistency check (contaminated by the noisy profile + the build
scale-mismatch).

**Why the genuine method isn't a periodic-Fourier script:** the actual Chen–Hou reconstruction is
*dynamic-rescaling to the steady profile* with the `c_l` eigenvalue — i.e. evolve the **rescaled** equations
`∂_τW = G_ξ − μW − UW_ξ − c_l ξ W_ξ`, `∂_τG = −(c_l−2)G − UG_ξ − c_l ξ G_ξ` (`U_ξ=HW`) to a fixed point, with
`c_l` set by a scale normalization. This needs the **self-similar variable `ξ=x/(T−t)^{c_l}` discretized over
ℝ** — a mapped/stretched grid plus the **non-periodic dilation operator `c_l ξ∂_ξ`** — which a periodic
Fourier box cannot represent (`ξ` ranges over ℝ; `c_l ξ∂_ξ` is not periodic). That is rigorous-numerics
infrastructure, not a session script with the current toolkit.

## §3 — Verification (and the witness catch)

**Evidence type: example-tested (negative).** The collapse metric and re-injection mismatch are computed and
reported; the conclusion (forward-collapse is resolution-gate-limited) follows from `‖Ω₁₆−Ω₈‖ > ‖Ω₈−Ω₄‖`.

**Witness-discipline catch (recorded).** The script's *first* hardcoded "READING" asserted
`COLLAPSE ✓ / SELF-CONSISTENT / reconstructed + verified` — **contradicted by its own numbers** (the collapse
metric increased; `‖U−Ω₁₆‖=1.8` at t=0). This is the structured-local-coherence hazard in miniature: an
optimistic narrative the data refutes. Caught by reading the actual values, not the auto-summary; the reading
was rewritten to the honest negative. This is exactly the failure mode the program's `:proved`=0 / witness
discipline exists to prevent.

**Caveats.** 1D HL model, within-truncation, `:proved`=0.

## §4 — Spec impact

- **No NS-ID change.** Feeds `NS-050`; `:open`, `:proved`=0.
- **What stands / what's open:** the forward-blow-up **exponent** `β=2.47 ∈ (2,4.53)` (`ns050_houluo_hl.jl`)
  remains the solid, validated result. The full **profile reconstruction** is **OPEN** — it needs the
  Chen–Hou rigorous-numerics machinery (self-similar variable over ℝ, mapped grid, the `c_l` eigenvalue),
  which is a genuine tooling build beyond the periodic-Fourier instruments of this arc.
- **Honest boundary of the whole arc:** the two-scale *instrument* is built/calibrated/validated (CLM β=1,
  HL β=2.47) and the faithful 2D-wall *solver* is built/validated — but reconstructing the *tuned profile*
  (and hence a faithful 2D corner IC) requires infrastructure this toolkit lacks. That is the honest stopping
  point: not a failure to hide, but the edge of what periodic-spectral instruments reach.

**Pointers:** `ns050_houluo_hl_companion.md` (the forward HL result, β=2.47, that stands),
`ns050_boussinesq_wall_companion.md` (the validated 2D-wall solver + the corner-IC null this attempted to
fix), `ns050_modulation_type2_scope.md` (the map).
