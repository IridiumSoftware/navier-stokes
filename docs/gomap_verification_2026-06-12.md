# Go-Map (grok-test) verification + port — 2026-06-12

**The cross-repo verification artifact for NS-052** (the A7 substrate-provenance pattern: a named result
from another repo enters this ledger only with a `substrate_source` pin **and** a committed local
verification artifact — this document + the re-run log). `:proved`=0; every row Scope ≠ PDE; distance
UNTOUCHED.

## The substrate

`~/grok-test` — a **positive attack map** ("Go Map") built by the Grok collaboration as the complement to
this repo's no-go ledger: GO-001..012, each with pre-stated kill criteria, scope tags, and the inherited
firewall. **substrate_source: `grok-test@241bc69`** (the as-found pin; corrections from this pass landed as
`a8aa292` — HQWW attribution, β-window flag, `.lake` build-isolation hazard).

## Verification protocol + results

Key results re-run on this machine against this repo's validated solver chain (`NS_REPO` read-only
includes), sequentially (`docs/gomap_verification_2026-06-12.out.txt` = the chain log). Reproduction
grades: **byte-identical** (deterministic re-run reproduces the pinned output exactly) > **numeric**
(values match) > **clean-run** (executes, verdict reproduced) > **not re-verified**.

| GO | Claim verified | Re-run result | Grade |
|---|---|---|---|
| **GO-003** | phase-repair threshold θ*≈0.46 (1D triad shadow; production recovers at ~46% coherence) | θ* mean = **0.462**, median 0.550, P/Pmax@0.5 = 0.114 | **numeric (exact)** |
| **GO-005** | swirl-sign rigidity FALSIFIED (S sign flips while Γ≥0 on intensification) | smoke re-run clean; kill TRIGGERED on AXIS_BLOB (per pinned output) | **clean-run** |
| **GO-008** | Beltramization↔δ_Λ bridge: +1.5 delay on both thresholds; peak δ 0.527 vs 0.587; matched-intensity Δ=−0.031; corr(lamb²,δ)=+0.72 | re-run output **byte-identical** to the pinned file | **byte-identical** |
| **GO-009** | β-band discrimination: HL 2.468 in (2,4.53); CLM 1.22 / TG 0.88–0.99 outside | CLM **1.2199** / HL **2.4682** / TG **0.8771** — numbers identical (only the corrected banner line diffs) | **numeric (exact)** |
| **GO-001** | Hole-A shell-weighted domination STRESSED (min_j Rp < 1, N-stable in sign 64↔128) | N=64 re-run **byte-identical**: HELICAL worst −0.701 / CONTROL −0.839 / TUBES −0.608, all STRESSED (N=128 from the pinned outputs) | **byte-identical** |
| **GO-011** | Lean 3D Carleman bridge (5 theorems, LEAN_EXIT=0) | **NOT re-verified** — rebuilding routes through the symlinked **live** navier-stokes `.lake` (collision risk with the concurrent Carleman session); recorded as grok-claimed with their committed build log; pending an isolated rebuild | **not re-verified** |

**Two independent catches flowed back to grok-test (`a8aa292`):** (1) the GO-009 "Chen–Hou–Huang band"
attribution (it is **Huang–Qin–Wang–Wei**, arXiv:2308.01528 — caught in this repo's prior-art round);
(2) the **β calibration-window flag** — their CLM β=1.22 is a whole-trajectory fit vs this repo's T-24
asymptotic-window β=1.00, a 22% window-dependence (band verdicts unaffected; no quantitative β use without
stating the window). Plus the `.lake` hazard note.

## What ports (the durable rows, with this repo's framing)

1. **The Hole-A integral-proxy cap (GO-001/001b/010/012) — CONVERGENT with our triad.** Their
   shell/CKN-mask/soft-weight/time-resolved probes find domination *shell-split and time-split* (worst-case
   negative shells at N=128, N-stable in sign; flow-dependent pockets only). Our triad-trimmed probe found
   the same by the *weight* axis (R_int 2.42→0.21 across weights; **R_feed≈0.98–1.03 marginal**). Two
   orthogonal cuts, one witness verdict: **the "one more DNS probe" lane for NS-046 is capped** — *unless
   the witness target changes.* Both maps independently name the same exception, which composes them:
   **the shell/CKN-localized probe measured against the FEED** `¼(|ω|²−(ω·e₃)²)` — their localization ×
   our corrected denominator — is the single DNS probe still licensed.
2. **GO-005 falsification** — corroborates and sharpens this repo's swirl-sign cell (we: corr(signΓ,signS)=0;
   they: S *dominant-sign flip* during intensification while Γ≥0). The Γ-sign rigidity route to ancient
   limits is dead at witness level from two independent fixtures/codes.
3. **GO-008 (new — the NS-045↔NS-049 bridge):** on the matched-spectrum pair, Beltramization *delays* the
   δ_Λ threshold crossing (+1.5 on two distinct thresholds) and lowers peak core defect (0.527 vs 0.587);
   matched-intensity difference is small (−0.031) so the **delay is the robust datum**, and it explicitly
   does **NOT** rescue Lockwood (δ stays multi-directional ≈0.53). First quantitative link between the
   helicity safety-valve and the anisotropy defect.
4. **GO-003 (new — quantifies W1):** production recovery is **continuous** in phase coherence with
   θ*≈0.46 — partial coherence suffices. This *partially answers our own triad's P2-C1 triviality attack*:
   the scramble collapse is not a Gaussianity step-function; there is structure in between.
5. **GO-009 (instrument extension):** the two-scale β discriminates Type-I (CLM, out-of-band) / Type-II
   (HL 2.468 ∈ (2,4.53)) / 3D NULL (TG, out) — band-membership testing added to the NS-050 kit, with the
   window flag attached.

**Not ported:** GO-011 (pending isolated rebuild); GO-002/002b/006/007 (confirmatory of existing NS-050 /
NS-048 / W2 rows — credited in the grok-test ledger, no new content here).

## Firewall

All witness-tier, vacuity-capped, `Scope ≠ PDE`. The Go Map's own conclusion matches this repo's: Hole A's
remaining target is analytic (a true Besov deformation inequality, not grid ratios); Hole B's is
Liouville-level structure. `:proved`=0; distance UNTOUCHED.
