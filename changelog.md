# changelog — Navier–Stokes obstruction program

## v0.1.43 — 2026-06-04 — Omnibus cross-audit: ledger sound; fix count drift + doc staleness

Full A0–A6 integrity sweep after the Metal/GPU arc (`audit_2026-06-04.md`). Coverage (30 SPEC =
30 registry), per-ID status parity (0 mismatches), evidence-existence (0 missing files), and the
`:proved`=0 / Scope firewall all hold with **zero violations**. Five findings, all count/doc/coverage drift:

- **F1 (fixed)** — entry-count drift: true count **30**; SPEC count line said 27 (stale — missing
  the POSSIBILISTIC + RESOLVED-DNS categories, predating NS-037..040), dashboard header said 29.
  Reconciled to 30 everywhere (authoritative class tally from the registry).
- **F2 (fixed)** — DESIGN.md was a full arc stale: synced §3 (plan EXECUTED; Step-2 INCONCLUSIVE
  @ N=256↔512) and added §7 covering NS-030..040 (geometric/scaling tour, possibilistic/inverse-Born
  map NS-037, resolved-DNS boundary program NS-038, Metal/GPU N=512 track NS-039/040). Firewall
  framing (§1, §6) unchanged.
- **F3 (fixed)** — CLAUDE.md status stamp refreshed 2026-05-31/v0.1.0 → 2026-06-04/v0.1.42 with the
  DNS/Metal/possibilistic arc; "zero progress on the prize" preserved.
- **F4 (note)** — no automated CI (research-script repo; recorded `.out.txt` + TEST_SPEC) — noted,
  not a defect.
- **F5 (fixed)** — TEST_SPEC coverage gap (surfaced by a follow-up question after the first pass
  under-audited TEST_SPEC). The verification-discipline doc indexed NS-010/011 + NS-020..024 +
  (T-06/08) NS-032/039 but had no check row for `:tested` entries NS-031/033/038/040. Added rows
  T-09..T-13; all 11 `:tested` entries now carry a documented licensing check.

No spec entries added/changed (status integrity confirmed, not modified). Distance: UNTOUCHED.

## v0.1.42 — 2026-06-04 — Step-2 gate (NS-032 @ N=512) + helicity depletes stretching (NS-040)

Two GPU results + the Step-2 gate formalized. `metal/dns_gpu.swift`, large-session. `:proved`=0.

- **Step-2 gate formalized + executed at N=256↔512 (extends NS-032).** TEST_SPEC **T-06**
  sharpened into the multi-condition gate (G1 δ·k_cut>6 RESOLVED / G2 spectral-N-convergence /
  G3 BKM co-movement) and **T-08** added (CKN dimension guard, calibrated by NS-039). New scorer
  `scripts/step2_gate.jl` + a δ-only loader mode (`NS_DELTAONLY=1`). Ran the inviscid-TG
  blowup candidate (ν=0) at N=256↔512 → **INCONCLUSIVE / regular-leaning**: the full-band δ-fit
  is 42–48% non-converged across N=256↔512 in the resolved window, and δ does not co-move with
  BKM at a common finite t* (G2/G3 fail). The gate correctly refuses a naive δ→0 as a resolution
  artifact — extends the N=32/64/128 NULL to the N≳512 NS-032 called for. Companion
  `docs/step2_gate_inviscid_tg_companion.md`. (nu=0 header guard fix in dns_gpu.swift.)
- **NS-040 (`:tested`) — strong helicity depletes (delays + concentrates) vortex stretching.**
  Resolves the confounded NS-038 case B (ρ_H≈1%). A matched-spectrum controlled pair —
  `helical` (ρ_H=0.97) vs `helicalc` (ρ_H=0.05) with IDENTICAL E0=0.125 AND Z0=0.534374 (helicity
  flipped via the ± sign of a +helical Beltrami-wave superposition) — at Re=1600, N=256↔512.
  Helical enstrophy grows **2–4× slower** (Z/Z0@t=6: 1.59 vs 6.67), resolution-robust to 3–4
  digits. Mechanism = delay+concentration: cascade suppressed early, then a delayed localized
  burst (winf 154, S_ω 0.26@t=9 vs control's declining 0.15; burst set ~1.7–2D, D rising with N
  per T-08). `abcpert` (ρ_H=0.98, large-scale) near-laminar — same direction. Companion
  `docs/helicity_depletion_companion.md`. New ICs in dns_gpu.swift: helical/helicalc/abcpert.
- SPEC NS-040 + NS-032 update + registry + dashboard; TEST_SPEC T-06/T-08; count 26→27.
  All flows REGULAR; resolution/mechanism results, not PDE claims. Distance UNTOUCHED.

## v0.1.41 — 2026-06-03 — Metal N=512 verdict: the C reconnection ≤1 touch is a resolution artifact (NS-039)

Stages 3–5 of the Metal track + the RWC-038 verdict. `metal/dns_gpu.swift`, large-session.

- **Stage 3+4 — GPU time-loop + snapshot writer + hybrid bridge, validated vs CPU.** Full
  GPU-resident RK4 loop + spectral snapshot writer; `scripts/load_gpu_snapshot.jl` reads them
  through the CPU-validated Julia diagnostics. Tubes (Kerr) IC ported to Swift. Float32-GPU ≡
  float64-CPU to 5–6 digits: TG N=256 Brachet peak Z/Z0=27.3902 (CPU 27.3901), D30/50/70
  identical; tubes N=256 reconnection D30=0.986@t=5.5 reproduced to the digit.
- **Two bring-up bugs fixed:** per-step `autoreleasepool{}` (MPSGraph OOM-killed N=256 ~100
  steps in); relative-divergence diagnostic (unnormalized FFT × float32 ⇒ report
  max|k·û|/max|û| ~1e-6 = div-free).
- **Stage 5 — N=512 verdict (NS-039, `:tested`).** Tubes reconnection D30 minimum lifts
  **0.986 (N=256) → 1.426 (N=512)** (finely time-sampled, Δt=0.25). The CKN ≤1 touch is a
  **resolution artifact**: N-convergence is upward/away-from-1, the reconnection is more intense
  yet less localized, and the whole D-spectrum lifts. TG N=512 cross-check: Brachet peak
  Z/Z0=27.43@t=9 (resolution-robust). All four RWC-038 clauses cleared.
- `:proved`=0; all flows REGULAR; resolution push that *removes a false ≤1D signal*, not a PDE
  claim. Distance UNTOUCHED. Companion `docs/dns_gpu_metal_companion.md`; SPEC NS-039 +
  registry row + dashboard. Count 25→26.

## v0.1.40 — 2026-06-03 — Metal N=512 track: GPU FFT (Stage 1) + GPU rhs (Stage 2) validated

Toward N=512 (RWC-038 frontier) on the M5 Max. `metal/`.

- **Stage 1 — MPSGraph 3D FFT probe GREEN** (`metal/probe_mpsfft.swift`): the spectral
  solver's crux (a Metal FFT — the fluoddity-metal fork is finite-difference Jacobi, no FFT
  to reuse) is solved by MPSGraph (Metal 4, native): 8³ roundtrip 2.4e-7; N=256 0.0051 s/fft
  (2.6× FFTW-18 CPU); N=512 0.102 s/fft ⇒ ~2 h for T=10 if FFT-bound, in budget (≤30 GB).
- **Stage 2 — GPU rhs + RK4, entirely in MPSGraph** (`metal/dns_gpu.swift`): rotational-form
  NS rhs (curl → ifft → u×ω → fft → 2/3 dealias → Leray projection → −νk²û) + RK4, fields as
  (re,im) real-tensor pairs (no hand-written Metal kernels). **Validated on inviscid
  ABC/Beltrami (the strongest gate — u×ω=0 ⇒ exactly stationary):** E/E0=H/H0=1.000000,
  H/2E=1.0000, field drift 7.2e-4/10 steps (float32 roundoff) ⇒ curl + cross + Leray all correct.
- Architecture = HYBRID: Swift+MPSGraph GPU time-stepper (float32) writes snapshots → existing
  VALIDATED Julia diagnostics (dns_tg256.jl) read them. Precision note: GPU float32 vs CPU
  float64 — adequacy confirmed at Stage-4 N=256 cross-validation (Brachet peak t=9).
- Next: Stage 3 (time-loop + snapshot writer) → Stage 4 (N=256 vs CPU) → Stage 5 (N=512).
  `:proved`=0; all flows regular; resolution push, not a PDE claim.

## v0.1.39 — 2026-06-02 — NS-038 formalized: the resolved N=256 DNS boundary program (A→B→C)

Promoted the resolved-DNS boundary queue to a first-class spec entry (large-session, new
**RESOLVED-DNS** class).

- **SPEC.md** — new section "RESOLVED DNS" + entry **NS-038**: A (TG, S_ω bounded ~0.2, δ
  bounded, D30 floors ~1.33, c²_int peaks 0.72 = geometric depletion observed), B (helical,
  IC-robust verdicts; helicity confounded), C (vortex tubes, reconnection event, D30→0.99
  transient at CKN ≤1 edge, regular, reconnection-specific). Status `:tested`; Scope: resolved
  N=256 DNS truncation (all flows regular; NOT PDE). FFTW-validated; Brachet peak t=9.
  Depends_on NS-010/004/006/037. Carries **RWC-038** (any "approach to singular set" needs
  threshold-robustness + resolution-robust estimator + IC-independence + N-convergence; the
  reconnection ‖ω‖∞≈97 is at the edge of N=256 ⇒ ≤1D verdict needs N≥512).
- **artifact_registry.md** — NS-038 row (RESOLVED-DNS class).
- **dashboard.md** — status summary + ledger 27→28 (+1 RESOLVED-DNS).
- Boundary queue A→B→C COMPLETE and formalized. `:proved`=0; prize untouched.
- **Next: N=512 via Metal** (RWC-038's open frontier) — GPU port begins.

## v0.1.38 — 2026-06-02 — FFTW N=256 TG re-run: validated ≡ hand-rolled; real speedup 3.3× (not 11.7×)

Re-ran canonical TG Re=1600 N=256 with FFTW (-t18) + enhanced diagnostics. Now the canonical
`scripts/dns_tg256.out.txt` (hand-rolled A preserved @779bd7b).

- **VALIDATED ≡ hand-rolled:** E/E0, Z/Z0, ‖ω‖∞, S_ω match to all digits (t=9 E/E0=0.690460,
  Z/Z0=27.39, S_ω peak 0.290; Brachet peak t=9). **δ converges** at developed times (t=9:
  0.077 both); early-δ difference = FFT-roundoff-floor noise (NS-010 δ-fragility), washes out.
  FFTW is a validated drop-in at full resolution.
- **Honest speedup ≈3.3× (NOT the isolated-fft3 11.7×):** 3.9h→~70min, = ~1.9× threading
  (6→18) × ~1.75× FFTW. The rhs is allocation/memory-bound (out-of-place P*A, ComplexF64
  copy, GC) so FFTW's raw speed is bottled up. ⇒ in-place mul!/rfft/prealloc is the real lever
  for N=512-on-CPU; earlier "~3-4h short-T N=512" too optimistic (true ≈10h at 3.3×). N=512 ⇒
  in-place/rfft opt OR Metal.
- **Clean TG baseline (new diagnostics):** D30 floors ~1.33 (never ≤1) under TG's distributed
  stretching; c²_int PEAKS 0.72 at the stretching max then relaxes — Gemini's geometric-depletion
  alignment-shift, observed directly.
- **TG-vs-C sharpens C:** distributed stretching (TG) floors D30~1.33; concentrated reconnection
  (C) drove D30→0.99 ⇒ the ≤1 touch is SPECIFIC to reconnection, not generic stretching — C's
  near-filamentary moment is real + reconnection-driven, not a TG artifact. Both regular.
- Companion addendum added. `:proved`=0; prize untouched.

## v0.1.37 — 2026-06-02 — C (vortex tubes) = resolved reconnection; FFTW ~6× ⇒ short-T N=512 in reach

**C — the adjudicator (Kerr anti-parallel vortex tubes, N=256, enhanced diagnostics).**
A genuine vortex-RECONNECTION event at t≈5.5–6.0: ‖ω‖∞ spikes ~4× (26→97), S_ω doubles
(0.10→0.24), δ dips to its min (0.088), and the most-intense-30% production set (D30) reads
**≈0.99 at t=5.5 — momentarily at the CKN ≤1 filament edge** — then recovers.
- **Triad VINDICATED on regularity:** δ bounded (never→0) + resolved (δ·k_cut≈7.5); alignment
  stable (c²_int≈0.65, bounded-persistence ⇒ regular). The flow stays analytic.
- **"D floors >1" REFINED:** the bulk (D50≈1.7, D70≈1.9) floors above 1, but at a real
  reconnection the extreme tail D30 transiently touches ≤1 — the one regime meeting the
  singular-set dimension. **CONFIRMATION-BIAS FLAG:** D30≤1 is the noisiest signal (top-30%,
  ±0.15, single sample, recovers in one Δt); D50/D70 stay >1.5; δ bounded ⇒ NOT a blowup. The
  ‖ω‖∞≈97 peak is at the EDGE of N=256 ⇒ a true ≤1D verdict at reconnection needs **N≥512**.
  Enstrophy peaks only 1.8× (localized event, not a developed cascade). Companion addendum added.
- Boundary queue A→B→C COMPLETE; NS-038 (resolved-DNS program) still DEFERRED pending owner call.

**Thread + FFTW benchmark** (`scripts/thread_bench.out.txt`). At N=256: hand -t6 = 0.154
s/fft3 (baseline); hand -t18 = 0.081 (1.9×, -t24 oversubscribes); **FFTW -t6 = 6.7×, FFTW
-t18 = 11.7×** on the FFT. Amdahl-real full-run ≈4–6× ⇒ **N=256 T=10: 3.9h → ~40–60 min.**
**Short-T N=512 now feasible on CPU (~3–4h with FFTW-18)** — the path to resolve C's reconnection
(N=512 tests whether D30≤1 survives or was a resolution artifact). Full-T N=512/N=1024 → Metal.
Recommend FFTW-18 as the production default; rfft/in-place (~2× more) deferred.

## v0.1.36 — 2026-06-02 — FFTW.jl integrated (opt-in, pinned) + checkpoint/resume; perf path

**Deliberate, recorded relaxation of the no-deps rule** (owner-authorized) for compute speed,
done with full lockfile discipline. The hand-rolled threaded FFT remains the DEFAULT and the
hermetic validation reference.

- **FFTW.jl v1.10.0 added, pinned** (`Project.toml` + `Manifest.toml` committed; Pkg verifies
  artifact SHAs ⇒ reproducible). Opt-in via `NS_FFT=fftw` + `julia --project=.`; default
  `NS_FFT=hand` (unchanged behavior, no `--project` needed — keeps in-flight jobs + resume working).
- **FFT plans cached** (created once per N, `FFTW.MEASURE`) — the reuse win. `FFTW.set_num_threads`
  (FFTW's own threading, better than @threads-over-slices).
- **Correctness GATE PASSED:** at N=64, FFTW reproduces the hand-rolled trajectory to all printed
  digits (E/Z/S_ω/D/alignment identical t=0/0.5/1.0; only machine-zero noise differs). FFTW is a
  validated drop-in. (N=64 micro-bench: 2.3× on fft3 — N=256 expected larger, cache-bound.)
- **Checkpoint/resume** (v0.1.36 earlier commit bfe8d3a): `NS_CKPT=Δt` serializes (t,U,E0,Z0)
  (overwrite, gitignored); `NS_RESUME=path` continues — bit-for-bit validated. Crash-proof +
  cheap T-extension/branching.
- **Benchmark updated** (`bench_threads.jl`) to time hand-vs-FFTW fft3 at each thread count;
  queued (watcher `bo60fce3i`) to run `-t 6/12/18/24 --project` after C → the "where we stand"
  data. Other Julia opts (in-place plans, rfft for real fields = further ~2×) deferred pending
  the N=256 numbers. Metal/CUDA (the N=512 path) noted, assessed after FFTW result.
- Scope/firewall unchanged: FFT library doesn't change the evidence class (still computational
  Float64); `:proved`=0; prize untouched.

## v0.1.35 — 2026-06-02 — Boundary B (helical) done: verdicts IC-robust; C (vortex tubes) fired

- **B (helicity boundary, H≠0) DONE** (N=256, Re=1600, energy-matched). Same qualitative
  verdicts as TG: S_ω bounded ≈0.147, δ bounded ~0.081 (resolved), D dips-then-recovers,
  energy monotone-decaying ⇒ **the resolved verdicts are IC-robust, not TG-specific.**
  Quantitative differences (enstrophy peak earlier+lower 8.7×@t=6; S_ω lower; D₅₀ dips only
  to 2.07 = less localized) are *suggestive* of helicity reducing localized stretching but
  **confounded** — the IC is only ~1% relatively helical (ρ_H≈0.011) and low-k-random vs TG's
  smooth structure. Honest: helicity NOT cleanly isolated; a clean test needs a strongly-helical
  ABC/Beltrami IC (ρ_H≈±1) — noted future boundary run. DNS companion addendum added.
- **C (vortex-tube boundary, the adjudicator) FIRED** at N=256 with the enhanced pipeline
  (threshold-robust D30/50/70 + strain–vorticity alignment). Background, ~3.9h. Tests whether
  D floors (geometric, both seats' prediction) or pushes →1, and whether the alignment relaxes
  after peak stretching. `:proved`=0; prize untouched.

## v0.1.34 — 2026-06-02 — Triad metabolized (Gemini+Grok): Fact 3 trimmed; alignment + threshold-D built in

Both witness seats returned and CONVERGED. `docs/triad_verdict_dns_localization.md`.

- **Convergence (independent):** (1) flow regular, distinction resolution-gated at N≤256–512;
  (2) the ~1.8 floor is most plausibly GEOMETRIC (tube/sheet, dim in (1,2), thickness ~ δ /
  Kolmogorov; can't reach ≤1 without δ→0; Hou–Li geometric depletion); (3) Fact 3 (D-dip) is
  fragile.
- **TRIM (incl. our own):** Grok's Fact-3 critique CONFIRMED — D is threshold-dependent
  (`D30/D50/D70 = 1.54/1.74/1.92` at N=64). The earlier "production set *localizes toward the
  CKN ≤1 filament limit*" wording is trimmed to "a threshold-dependent ~1.5–1.9-dim tube/sheet
  object that does NOT approach ≤1." (`dns_tg256_companion.md` annotated.) Gemini's
  "self-arrest/breathing" held as hypothesis (timing: D recovers t≈6, dissipation peak t≈9).
- **Two Q1 discriminators (both resolution-robust-ish):** Gemini = δ(t) functional form
  (algebraic collapse vs exponential leveling); Grok = conditional strain–vorticity alignment
  persistence on the intense set.
- **Pipeline enhanced (committed) → C captures it:** `dns_tg256.jl` now outputs threshold-robust
  D (D30/D50/D70, Grok's test) + strain–vorticity alignment (cos²(ω,e_int/e_max), enstrophy-
  weighted; Gemini/Grok mechanism). N=64 smoke validates: threshold-sensitivity confirmed;
  alignment = classic Ashurst intermediate-eigenvector (c²_int=0.77), shifting under stretching.
- **The vortex-tube run (C) is now the adjudicator:** both seats predict D floors (geometric,
  IC-independent) rather than → 1. Required Witness Check carried (any "approach to singular set"
  must clear threshold-robustness + resolution-robust estimator + IC-independence + N-convergence).
  `:proved`=0; prize untouched. (A/B ran on the pre-enhancement pipeline; C gets the new diagnostics.)

## v0.1.33 — 2026-06-02 — Triad brief prepared (the D-localization discrimination question)

`docs/triad_brief_dns_localization.md` — witness-triad brief (Grok edge-witness-Φ / Gemini
synthesis / Aaron instantiator; Claude metabolism). Self-contained, standard-fluids terms,
internal labels stripped (so the seats reason from physics, not our framing). Payload: the
resolved N=256 TG verdicts (S_ω bounded ~0.2; δ bounded; D *dips to 1.82 at peak stretching*
then recovers — localizing toward the CKN ≤1 filament limit), with helical running + the
near-singular vortex-tube IC queued (starts D=1.74, ‖ω‖∞=16). Three questions: Q1 (the
headline) — what resolution-robust observable distinguishes "localizing toward a singularity"
from "regular intermittency"? Q2 — predict the vortex-tube outcome + the single cleanest
measurement. Q3 (Grok) — structural reason for a ~1.8 floor, or artifact? Firewall + anti-
anchoring carried. To be run externally; responses metabolized + witness-trimmed on return.

## v0.1.32 — 2026-06-02 — Boundary-exploration harness: helical (B) running, vortex-tubes (C) queued

Parametrized `dns_tg256.jl` into a boundary harness (`NS_IC` ∈ tg | helical | tubes),
energy-matched to TG (E≈0.125, Re=1600) for fair cross-boundary comparison.

- **B (helicity boundary, H≠0):** `helical_ic` (low-k random helical, rescaled). N=64 smoke
  clean (H0≠0, div 4e-12, H≈conserved). **N=256 run LAUNCHED** (background, ~3.8h) — tests
  whether the surviving 3D Casimir (NS-036) changes the resolved verdicts (S_ω bounded? D dip?).
- **C (blowup-candidate boundary):** `vortex_tube_ic` — Kerr-style anti-parallel vortex tubes
  along x (opposite circulation, sinusoidal centerline wiggle), ω prescribed → Leray-projected
  div-free → u=curl⁻¹ω. N=64 smoke clean (div 4e-12, H0≈0 by anti-parallel symmetry) and
  **already informative: ‖ω‖∞=16.5 (vs TG 2.0), D_box=1.74 at t=0 (vs TG 2.43)** — the IC
  starts far more filamentary (near-singular character). VALIDATED + QUEUED for N=256 (fires
  after B; can't run concurrently — both bandwidth-bound).
- Harness + both N=64 validations committed. The N=256 science (B verdicts, C verdicts) lands
  next. `:proved`=0; prize untouched.

## v0.1.31 — 2026-06-02 — Resolved N=256 DNS (TG Re=1600): the gated verdicts, resolved

First run on the real ~6-hour budget (prior runs ~10 min). Resituated after Aaron flagged
"exhausted at laptop scale" as premature. `scripts/dns_tg256.jl` — threaded radix-2,
N=256, viscous TG Re=1600, dt=0.005, T=10, ~3.8h on 6 threads.

- **Validated vs Brachet-1983:** enstrophy peaks at t=9.0 (Z/Z₀=27.4) — the canonical TG
  Re=1600 dissipation-peak time. Energy monotone-decaying, H≈1e-18 (TG symmetry exact). The
  hand-rolled hermetic solver reproduces published DNS at N=256.
- **S_ω BOUNDED ≈0.2** (transient peak 0.29 at t≈4, then settles) — the "bounded vs growing"
  gate RESOLVED: bounded, no blowup signature (expected at Re=1600).
- **δ(t) bounded** (min 0.077 at the peak, never→0), well-resolved (δ·k_cut≈6.5) — NS-010
  viscous control confirmed at 256.
- **D_box DYNAMIC** — dips to 1.82 at peak stretching (t≈4, when S_ω peaks + ‖ω‖∞ jumps to
  ~14), recovers to ~2.0. The production set LOCALIZES toward the CKN≤1 / NS-037 filament
  limit at peak stretching but bottoms ~1.8 (never ≤1). Refines the under-resolved N≤128
  "static D≈2.3."
- New `docs/dns_tg256_companion.md`. Candidate **NS-038** (resolved-DNS verdicts) DEFERRED —
  recommend formalizing after the boundary queue (A=res/TG done, B=helicity, C=vortex-tubes).
  Honesty: Brachet match on peak-TIME (robust); D_box is a 5-scale fit (±0.15). `:proved`=0;
  prize untouched.

## v0.1.30 — 2026-06-02 — Touchability ranking: C_ε > exponents > C_K (refines NS-037c)

Same hard-vs-frame-dependent test on the Kolmogorov constant C_K and the dissipation
anomaly C_ε. `scripts/kolmogorov_dissipation_hard_test.jl`.

- **C_K (amplitude): purely frame-dependent** — the 4/5 law is 3rd-order (touches it not),
  realizability bounds exponents not amplitudes, only C_K>0. The SLOPE it sits on is touched:
  ζ_2∈[2/3,1] bracketed (concavity floor 2/3=K41, monotone ceiling 1; extremals saturate
  both) ⇒ spectral slope ∈[−2,−5/3]; but the AMPLITUDE C_K is not.
- **C_ε (dissipation): partially touched** — RIGOROUS finite upper bound (Doering–Foias–
  Constantin, C_ε≤c_1/Re+c_2, from the NS energy balance); positivity is the empirical zeroth
  law (unproven, tied to the 4/5 RHS / Onsager); value frame-dependent. The most-touched of
  {C_K, μ, C_ε} — the one inside a rigorous NS inequality.
- **RANKING + principle:** dissipation rate (rigorous bound) > exponents (realizability
  brackets) > spectral amplitude (untouched). NS's rigorous reach = exact laws (4/5) +
  realizability (exponents) + energy balance (dissipation), NOT amplitudes.
- Refines NS-037(c) (prior "frame-dependent (μ,C_K,κ,C_ε)" lumping was too coarse — C_ε has
  a rigorous bound). NS-037 updated + Source/companion added; stays `:argued` (conjunctive
  rule). New `docs/kolmogorov_dissipation_hard_test_companion.md`. Anti-anchoring kept.
  `:proved`=0; prize not the target.

## v0.1.29 — 2026-06-02 — NS-037 formalized: the inverse-Born / possibilistic turbulence map

Promoted the v0.1.26–28 turbulence-possibilistic arc to a first-class spec entry
(large-session pass), in a new **POSSIBILISTIC** class.

- **SPEC.md** — new section "POSSIBILISTIC / EMPIRICAL MAP" + entry **NS-037** (umbrella for
  the three artifacts): (a) the inverse-Born map (ζ_p↔D(h) Legendre; attractor runs to the
  CKN wall); (b) the obstruction (log-normal cascade FORBIDDEN by realizability; log-Poisson
  survives on the codim-2 integer); (c) the μ∈[0,1] hard bound (tight, no tighter; forced vs
  frame-dependent boundary). Status `:argued`; evidence algebraic + computed; Scope EMPIRICAL
  phenomenology + exact 4/5 + realizability (prize deliberately not the target).
- **artifact_registry.md** — NS-037 row (new POSSIBILISTIC class; 2 honesty flags recorded).
- **dashboard.md** — status summary + ledger. **Count corrected 25→27**: the prior "25"
  undercounted RELATED by one (NS-025 Gosme + NS-035 Ryan = 2 RELATED); true total was 26,
  now 27 with NS-037 (+1 POSSIBILISTIC). An A5/A6 stale-count fix folded in.
- Methodology source: closure-v5 `BUSINESS/inverse_born_methodology.md` (A. Green, Apr 2026).
- Audit: A1 coverage ✓ (every NS-ID has a row); A4 zero `:proved` ✓. `:proved`=0; prize untouched.

## v0.1.28 — 2026-06-02 — Hard layer bounds μ ∈ [0,1] (tight) — and honestly stops there

Tested whether the frame-independent (hard) invariants can promote the intermittency
exponent μ to a structural bound. `scripts/mu_hard_bound.jl`. μ = 2 − ζ_6.

- **μ ≤ 1** from monotonicity (ζ_6 ≥ ζ_3 = 1, regular flow / bounded velocity); **μ ≥ 0**
  from concavity (ζ_6 ≤ 2ζ_3 = 2). So μ ∈ [0,1], frame-independently.
- **Tight at both ends:** K41 (linear ζ_p) saturates μ=0; ramp-then-flat saturates μ=1 —
  both admissible (concave, nondecreasing, ζ_3=1).
- **CKN does NOT tighten:** it bounds genuine singularities (h<0); a regular flow has h≥0
  everywhere ⇒ no singular set ⇒ CKN vacuous on the spectrum. Concavity/D≤3 permit μ→1.
- **Answer:** YES the hard layer bounds μ above (μ≤1), but NO TIGHTER. The observed
  μ≈0.20–0.25 is interior; the gap to ~0.2 is frame-dependent content the anti-anchoring
  discipline forbids importing as structure. The methodology brackets μ and honestly stops.
- **Confirmation-bias flag (recorded):** the random ensemble's min μ=0.200 coincides with
  the observed μ — a SAMPLING ARTIFACT of the slope generator, NOT a structural bound (true
  lower end is 0, K41). Logged precisely so it is not mistaken for a derivation.
- New `docs/mu_hard_bound_companion.md`. Strengthens deferred NS-037. `:proved`=0.

## v0.1.27 — 2026-06-01 — Inverse-Born PUSH: derive the cascade by obstruction (log-normal FORBIDDEN)

Applied the closure-v5 inverse-Born obstruction methodology verbatim (A. Green, Apr 2026;
`closure-v5 BUSINESS/inverse_born_methodology.md`) to the turbulence cascade.
`scripts/turbulence_inverse_born.jl`.

- **Invariant stratification (the gate):** only frame-independent invariants used as HARD
  constraints — ζ_3=1 (4/5, exact), D≤3, ζ_p nondecreasing+concave (realizability), CKN ≤1D,
  the codim-2 filament integer. The numbers (C_K, μ, ζ_{p≥4}, κ, C_ε) are convergence
  targets, explicitly NOT anchored on (anti-anchoring, methodology §9).
- **The obstruction (HARD layer only) over the cascade-model family:** log-normal (K62) is
  **FORBIDDEN** — ζ′_p<0 for p>p*=3/μ+3/2 (≈16.5) and D(h)<0 (negative dimension): two
  independent realizability violations. A clean structural NULL (cf. P2-A/P2-B). β-model
  passes the hard layer but is monofractal (disfavored only at the convergence layer, flagged
  *). K41 allowed-degenerate. log-Poisson/She–Lévêque SURVIVES — monotone, concave, ζ_3=1,
  D(h_min)=1 exactly (codim-2), meeting the CKN ≤1D edge; survives on STRUCTURAL INTEGERS,
  not fitted numbers.
- **Verdict:** the null promotes "why not log-normal" to "structurally impossible at every
  Re, in every flow." What is FORCED (structure, not numbers): ζ_3=1 tangent, monotone-concave
  ζ_p, ≤1D singular end. The selection of log-Poisson among survivors is the WEAKER
  frame-dependent layer — labeled as such, not promoted.
- New `docs/turbulence_inverse_born_companion.md`. Strengthens candidate NS-037 (still
  deferred). `:proved`=0; the prize was not the target.

## v0.1.26 — 2026-06-01 — Inverse-Born / possibilistic map of turbulence's measured constants

A deliberate pivot off the prize: map *possibility* and *probability* (not just necessity)
of the physical phenomenon, on its natural manifolds. `scripts/turbulence_nogo_map.jl`.

- **The inverse-Born is literal:** the multifractal formalism is a large-deviation/Born
  structure — `ζ_p = inf_h[ph+3−D(h)]`, so measured moments `ζ_p` are the Legendre
  transform of the singularity spectrum `D(h)` (the possibility structure / rate function).
  Inverse-Born = inverse Legendre `D(h)=3−max_p[ζ_p−ph]`, recovering `D(h)` from data.
- **Panel 1 (inertial (h,D) manifold):** measured `ζ_p` match She–Lévêque to ±0.02 (ζ₃=1
  exact); recovered `D(h)` peaks at D=3 (h≈0.38), passes the K41/Onsager pivot (h=1/3,
  D≈2.97), and **runs down to the CKN wall (D=1 @ h=1/9)**. Forced: D≤3, concavity, ζ₃=1
  (4/5) tangent, CKN ≤1D edge. The attractor *saturates* the CKN no-go (flagged as
  consistency, not identity — intense filaments vs hypothetical singular set).
- **Panel 2 (σ-ladder overlay):** h=1/3 ⟺ σ=0 (NS-036) is the rigorous pivot; h<1/3 (rough)
  sits on the enstrophy/stretching side — local spectrum and global ladder agree on where
  the difficulty is.
- **Panel 3 (wall manifold (Re,y⁺)):** onset Re_c (pipe 2040 / Couette 325) = laminar
  forbidden→possible (NS-021 lifetimes); log law κ≈0.41 forced-in-form by overlap, window
  opens as Re→∞. Hinge: the dissipation anomaly C_ε≈0.5 (ν-independent) forces h=1/3.
- Tags throughout: [EXACT] (4/5, D≤3, concavity) / [MEASURED] (C_K,ζ_p,μ,C_ε,κ,Re_c) /
  [MODEL] (She–Lévêque, h↔σ beyond the pivot). New `docs/turbulence_nogo_map_companion.md`.
- Candidate spec entry **NS-037** (possibilistic/inverse-Born map) DEFERRED — owner's call.
  `:proved`=0; the prize was deliberately not the target.

## v0.1.25 — 2026-06-01 — DEC sandbox: structure-preserving discrete-NS substrate (discrete.rtfd part 2)

The legitimate discrete direction, built honestly: a periodic cubical chain complex on 𝕋³
(`scripts/dec_repair_sandbox.jl`, Serre operators, std-lib SparseArrays/LinearAlgebra).

- **Structure-preserving:** `∂₁∂₂=∂₂∂₃=0` to machine zero at N=2,3,4 — a real DEC/mimetic
  substrate (and the correctness gate).
- **"b₁ pinned under refinement" on the actual mesh:** Betti numbers `(1,3,3,1)` at
  N∈{3,4,6} (Euler χ=0 each). `dim H₁=3` at every resolution — refinement does NOT
  manufacture new 1-cycle classes. Confirms NS-020 structurally.
- **The genuine 2-chain repair cost** `min{‖z₂‖:∂₂z₂=c₁}` (discrete Seifert surface,
  SVD-pseudoinverse min-norm filling) does NOT overflow: peak label `‖z‖∞` *decreases*
  (0.66→0.38) as a filament loop grows; total grows only sub-linearly (below √area); the
  only ∞-cost cycles are the 3 fixed H₁ generators. Completes part 1's field/Hodge
  refutation in the chain picture.
- **Net:** the discrete substrate is real and kept as a sandbox, but it does NOT support
  the `discrete.rtfd` "dual-closure uplift / the PDE is the wrong model" claim. NS-020
  annotated (part 2); new `docs/dec_repair_sandbox_companion.md`. No new spec entry.
  (Honesty: an earlier draft of the printed verdict said total "~√area"; corrected to
  sub-linear + peak-decreasing to match the data, before commit.)
  `:proved`=0; distance to prize UNTOUCHED.

## v0.1.24 — 2026-06-01 — "repair cost grows" tested directly → REFUTED (discrete.rtfd part 1)

Adjudicated the central claim of the Desktop `discrete.rtfd` "dual-closure uplift" pass
(Grok): that repair cost `Cost(c)=inf{‖z‖:∂z=c}` grows exponentially under 3D stretching,
"proxied by enstrophy" — its basis for "the PDE is the wrong model."

- Computed the REAL cost on the validated 3D solver. The minimal filling of the vorticity
  is the **velocity** (one derivative smoother): `R_X(ω)=‖curl⁻¹ω‖=‖u‖=√(2E)` (sanity
  mismatch 0.0). On inviscid Taylor–Green N=64: enstrophy½ grows **×3.34** (‖ω‖∞ ×10) while
  `R_X` drifts **×1.0000** (= conserved energy); ratio `R_X/‖ω‖` decays 0.577→0.173.
  k-space: repair cost stays 99.8% low-band, enstrophy migrates high-band. Viscous TG:
  `R_X` decays monotonically with energy (no "overflow").
- **Verdict:** "grows exponentially" is true only of the enstrophy **proxy** it was swapped
  for; the real cost is energy-side (σ=−½, supercritical) — the same NS-036 wall, relabeled.
  Confirms NS-020 "repair-cost ≈ 1/vorticity" (now verified under stretching). The
  document's own variational derivation (mean-curvature → low-cost) already contradicts it.
- NS-020 annotated; new `scripts/repair_cost_under_stretching.jl` (+ .out.txt) +
  `docs/repair_cost_under_stretching_companion.md`. No new spec entry.
- **Scope honesty:** refutes the field/Hodge `L²`-repair version + the general
  derivative-smoother argument; the explicit 2-chain Seifert-surface version is the next
  step (DEC sandbox, part 2). `:proved`=0; distance to prize UNTOUCHED.

## v0.1.23 — 2026-06-01 — NS-036 formalized: the criticality–Casimir hinge enters the spec

Promoted the v0.1.22 §5 tightening to a first-class spec entry (large-session pass):
- **SPEC.md** — new entry **NS-036** ("criticality–Casimir hinge: supercriticality
  [NS-034] ≡ Casimir deficit [NS-033 Slice 6], joined at enstrophy; curvature
  independent"), **`:argued`**, evidence `algebraic + computed`, Depends_on NS-034 /
  NS-033 / NS-002 / NS-005.
- **artifact_registry.md** — NS-036 row (test covers the interpolation sub-claim; the
  entry-level equivalence stays `:argued` per the conjunctive-claim rule).
- **dashboard.md** — status summary + ledger count 24→25 (ANALYSIS 1→2: NS-034 + NS-036).
- **docs/criticality_casimir_hinge_companion.md** — new companion (§1 basis / §2 results /
  §3 verification / §4 spec impact).
- Test `scripts/criticality_casimir_hinge.jl` (+ .out.txt) already landed at v0.1.22.
- Audit: A1 coverage (every NS-ID has a row) ✓; A2 status parity ✓; A3 artifacts exist ✓;
  A4 zero `:proved` ✓. `:proved`=0; distance to prize UNTOUCHED.

## v0.1.22 — 2026-06-01 — §5 tightened: the criticality–Casimir hinge (a≡b), curvature is independent

Analytic tightening of the write-up's §5 capstone ("three routes, one wall") into an
exact implication chain — resolution-free, the one move left that *strengthens* rather
than gates.

- **(a) ≡ (b) is now a derivation, not an assertion**, joined at **enstrophy**. On the
  homogeneous-Sobolev ladder (NS-034 exponents, quadratic units): energy σ=−1, critical
  `Ḣ^{1/2}` σ=0, enstrophy `‖ω‖²_{L²}` σ=+1 — **symmetric about σ=0**, critical = the
  geometric-mean midpoint via the elementary exact interpolation
  `‖u‖²_{Ḣ^{1/2}} ≤ ‖u‖_{L²}·‖u‖_{Ḣ¹}`. So bounded energy + bounded enstrophy ⇒ regular,
  and the whole 3D question collapses to **one rung**: can enstrophy be a-priori bounded?
  = the Casimir question verbatim (2D: enstrophy is a Casimir ⇒ regular; 3D: family
  collapses to helicity, itself σ=0 + sign-indefinite ⇒ open). Common mechanism = the
  vortex-stretching production `P=∫ω·Sω` (= the `S_ω` detector of §3). "Enstrophy
  non-coercivity" = the *name of the joint*, not a third coincidence.
- **(c) curvature corrected to an *independent* companion** (honesty fix to "one fact,
  three costumes"): Arnold's negative curvature is on SDiff(𝕋²) — the **2D, regular**
  case — so curvature ⇒ *sensitivity* (unpredictability), not *singularity*. The same
  "two notions" lesson as Slice 2 / the robustness↔sensitivity tension.
- **Verified:** `scripts/criticality_casimir_hinge.jl` (+ .out.txt) — interpolation holds
  for generic spectra (ratio ≤ 0.87) and is **sharp**: equality (ratio=1.000) *iff*
  scale-pure (single shell); the gap below 1 *is* the multi-scale/cascade content.
- Scope: NS scaling + elementary interpolation + exact Euler Casimir algebra.
  **Sharpens** the wall to a single inequality on a single rung; does **not** close it.
  `:proved`=0; distance to prize UNTOUCHED. (Spec impact: candidate NS-036 "criticality–
  Casimir hinge" — deferred, owner's call; for now an exact `:verified` companion in §5.)

## v0.1.21 — 2026-06-01 — NS-020 note: independent rediscovery (Grok), confirmatory

A long Grok conversation (`~/Desktop/grok.rtf`) independently re-derived the
finite-incidence / chain-complex reformulation already FALSIFIED in NS-020 (flux
closure `∂₁q=0` vs. repair closure `q∈im ∂₂`; refinement-tower repair-cost `R_X(q)`;
"3D repair fires out of turn"; NSA / surreal lifts). Metabolized and logged as
**confirmatory calibration**, not a reopened path:
- Same `H₁` obstruction we mapped; on fixed-topology domains `dim H₁` is pinned under
  refinement; vortex filaments are not new domain 1-cycles (`ω=∇×u` always exact).
- Grok's own honest catch — `R_X(q)≈1/|ω|` — *inverts* the turbulence criterion and
  confirms the difficulty is **norm-driven** (NS-002 / Casimir deficit / enstrophy
  non-coercivity, §5), not topological. Repair gets *cheaper* exactly where blowup
  threatens, so the homological framing is orthogonal to the real wall.
- "Fires out of turn" = the vortex-stretching / production–dissipation race relabeled
  (already probed rigorously via `S_ω`); NSA/surreal = speculative scaffolding on a
  falsified foundation.
- NS-020 entry annotated with a dated update. The rediscovery accepted the verdict.
  No new spec entry; no script. `:proved`=0; distance to prize UNTOUCHED.

## v0.1.20 — 2026-06-01 — Box-counting dimension: the M*↔CKN close (and it corrects f50)

`scripts/ryan_ckn_box_dimension.jl` (box-counter validated: line→1, plane→2, volume→3). The
Ryan-correct, scope-INVARIANT measure of the vortex-stretching production set:
- **D ≈ 2.3, RESOLUTION-ROBUST (N=64 vs 128 agree to ±0.09) and time-STABLE.**
- **CORRECTS the f50 reading (v0.1.19):** f50's apparent "localization toward ≤1D" (0.16→0.06,
  shrinking with N) was a RESOLUTION-COUPLED artifact (a volume fraction). The true dimension
  does NOT drop — the production is an **intermittent ~2.3-D fractal** (vortex sheets/tubes,
  real-turbulence value), NEITHER a forming ≤1D singular set NOR space-filling. **D>1 ⇒ no
  resolved singular set** (CKN's ≤1 not approached at N≤128; true verdict needs N≳512).
- **Ryan principle (NS-035) validated twice:** it told us which measure to trust (scope-invariant
  over resolution-coupled), and that measure then CORRECTED the misleading one — the f50
  "localization" was exactly the resolution artifact Ryan predicts you'll be fooled by.
- NS-006 note updated (the conclusive measure + correction). No new spec entry. `:proved`=0;
  distance to prize UNTOUCHED. The M\*↔CKN thread is honestly CLOSED at accessible resolution.

## v0.1.19 — 2026-06-01 — Two probes: reality stabilizer (Grok Move 4) + M*↔CKN scope localization

`docs/move4_ckn_probes_companion.md` + two scripts.
- **Reality stabilizer (Move 4, `complex_burgers_reality_leakage.jl`)** — complex viscous
  Burgers (real heat-protected; complex φ-zero blowup = 1D Li–Sinai). Tunable reality leakage
  λ damping Im(u), integrating-factor RK4. λ=0 blows up at t*=5.54 (Cole–Hopf-validated ✓);
  **reality PROTECTS with a boundary λ_c∈(0.02,0.05)** — T* rises ~22% below it (delay),
  regular above it. Grok's "protection boundary" confirmed. Sharpens NS-013. Scope: 1D-model.
  (Caught + fixed a stiff-viscous instability; corrected my own first "sharp" reading.)
- **M\*↔CKN scope localization (`ryan_ckn_scope_localization.jl`)** — track the minimal scope
  carrying the vortex-stretching production. It **LOCALIZES** in the resolved window (f50:
  0.16→0.06) and **SHARPENS with N** (the Ryan-Class-II / CKN-≤1D signature). **HONEST CAVEAT
  (Ryan-internal):** f50 is a volume *fraction* (resolution-coupled); the conclusive
  scope-invariant measure is the **box-counting DIMENSION** (= what CKN bounds) — the
  principled next step. Suggestive of concentration, NOT a resolved singular set at N≤128.
  Notes on NS-006, NS-013. No new spec entry. `:proved`=0; distance to prize UNTOUCHED.

## v0.1.18 — 2026-06-01 — The Ryan scope/resolution lens (NS-035): the principle behind the diagnostic

Recorded Alex Ryan, *Emergence is coupled to scope, not level* (arXiv:nlin/0609011,
2006), as **NS-035 (RELATED, :cited)** + companion `docs/ryan_scope_resolution_lens.md`.
Near-literal map (resolution↔grid N, scope↔domain integral) ⇒ it *grounds* the whole
diagnostic arc:
- **The principle behind σ=0:** the δ-slope-fit is a RESOLUTION operation = Ryan Class I
  (weak/epistemic — drifts with N, categorically blind to a genuine singularity); the σ=0
  invariants (helicity, E·Ω, S_ω) are SCOPE quantities = Class II (where novel/ontological
  emergence, incl. real blowup, lives). **δ was the wrong CLASS** — not just fragile.
- The **robustness↔sensitivity tension** = the scope(ontological/robust)–resolution(epistemic/
  fine) split, irreducible.
- **Re-reads:** helicity/Casimirs = Ryan-novel-emergent (scope-coupled topological) invariants
  ⇒ Casimir deficit = a deficit of ontological invariants; supercriticality (NS-002/034) =
  resolution-coupled control vs scope-coupled question.
- **New criterion:** Class-II singularity ⟺ a SCOPE quantity diverges AND the divergence
  CONVERGES as N→∞ (a δ→0 resolution drift is Class I, inconclusive). Ryan's minimal
  macrostate M\* ↔ CKN (NS-006): track the minimal scope carrying the production (≤1D
  localizing = Class II; spreading = Class I) — the next concrete diagnostic direction.
- Conceptual lens (tighter than the witness-trimmed closure/GPG bridge, but the interpretive
  "blowup=Ryan-novel-emergent" claim is RWC-NS-gated). NS-010 note + counts → 25 entries.
  `:proved`=0; distance to prize UNTOUCHED.

## v0.1.17 — 2026-06-01 — The σ=0-detector question, answered (production skewness) + an amendment

Grok's 2nd Oracle pass refined "Critical Gate Flux" (Move 1) → anchored to the
**vortex-stretching production skewness** `S_ω=P/⟨|ω|²⟩^{3/2}`, `P=⟨ω·(ω·∇)u⟩`.
`scripts/grok_production_skewness_probe.jl` (same spectrally-embedded inviscid flow, N=32/64/128).
- **Correctness:** `dΩ/dt = P` verified (2–6%) — S_ω built on the genuine enstrophy-blowup driver.
- **The right detector CLASS:** S_ω is **both** resolution-robust (4.8% across N, vs δ-fit 63%)
  **and** singularity-relevant (the stretching efficiency; `dΩ/dt=c·Ω^{3/2}` ⇒ blowup iff S_ω
  bounded below) — the "both" that ρ_H (robust-but-blind) and δ (sensitive-but-a-fragile-fit) lacked.
- **AMENDMENT to Grok's "both by construction" (the metabolism's honest correction):** NO FREE
  LUNCH — robustness↔sensitivity are in **TENSION**. S_ω is *less* robust than ρ_H (4.8% vs 0.5%)
  precisely because it depends on the strain (small scales = the cutoff-sensitive part);
  sensitivity to the singularity *is* small-scale dependence ⇒ the diagnostic you need is the
  one resolution hurts most. (A real structural reason the numerical attack is hard.)
- **Honest verdict:** S_ω peaks ~0.18 (resolved) then decays, but the decay is resolution-
  contaminated past the wall — the right OBJECT, not a verdict; the bounded-vs-growing question
  stays resolution-gated, now posed in the correct variable.
- Appended to `docs/grok_oracle_anchoring_companion.md` §6; NS-010 note extended. No new spec
  entry. `:proved`=0; distance to prize UNTOUCHED.

## v0.1.16 — 2026-06-01 — Grok Oracle pass: metabolized, anchored, one nugget tested

Triad protocol — Grok in the Oracle/Φ (exploratory) seat; metabolism seat anchored
his 5 wild moves to NS and ran the one computable one. `docs/grok_oracle_exploratory_brief.md`
(the brief), `docs/grok_oracle_anchoring_companion.md` (the integration),
`scripts/grok_scale_invariant_probe.jl`.
- **Anchoring:** Move 3 (mirror world) = our analyticity-strip method (NS-010..013);
  Move 5 (fracture dimension) = CKN (NS-006); Moves 1+2 distill to a real diagnostic
  nugget; Move 4 (substrate predicts) **walks back through the fenced bridge — not chased**;
  the "anomaly class in H³(Diff,ℝ)" is evocative (helicity *is* cohomological,
  supercriticality *is* anomaly-like) but **not literal** — a name, not a construction.
- **The tested nugget (Moves 1+2):** our δ-diagnostic failed because it's a spectrum-
  SLOPE FIT (resolution-fooled). A σ=0 (scale-invariant) diagnostic should be robust.
  **CONFIRMED:** on one spectrally-embedded inviscid flow (same flow at N=32/64/128),
  relative helicity ρ_H and E·Ω agree to **0.5% / 1.0%** across N where δ drifts **63%**.
  **Honest limit:** robust ≠ singularity-DETECTOR (ρ_H just tracks Ω-growth). Open:
  a σ=0 quantity that's *both* robust and singularity-sensitive.
- **Honesty catch mid-test:** first run compared *different* random ICs per N (confounded —
  ρ_H spuriously "drifted 152%"); spectral-embedding fix (verified E/H/Ω identical at t=0)
  made it a true resolution test. Confirmed Grok's idea cleanly.
- NS-010 gets a "better-diagnostic-class" note. No new spec entry. `:proved`=0; prize UNTOUCHED.

## v0.1.15 — 2026-06-01 — Synthesis write-up of the obstruction program

`docs/obstruction_program_writeup.md` — a standalone preprint-style synthesis of the
whole arc (NS-001..034), written to survive a witness pass: enthusiasm in the framing,
rigor in the claims. Sections: the firewall frame; the walls; the validated diagnostic +
its charted inviscid-3D limit; the honest nulls (Step 2 + N=128); **the geometric
capstone — three routes (scaling/NS-034, coadjoint Casimir deficit, Arnold curvature)
converging on one structural wall**; and **§6 "the residue is speaking"** — the
closure/GPG/triad thread, fully firewalled:
- decay-default / closure-as-achievement; the autopoietic CTMC; GPG/hypergraph-rewrite
  substrate (Brian's Substrate→GPG→RCFS→derived, test-first/unverified).
- **the S↔A triad rotation** (gate = weak-edge target, rotation-covariant; (M,R) gate S
  and turbulent roll-gate A are the same triangle rotated — `closure_triad_rotation`).
- the witness trims: convergence "real but overstated" (C1 broad / C2 dead / C3 refuted),
  "one notion or two? → two", Slice-2 gate-is-multi-mode, Gosme NEGATIVE — **four
  independent trims**, with an explicit **Required Witness Check (RWC-NS)** fencing any
  load-bearing use.
- the honest synthesis: the residue speaks a structural GRAMMAR (triadic closure,
  rotation-covariant gate, decay-default, the recurring wall), NOT a bridge to the PDE.
No new spec entries (synthesis of existing); `:proved`=0; distance to prize UNTOUCHED.

## v0.1.14 — 2026-06-01 — High-res near-singularity hunt N=128 (recreational; confirms NS-032)

`scripts/blowup_highres.jl` — "just for fun" resolution push of the Step-2 hunt
(NS-032) to N=128 (2× linear, 8× grid points), hermetic hand-rolled FFT, multithreaded
(16 cores; threaded fft3 roundtrip verified 2e-15). Inviscid Taylor–Green, T=5.
- **Resolution wall moves cleanly with N:** t_res ≈ 3.0 / 4.26 / ≥5.0 for N=32/64/128.
  More resolution buys more resolved cascade time (finer 2/3 cutoff), not removal.
- **δ does NOT converge — it drifts DOWN monotonically with N** (at fixed t,
  δ(N=32)>δ(N=64)>δ(N=128); |Δ|₆₄,₁₂₈ up to 73%, growing with time). The δ-slope-fit
  tracks the widening fit band over the developing power-law range, not a converged
  analyticity strip. Confirmed at a THIRD resolution — pushing N does NOT rescue the
  δ-diagnostic for inviscid 3D. δ-decline decelerates (consistent with no finite-time TGV
  singularity, the literature reading). BKM finite (→38), energy conserved, enstrophy ×15.
- **Verdict UNCHANGED in kind: a higher-res INCONCLUSIVE.** Vivid demonstration of why the
  real studies need N≳512 — the problem is genuinely hard, not just under-computed here.
- Recorded as a recreational extension of NS-032 (no new entry); SPEC/registry noted.
  **`:proved`=0; distance to prize UNTOUCHED.** (First file to break hermetic? No — still
  hand-rolled FFT, no FFTW; only added: `Base.Threads` + `julia -t`.)

## v0.1.13 — 2026-06-01 — Slice 6: 3D-Euler coadjoint/isovortical structure — the Casimir deficit

`scripts/manifold_6_coadjoint_3d.jl` (extends NS-033). The geometric capstone:
Euler = coadjoint-orbit flow (vorticity frozen-in / Lie-dragged); the 2D/3D gap is
the **CASIMIR DEFICIT**.
- **2D Euler (∞ Casimirs):** ∫ω², ∫ω⁴, ∫|ω|, max|ω| conserved to 1.000000 + the
  sorted vorticity distribution preserved — the flow only REARRANGES ω (isovortical)
  ⇒ enstrophy bounded ⇒ rigid orbit ⇒ regular.
- **3D Euler (~1 Casimir):** HELICITY conserved to 1.000000 (topological Casimir,
  vortex-line linking — Moffatt) + energy conserved, but ∫|ω|² grows ×6 and max|ω| ×3.6
  over t∈[0,2] (vortex stretching) — the ∫f(|ω|) family is NOT conserved ⇒ loose orbit
  ⇒ open.
- **The capstone:** the Casimir deficit (∞→1) is the coadjoint-geometric statement of
  the 2D/3D gap — the SAME wall as enstrophy non-coercivity (`physical_invariants.md`)
  and energy supercriticality (Slice 3 / NS-002, NS-034), now in orbit-invariant terms.
  Three independent geometric routes, one wall.
- Compact 2D Euler inline (distinct names; spectral_2d_control has no include-guard);
  3D via the guarded spectral_3d_control. Honest: 3D enstrophy growth resolution-limited
  (resolved window shown); viscosity breaks the Casimirs — ideal-flow geometry, NOT NS.
- Folded into NS-033 (now 6 slices). **`:proved`=0; distance to prize UNTOUCHED.**

## v0.1.12 — 2026-06-01 — Gosme/MFE symmetrization test (NS-021×NS-025) → NEGATIVE

Ran the queued NS-025 phenomenology experiment: does Gosme's causal-symmetrization
signature (structure↔activity Granger coupling becomes bidirectional at maturity)
appear in the MFE 9-mode saddle? `scripts/mfe_gosme_symmetrization.jl`.
- Operationalization: structure = streak a₂ / roll a₃; activity = fluctuation energy
  Σ₄..₉ aᵢ² (disjoint — avoids the q_pert⊃a₃² confound the queue note missed);
  maturity ↦ Re (250→400); directional Granger (Geweke); symmetrization index SI.
- Sanity passed (white noise ⇒ G≈0). **Result: NO robust maturity-symmetrization
  signature.** Roll a₃ is activity-DRIVEN at every Re (G(A→S)≫G(S→A), SI low); streak
  a₂ is bidirectional at low–mid Re (SI≈0.997 @Re300) but DE-symmetrizes by Re=400;
  the proxies disagree on the trend; high-Re coupling near the noise floor. **The Gosme
  signature is NOT reproduced** — honest negative, consistent with NS-024's broad/generic.
- **Confirmation-bias guard:** caught and corrected an initial cherry-picked "present"
  verdict (lenient slope-test on one proxy) → the honest mixed/negative reading.
- Recorded under NS-025 (queued experiment DONE) + registry; no new entry (a negative
  phenomenology probe). Scope: ODE-truncation. **`:proved`=0; distance to prize UNTOUCHED.**

## v0.1.11 — 2026-06-01 — Slice 5: Arnold curvature of SDiff(T²) (extends NS-033)

The ∞-dim sibling of Slice 4 — `scripts/manifold_5_sdiff_curvature.jl`. Arnold
(1966): 2D ideal flow = geodesics on the area-preserving diffeo group SDiff(T²),
L² metric; its sectional curvature is mostly negative (the geometric root of
weather unpredictability). Algebra built exactly: velocity modes v_k=ik^⊥e^{ik·x},
bracket [v_k,v_l]=−(k×l)v_{k+l} (derived), energy metric ⟨v_k,v_k⟩∝|k|², coadjoint
B(v_k,v_l)=(k×l)(|k|²/|k−l|²)v_{k−l}, connection ∇=½([,]−B−B); curvature on the
closed finite set {a·k+b·l: a,b∈−3..3}.
- **Verified:** k∥l (k×l=0) ⇒ C=0 (flat, commuting flows) exactly; C symmetric.
- **Sign census** (2256 sections, k,l∈[−3,3]², DATA not asserted): **84% NEGATIVE
  (Arnold)** / **9% POSITIVE (Misiołek, e.g. C((2,2),(2,1))=+0.35)** / 6% flat.
  Both classical results reproduced. (My first 9-pair sample hit all-negative —
  corrected by the full census showing genuine positive sections exist.)
- **Predictability:** negative κ ⇒ error δ(t)≈δ₀e^{t/τ}, 1/τ=|v|√(−κ) (Jacobi);
  Arnold's atmosphere figures ⇒ ~10⁵ amplification over 2 months = "5 more digits
  for a 2-month forecast" ⇒ ~2-week horizon. Our curvature matches the sign/structure;
  absolute rate is normalization-dependent (flagged).
- Folded into NS-033 (now 5 slices; scope "2D ideal flow / finite truncations").
  Registry + companion updated. **`:proved`=0; distance to prize UNTOUCHED** (2D Euler
  geometry, not the 3D PDE). Slices 1+4+5 = one Lie-group object (orbit / finite curv /
  ∞-dim curv).

## v0.1.10 — 2026-06-01 — Slice 3 made rigorous: the scaling-exponent calculus (NS-034)

Upgraded the manifold study's most load-bearing finding ("supercriticality = the
non-compact scaling quotient") from a torus demonstration to an **exact calculus**
(`scripts/manifold_3b_criticality.jl`).
- **Exact exponents** (change of variables on ℝ³): σ(L^q)=1−3/q, σ(Ḣ^s)=s−½,
  σ(L^p_tL^q_x)=1−3/q−2/p. CRITICAL (σ=0, scale-invariant, descends to the dilation
  quotient) = {L³, Ḣ^{1/2}, BMO⁻¹, **Prodi–Serrin 2/p+3/q=1**}; SUPERCRITICAL (σ<0)
  = energy (σ=−1) and dissipation (σ=−1), the a-priori-controlled quantities.
- **Verified** continuous-λ: σ(Ḣ^s)=s−½ to quadrature precision (s=0 decays λ^{−½};
  s=½ flat ≡1 = critical; s=1 grows); PS borderline ⟺ σ=0 exactly.
- **Supercriticality as a precise descent failure:** controlled norms σ<0 (a Leray
  bound is vacuous as λ→∞), regularity-deciding norms σ=0 (uncontrolled), no overlap
  = the wall. **Unifies NS-002 (supercriticality) ↔ NS-005 (critical-norm criterion).**
- Added **NS-034** (Class ANALYSIS, evidence algebraic+computed, **:argued** — the
  analytic exponents are exact but the entry FRAMES the obstruction, standard
  criticality theory re-derived + verified; NOT a regularity proof). NS-002 evidence
  strengthened to cite it. Companion Slice-3 §2 extended. Counts → 24 entries.
  **`:proved`=0; distance to prize UNTOUCHED** (a framing of the wall, not a breach of it).

## v0.1.9 — 2026-06-01 — Step-2 gated null (NS-032) + the state-space manifold study (NS-033)

**NS-032 — Stage 1c-3D Step 2, the gated blowup hunt → NULL.**
`scripts/spectral_3d_blowup_candidate.jl`. Inviscid Taylor–Green (Brachet, the
canonical Euler near-singularity probe), N=32 & 64, three gates (G1 resolved,
G2 N-converged, G3 BKM co-moving). δ narrows 2.10→0.37 but **G2 fails** (~50%
δ-disagreement across N — the Step-1 δ-fit fragility) and **G3 fails** (δ bottoms
0.37, BKM finite). **INCONCLUSIVE — the gates correctly flag a resolution-limited
cascade, no false-positive blowup.** Decline decelerates (weakly consistent with,
not evidence for, no-finite-time-singularity). `:tested` null, Scope inviscid-3D.

**NS-033 — the NS state-space manifold study (4 exact slices).** CFS-style
geometric reconnaissance (no resolution wall) — `scripts/manifold_{1,2,3,4}_*.jl`
+ `docs/manifold_study_companion.md`:
- **Slice 1 coadjoint orbit (exact):** triad = Euler rigid body; Casimir=energy
  sphere, helicity polhodes, middle-leg saddle (cascade donor), separatrix,
  invariants ~1e-13.
- **Slice 2 edge manifold (MFE):** laminar|turbulent boundary, log critical
  slowing σ≈0.19, shear+streak edge state. **CORRECTION: the edge-manifold normal
  is multi-mode and the roll a3 is ~TANGENT — "a3=gate" refuted; the NS-023
  committor-gate is a distinct conditional notion (two notions, not one).**
- **Slice 3 invariant/scaling quotient:** rotation-invariant (1e-15); scaling
  field-exponents (λ²,λ³,λ⁴,λ⁶) exact. **CORRECTION: physical exponents need the
  λ⁻³ domain rescaling — E~λ⁻¹ supercritical, H~λ⁰ invariant; supercriticality is
  a measure/scale fact, not amplitude. H, E·Ω descend to the critical quotient.**
- **Slice 4 Arnold curvature:** Koszul sectional curvature **verified κ≡¼ on
  bi-invariant SO(3)**; anisotropic rigid body has a negative plane (κ(2,3)=−0.91);
  Lyapunov λ>0 (MFE saddle) vs ≈0 (integrable triad) = Arnold unpredictability.
- The study **re-derives the firewall's thesis geometrically**: supercriticality =
  the non-compact scaling direction of the invariant quotient; the cascade donor =
  a coadjoint saddle + a negatively-curved plane. `:tested`, Scope geometry.
- Two honest corrections recorded mid-build (Slices 2, 3), not buried.
- Counts → 23 entries; `:proved` = 0. **Distance to prize: UNTOUCHED.**

## v0.1.8 — 2026-06-01 — NS-010 Stage 1c-3D Step 1: the 3D regularity control

First 3D move — deliberately the known-regular CONTROL, not a blowup hunt.
`scripts/spectral_3d_control.jl` (+ companion `docs/ns010_stage1c_3d_companion.md`):
3D pseudospectral solver, rotational form `∂_t û = P[(u×ω)^] − νk²û` (Leray
projection, vortex stretching LIVE), hand-rolled radix-2 3D FFT (no FFTW), RK4,
2/3 dealias. N=1 smoke gate (`SMOKE=1`) passed before the full sweep.
- **(A) Solver VALIDATED** — 3D Euler on a seeded helical IC conserves ENERGY and
  **HELICITY** to 0.0000%, div_max≈1e-12 (T-07). Helicity is the 3D-specific Tier-1
  check 2D could not provide (vortex stretching is live; enstrophy grows ~8.6×).
- **(C) Regularity control PASS** — viscous Taylor–Green (ν=0.02, N=64): δ bounded
  (min 0.605, never→0), BKM ∫‖ω‖∞ finite (≈14.2), energy monotonically decays,
  enstrophy peaks-then-decays. Clean exponential tail (well-resolved). T-06 (BKM
  co-movement) affirmed in the regular direction.
- **(B) HONEST CORRECTION** — the exponential-strip δ-FIT does NOT cleanly converge
  across N∈{16,32,64} on the inviscid developing-cascade run (~50% non-monotonic
  spread); the fit band k=2..N/3 is window-sensitive once a power-law range forms.
  Energy is conserved at every N (the SOLVER is robust; the δ-slope-FIT is the
  fragile piece). An earlier draft script line claimed clean convergence — corrected
  in the script + companion, not buried. Panel A's δ-decline is the expected inviscid
  cascade (strip narrowing as enstrophy grows), NOT a regularity claim.
- **Consequence:** Step 2 (blowup-candidate IC) is GATED on BKM co-movement (T-06)
  + true *spectral* N-convergence, NOT the δ-slope-fit alone — the fit is fragile
  exactly in the inviscid/under-resolved regime a blowup hunt lives in. Build the
  Step-2 IC on the mechanism axis {NS-002,004,009} (band-finding #1).
- Spec: NS-010/011 Scope note extended to "1D+2D+3D(viscous-control)" with the
  δ-fit caveat documented (status stays :tested). TEST_SPEC: T-06 (BKM gate,
  defined/affirmed-regular) + T-07 (3D solver E+H validation, PASS). Registry +
  dashboard updated. **Distance to prize: UNTOUCHED; Scope: 3D-truncation, not the PDE.**

## v0.1.7 — 2026-06-01 — TCE self-map: triadic coordination structure of the program (NS-031)

Pre-3D structural reconnaissance. Ran TCE's `Discovery.Triadic` engine (via
`SpecBridge`, test-suite `triadic-coordination-runonspec`) on the NS obstruction
ledger encoded as a 20-node corpus (`discovery/ns_obstruction_corpus.json`): `deps`
= genuine logical premises from SPEC prose, `layer` = program depth, `logic` tier
carrying the Scope firewall (`classical` PDE-analysis / `other:closure` model arc /
`bridge` = NS-024,NS-030 only). `status: proved_conditional` is the engine's
anchor-eligibility flag, **decoupled from the PDE-proof firewall** (`:proved` still 0).
- **64 triads → 10 independent units** (edge-disjoint dedup). Keystone obstruction
  triad **{NS-002,003,004} @1.0** (supercriticality+energy+BKM); pure-scaling
  {NS-002,007,009} @1.0; closure-arc {NS-023,024,025} @1.0; Leray-energy cluster
  {NS-005,006,008} @0.78; **live complex-plane attack triad {NS-011,012,013} @0.70**;
  PDE bridge **{NS-003,004,010} @0.83** (walls → validated diagnostic).
- **Firewall reproduced, not assumed:** a scan of all 64 triads finds **zero**
  mixing the PDE-analysis tier with the closure tier; the bridge NS-024 has one
  pairwise cross-tier edge (→NS-009) that never closes a triangle — an independent
  engine-side reproduction of NS-024's witnessed "broad/generic, no PDE purchase."
- NS-001 (root) and NS-021 (MFE) appear in no triad (universal-premise / most-isolated);
  {NS-010,011,012} is subsumed by NS-013 (collapse filter).
- Added **NS-031** (Class PROGRAM, `computed`, **:tested**, **Scope: methodology —
  NOT PDE**), registry row, companion `docs/ns_triad_discovery_companion.md`,
  reproducible log `discovery/ns_triad_discovery.out.txt`. Counts → 21 entries;
  `:proved` = 0. **Sets the 3D attack geometry** (NS-002 wall — NS-004/010 — NS-011).
- **Band stratification folded in** (companion §2 + run-log View D): HIGH =
  foundational redundancy; **MID = "cross-framing invariance" is where the
  actionable couplings sit** — two NEW readings beyond the dedup-10: the
  *mechanism* axis **{NS-002,004,009}** (how it blows up: scaling×stretching×
  anomalous-dissipation) and the *dead-ends* triple **{NS-007,008,020}** (the
  fenced-off method classes, incl. our own falsified homology); LOW = structural
  echo (keystone shadows, no new PDE nugget). 8 band-finding follow-ups added to
  `dashboard.md`. Threshold caveat: 0.85/0.70/0.55 are closure-v5 defaults, not
  recalibrated for 20 nodes (relative-only).
- Housekeeping: TCE de-dup DONE (turbulence scripts pruned from TCE @`8fcf1b4`);
  navier-stokes is their sole home. **Distance to prize: UNTOUCHED.**

## v0.1.6 — 2026-06-01 — Consolidation: validated-diagnostic milestone + internal audit

Pre-3D consolidation checkpoint (`docs/validation_milestone.md`).
- **Internal cross-audit PASS** (TCE-style): A1 spec↔registry ID parity (20 IDs),
  A3 every referenced artifact exists (+ every `.jl` has its `.out.txt`), A4 firewall
  intact (**zero** `:proved` status; only reserved-language mentions).
- **Validation ladder consolidated:** the NS-010/011 diagnostic is two-sided —
  correctly reports blowup (1a Burgers exact δ; 1b CLM exact δ + BKM co-movement)
  AND regularity (1c 2D: δ bounded, invariants conserved <1e-6) against ground truth.
  Hermetic radix-2 FFT (1D+2D), self-checked. Tool chain trusted before 3D.
- Dashboard milestone recorded; distance-to-prize UNTOUCHED.
- Open (decisions, not done here): push/remote; prune the migrated turbulence scripts
  from TCE; and "run the TCE" prep step before the 3D escalation.

## v0.1.5 — 2026-06-01 — NS-010 Stage 1c (2D): the regularity control

`scripts/spectral_2d_control.jl` (+ companion). 2D pseudospectral NS/Euler
(vorticity form; hand-rolled FFT extended to 2D, roundtrip exact). 2D is *known*
globally regular ⇒ the diagnostic must report regularity — and it does:
- **Solver validated** by the Tier-1 invariants: 2D Euler conserves energy,
  enstrophy, ‖ω‖∞ to <1e-6 (the exact-invariant ground truth in lieu of a closed
  form). FFT 2D self-check exact.
- **Control PASS (T-05):** δ(t) decreases via filamentation but stays **bounded
  (≥0.23, never→0)**; ‖ω‖∞ conserved ⇒ BKM ∫‖ω‖∞ **finite** ⇒ no blowup. NS (ν>0):
  energy & enstrophy monotonically decay, δ bounded. The diagnostic **distinguishes
  regularity from blowup** (vs CLM Stage 1b, δ→0) — the prerequisite for 3D.
- **physical_invariants.md made concrete:** enstrophy & ‖ω‖∞ are Tier-1 coercive in
  2D (no vortex stretching) ⇒ BKM finite ⇒ regular. The 2D side of the 2D/3D gap.
- **Honesty:** corrected a text claim ("N=256 conserves enstrophy better") that the
  data didn't support (both N conserve exactly; cascade not yet at the cutoff).
- **Firewall:** 2D truncation, not the PDE. NEXT = 3D (open regime, no benchmark).

## v0.1.4 — 2026-06-01 — NS-010 Stage 1b: spectral solver + BKM co-movement (CLM)

`scripts/spectral_clm_blowup.jl` (+ companion). Apply the validated δ(t) diagnostic
to a *real pseudospectral solver* of the Constantin–Lax–Majda model `ω_t=ωH(ω)` —
the 1D vortex-stretching (NS-004) analog that genuinely blows up.
- Hand-rolled radix-2 FFT (no FFTW dependency), self-checked vs manual DFT (5e-13).
- Derived exact CLM strip `δ(t)=ln(2/t)` (complex singularity `x*=π/2+i ln(2/t)`),
  blowup `t*=2`, simple pole. δ_fit reproduces it exactly.
- **T-04 PASS (BKM half):** δ→0 co-diverges with ∫‖ω‖∞→∞ at the same t*=2.
- **T-03 PASS (with honest correction):** solver+δ N-robust to <0.1% for
  N∈{512,1024,2048} through t=1.98. I predicted a small-N breakdown there; there is
  none — the spectrum-slope fit is robust to cutoff under-resolution. Recorded as a
  correction, not buried.
- NS-010/011 stay `:tested` (now exercised on a 2nd exact benchmark + a real
  time-stepper); NS-004 corroborated computationally.
- **Firewall:** validates the tool chain on the vortex-stretching nonlinearity in a
  1D model. Does NOT touch 3D-NS regularity. NEXT = Stage 1c (2D→3D, no benchmark).

## v0.1.3 — 2026-06-01 — NS-010 Stage 1a: analyticity-strip diagnostic VALIDATED

`scripts/burgers_analyticity_strip.jl` (+ companion `docs/ns010_analyticity_strip_companion.md`).
First `Scope: PDE-method` work. The complex-singularity / analyticity-strip blowup
diagnostic (NS-010/011) is validated against an EXACT 1D closed form:
- Derived the exact inviscid-Burgers strip width `δ(t)=arccosh(1/t)−√(1−t²)` (from
  the complex-characteristic singularity `cos ξ*=1/t`, `ξ*=i·arccosh(1/t)`), shock
  at `t*=1`, `δ~(t*−t)^{3/2}`.
- **Spectrum-fitted δ(t) matches it to ≤4.1%** (t=0.3–0.95; cube-root `k^{-4/3}`
  prefactor removed); **3/2-law exponent = 1.519** (theory 1.5). **T-01 PASS, T-02
  PASS (inviscid).**
- Viscous control (Cole–Hopf, ν=0.1): δ bounded (~0.4) for all t incl. past t*=1,
  vs inviscid δ→0 — viscosity holds the complex singularity off the real axis.
- NS-010/011 promoted `:argued → :tested` (Scope: PDE-method, validated in 1D-model).
- **Firewall intact:** validates the *tool*; the 3D-NS question (does δ→0 there) is
  untouched — Stage 1b (spectral truncation) + ultimately the open problem. T-03
  (full N-sweep) PARTIAL; T-04 (BKM/critical-norm co-movement) PENDING for 1b.

## v0.1.2 — 2026-05-31 — Log external related work (Gosme)

Added **NS-025 (Class RELATED)**: Gosme, *Causal symmetrization as an empirical
signature of operational autonomy in complex systems*, arXiv:2512.09352 (Dec 2025)
— verified real (paper fetched; Aaron's cited title was a close paraphrase). An
external empirical operationalization of the closure-to-efficient-causation /
(M,R) framework on 50 software ecosystems: order parameter Γ (bimodal phase
transition), "causal symmetrization" (Granger structure↔activity coupling 0.71→0.94
at maturity), "structural zombies." **Scope: software-ecosystems / phenomenology —
NOT NS-PDE; cannot bear on the prize.** Bears on NS-023/024 (closure-theory side).
Added Class `RELATED` to `CLAUDE.md`; registry row; flagged the symmetrization-vs-
(M,R)-symmetry comparison as caution-not-claim. Queued a phenomenology experiment:
test whether the symmetrization signature appears in the MFE saddle (Granger
structure=roll a₃ vs activity=perturbation energy), Scope: ODE-truncation.

## v0.1.1 — 2026-05-31 — Physical invariants reference

Added `physical_invariants.md` — the tiered invariant constraint set for NS, in
the lineage of the closure-v5 `physical_invariants.md` and the possibilistic-
inversion `geophysical_invariants.md`. Tier 1 (frame-independent / hard:
incompressibility, energy inequality, momentum, scaling symmetry→supercriticality,
Galilean/rotation symmetries, helicity & circulation [Euler-exact / NS-decaying],
enstrophy [2D-coercive / 3D-battleground], BKM); Tier 2 (frame-dependent
phenomenology: K41 −5/3, increment 1/3, anomalous dissipation, intermittency, Re
thresholds, blowup scenarios — soft only, anchoring anti-pattern if hard); Tier 3
(established theorems = the fixed end). **Load-bearing reading recorded: the 2D/3D
regularity gap IS an invariant-tier story — enstrophy is Tier-1 coercive in 2D, the
battleground in 3D, leaving only the supercritical energy as Tier-1 control.** The
tier-confusion anti-pattern is the Scope firewall in invariant terms. Wired into
`CLAUDE.md` ground-truth hierarchy and cross-referenced to `SPEC.md` NS-IDs.

## v0.1.0 — 2026-05-31 — Repository established

**Founding commit.** Set up the obstruction-program scaffold for the 3D
incompressible Navier–Stokes global-regularity (Clay) problem, in the TCE
ground-truth-hierarchy style, adapted for a mathematics obstruction program.

- **Business files:** `CLAUDE.md` (constitution + the Scope firewall),
  `SPEC.md` (the obstruction ledger, 18 entries), `DESIGN.md` (strategy +
  the complex-plane live attack + cross-project framing), `dashboard.md`,
  `artifact_registry.md`, `TEST_SPEC.md`.
- **Spec populated from what we know:** problem statement (NS-001);
  obstructions NS-002..009 (supercriticality, Leray energy-only control, BKM,
  Prodi–Serrin–ESS, CKN partial regularity, no-self-similar-blowup, Tao
  averaged-blowup no-go, Onsager 1/3); diagnostics NS-010/011 (analyticity
  strip, complex-singularity tracking); live NS-012/013 (Li–Sinai complex-data
  blowup; real⇐complex open).
- **Prior arc migrated** (copied from TCE; TCE copies remain @79e5e35):
  15 scripts + 2 witness docs. Recorded honestly as NS-020 (homology
  reformulation **:falsified**), NS-021 (MFE saddle phenomenology, Scope:
  ODE-truncation), NS-022 (helical triad, Scope: model), NS-023 (autopoietic
  closure / (M,R) rotation-covariant gate, Scope: abstract closure — a separate
  domain), NS-024 (closure↔turbulence convergence, witness-trimmed to
  broad/generic, Scope: analogy).
- **Honest baseline recorded:** zero progress on the prize; `:proved` count = 0
  by design; distance-to-prize = UNTOUCHED.

**Next:** the complex-plane diagnostic (NS-010/011) — Burgers exact poles, then a
spectral truncation watching the analyticity-strip width δ(t). First in-repo
direction with `Scope: PDE-method`; still a diagnostic in models, not a proof.
