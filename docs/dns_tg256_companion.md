# Companion — resolved N=256 Taylor–Green DNS (Re=1600): the gated verdicts, resolved

**2026-06-02.** The first run to use the real ~6-hour compute budget (prior runs were
~10 min at N=64–128). A **resolved** viscous Taylor–Green DNS at **N=256, Re=1600** — the
canonical Brachet-1983 benchmark — turning the resolution-GATED diagnostics (`S_ω` bounded
vs growing; production-set dimension; `δ` convergence) into **resolved** verdicts on a flow
validated against the literature. Scope: 3D pseudospectral DNS truncation (resolved). NOT
the PDE; `:proved`=0.

## §1 — Computational basis

- **Source (new):** `scripts/dns_tg256.jl` (+ `.out.txt`; N=64 smoke `dns_tg256_N64.out.txt`).
  Threaded radix-2 FFT (6 threads), reuses `spectral_3d_control.jl`. Std-lib Julia.
- **Run:** viscous TG, `N=256`, `ν=1/1600`, `dt=0.005`, `T=10`, sample every 0.5. Wall-clock
  ~3.8 h (6.7 s/step × 2000 steps + diagnostics). Solver pre-validated at N=256 (E/H
  conserved to 1e-6 on a 10-step inviscid check); pipeline pre-smoked at N=64.
- **Diagnostics per sample:** E, H, Z, ‖ω‖∞, `δ(t)` (analyticity strip), `S_ω=⟨ω·(ω·∇)u⟩/⟨|ω|²⟩^{3/2}`
  (vortex-stretching production skewness), `D_box` (box-counting dim of the top-50%-production set).

## §2 — Results

**Validation (Brachet 1983).** Enstrophy peaks at **t=9.0** (`Z/Z₀=27.4`), then decays —
the canonical TG Re=1600 dissipation-peak time. Energy decays monotonically (1.0→0.596);
helicity ~1e-18 throughout (TG symmetry exact). The hand-rolled hermetic solver reproduces
the published DNS benchmark at N=256.

| t | E/E₀ | Z/Z₀ | ‖ω‖∞ | δ | S_ω | D_box |
|---|---|---|---|---|---|---|
| 0.0 | 1.000 | 1.0 | 2.0 | 3.54 | 0.00 | 2.43 |
| 4.0 | 0.972 | 4.4 | 13.8 | 0.108 | **0.276** | **1.82** |
| 4.5 | 0.962 | 6.5 | 24.3 | 0.096 | **0.290** | 1.83 |
| 9.0 | 0.690 | **27.4** | 66.9 | **0.077** | 0.213 | 1.96 |
| 10.0 | 0.596 | 24.5 | 73.1 | 0.079 | 0.198 | 2.02 |

**Resolved verdicts:**
1. **`S_ω` BOUNDED** — transient peak 0.29 at t≈4 (steepening), then settles to ~0.2 through
   the enstrophy peak and decay. Does *not* grow. The "bounded vs growing" gate, resolved at
   N=256: **bounded ≈ 0.2.** No blowup signature (expected at Re=1600).
2. **`δ(t)` bounded** — min 0.077 at the enstrophy peak, never → 0, well-resolved
   (`δ·k_cut ≈ 6.5 ≫ 1`). The diagnostic correctly reports regularity on a resolved flow
   (NS-010 viscous control, confirmed at 256).
3. **`D_box` DYNAMIC** — dips to **1.82 (top-50%) at t≈4** (when `S_ω` peaks and ‖ω‖∞ jumps
   to ~14), recovers to ~2.0. At N=256 the production set is a ~1.8–2.0-dim object that
   *transiently localizes* under stretching (the earlier N≤128 "static D≈2.3" was
   under-resolved).
   > **WITNESS-TRIM (2026-06-02, `triad_verdict_dns_localization.md`).** Both triad seats
   > (Gemini synthesis, Grok adversarial) independently trimmed the original wording here —
   > "*localizes toward the CKN ≤1 filament limit*." `D` is **threshold-dependent**
   > (`D30/D50/D70 = 1.54/1.74/1.92` — confirmed) and floors **above 1**; the honest reading
   > is *a threshold-dependent ~1.5–1.9-dim tube/sheet object that does **not** approach ≤1*
   > (geometric, à la Hou–Li depletion), **not** an approach to the singular set. The CKN ≤1
   > bound is a theorem the resolved dynamics do not approach. Fact 3 is provisional until
   > threshold-robustness + IC-independence (the queued vortex-tube run) confirm it.

## §3 — Verification

**Type — computed (resolved DNS).**
- *Validation:* the enstrophy peak at t=9.0 matches the canonical Brachet-1983 Re=1600 TG
  dissipation-peak time (peak *time* is the robust benchmark; magnitude is
  normalization-dependent and not over-claimed). Energy monotone-decaying, H≈0 — solver correct.
- *Resolution:* `δ·k_cut ≈ 6.5` at the enstrophy peak ⇒ the analyticity strip is wider than
  the grid scale ⇒ the flow is resolved (unlike the inviscid N≤128 under-resolved runs).
- *S_ω:* bounded ~0.2 across the developed regime; computed from the full velocity-gradient
  tensor (15 transforms/sample).
- *D_box:* 5-scale box-count (scales 2..32 → boxes 128³..8³), ±~0.15 fit uncertainty; the
  2.0→1.82 dip is a real but modest localization signature, not a sharp collapse.

**Honest scope.** Re=1600 TG is a *regular* flow — these verdicts confirm regularity at
resolved scale; they are not a blowup test. The value is methodological: the previously
resolution-gated diagnostics now have *trustworthy* (resolved, literature-validated) values,
and the dynamic `D`-localization to ~1.8 at peak stretching is a new, resolved observation
tying to NS-037 (the attractor toward the CKN wall — here, time-resolved).

## §4 — Spec impact

Proposes **NS-038 — "Resolved N=256 DNS verdicts (the boundary-exploration program)"**
(candidate; DEFERRED — recommend formalizing after the boundary queue A→B→C runs so NS-038
covers the resolved-DNS program as a whole). It would: strengthen **NS-010** (`δ` bounded +
resolved at N=256), and refine **NS-037** (`S_ω` bounded ≈0.2 resolved; the static D≈2.3
replaced by a dynamic dip to ~1.8 at peak stretching — the production set localizes toward
but does not reach the CKN ≤1). Evidence: computed (resolved DNS, literature-validated);
Status `:tested`; Scope: resolved 3D DNS truncation; `:proved`=0.

*Firewall: resolved 3D pseudospectral DNS truncation; NOT the PDE; the prize untouched.
`:proved`=0. Metabolized by Claude, 2026-06-02.*

---

## Addendum — B (helicity boundary, H≠0): the verdicts are IC-robust; helicity not cleanly isolated

**2026-06-02.** Boundary B of the queue: the same resolved N=256 DNS (Re=1600, energy-matched
E≈0.125), but a low-k random **helical** IC (H≠0) instead of Taylor–Green (H=0). `scripts/dns_tg256_helical.out.txt`.

**Result (helical vs TG):**

| quantity | TG (A) | helical (B) |
|---|---|---|
| enstrophy peak | 27.4× at t=9.0 | **8.7× at t=6.0** (earlier, lower) |
| S_ω (developed) | bounded ≈0.20 | bounded ≈**0.147** |
| δ (min) | 0.077, resolved | 0.081, resolved |
| D₅₀ dip | 1.82 | **2.07** (less localized) |
| E/E₀ at t=10 | 0.596 | 0.239 (faster decay) |

- **Same qualitative verdicts (regular):** S_ω bounded, δ bounded-away-from-0 (resolved,
  δ·k_cut≈6.9), D dips-then-recovers, energy monotone-decaying. ⇒ the resolved verdicts are
  **not TG-specific** — they survive a different (random, helical) IC. A real IC-robustness check.
- **Quantitative differences are CONFOUNDED, not cleanly attributable to helicity:** helical
  peaks earlier+lower, S_ω lower, D less localized — all *suggestive* of helicity reducing
  localized stretching (consistent with helicity partially blocking the cascade). **But** (i)
  the IC is only **~1% relatively helical** (`ρ_H ≈ H/(2√(EΩ)) ≈ 0.011` — the random IC gives
  weak net helicity), and (ii) it is low-k-random vs TG's smooth structure. So the differences
  mix a weak helicity effect with an IC-spectral-content effect.
- **Honest verdict:** B confirms the resolved verdicts are IC-robust; it does **not** cleanly
  isolate the helicity dependence. **A clean helicity test needs a strongly-helical IC**
  (ABC / Beltrami flow, `ρ_H ≈ ±1`, where `ω = ±λu`) — a noted refinement (a future boundary run).
- B ran on the *pre-enhancement* pipeline (single D₅₀, no alignment/threshold-robust D); the
  vortex-tube run (C) carries the full diagnostics.

*Firewall unchanged: resolved DNS truncation; not the PDE; `:proved`=0.*

---

## Addendum — C (vortex-tube / Kerr boundary): a resolved reconnection event, regular but near-filamentary

**2026-06-02.** Boundary C, the adjudicator: anti-parallel vortex tubes (opposite circulation,
sinusoidal centerline wiggle), N=256, Re=1600, energy-matched, with the enhanced diagnostics
(threshold-robust D30/50/70 + strain–vorticity alignment). `scripts/dns_tg256_tubes.out.txt`.

**The reconnection event (t≈5.5–6.0):** the tubes collide and reconnect —

| t | ‖ω‖∞ | S_ω | δ | D30 | D50 | D70 | c²_int |
|---|---|---|---|---|---|---|---|
| 5.0 | 25.7 | 0.098 | 0.109 | 1.72 | 1.88 | 2.06 | 0.665 |
| **5.5** | **84.4** | **0.229** | 0.105 | **0.986** | 1.66 | 1.86 | 0.658 |
| **6.0** | **96.7** | **0.241** | **0.088** | 1.59 | 1.75 | 1.78 | 0.637 |
| 6.5 | 77.3 | 0.172 | 0.088 | 1.45 | 1.82 | 1.87 | 0.617 |
| 10.0 | 26.6 | 0.118 | 0.104 | 1.67 | 1.80 | 2.00 | 0.605 |

- `‖ω‖∞` spikes **~4×** (26→97), `S_ω` more than doubles (0.10→0.24), `δ` dips to its minimum
  (0.088) — a genuine, sharp vortex-reconnection event, the sharpest of the three boundaries.
- **`D30` momentarily reads ≈0.99 at t=5.5** — the most-intense-production core transiently
  reaches the **CKN ≤1 filament edge**, the closest approach across all runs. Then it recovers.

**Adjudication (the triad's question, answered honestly):**
- **Flow stays REGULAR** — `δ` bounded (min 0.088, never→0) and **resolved** (`δ·k_cut≈7.5`).
  No loss of analyticity. The alignment stays **bounded/stable** through the event
  (`c²_int≈0.64–0.67`, no runaway) — by Grok's persistence criterion, *regular*; by Gemini's
  reading, geometric depletion keeping it regular. **Both seats vindicated on regularity.**
- **"D floors above 1" — refined.** The *bulk* set does (D50≈1.7, D70≈1.9 even at the spike),
  but at a real **reconnection** the most-intense 30% (D30) *transiently* touches the CKN ≤1
  edge — sharper than either seat predicted. The one regime where the resolved dynamics meets
  the singular-set dimension, exactly where the multifractal/CKN picture says it should.

**CONFIRMATION-BIAS FLAG (load-bearing — this is NOT a near-blowup):**
- `D30≤1` is the **noisiest** signal we have: top-30% threshold (most sensitive), 5-scale
  box-count (±0.15), a **single sample**, and it **recovers in one Δt**. The robust measures
  (`D50`, `D70`) stay >1.5 *at the spike*. So "≤1" is the extreme tail, transient — **not** a
  forming singular set.
- `δ` never approaches 0; the flow is analytic throughout. Re=1600 is regular.
- The `‖ω‖∞≈97` peak is at the **edge of N=256 resolution** (marginally resolved); a true ≤1D
  verdict *at the reconnection* needs **N≥512** (GPU/Metal territory). This is precisely the
  event where higher resolution would matter.
- Sanity: enstrophy peaks at only **1.8×** (vs TG 27×, helical 8.7×); energy barely decays
  (0.86 at t=10). A *localized reconnection*, not a developed cascade.

**Net:** a resolved, near-filamentary vortex reconnection in a globally regular flow — the
sharpest localization of the boundary queue, transiently touching the CKN ≤1 edge in the
extreme tail, with regularity intact. Confirms the triad; flags N≥512 as the resolution
frontier exactly at reconnection.

*Firewall unchanged: resolved DNS truncation; not the PDE; `:proved`=0; prize untouched.*
