# Companion — Helicity depletes (delays + concentrates) vortex stretching: the clean controlled pair (NS-040)

**Session date:** 2026-06-04. **Owner:** Aaron Green.
**Scope firewall:** `:proved`=0. Resolved 3D pseudospectral DNS at Re=1600 — NOT the PDE. All
flows REGULAR. This is a *mechanism* result (helicity vs vortex stretching), not a PDE claim.

---

## §1 — Computational basis

**Question.** NS-038 case B ("helical") was **confounded**: the IC was only ~1% relatively
helical (ρ_H≈0.011) and low-k-random, so the (weaker enstrophy growth) could not be cleanly
attributed to helicity. Does *strong* helicity genuinely deplete vortex stretching?

**The clean test — a matched-spectrum controlled pair.** Pure ABC/Beltrami is an exact *steady*
Euler solution (`curl u=u` ⇒ `u×ω=0`), so it does not cascade and cannot test depletion.
Instead, build strongly-helical and non-helical ICs with **identical energy AND enstrophy
spectra**, differing only in helicity:
- Superpose **+helical Beltrami waves** over the low-k shells |k|²∈{1..6}:
  `v_k(x) = e₁ cos(k·x) − s·e₂ sin(k·x)`, with {e₁,e₂,k/|k|} right-handed orthonormal.
  Each `v_k` satisfies `curl v_k = +|k| v_k` (verified analytically), so helicity-density is
  positive everywhere.
- **`helical`** (s=+1 every mode): ρ_H = H/(2√(E·Z)) = **0.975**.
- **`helicalc`** (CONTROL; s alternates ±1): equal ± helical content ⇒ ρ_H = **0.054**, with
  the **same** E0=0.125 and **same** Z0=0.534374 as `helical` — the helicity-flipped twin.
- **`abcpert`**: ABC Beltrami + a small (0.1) non-Beltrami perturbation (ρ_H=0.983); cascades
  only weakly (large-scale, near-laminar) — a directional check, not the clean comparison.

Implemented in `metal/dns_gpu.swift` (real-space construction, CPU energy-normalize to E=0.125,
then the existing FFT path). Runs: GPU spectral solver (MPSGraph/Metal 4, M5 Max, float32),
Re=1600, T=10, dt=0.005, at **N=256 and N=512**. Diagnostics via the CPU-validated Julia
pipeline (`scripts/load_gpu_snapshot.jl`). All ICs div-free (divRel≤2e-6), H conserved
(viscous decay).

---

## §2 — Results

**Net depletion — enstrophy growth Z/Z₀ (the vortex-stretching proxy), resolution-robust:**

| t | helical (ρ_H=0.97) | helicalc (ρ_H=0.05) | ratio | N=256↔512 agreement |
|---|---|---|---|---|
| 4 | 1.137 | 3.863 | **3.4×** | identical to 3–4 digits |
| 6 | 1.587 | 6.670 | **4.2×** | identical |
| 8 | 3.315 | 9.972 | 3.0× | identical |
| 10 | 6.866 | 13.029 | 1.9× | identical (helical 6.866 vs 6.871) |

The helical flow develops enstrophy 2–4× slower than its helicity-flipped twin; energy decays
slower too (E/E0 @t=10: 0.886 helical vs 0.690 control) ⇒ helicity inhibits the cascade to
small scales. **Matched N=256↔512 to 3–4 digits** ⇒ not a resolution artifact (the depleted
cascade has little small-scale content to under-resolve).

**Mechanism = delay + concentration, not elimination — production skewness S_ω and the burst:**

| | helical t=6 | helicalc t=6 | helical t=9 | helicalc t=9 |
|---|---|---|---|---|
| S_ω (N=256) | 0.142 | 0.141 | 0.252 | 0.151 |
| S_ω (N=512) | — | — | **0.264** | 0.153 |
| winf (N=512) | — | — | 154.4 | 47.7 |
| D30 (256→512) | 2.08 | 1.78 | 1.47→1.73 | 1.69→1.80 |

Early (t≤6) the helical flow's *integral* enstrophy grows far slower at comparable normalized
S_ω. At t=9 it undergoes a **delayed, intense, localized burst** (winf 154, S_ω 0.26 —
resolution-robust) while the control is already past peak and dissipating (S_ω 0.15). The burst's
top-production set is ~1.7–2D with D30 *rising* with N (1.47→1.73 — the NS-039/T-08 pattern),
i.e. not filamentary, no ≤1 touch. Integral enstrophy stays far lower throughout. `abcpert`
(ρ_H=0.98, large-scale) is near-laminar (Z/Z0=1.15 @t=10) — extreme depletion, same direction.

---

## §3 — Verification

- **IC correctness (example-tested, N=64):** ρ_H = 0.975 (helical) / 0.054 (helicalc) / 0.983
  (abcpert); helical & helicalc share E0=0.125 **and** Z0=0.534374 exactly (matched spectrum);
  all div-free (divRel≤2.4e-6); H conserved under viscous decay. The +helical Beltrami-wave
  construction `curl v_k=+|k|v_k` is verified analytically (companion §1).
- **N-convergence (computed):** Z/Z0(t) for both helical and helicalc match N=256↔512 to 3–4
  digits at every sampled t ⇒ the depletion is resolution-robust at the validated Re=1600 scale.
- **Direct stretching diagnostic:** S_ω (production skewness P/⟨|ω|²⟩^{3/2}) reproduces the
  delayed-burst signature at both N (helical 0.25→0.26 @t=9 vs control 0.15).
- **Evidence type: computed** (GPU float32 vs a matched control + N-convergence). **:tested.**
  NOT a PDE claim.

---

## §4 — Spec impact

**NS-040** (`:tested`, RESOLVED-DNS class). Key: *"strong helicity depletes (delays +
concentrates) vortex stretching — clean matched-spectrum controlled pair, resolution-robust
N=256↔512; resolves the confounded NS-038 case B."* Depends_on: NS-038, NS-022 (helical triad).
Evidence: computed. Source: `metal/dns_gpu.swift` (helical/helicalc/abcpert ICs) +
`scripts/load_gpu_snapshot.jl` + `metal/B_{helical,helicalc,abcpert}_{256,512}.txt`. Scope:
resolved 3D pseudospectral DNS truncation — NOT the PDE; `:proved`=0; all flows REGULAR.
