# NS-050 + Type-II prior-art verification round — 2026-06-11

**Lifts the NS-050 / Type-II citation block from C1 ("named/abstract — verify before citing as established")
to C2 (primary statement read), with the errors the verification caught.** Sources: arXiv abstract pages
(primary statements), 2026-06-11. `:proved`=0; citation hygiene only; distance UNTOUCHED.

## Verified (C1 → C2)

| Citation | Verified statement (verbatim anchors) | Verdict vs our record |
|---|---|---|
| **MRRS** (arXiv:1912.11009, Merle–Raphaël–Rodnianski–Szeftel) | smooth finite-energy data for **compressible** 3D NS+Euler imploding with infinite density; smooth self-similar Euler profiles at **quantized speeds**; *"all blow up dynamics obtained for the Navier-Stokes problem are of type II (non self-similar)"* | ✓ row accurate (compressible; NS singularities Type-II) |
| **Chen–Hou** (arXiv:2210.07191) | *"Stable nearly self-similar blowup of the 2D Boussinesq and 3D Euler equations with smooth data"* — finite energy, **with boundary**; nonlinear stability of approximate self-similar profiles; MatLab verification codes linked | ✓ row accurate (with-boundary; smooth data) |
| **Elgindi** (arXiv:1904.04795) | C^{1,α} 3D incompressible Euler on ℝ³: *"these local solutions can develop singularities in finite time, even for some of the simplest three-dimensional flows"* | ✓ content; **journal tag in our row ("Annals of PDE") not confirmed** — arXiv page lists none; drop the journal claim pending a check |
| **Tao** (arXiv:1908.04958) | critical `L³` norm must blow up *"at a rate (log log log 1/(T*−t))^c or faster for an infinite sequence of times"* — a triple-log **lower bound**, via Carleman (quantitative compactness) | ✓ exactly as recorded ("gap-to-full-exclusion is qualitative") |
| **Palasek** (arXiv:2101.08586) | weighted critical norms `‖r^{1−3/q}u‖`; for **axisymmetric** `q∈(2,3]`, bounds depend on a **double** exponential ⇒ **double-log** blowup-rate lower bound, improving Tao's triple-log in the axisym case | ✓ as recorded |
| **Seregin** (arXiv:2304.04045) | *"Remarks on Type II blowups"* — Euler scaling applied to a *scenario* of potential Type-II blowups (27-word abstract; scenario-study, not yet exclusion) | ✓ machinery as recorded; **author now pinned: Seregin** |
| **Seregin** (arXiv:2507.08733) | *"under some assumptions, such type of blowups cannot happen"* — conditional Type-II exclusion for suitable weak solutions via **Euler scaling + Liouville theorems for ancient Euler solutions** (v2 Jan 2026) | ✓ the NS-048 Hole-B machinery, confirmed verbatim |

## Errors / sharpenings the round caught

1. **MISATTRIBUTION (the Albritton–Barker pattern again): arXiv:2308.01528 is by Huang–Qin–Wang–Wei
   (De Huang, Xiang Qin, Xiuyuan Wang, Dongyi Wei) — NOT "Chen–Hou–Huang."** Title: *"Exact self-similar
   finite-time blowup of the Hou-Luo model with smooth profiles"*; method **purely analytic** (fixed-point),
   not computer-assisted. (Likely conflated with Chen–Hou–Huang's De Gregorio work.) Result content as we
   recorded: exact self-similar HL blowup with smooth profiles. **Fixed at all six sites** (SPEC, TEST_SPEC
   T-26, citation_tiers, HL companion ×4, dashboard).
2. **The `c_l∈(2,4.53)` band is a FULL-TEXT claim, not in the abstract** — the T-26 calibration
   (β=2.47 ∈ the band) stands as recorded by the session that read the paper, but the band now carries a
   **pending line-read flag** (locate the theorem stating the profile-family exponent range).
3. **Hou (arXiv:2405.10916) UNDER-STATED in our row:** it is *generalized* axisymmetric NS — **solution-dependent
   viscosity**, effective dimension **≈3.188** ("appears to converge toward 3 as background viscosity
   diminishes"), maximum vorticity O(10³⁰), **numerical**. Even further from clean 3D NS than "near-self-similar
   axisym NS" suggested. Row sharpened.

## DSS-literature sweep (the M1 DSS branch — the cheap de-risk)

The DSS escape route from G3 (a discretely-self-similar profile evades the *exact*-self-similar exclusion)
has **substantially more prior art than our map recorded**:

- **DSS solution theory exists** (the function class is natural): Bradshaw–Tsai forward DSS local-Leray
  solutions for DSS data in weak-`L³` (arXiv:1510.07504), in `L²_loc` with the local energy inequality
  (arXiv:1801.08060), in Besov (arXiv:1703.03480); building on Chae–Wolf.
- **AND a DSS-exclusion side exists:** *"Removing discretely self-similar singularities for the 3D
  Navier-Stokes equations"* (arXiv:1610.09464) — conditional removal of DSS singularities.

**Impact on M1 (recorded, not over-read):** the DSS branch is *not* virgin territory — it has its own
existence theory **and its own partial no-go literature**. A DSS-profile construction attempt must engage
1610.09464's removal conditions (the DSS analog of G3's role for exact self-similarity). This sharpens the
M1 gate's DSS sub-branch from "untested" to "mapped: partially obstructed, conditions citable." All C1
(named; statements not yet read at C2) — a follow-up round if the DSS branch is pursued.

## Ledger actions

`docs/citation_tiers.md` NS-050 block updated (C1→C2 where read; attribution fixed; Hou row sharpened; DSS
rows added at C1). T-26 + SPEC NS-050 + dashboard + HL companion: attribution fixed, band flagged.
`:proved`=0; the tiers say how well we checked others' statements, nothing more.
