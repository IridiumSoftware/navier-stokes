# NS-002/013 — The phase-blindness face of supercriticality (companion)

**Date:** 2026-06-07. **Scope: resolved-ish 3D pseudospectral DNS truncation (Re=1600). NOT the PDE.**
`:proved`=0; distance UNTOUCHED. A within-truncation witness synthesizing three recent probes; a phase
surrogate diagnoses *where* each norm's content sits (phase vs amplitude), not an analytic step.

## §1 — Computational basis

- **Script:** `scripts/ns013_phase_norm_split.jl` (reuses the validated `phase_scramble` surrogate from
  `ns013_phase_production_3d.jl` + the dyadic Littlewood–Paley machinery from `ns046_besov_smallness_probe.jl`,
  on the `dns_tg256` solver chain). Output `scripts/ns013_phase_norm_split.out.txt`.
- **Idea.** Under the random-phase surrogate (`|û(k)|` fixed ⇒ `E,Z,H` exactly preserved; `α:0→1` scales
  the phase scramble), measure which norms are phase-BLIND vs phase-SENSITIVE, to give the central
  obstruction NS-002 (controlled σ<0 vs deciding σ=0) a phase-space reading. Develops TG (`H=0`) and a
  random helical field (`H≠0`) to `t=4` (N=64), sweeps `α` over 5 seeds.

## §2 — Results

| quantity | TG α=1 | Helical α=1 | class |
|---|---|---|---|
| `Z/Z0` (enstrophy) | 1.0000 | 1.0000 | **phase-BLIND** (exact) |
| `|dH|` (helicity) | ~1e-17 | ~1e-17 | **phase-BLIND** (exact) |
| `P=∫ω·Sω` (production) | 1.0 → **0.033** | 1.0 → **0.007** | **phase-SENSITIVE** (robust, both flows) |
| `S_ω` (skewness) | 0.22 → 0.007 | 0.014 → 0.0001 | **phase-SENSITIVE** (robust) |
| `‖ω‖∞` (BKM) | 1.0 → 0.44 | 1.0 → 1.03 | phase-sensitive **only for the coherent flow** |
| `‖ω‖_{Ḃ⁰_{∞,1}}` | 1.0 → 0.74 | 1.0 → 0.90 | weakly/flow-dependently sensitive |

**Robust split.** The a-priori-coercive `L²` invariants `E,Z,H` (Leray's controlled quantities, NS-003)
are **exactly phase-blind** (depend only on `|û(k)|`, by Parseval). The **production `∫ω·Sω`** — the
nonlinear term that breaks the σ=+1 enstrophy rung and decides regularity — is **strongly phase-sensitive**
(collapses 97–99% in *both* flows while `E,Z,H` are pinned to ~1e-16). So the *controlled* quantities are
blind to the phase coherence that *carries the production*: a concrete phase-space face of supercriticality
(NS-002 / NS-034 — controlled σ<0 vs deciding σ=0, no overlap).

**Honest nuance (a near-over-reach, declined).** The BKM/critical-Besov norms `‖ω‖∞`, `‖ω‖_{Ḃ⁰_{∞,1}}` are
phase-sensitive **only for the coherent flow** (TG `‖ω‖∞`→0.44) and **flat/weak for the random-helical
field** (`‖ω‖∞`~1.03, Besov −10%) — because the random-helical IC starts phase-incoherent, so its peaks
are already near their scrambled value. The `‖ω‖∞`/Besov sensitivity is an **intermittency (coherence)
effect, flow-dependent**, NOT a universal collapse. Claiming "the critical-Besov norm collapses under
scramble" would have been an over-reach (caught here); the clean, robust claim is **production-vs-controlled**,
not Besov-vs-controlled. (The intermittency dependence is itself informative: the phase-sensitivity of the
deciding `L^∞`/Besov norm scales with how coherent/intermittent the field is — and a real blowup would be
an extreme-intermittency event.)

## §3 — Verification

- *Computed.* DNS truncation on the validated chain. N=1 gate: `Z,H` preserved to ~1e-16 (surrogate
  correctness), production responds.
- *Control built in.* `E,Z,H` are preserved **exactly** at every `α` (`|dZ|/Z,|dH|~1e-16`), so the
  production collapse cannot be an energy/enstrophy/helicity artifact — it isolates phase coherence as the
  carrier. Two flows + a coherence sweep + seed averaging.

## §4 — Spec impact

**No new S-ID; no status change.** Within-truncation witness tying the NS-013 phase/reality arc
(`ns013_realcomplex_production`, `ns013_phase_production_3d`) to the central obstruction **NS-002 / NS-034
(supercriticality)**: the controlled `L²` invariants are phase-blind, the regularity-deciding production is
phase-sensitive — the controlled quantities are structurally blind to the phase coherence where the
production lives. A concrete *illustration* consistent with supercriticality, **not** a proof of it
(vacuity cap; a phase surrogate is a diagnostic of content-location, not an analytic statement). `:proved`=0;
prize UNTOUCHED.
