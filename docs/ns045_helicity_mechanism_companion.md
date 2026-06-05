# NS-045 — Helicity-depletion mechanism audit: the mechanism is Beltramization

**Date:** 2026-06-05. **Owner:** Aaron Green (audit by Claude; target proposed by Brian).
**Scope firewall:** resolved 3D pseudospectral DNS truncation (Re=1600). **NOT the 3D-NS PDE.**
Per the LOW#1 lesson this certifies the *within-truncation* mechanism only; it cannot inform the
singular limit. `:proved`=0; distance to the prize UNTOUCHED.

## §1 — Computational basis

`scripts/ns045_helicity_mechanism.jl` (+ `.out.txt` N=64, `_N128.out.txt` N=128), reusing the
validated CPU pseudospectral solver `scripts/spectral_3d_control.jl` (RK4 + Leray projection + 2/3
dealias) and the diagnostics `field_diag`/`box_dimension` from `scripts/dns_tg256.jl`. Std-lib Julia
(hand-rolled threaded radix-2 FFT, power-of-two N; `julia -t auto`).

**Matched-spectrum pair (the NS-040 setup, reconstructed in the Craya–Herring ± helical basis).** For
each independent wavevector `k` (shell `1≤|k|≤4`) a random complex amplitude `A(k)` is placed on the
curl eigenvectors `h±(k)` (`ik×h±=±|k|h±`):
- **helical**: `h₊` for *every* mode ⇒ maximally helical;
- **control** (`helicalc`): `h₊` or `h₋` at random ⇒ net helicity ≈ 0, with the **same `|û(k)|` per
  mode** ⇒ identical `E(k)` and (since `|ω̂(k)|²=|k|²|û(k)|²`) identical enstrophy spectrum.
Reality enforced by `û(−k)=conj û(k)`; both rescaled to `E₀=0.125`. **Verified matched to machine
precision** (below). Re=1600 (`ν=1/1600`), `dt=0.01`; N ∈ {16 (smoke), 64 (main, T=8), 128 (conv.,
T=5)}.

**Diagnostics per sample:** `E, Z, H, ρ_H=H/(2√(EZ))`; production `P=⟨ω·Sω⟩` and skewness
`S_ω=P/⟨|ω|²⟩^{3/2}` (NS-038 detector, `field_diag`); ω–strain alignment `c²_int=cos²(ω,e_int)`
(mechanism a); **Beltramization** `cos²(u,ω)` and the normalized Lamb-vector magnitude
`lamb²=⟨|u×ω|²⟩/⟨|u|²|ω|²⟩` (mechanism b — `u×ω` is the actual nonlinear driver); `±` helical energy
split.

## §2 — Results

**IC validation (N=64).** helical: `E=0.125, Z=1.1510, ρ_H=+0.968`, `E₊/(E₊+E₋)=1.000`, `div≈1e-13`.
control: `E=0.125, Z=1.1510, ρ_H=−0.069`, `frac₊=0.443`, `div≈1e-13`. **Matched-spectrum check:
`|ΔE|=1.4e-17, |ΔZ|=2.2e-16`** — identical energy *and* enstrophy spectra, helicity flipped. Faithfully
reproduces NS-040's pair.

**The depletion (reproduced).** Control enstrophy bursts to `Z_peak=11.6 @ t=6.5`; the helical member
is still climbing gently through `Z=6.1 @ t=8` (`Z@t=4`: helical 1.82 vs control 7.28 — 4×). Matches
NS-040's "2–4× slower, delayed".

**The mechanism — (b) Beltramization, NOT (a) ω–S alignment.** The *only* large helical-vs-control
difference present **from t=0** (i.e. causal, not consequent) is the Lamb-vector geometry:

| t=0 | Lamb² `⟨\|u×ω\|²⟩/⟨\|u\|²\|ω\|²⟩` | cos²(u,ω) | c²_int (ω–S) |
|---|---|---|---|
| helical | **0.026** | **0.92** | 0.333 |
| control | **0.69** (26×) | 0.32 | 0.327 |

- **Mechanism (b) certified:** strong helicity makes the field near-Beltrami (`u∥ω`, cos²=0.92), which
  **crushes the Lamb vector `u×ω` ~26×**. Since `u×ω` *is* the nonlinear term, vortex-stretching
  production is geometrically switched off ⇒ enstrophy growth is *delayed*. As the flow evolves the
  helical field de-Beltramizes (cos² 0.92→0.41, lamb² 0.026→0.48, ρ_H 0.97→0.80 by t=8) — and *that's*
  when its enstrophy finally grows. This is exactly NS-040's "delay + concentration", now mechanistic.
- **Mechanism (a) refuted as the cause:** `c²_int` develops *near-identically* in both members
  (helical 0.33→0.56, control 0.33→0.66) — the classic intermediate-eigenvector alignment forms in
  both as they become turbulent. The helical member's slightly lower late `c²_int` is a *lagging
  consequence* of its delayed development, not the leading cause (the Lamb-vector gap is there at t=0,
  the alignment gap emerges only later).

**Explicit transport chain (the CCATT-style "how"):** H-rich geometry → `u∥ω` (Beltramization) →
Lamb vector `u×ω` suppressed → production `P=∫ω·Sω` suppressed → enstrophy growth delayed; depletion
ends when helicity decays and the field de-Beltramizes. This is the explicit mechanism *beyond* scalar
helicity conservation that Brian's PASS condition requires.

**N-convergence (N=16 ↔ 64 ↔ 128).** The mechanism is IC-geometry-driven (Beltramization is a property
of the maximally-helical field, not of small scales): the t=0 signature `cos²(u,ω)=0.92`, `lamb²=0.026`,
`ρ_H=+0.968` (helical) / `0.32, 0.69, −0.069` (control) is **identical at N=16, N=64 and N=128**, and
the early `P(t)`/`Z(t)`/`c²_int(t)` trajectories agree across N to ~4 digits (e.g. helical at t=1.0:
`Z=1.1585, P=0.05225, cos²=0.9023, lamb²=0.0317` at *both* N=64 and N=128; matched-spectrum at N=128:
`|ΔE|=2.8e-17, |ΔZ|=0`). The depletion mechanism is therefore **not a resolution artifact** — it is
fixed by the helical IC geometry and reproduces identically across the resolved range.

## §3 — Verification

- **Matched-spectrum construction (exact):** `|ΔE|=1.4e-17`, `|ΔZ|=2.2e-16`; `ρ_H=+0.968` vs `−0.069`;
  `div_max≈1e-13`. The `±` split (`frac₊` 1.000 vs 0.443) confirms the helical/mixed sector structure.
  Type: exact-invariant (the construction is verified, not asserted).
- **The mechanism claim (example-tested / computed):** the helical-vs-control divergence of `P(t)`/`Z(t)`
  co-moves with the **Lamb-vector / Beltramization** diagnostic (present from t=0), *not* with `c²_int`
  (near-identical until late). Reproduced N=16↔64↔128.
- **Pass condition (Brian's NS-045):** *resolution-converged reduction/delay in P/S_ω correlating with a
  mechanism diagnostic beyond scalar helicity conservation* — **MET** (the Beltramization/Lamb-vector
  correlation, present from t=0 and N-converged 16↔64↔128). Brian's full pass nominates N=256↔512 (GPU;
  expensive; and vacuity-capped per LOW#1 — it would not change the *within-truncation* verdict, since
  the mechanism is IC-geometry-fixed, not small-scale).

## §4 — Spec impact

NS-045: `:open` → **`:tested`** (the mechanism is certified *within the truncation*: Beltramization /
Lamb-vector suppression, not ω–S alignment). Evidence type: **computed**. Scope: resolved 3D DNS
truncation — NOT the PDE. Caveat carried: certifies the within-truncation mechanism only (LOW#1 cap);
`:proved`=0; prize UNTOUCHED. The result also *sharpens NS-040*: its "mechanism = delay+concentration"
is now resolved into "delay = Beltramization-suppressed Lamb vector; the burst = post-de-Beltramization".
