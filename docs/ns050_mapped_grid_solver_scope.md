# NS-050 — Scope: a mapped-grid dynamic-rescaling solver for self-similar profiles (the Chen–Hou tool)

**Date:** 2026-06-10. **Status: `:open`, a SCOPE — design + effort ladder, NOT a build.**
`Scope: PDE-analysis / numerical-tooling`. **`:proved`=0; distance to the Clay prize UNTOUCHED.** Scopes the
infrastructure the periodic-Fourier toolkit provably cannot provide (`ns050_houluo_profile_companion.md`):
a 1D dynamic-rescaling solver on the **self-similar variable over ℝ** that converges to the steady
self-similar profile `(Ω,Θ)` and the exponent `c_l` — i.e. reconstructs the tuned Chen–Hou profile properly.

> **Honest framing up front.** This reconstructs a *known* object (Chen–Hou already built this profile with
> rigorous numerics for their proof). The value is **infrastructure**: a reusable self-similar-profile
> instrument for the program (HL now; DSS/ancient-solution profiles later — NS-048), a high-accuracy `c_l`
> cross-checking the forward `β=2.47`, and a tuned IC for the 2D wall. It is **not new mathematics** and does
> **not** touch the prize. A numerical profile, not a proof (Chen–Hou's interval-arithmetic rigor is a
> separate tier we are not claiming).

---

## 1. Why the periodic-Fourier box fails (the precise obstruction)

The self-similar profile lives in `ξ = x/(T−t)^{c_l} ∈ ℝ` (the structure occupies all of ℝ in the rescaled
frame; it decays *algebraically*, not periodically). Two things break a periodic-Fourier box:
1. **The dilation operator `c_l ξ ∂_ξ`** is non-periodic (`ξ` is unbounded); it has no clean Fourier form.
2. **The far-field tail** (`Ω(ξ)→0` algebraically as `|ξ|→∞`) is unresolvable on a fixed periodic grid; the
   forward-collapse run hit the resolution gate before the asymptotic regime (the recorded negative).

A grid adapted to `ξ∈ℝ` removes both: it represents the dilation operator exactly and resolves the
algebraic tail.

## 2. The equations to solve (derived; verbatim target)

HL model: `ω_t + uω_x = θ_x`, `θ_t + uθ_x = 0`, `u_x = Hω`. Self-similar ansatz `ω=(T−t)^{−1}Ω(ξ)`,
`θ=(T−t)^{c_l−2}Θ(ξ)`, `u=(T−t)^{c_l−1}U(ξ)` with `U_ξ=HΩ`. Substitution gives the **steady profile system**
(the fixed point to solve):

```
(P1)   Ω + c_l ξ Ω' + U Ω' = Θ' ,        U' = H Ω
(P2)   c_l ξ Θ' − (c_l−2) Θ + U Θ' = 0
```

with symmetry `Ω` odd, `Θ` even (so `U` odd, `U(0)=0`), and decay `Ω,Θ → 0` as `|ξ|→∞`. `c_l ∈ (2,4.53)` is
the eigenvalue (the smooth-profile family; the forward run selected `c_l≈2.47`).

**Two solve strategies** (the tool should support at least one):
- **(a) Dynamic relaxation** — evolve `∂_τΩ = −(LHS of P1)`, `∂_τΘ = −(LHS of P2)` to the fixed point, with
  `c_l` adapted each step by a scale normalization and an amplitude rate `μ` by `‖Ω‖∞=1`. Robust, slow.
- **(b) Newton on the eigenvalue problem** — solve `(P1,P2)` + a normalization for `(Ω,Θ,c_l)` jointly by
  Newton iteration. Fast, needs a good initial guess (seed from the forward run's rescaled profile).

## 3. Numerical design

**Grid — rational map ℝ→[−1,1] (Boyd rational-Chebyshev / algebraic map).** Use
`ξ = L · s/√(1−s²)`, `s∈(−1,1)`, with a uniform/Chebyshev grid in `s` and a scale parameter `L` set to the
profile core width. This clusters points near `ξ=0` (the steep core) and stretches to the algebraic tail.
- `∂_ξ = (ds/dξ) ∂_s = ((1−s²)^{3/2}/L) ∂_s` — exact under the map.
- **Dilation `ξ∂_ξ`** becomes `(s√(1−s²))·... ∂_s` — a bounded, explicit operator on the `s`-grid. (This is
  the operator the periodic box could not represent.)

**The hard piece — the Hilbert transform on ℝ, `H`, on the mapped grid.** `H` is global; `Hf(ξ)=π^{-1}PV∫f/(ξ−η)dη`.
Three candidate implementations, in increasing robustness:
1. **Large-box periodic FFT-Hilbert** with box ≫ profile support (cheap, but reintroduces a tail-truncation
   error — the thing we are trying to avoid; acceptable only as a Stage-0 sanity check).
2. **Rational-Chebyshev Hilbert** — the `TB_n(ξ)` rational-Chebyshev basis has *known* Hilbert transforms
   (Boyd), so `H` is a known matrix in that basis. **Preferred.** This is the central technical build.
3. **Direct PV quadrature** on the mapped grid (with a desingularized kernel near `η=ξ`). Robust fallback,
   `O(N²)`.
This `H`-on-ℝ is the single biggest technical risk; Stage 2 (below) is dedicated to it.

**Normalization (fixes `c_l`, the eigenvalue).** Impose two conditions: `‖Ω‖∞=1` (amplitude → fixes `μ`/the
overall scale) and a scale condition — e.g. fix `U'(0)` (the rescaled strain at the symmetry center) or the
location of `max|Ω|` — which selects `c_l`. The dynamically-stable `c_l` should match the forward `β≈2.47`.

## 4. Validation plan (every stage gated by a check, per TEST_SPEC discipline)

- **V1 (operators):** `∂_ξ`, `ξ∂_ξ` on the mapped grid reproduce exact derivatives of a known decaying test
  function (e.g. `ξ/(1+ξ²)`) to spectral accuracy.
- **V2 (Hilbert):** `Hf` matches a closed form — e.g. `H[1/(1+ξ²)] = ξ/(1+ξ²)` (known pair) — to tolerance.
  *This is the make-or-break check.*
- **V3 (profile residual):** the converged `(Ω,Θ)` satisfies `(P1),(P2)` to a small residual.
- **V4 (cross-tool):** the solved `c_l` lands in `(2,4.53)` **and matches the forward-run `β=2.47`**
  (`ns050_houluo_hl.jl`) — an independent cross-validation between two different instruments.
- **V5 (re-injection):** map `(Ω,Θ)` back to physical space and feed the periodic-Fourier forward solver;
  it must blow up *immediately* self-similarly (the self-consistency check the forward-collapse couldn't do
  cleanly). Closes the loop with the existing tools.

## 5. Effort ladder

1. **Stage 1 — mapped-grid operators** (`∂_ξ`, `ξ∂_ξ`, the map) + V1. *Small.*
2. **Stage 2 — `H` on ℝ on the mapped grid** (rational-Chebyshev Hilbert matrix) + V2. *The crux; medium.*
3. **Stage 3 — the profile solve** (dynamic relaxation first; Newton if needed), seeded from the forward
   rescaled profile + `c_l=2.47`, → `(Ω,Θ,c_l)` + V3. *Medium.*
4. **Stage 4 — cross-validation** V4 + V5. *Small.*
5. **Stage 5 (forward, separate) — 2D extension** for the literal Hou–Luo corner: a 2D self-similar variable
   `(ξ₁,ξ₂)` with the wall at `ξ₂=0`, the 2D dilation, and the 2D Biot–Savart/`H`. **Much larger**; the 1D
   tool is the prerequisite. Only after this would a *faithful 2D corner IC* exist.

## 6. Honest caps

- **Reconstructs a KNOWN object** (Chen–Hou's profile), more accurately than forward-collapse managed. Value
  = reusable infrastructure + cross-validation + the 2D-corner IC, **not** new math, **not** the prize.
- **Numerical, not rigorous.** A high-accuracy profile, not Chen–Hou's interval-arithmetic *proof*. `:proved`=0.
- **`H`-on-ℝ on a mapped grid is the central risk** (V2 is the gate). If V2 fails to spectral accuracy, the
  tool is unreliable and that must be reported, not worked around.
- **The 2D extension (Stage 5) is a separate, larger project** — scoping it fully is its own task.
- **Program-wide reuse:** the same machinery (self-similar variable over ℝ + dilation + a singular-integral
  operator + `c_l` eigenvalue) is what a **DSS / ancient-solution profile** search for NS-048 would need —
  so this tool is not HL-specific; it is the program's missing self-similar-analysis instrument.

## 7. Spec impact

- **No NS-ID change; no `SPEC.md`/`dashboard.md` status change.** A scope under `NS-050`; `:open`,
  `Scope: PDE-analysis / numerical-tooling`, `:proved`=0.
- **Decision deferred to Aaron:** building this is a deliberate multi-stage tooling project (Stages 1–4 ≈ the
  HL profile; Stage 5 = 2D). Recommended only if the reusable self-similar-profile instrument is wanted for
  the program (HL cross-validation now, NS-048 DSS/ancient profiles later) — not for prize value, which it
  has none of.

**Pointers:** `ns050_houluo_profile_companion.md` (the forward-collapse negative this answers),
`ns050_houluo_hl_companion.md` (the forward `β=2.47` to cross-validate against),
`ns050_modulation_type2_scope.md` / `ns050_dss_modulation.md` (the DSS/ancient-profile reuse case).
