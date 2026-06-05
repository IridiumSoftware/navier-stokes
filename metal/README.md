# metal/ — the N=512 GPU track (M5 Max, Metal 4 / MPSGraph)

Goal: push the resolved DNS to **N=512** to settle RWC-038 — does C's vortex-tube
reconnection `D30≈0.99` (the CKN ≤1 touch, at the edge of N=256) survive at higher
resolution, or was it an N=256 artifact?

## Foundation (DONE, 2026-06-02) — `probe_mpsfft.swift`

The crux of "N=512 in Metal" is a 3D FFT (our solver is spectral; the `fluoddity-metal`
fork is finite-difference Jacobi, no FFT to reuse). **MPSGraph (Metal 4) provides a native,
correct, fast GPU FFT** — probe result on the M5 Max:

| | result |
|---|---|
| 8³ complex roundtrip (fft∘ifft) | max err **2.4e-7** — PASS (float32) |
| N=256 forward 3D FFT | **0.0051 s/fft** (2.6× FFTW-18 CPU; ~30× hand-rolled-6) |
| N=512 forward 3D FFT | **0.102 s/fft** ⇒ ~2 h for T=10 if FFT-bound (≤30 GB working set) |

⇒ **N=512 is in budget on this GPU. No hand-written FFT kernels needed.**

## Planned architecture — HYBRID (Swift+MPSGraph stepper ✕ Julia diagnostics)

- **Swift + MPSGraph** runs the N=512 spectral time-stepper (rotational-form NS: MPSGraph
  FFT + Metal compute kernels for the `u×ω` nonlinearity, Leray projection, dealias, RK4)
  and writes **field snapshots** (spectral `û,v̂,ŵ`) at sample times.
- **The existing validated Julia diagnostics** (`scripts/dns_tg256.jl`: δ, S_ω, box-D,
  alignment) read the snapshots → the verdict table. **Same diagnostics as the CPU runs**,
  so N=512 cross-validates directly against the N=256 CPU baseline.

Rationale: reuses *both* the native fast GPU FFT *and* the already-validated diagnostics —
no re-implementing the δ-fit / box-counting in Swift; results stay comparable to the ledger.

## Build/run

```
swiftc -O probe_mpsfft.swift -o probe_mpsfft \
  -framework Metal -framework MetalPerformanceShadersGraph -framework Foundation
./probe_mpsfft
```

## Validation discipline (carried)

The GPU solver must reproduce the CPU spectral solver before any N=512 claim: (i) E/H
conservation on an inviscid check; (ii) the **Brachet TG Re=1600 enstrophy peak at t≈9** at
N=256; (iii) bit-vs-CPU agreement on a few steps at small N. Only then N=512. `:proved`=0;
all flows regular; this is a *resolution* push for RWC-038, not a PDE claim.

## Stage 2 (DONE, 2026-06-03) — `dns_gpu.swift`: the rhs + RK4, all in MPSGraph

Rotational-form NS `rhs` (curl → ifft → `u×ω` Lamb vector → fft → 2/3 dealias → Leray
projection → `−νk²û`) + RK4, built **entirely in MPSGraph** (fields kept as (re,im)
real-tensor pairs; complex only at FFT boundaries). **No hand-written Metal kernels.**

**Validation — inviscid ABC/Beltrami (the strongest gate):** `u×ω=u×u=0` ⇒ exactly
stationary. Result (M5 Max, N=64): **E/E0=1.000000, H/H0=1.000000, H/2E=1.0000** (Beltrami),
field drift 7.2e‑4 over 10 steps (float32 FFT-roundoff; STATIONARY). ⇒ curl + cross-product
+ Leray projection all correct. **Precision note:** the GPU path is **float32** (vs the CPU
float64); adequacy for the diagnostics is confirmed at the Stage-4 N=256 cross-validation.

## Stage 3+4 (DONE, 2026-06-03) — time-loop, snapshot writer, hybrid bridge, N=256 cross-validation

Full GPU-resident RK4 time-loop (ping-pong tensors, no per-step CPU readback) + snapshot
writer (spectral `û,v̂,ŵ` → `.bin`) + `scripts/load_gpu_snapshot.jl` reading them through the
**CPU-validated** Julia diagnostics (δ, S_ω, box-D30/50/70, alignment). TG and tubes ICs both
ported (tubes = Kerr anti-parallel vortex tubes: seed ωx → in-graph Leray-project → `û=ik×ω̂/|k|²`
→ E-normalize, mirroring `vortex_tube_ic`).

Two bugs found and fixed during bring-up:
- **Per-step `autoreleasepool`** — MPSGraph's `g.run()` autoreleases intermediate MTLBuffers
  that never drain in a tight loop; N=256 was OOM-killed (SIGKILL) ~100 steps in. Wrapping each
  step in an `autoreleasepool{}` bounds memory (`cur` survives via strong refs past the drain).
- **Relative divergence diagnostic** — the FFT is unnormalized, so energy-mode coefficients are
  ~N³; an *absolute* `k·û≈0.05` against `|û|~3e4` is a *relative* divergence ~1e-6 = float32 ε.
  Solver and loader now report `max|k·û|/max|û|` (N-independent, ~1e-6 ⇒ div-free).

**Validation (M5 Max, float32 GPU vs float64 CPU, all to 5–6 digits):**
- **TG N=256, t=9 Brachet peak:** Z/Z0 = **27.3902** (CPU 27.3901), E/E0 0.690462 (0.690460),
  winf 66.93 (66.92); snapshot diagnostics δ=0.077, S_ω=0.2134, D30/50/70 = 1.650/1.963/2.191 —
  all identical to the CPU baseline. ⇒ **float32 is adequate** for these diagnostics.
- **Tubes N=256 reconnection (t=5.0/5.5/6.0):** winf 25.67/84.41/96.72 (CPU 25.67/84.41/96.70),
  **D30 1.718/0.986/1.590** (CPU 1.718/0.986/1.590) — the CKN ≤1 touch (D30=0.986 at t=5.5)
  reproduced to the digit. ⇒ GPU tubes solver trusted for the N≥512 RWC-038 push.

Step cost: ~0.19 s/step at N=256, ~2.4 s/step at N=512 (M5 Max 32-core GPU).

## Stage 5 (IN PROGRESS) — N=512 RWC-038 verdict

N=512 tubes run (dt=0.005 ≡ N=256 for clean N-convergence; T=7; snapshots t=5.0/5.25/5.5/5.75/6.0)
→ Julia diagnostics → does the D30≈0.99 reconnection touch survive, deepen, or rise at N=512?
`:proved`=0; all flows REGULAR; a *resolution* push, not a PDE claim.

---

## SEPARATE TRACK — `active_turbulence_gpu.swift` (AT-6, the active-turbulence phenomenology track)

**Not the obstruction DNS above.** This is the GPU port of the *faithful 2D active-turbulence
fluid* (`SIM_SPEC.md`, AT-#; **Scope: phenomenology, ≠ PDE, ≠ obstruction map**). It reuses the same
MPSGraph machinery (built-in FFT, GPU-resident ping-pong, no Metal kernels) but solves the **2D
vorticity IF-RK4** equation (state = ω̂), cross-validated against the CPU Julia
(`scripts/active_turbulence_fluid.jl` / `_forced.jl`).

```
swiftc -O active_turbulence_gpu.swift -o active_turbulence_gpu \
  -framework Metal -framework MetalPerformanceShadersGraph -framework Foundation
NS_MODE=at01   ./active_turbulence_gpu   # inviscid invariants  (→ drift 3.8e-6, float32)
NS_MODE=at02   ./active_turbulence_gpu   # viscous decay vs exp(−νk²t)  (→ 2.95e-6)
NS_MODE=forced ./active_turbulence_gpu   # forced cascade  (→ forward slope −3.48, R²=0.99)
```

**Validation (M5 Max, float32 GPU ≡ float64 CPU to ~6 digits; AT-6 / TEST_SPEC T-21):** AT-01 invariants
3.8e-6 (CPU 1.3e-14), AT-02 decay 2.95e-6 (CPU 7.3e-16), forced cascade −3.48 R²=0.99 (CPU −3.36, same
universal −3). ~100× faster than the CPU (3100 steps N=128 in 3.1 s). The validated core for Phase 4b
(wiring into the interactive `fluoddity-metal` app for live watching). Binary gitignored.
