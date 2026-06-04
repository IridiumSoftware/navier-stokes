# Companion — Metal/MPSGraph GPU spectral DNS to N=512: the RWC-038 reconnection verdict

**Session date:** 2026-06-03. **Owner:** Aaron Green.
**Scope firewall (in force):** `:proved`=0. Everything here is *resolved* 3D pseudospectral
DNS at Re=1600 — NOT the 3D-NS PDE. All flows are REGULAR (Re=1600 is not a blow-up regime).
This session makes **no** regularity/blow-up claim; it *resolves a Required Witness Check* by
showing the one diagnostic that flirted with the CKN ≤1 boundary at N=256 is a resolution
artifact. **Distance to the prize UNTOUCHED.**

---

## §1 — Computational basis

**Goal.** Settle RWC-038: C's anti-parallel vortex-tube (Kerr) reconnection drove the
top-30%-production box-dimension `D30` to ≈0.99 at N=256 — momentarily at the CKN ≤1 filament
edge, then recovering. RWC-038 flagged this as the noisiest signal (top-30%, ±0.15, single
sample, at the **edge of N=256 resolution**) and required **N≥512** for a real verdict. This
session builds a GPU spectral solver, validates it against the CPU baseline, and runs N=512.

**The GPU solver** — `metal/dns_gpu.swift` (Swift 6, MPSGraph / Metal 4, M5 Max 32-core GPU,
macOS 26.5). Rotational-form NS `∂_t û = P[(u×ω)^] − ν|k|²û`, RK4, built **entirely in
MPSGraph** — fields carried as `(re,im)` real-tensor pairs, complex only at FFT boundaries; no
hand-written Metal kernels. Pipeline per `rhs`: curl (`ik×û`) → ifft → Lamb vector `u×ω` → fft
→ 2/3 dealias → Leray projection `P[Ĉ]=Ĉ−k(k·Ĉ)/|k|²` → `−ν|k|²û`. keff convention `k=i (i≤N/2)
else i−N`. ICs: `tg` (Taylor–Green), `abc` (ABC/Beltrami), `tubes` (Kerr anti-parallel vortex
tubes — see §3). Build:
```
swiftc -O dns_gpu.swift -o dns_gpu \
  -framework Metal -framework MetalPerformanceShadersGraph -framework Foundation
```
Env: `NS_N NS_T NS_DT NS_NU NS_SAMPLE NS_IC(tg|abc|tubes) NS_SNAP NS_OUT`.

**The hybrid bridge** — `scripts/load_gpu_snapshot.jl`. The GPU writes spectral-field snapshots
(`.bin`: header `Int32 N, Float32 t`, then `6×N³ Float32` = `uh_re,uh_im,vh_re,vh_im,wh_re,
wh_im`, Swift row-major `(i*N+j)*N+k`). The loader reads them (layout fix
`permutedims(reshape(a,N,N,N),(3,2,1))`; FFT convention ≡ Julia `fft3`), reconstructs `û,v̂,ŵ`
as `ComplexF64`, and runs the **same CPU-validated diagnostics** as the N=256 program
(`scripts/dns_tg256.jl`: δ analyticity-strip, `S_ω` production skewness, box-`D30/50/70`,
strain–vorticity alignment). So N=512 cross-validates against the N=256 baseline on identical
measures, with the verdict computed by the already-trusted CPU code path.

**Runs (M5 Max).** TG N=256 (t=10), tubes N=256 (t=7), tubes N=512 (t=7) + finer-time tubes
N=512 (t=6, Δt_sample=0.25), TG N=512 (t=10). Step cost ~0.19 s/step (N=256), ~1.82 s/step
(N=512). Snapshots: `metal/snap_N{256,512}_{tg,tubes}_t*.bin` (gitignored; 402 MB at N=256,
3.2 GB at N=512).

**Two bring-up bugs found & fixed (both load-bearing at scale):**
1. **Per-step `autoreleasepool`.** MPSGraph's `g.run()` autoreleases intermediate MTLBuffers
   that never drain in a tight loop; N=256 was OOM-killed (SIGKILL/137) ~100 steps in. Each
   step is now wrapped in `autoreleasepool{}` (the `cur` state survives the drain via strong
   refs). Memory bounded; 200-step N=256 checkpoint clean, full N=512 runs clean (~30 GB).
2. **Relative divergence diagnostic.** The forward FFT is *unnormalized*, so energy-mode
   coefficients are ~N³ (≈3×10⁴ at N=64). An *absolute* `k·û≈0.05` against `|û|~3×10⁴` is a
   *relative* divergence ~10⁻⁶ = float32 ε — i.e. div-free. The solver and loader now report
   `max|k·û| / max|û|` (N-independent). Localization that settled it: GPU's own div ≡ loader's
   div (not a loader bug); dealiased ≈ raw (not high-k noise); relative ≈ float32 ε (benign).

---

## §2 — Results

### GPU solver validated against the CPU float64 baseline (float32, to 5–6 digits)

**TG N=256, Brachet Re=1600 enstrophy peak (t=9):**

| quantity | GPU float32 | CPU float64 |
|---|---|---|
| Z/Z0 @ t=9 | 27.3902 | 27.3901 |
| E/E0 @ t=9 | 0.690462 | 0.690460 |
| winf @ t=9 | 66.93 | 66.92 |
| snapshot δ, S_ω | 0.077, 0.2134 | 0.077, 0.2134 |
| snapshot D30/50/70 | 1.650/1.963/2.191 | 1.650/1.963/2.191 |

**Tubes N=256 reconnection (t=5.0/5.5/6.0):** winf 25.67/84.41/96.72 (CPU 25.67/84.41/96.70);
**D30 1.718/0.986/1.590 (CPU identical)**; S_ω 0.0981/0.2293/0.2412 (CPU identical). The CKN ≤1
touch (D30=0.986 at t=5.5) reproduced to the digit in float32. ⇒ **float32 is adequate** and the
GPU tubes solver is trusted for the N=512 push.

### The N=512 verdict — the ≤1 touch is a resolution artifact

N=512 tubes (dt=0.005 ≡ N=256, clean N-convergence), D30 across the reconnection, finely
time-sampled (Δt_sample=0.25):

| t | 5.00 | 5.25 | **5.50** | 5.75 | 6.00 |
|---|---|---|---|---|---|
| **N=512 D30** | 2.019 | 2.013 | **1.426** | 1.721 | 1.563 |
| N=256 D30 | 1.718 | — | **0.986** | — | 1.590 |
| N=512 winf | 25.8 | 37.2 | 96.6 | 99.8 | 124.2 |
| N=256 winf | 25.7 | — | 84.4 | — | 96.7 |

**The N=512 D30 minimum is 1.426, at t=5.5 — the same time as the N=256 dip — bracketed by
2.013 (t=5.25) and 1.721 (t=5.75).** The dip is *not* undersampled: the curve is smooth around
its minimum, with no sub-sample plunge toward 1. As resolution doubles, the reconnection-onset
D30 lifts **0.986 → 1.426**, *away from 1*.

Three independent arguments, all pointing the same way:
1. **N-convergence is upward, away from 1.** A genuine ≤1-D filamentary set sharpens *toward*
   its true (≤1) dimension under refinement; an estimate that jumps *up* by 0.44 is the
   signature of **under-resolution at N=256** (the top-30% set too coarsely gridded for the
   box-count slope, reading spuriously low). The whole spectrum lifts: at t=5.5,
   D50 1.657→1.980, D70 1.856→2.111.
2. **More intense, yet less localized.** N=512 resolves a *stronger* reconnection (winf 84→97
   at t=5.5, 97→124 at t=6.0). If this approached a singular set, higher intensity should mean
   *more* localization (lower D). D went *up* — killing the "approach to ≤1-D singular set"
   reading.
3. **RWC-038 predicted exactly this.** It flagged D30=0.986 as the noisiest signal at the edge
   of N=256 and demanded N≥512. N=512 confirms it was numerical, not physical.

### TG N=512 resolution cross-check

The validation case at the higher resolution — Brachet peak at t≈9. TG N=512 t=9:
**Z/Z0=27.4254** (N=256 27.39, Brachet 1983 ≈27.4), E/E0=0.691 (0.690), δ=0.052 (0.077,
narrower but resolved), S_ω=0.2355 (0.2134), **D30/50/70=1.767/1.965/2.186** (N=256
1.650/1.963/2.191), div_rel=1.1e-6. The *integral* enstrophy peak (the literature diagnostic)
is **resolution-robust**; D50/D70 are essentially identical across N; D30 (the noisiest) rises
slightly with N — the **same upward direction** as the tubes case, staying well above 1. This
independently confirms the box-dimension estimator's resolution behavior: D holds or *rises*
with N, never drifting toward ≤1. (winf is lower at N=512, 56.7 vs 66.9 — pointwise max
vorticity is the least-converged quantity and TG at Re=1600 is already fully resolved at N=256;
the integral diagnostics are the robust comparison.)

---

## §3 — Verification

**The `tubes` IC port (Swift, validated example-tested at N=64).** Mirrors
`scripts/dns_tg256.jl::vortex_tube_ic` (a=0.30, b=0.80, ε=0.30, kx=1): seed vorticity
ωx = (two anti-parallel Gaussian tubes with a sinusoidal perturbation), ωy=ωz=0, built in real
space; then in-graph: FFT → Leray-project ω div-free → recover velocity `û = i k×ω̂/|k|²`
(the `curl` helper returns `i k×(·)`, scaled by `INV`; `INV=0` at `k=0` removes the mean) →
energy-normalize to E=0.125 (in-graph scalar `s=√(0.25/⟨|u|²⟩)`).
*Verification (example-tested, N=64, dt=0.01, vs CPU `dns_tg256_tubes_N64.out.txt`):* IC
**Z0=0.954126** (CPU 0.95413), winf0=16.47 (CPU 16.47); t=0.5 E/E0=0.995221, Z/Z0=1.0182,
winf=16.25 (CPU identical); t=1.0 E/E0=0.990081, Z/Z0=1.1491, winf=17.15 (CPU identical).
divRel0=2.3×10⁻⁸.

**ABC/Beltrami stationarity (the rhs gate, prior session).** Inviscid `u×ω=0` ⇒ exactly
stationary: E/E0=H/H0=1.000000, field drift 7.2×10⁻⁴/10 steps (float32 roundoff). ⇒ curl +
cross-product + Leray projection correct.

**TG N=256 vs CPU (example-tested).** See §2 table — Brachet peak Z/Z0=27.3902 (CPU 27.3901)
and snapshot D30/50/70 identical to the float64 CPU baseline ⇒ float32 adequacy established.

**Tubes N=256 vs CPU (example-tested).** See §2 — the full reconnection signature including
D30=0.986 at t=5.5 reproduced to the digit ⇒ the GPU tubes solver reproduces the known result
at the resolution where the answer is established, before extrapolating to N=512.

**N=512 N-convergence (computed, resolved-DNS).** D30 minimum 0.986 (N=256) → 1.426 (N=512),
finely time-sampled; div-free throughout (divRel ~5×10⁻⁷); stable through the reconnection.

**Evidence type: computed** (resolved DNS, GPU float32 cross-validated against CPU float64 to
5–6 digits, literature-validated on the Brachet TG peak). **Not** `:proved` — no machine proof;
this is numerical evidence within resolved DNS.

---

## §4 — Spec impact

Proposed new entry **NS-039 — GPU N=512 resolution of the RWC-038 reconnection-localization
frontier.** Key: *"the N=256 D30≈0.99 CKN ≤1 touch is a resolution artifact; at N=512 it lifts
to ≈1.43."* Logic tier: RESOLVED-DNS. Evidence type: computed (GPU float32 ≡ CPU float64 to
5–6 digits; literature-validated). Depends_on: NS-038 (the A→B→C program & RWC-038), NS-006
(CKN ≤1), NS-004 (BKM/‖ω‖∞). Registry status: **:tested**. Scope: resolved 3D pseudospectral
DNS truncation — NOT the PDE; `:proved`=0; all flows REGULAR; distance UNTOUCHED.

RWC-038 update: the **N≥512** clause is now addressed — the ≤1 touch does **not** survive
resolution refinement (i: threshold — whole D-spectrum lifts; ii: the box estimator is the same
CPU-validated code; iii: IC — the touch is tubes-specific, A/B floor D30≥1.33; iv:
N-convergence — D30 rises 0.986→1.426). The discriminator on δ(t) functional form remains
near-degenerate at these N and is **not** claimed resolved.

Source files: `metal/dns_gpu.swift`, `scripts/load_gpu_snapshot.jl`, `metal/gpu_tubes256.txt`,
`metal/gpu_tubes512.txt`, `metal/gpu_tubes512_fine.txt`, `metal/gpu_tg256.txt`,
`metal/gpu_tg512.txt`. Snapshots gitignored (sizes in §1).
