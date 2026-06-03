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
