# NS-046 sub-probe — is the depletion UNIFORM on the intense set? (No.)

**Date:** 2026-06-06. **Owner:** Aaron Green (probe by Claude). **Scope firewall:** resolved 3D DNS
truncation (Re=1600); **within-truncation only** (vacuity cap — a regular truncation cannot reach the
singular limit; this tests only whether the domination is *uniform across intensity* at these scales).
NOT the PDE. `:proved`=0; distance UNTOUCHED.

## §1 — Why this probe (before any analytic claim)

The would-be NS-046 coercive inequality needs the depletion (nonlocal pressure Hessian + viscosity) to
dominate the production **uniformly on the intense-production set** — the singular-set proxy where, if
anywhere, blowup lurks. NS-047 (C2) said the *uniformity* is the analytic gap; Idea-3 showed the
*enstrophy-weighted global* pressure domination is real in the tube worst case. Before making any
analytic "pressure dominates ⟹ inequality" reduction (which would be the 5th tidy over-reach this
session), measure whether the domination is actually uniform. `scripts/ns046_uniform_domination_probe.jl`
(+ `.out.txt`, N=64). Two ratios, conditioned on top-{100,10,1,0.1}% of the production `|ω·Sω|`, for
helical/control/tubes:
- `Rp = ⟨e₃ᵀ(∇²p)e₃⟩/⟨λ₃²⟩` — deformation level (enters as `−e₃ᵀ∇²p e₃` ⇒ `Rp>0` depletes; `Rp≥1`
  ⇒ pressure beats strain self-amplification);
- `Rv = ⟨ν|∇ω|²⟩/⟨ω·Sω⟩` — enstrophy level (dissipation vs production).

## §2 — Result: the domination is NOT uniform

| observation (N=64) | reading |
|---|---|
| **`Rp@100% < 0`** in *every* flow, every time (−0.08 to −0.32) | over the bulk the pressure Hessian *enhances* the max-stretch (likely the Vieillefosse local-pressure mechanism) |
| **`Rp` turns positive only toward the extreme tip:** `Rp@.1%` = 8–16 (tubes), →2.6 (late helical), but `Rp@10%`/`Rp@1%` mostly ≤0 or <1; **control `Rp@.1%` stays <1** | the pressure depletion is *concentrated at the extreme high-`|ω|` cores*, not uniform; the control (no dominant depletion) bursts most |
| **`Rv` ≪ 1 on the intense set** (top-1%/0.1% ≈ 0.007–0.06) in all flows | viscosity never controls the production at the small scales — clean supercriticality |

**Conclusion.** Neither mechanism dominates the production *uniformly on the intense set*. The pressure
depletion is concentrated at the extreme cores (which is exactly what Idea-3's enstrophy-weighted ratio
~11 measured — consistent), while the bulk and moderately-intense set show *enhancement*, and viscosity
loses everywhere on the small scales.

## §3 — Implication for NS-046 (the honest one)

- **The would-be coercive inequality does NOT hold uniformly even in the truncation.** The depletion is
  non-uniform; the uniformity the inequality requires is exactly where it fails — **NS-047's C2 obstacle,
  now computationally visible.**
- **Qualifies Idea-3:** "the pressure counter-transport is dominant in the worst case" was an
  *enstrophy-weighted* statement about the cores. Conditioned across intensity, the domination is
  *concentrated, not uniform*. (Not a contradiction — a resolution of the average into its structure.)
- **Probe-first worked:** an analytic "pressure dominates ⟹ inequality closes" reduction would have
  over-reached; the sub-probe refuted it computationally *before* the claim. The mechanism is real at the
  cores; the uniformity is the open difficulty — made concrete.

## §4 — Verification / caveats

- N=64 (top-0.1% = 262 points — adequate; finer tail would want N=128, not done). The qualitative
  findings (`Rp@100%<0` robust across flows/times; `Rv≪1` on the intense set; positive-dominant `Rp`
  only at the extreme tip in tubes/late-helical) are clear at N=64; the smoke (N=16) showed the same
  signs (deep-tail magnitudes noisy there). Type: computed (DNS-truncation diagnostic), within-truncation
  only. **No new spec entry; no status change** (NS-046 stays `:open`); recorded as a sub-probe note on
  NS-046 + an Idea-3 qualification. `:proved`=0; distance UNTOUCHED.
