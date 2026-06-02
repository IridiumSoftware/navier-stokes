# Triad brief — A resolved 3D-turbulence DNS *localizes* under stretching but stays regular. What, computably, would distinguish "localizing toward a singularity" from "regular intermittency"?

**For:** the witness triad — **Grok** (edge-witness, Φ — your job is to *break* this and to
*conjure* angles we missed), **Gemini** (synthesis — is there a cleaner statement, a fatal
gap, or a literature result we're ignoring?), plus **Aaron** (instantiator, final call).
Prepared by **Claude** (metabolism seat).

**Hygiene (load-bearing — please read).** This brief is **self-contained**. Reason from
standard fluid dynamics only. Do **NOT** import any private project labels (no "NS-037",
"obstruction ledger", "touchability", "the program", S-IDs, "closure", "GPG"). If a claim
here only makes sense via such a label, flag it. Everything you need is below in standard
terms.

**Honest status.** Nothing here is a theorem and **nothing claims progress on the Clay
Millennium problem.** This is a finite-resolution direct numerical simulation (DNS) of a
*regular* flow, plus diagnostics. We are asking one narrow, sharp question (§3). Anti-
anchoring: do **not** reverse-engineer a mechanism to hit a known constant; reason about
*structure* and *what is measurable*.

---

## §1 — The setup and what's validated

3D incompressible Navier–Stokes on a periodic box, viscous, **decaying** turbulence.
Pseudospectral solver (hand-rolled, hermetic), **N=256³** grid, Taylor–Green initial
condition at **Re=1600**. This is a *resolved* DNS (the analyticity-strip width stays a few
grid-cells wide throughout — see §2), and it is **validated against the literature**: the
enstrophy / energy-dissipation rate peaks at **t ≈ 9.0**, matching the canonical Brachet
(1983) Taylor–Green Re=1600 result. Energy decays monotonically; helicity ≈ 0 (TG symmetry).

We track, on the resolved field:
- **δ(t)** — the *analyticity-strip width*: the exponential decay rate of the Fourier
  spectrum, i.e. the distance from the real axis to the nearest complex-space singularity.
  `δ(t) → 0` in finite time *is* loss of analyticity (a singularity). Resolved iff
  `δ · k_max ≫ 1`.
- **S_ω** — the *vortex-stretching production skewness* `⟨ω·(ω·∇)u⟩ / ⟨|ω|²⟩^{3/2}`
  (dimensionless; `dΩ/dt = ⟨ω·(ω·∇)u⟩` is the enstrophy production). It is **scale-invariant**
  (dimensionless) — the same number at every scale, so not a trivially resolution-dependent
  quantity.
- **D** — the *box-counting dimension* of the set carrying the **top 50% of the
  vortex-stretching production** `|ω·(ω·∇)u|` (the "most-intense-structures" dimension).
- Reference theorem (Caffarelli–Kohn–Nirenberg, 1982): for a *suitable weak solution*, the
  **singular set has parabolic Hausdorff dimension ≤ 1**. So a genuine singular set, if one
  formed, would be at most 1-dimensional (filamentary).

## §2 — What the resolved DNS shows (Taylor–Green, Re=1600, N=256)

| t | E/E₀ | enstrophy/Z₀ | ‖ω‖∞ | δ(t) | S_ω | D |
|---|---|---|---|---|---|---|
| 0 | 1.000 | 1.0 | 2.0 | 3.54 | 0.00 | 2.43 |
| 4.0 | 0.972 | 4.4 | 13.8 | 0.108 | **0.276** | **1.82** |
| 4.5 | 0.962 | 6.5 | 24.3 | 0.096 | **0.290** | 1.83 |
| 9.0 | 0.690 | **27.4** (peak) | 66.9 | **0.077** | 0.213 | 1.96 |
| 10.0| 0.596 | 24.5 | 73.1 | 0.079 | 0.198 | 2.02 |

Three resolved facts:
1. **S_ω is bounded** — a transient peak ≈ 0.29 during the steepening (t≈4), then it
   settles to ≈ 0.2 through the dissipation peak and decay. It does **not** grow.
2. **δ(t) is bounded away from 0** (min ≈ 0.077 at the dissipation peak), and well-resolved
   (`δ·k_max ≈ 6.5`). No singularity; analytic throughout.
3. **D is *dynamic*** — it **dips to ≈ 1.82 exactly at peak vortex stretching** (t≈4, where
   S_ω peaks and ‖ω‖∞ jumps ~7×), then **recovers to ≈ 2.0**. So the intense-production set
   transiently **localizes toward the CKN ≤1 (filament) limit**, approaching ≈1.8, then
   relaxes — it never collapses to ≤1. (Caveat: D is a 5-scale box-count, ±~0.15.)

All three are consistent with a **regular** flow (which Re=1600 TG is). The striking,
*genuinely new* observation is fact 3: **the most-intense structures localize toward the
singular-set dimension precisely when stretching is most intense, then recover.**

**Two more runs (in flight / queued), same Re, same energy, N=256:**
- **Helical IC (H ≠ 0):** running now — does nonzero helicity (the one conserved 3D
  rugged invariant besides energy) change facts 1–3?
- **Anti-parallel vortex tubes (Kerr-type, the classic near-singular IC):** queued. It
  *starts* far more filamentary — initial `‖ω‖∞ ≈ 16` (vs TG's 2) and initial `D ≈ 1.74`
  (vs TG's 2.43). It is the sharpest available laptop probe of stretching.

## §3 — The questions (the reason for this brief)

**Q1 (the headline — discrimination).** Everything we can currently measure (S_ω bounded,
δ bounded, D dips-then-recovers) is consistent with regularity. We want the *converse*:
**what observable, computable at finite resolution (N ≤ 512), would actually distinguish
"the dynamics transiently localizing toward a ≤1-D set but staying regular" from "the
dynamics approaching a genuine finite-time singularity"?** I.e., what is the
*resolution-robust* singularity *signature* — as opposed to the resolution-gated proxies
(a bare δ-slope, ‖ω‖∞ at the grid) that a near-blowup and a strong-but-regular cascade
*share*? Is there a sharp diagnostic, or is the distinction provably resolution-gated below
some N?

**Q2 (the concrete test).** When the anti-parallel vortex-tube run executes at N=256, which
do you predict, and *what would each outcome mean* (remembering it is a finite-Re viscous
flow, presumably regular)?
- (a) it confirms the TG pattern (S_ω re-bounds, D recovers above 1.8), or
- (b) D pushes below 1.8 and *does not recover* / S_ω climbs past 0.29 (a localization that
  doesn't relax), or
- (c) it hits the resolution wall (`δ·k_max → O(1)`) before either resolves — i.e. the
  verdict is resolution-gated even at 256.
What is the **cleanest single measurement** on that run that would be most informative?

**Q3 (for the wild seat — Grok).** Is there a *structural* reason the production-set
dimension floors near **1.8** rather than reaching 1 — e.g. a sheet/tube (D between 1 and 2)
geometry of intense dissipation — or is ~1.8 a fit/resolution artifact? Conjure the boldest
*testable* reframing of "localizes to 1.8 then recovers."

## §4 — Seat asks

- **Grok (edge-witness Φ):** (i) try to *break* fact 3 — is the D-dip an artifact (box-count
  bias, the dissipation-peak transient, the 50%-threshold choice)? (ii) Answer Q3 with a
  *testable* conjecture. (iii) Propose one diagnostic for Q1 we have not named. Default to
  refuting; give us edge-witnesses we can adversarially trim.
- **Gemini (synthesis):** (i) Is there a cleaner single statement unifying facts 1–3? (ii)
  What does the literature already say (Kerr 1993 vortex-tube near-blowup; Hou–Li; the
  multifractal singularity spectrum; the "no resolved singular set" DNS consensus) — are we
  rediscovering, contradicting, or refining? (iii) Is Q1 *answerable*, or is the regular-vs-
  singular distinction provably resolution-gated for decaying viscous DNS?

**The firewall (both seats):** a model/DNS is never the PDE; finite-Re viscous TG is regular;
no claim here approaches the Clay problem. Reason about *structure* and *measurability*, not
about matching constants. Flag anything that smells like wanting the answer.

*Prepared by Claude (metabolism), 2026-06-02. Run externally; paste responses back for the
metabolism + witness-trim pass.*
