# NS-048 companion — Bounded ancient solutions & the Liouville frontier: literature map

**Date:** 2026-06-12. **Status: literature map (no new claim). Scope: PDE-analysis (≠ the PDE).**
`:proved`=0; distance UNTOUCHED. Companion to NS-048 (Hole M4) and the NS-053 seed entry.
**Provenance + tier honesty:** assembled in one session from abstracts, excerpts, and prior repo
knowledge — every tier below is the tier *as of this writing*; nothing here has been line-read in
this session. Per the don't-bluff rule, upgrade tiers (C1→C2/C3) before any entry below becomes
load-bearing in an attack. The tier column is the work queue.
**[FILED 2026-06-12 with three in-repo cross-check annotations (marked ▸CLAUDE) and a re-ranked
queue — see §4 and §7. The map's edges were checked against work already banked in this repo.]**

---

## 0. The question this doc answers

NS-048 Hole M4: exclude the **general non-self-similar bounded mild ancient solution** of 3D NS
(⟺ rule out Type-I blowup). Is there a partial exclusion to *sharpen*, or is the attack from
scratch? **Answer: not from scratch — a mature machine exists — but the unconditional 3D core is
untouched by anyone, and the founding paper says so explicitly.**

## 1. The foundation (M1–M2, fully standard)

**KNSS — Koch, Nadirashvili, Seregin, Šverák,** *Liouville theorems for the Navier-Stokes
equations and applications*, Acta Math. 203 (2009); arXiv:0709.3599.
- The reduction: a finite-time singularity arising from a mild solution generates a **non-trivial
  bounded ancient mild solution** (their Prop. 6.1). Hence: ancient Liouville ⇒ no blowup (in the
  relevant class). This is the repo's M1–M2 in its original form.
- The "parasitic solutions" u = b(t), p = −b′(t)·x are excluded by the *mild* formulation; a
  bounded ancient mild solution of the form b(t) is constant (their Rmk. 6.1).
- **Tier: C2** (primary statement read). ▸CLAUDE: the in-repo C3 (`knss_verification_2026-06-07.md`)
  covers **Lemma 6.1 (compactness)** and the blow-down procedure — **not Prop. 6.1 itself**; do not
  cite C3 on the Prop. 6.1 chain until that read is done.

## 2. What is actually PROVED (the solved shells, inside → out)

| # | class | result | source | tier (current → needed) |
|---|---|---|---|---|
| 2.1 | **2D, bounded ancient** | u ≡ const (or b(t), by admissibility class) — SOLVED | KNSS Thm 5.1 | C2 |
| 2.2 | **3D axisym, NO swirl, bounded ancient** | u ≡ const — SOLVED | KNSS | C1→C2 |
| 2.3 | **3D axisym WITH swirl** | OPEN in general; partial results via the rv_θ maximum principle; Type-I excluded for axisym (conditional class) | KNSS conjecture + Chen–Strain–Tsai–Yau (two papers, ~2008–09) + successors (Koch-school) | C1 |
| 2.4 | **2D half-space, Dirichlet** | mild bounded ancient + L_{2,∞} energy condition ⇒ u ≡ 0 | Seregin, arXiv:1310.1494 | C1 |
| 2.5 | **3D half-space** | properties/partial classification of mild bounded ancient solutions | Barker–Seregin, arXiv:1503.07428 | C1 |
| 2.6 | **L³-sequential Liouville** | ancient solution bounded in L³ along a backward *sequence* of times ⇒ trivial | **Albritton–Barker, arXiv:1811.00502** | **EXECUTED 2026-06-12** ▸CLAUDE: attribution **CONFIRMED — AB Thm 1.2** (`docs/ab_sequential_l3_verification_2026-06-12.md`); now C2+architecture (statement verbatim; mechanism mapped: sequentiality→compactness; backward uniqueness one layer down via Prop 4.2←ARMA-2018←BSŠ) |
| 2.7 | **Type-I ⟺ ancient (equivalence)** | Type-I singular point exists ⟺ non-trivial mild bounded ancient solution with I < ∞ exists (novelty = reverse direction, "zoom out") | Albritton–Barker, same paper | **C3 in-repo** (round-2 verification; the Type-I-conditioned scope correction is already in SPEC G4 wording) |
| 2.8 | **Geometric/vorticity-direction exclusions** | singularity exclusion under vorticity-direction confinement (cone/half-space conditions on ω̂ at regular points) | arXiv:2501.08976 (2025) + lineage | C0/C1 |

Survey rail: **Seregin–Šilkin,** *Liouville-type theorems for the Navier–Stokes equations*,
Russian Math. Surveys (2018) — the programmatic statement that local regularity reduces to ancient
Liouville theorems; use as the consolidated map of the conditional zoo. Tier C1.

## 3. The structural diagnosis (why the solved shells stop where they stop)

Every solved case in §2 runs through the **same mechanism**: reduction to a *scalar* quantity
obeying a (strong) maximum principle — 2D vorticity (2.1, 2.4), the swirl-free axisym vorticity
ratio (2.2), rv_θ (the partial lever in 2.3). Seregin states this pattern explicitly
(arXiv:1310.1494 §1). General 3D offers **no known scalar maximum-principle quantity** — and, per
the recent literature's own framing (e.g. 1811.00502 intro): unlike minimal surfaces, semilinear
heat, and harmonic maps — where zoom-and-classify succeeded — 3D NS has **no known critical
conserved quantity or monotonicity formula**. That missing object *is* Hole M4 restated. Every
comparable geometric-PDE problem that fell to the rescale-and-exclude strategy fell to a
monotonicity formula; the head-on M4 attack is, concretely, a hunt for one.

(Consistency note: this is the same wall as NS-002/NS-036 seen from the ancient-solution side —
the controlled quantities sit at σ=−1; a monotonicity formula would have to live at σ=0. One wall,
another face; do not count it twice in the MDAGC.)

## 4. Sharpenable edges (ranked; each with its first move and kill criterion)

**4.1 The Albritton–Barker L³-sequential Liouville — EXECUTED 2026-06-12 (`docs/ab_sequential_l3_verification_2026-06-12.md`). VERDICT: a SHARPENED WALL-RESTATEMENT** — the sequential hypothesis powers compactness (not backward uniqueness, which enters one layer down via Prop 4.2 — the Carleman-ladder synergy confirmed with precision); **the gap to unconditional KNSS is the `L³`-decay structure itself, not the sequence** (the theorem already needs only a sequence; bounded ancient solutions need not be `L³` at any time — constants witness) ⇒ the σ=0 wall (§3's diagnosis) again. Dead as a small-δ lane; live residual: *any* σ=0 backward-decay mechanism plugs directly into Thm 1.2 and closes Type-I. **TRACKED 2026-06-13 (`docs/ns048_sigma0_decay_carleman_tracking.md`):** the reduction's three links — L1 (Type-I⟹ancient, cited) · L2 (σ=0 decay, the OPEN antecedent = the monotonicity-formula hunt, on no track) · L3 (AB Thm 1.2, cited) — mapped against the Carleman ladder, which formalizes **Tao 1908.04958**'s quantitative form of the ESS backward-uniqueness substrate under L3's engine (NOT AB's theorem, NOT L2) ⇒ ladder completion ⇏ NS-048 closure. *(Original entry below, kept for the record.)*
The gap between "bounded in L³ along a backward time-*sequence*" and the unconditional statement is
the smallest advertised distance to the real theorem in this literature.
- *First move:* line-read 1811.00502 (the sequential-L³ part; fold into the existing round-2 C3 on
  Thm 1.1); identify exactly where the sequential hypothesis enters (backward uniqueness step?
  compactness?) and whether the repo's Carleman ladder touches that step.
  ▸CLAUDE: the synergy is *stronger than stated* — the concurrent Lean session is at ladder-5 of
  **Tao's quantitative-L³ Carleman machinery**, the same backward-uniqueness substrate ESS-type
  steps rest on; if the sequential hypothesis enters there, the repo will eventually hold that step
  machine-verified — the first place the formalization ladder touches a live exclusion edge.
- *Kill:* if the hypothesis is load-bearing at a step requiring ESS-type backward uniqueness in a
  form known to be sharp, the edge is a wall-restatement — log and stop.

**4.2 Axisymmetric with bounded swirl — EXECUTED 2026-06-12. The tiered sub-table + the exact
open sub-case.** New reads this pass: CSTY I/II at C2 verbatim; the rest assembled from in-repo C3
material (the port→route-i→combined thread + the LZZ/Pan–Li/WHWY/CFZ reads).

| # | class (axisym ℝ³, mild, unless noted) | result | source | tier |
|---|---|---|---|---|
| a | **no swirl**, bounded ancient | u ≡ const — SOLVED | KNSS | C2 |
| b | **with swirl**, ℝ²×T¹ (axis direction compactified), bounded ancient | SOLVED | Lei–Ren–Zhang | C3 in-repo |
| c | **with swirl**, Γ=rv_θ ∈ L^p (radial decay), ancient | SOLVED — Γ-decay ⇒ swirl-free reduction ⇒ (a) | Lei–Zhang–Zhao | C3 in-repo |
| d | finite-time side, **with swirl**: \|v\| ≤ C₊(r²−t)^{−1/2} ⇒ regular at 0 (the Type-I self-similar rate excluded) | SOLVED (conditional) | **CSTY I** — Chen–Strain–Tsai–Yau, math/0701796, IMRN 2008 | **C2 (this pass)** |
| e | finite-time side: \|v\| ≤ C₊\|t\|^{−1/2} **or** C₊r^{−1+ε}\|t\|^{−ε/2} (ε>0) ⇒ regular | SOLVED (conditional) | **CSTY II** — 0709.4230, CPDE 34:3, 2009 | **C2 (this pass)** |
| f | the borderline \|v\| ≤ C/r (no t-decay) — the critical scale-invariant bound | PARTIAL — the famous open borderline | Lei–Zhang lineage | C1 — named; verify before citing |
| g | **no swirl**, sublinear growth \|u\| ≤ Cr^α (α<1), ancient | u ≡ const; the α=1 counterexamples are swirl-FREE | Pan–Li | C3 in-repo |
| h | axial-only \|x₃\|^α ancient conjecture (**with swirl**) | **OPEN** — the in-repo port thread; session-scale attacks exhausted | `ns048_anisotropic_z_port.md` → `ns048_route_i_blowdown.md` → `ns048_combined_axial_radial.md` | in-repo |
| i | direction-confinement: ω̂ in a double cone at high \|ω\| ⇒ regular | SOLVED (conditional) | Lei–Ren–Tian, 2501.08976 | C2 (§4.3 + the census) |

**The exact open sub-case: the bare bounded mild ancient axisym solution WITH swirl on ℝ³ — no
decay, growth, compactification, or confinement side-condition.** Every solved neighbor adds
exactly one crutch: radial decay (c), axis-compactification (b), temporal/Type-I decay (d, e), or
direction confinement (i) — and **every with-swirl closer routes through Γ-decay → the swirl-free
reduction**, never through controlling the source S=(2Γ/r⁴)∂_zΓ directly (the in-repo LZZ verdict;
§3's scalar-maximum-principle diagnosis at its sharpest).
*Kill check (equivalence): NOT met* — axisym-with-swirl retains the scalar rv_θ max-principle
structure absent in general 3D, and no equivalence to the full problem is known ⇒ it stays a
genuine restricted target. But no session-scale lane remains: the in-repo attacks (port, route-i,
combined) are exhausted; what's left is the bare conjecture. *(Original entry below, kept for the
record.)*
Partial scalar structure exists (rv_θ max principle); the repo already owns axisym machinery.
- *First move:* assemble the post-KNSS axisym-swirl state of the art into one tiered sub-table;
  identify the *exact* open sub-case.
  ▸CLAUDE: this is **~60% done in-repo** — already held at C3 line-read: LZZ's swirl-free-reduction
  mechanism, Pan–Li (sublinear growth — **NO-swirl**, the scope catch matters here), WHWY's
  `|x₃|^α` criterion, CFZ's radial family; plus the executed port→route-i→combined thread
  (`ns048_anisotropic_z_port.md` → `ns048_route_i_blowdown.md` → `ns048_combined_axial_radial.md`)
  whose net standing IS the sub-case identification: *the axial-only ancient conjecture is OPEN;
  the blow-down is structurally radial; every known closer routes through Γ-decay.* Assemble the
  sub-table FROM those docs; the new reading is CSTY + the Koch-school refinements only.
- *Kill:* if the open sub-case is already known to be equivalent in difficulty to the full
  problem (some axisym reductions are), log and demote to instrument-only.

**4.3 Vorticity-direction / geometric confinement — EXECUTED 2026-06-12
(`scripts/ns048_direction_cone_census.jl` + `.out.txt`). VERDICT: the pre-registered KILL, met
N-STABLY — filed under the CF-family.** The paper is **Lei–Ren–Tian** (arXiv:2501.08976, C2),
hypothesis verbatim: ω̂ confined to a **double cone** in high-|ω| regions ⇒ regular (⟺ at a
singularity the directions intersect every great circle). Honesty catch before running: the held
δ_Λ/|∇ξ|² are *second-moment* diagnostics — the hypothesis is about **support**, so the census
computed the smallest-enclosing-double-cone half-angle θ\*(q) = arccos(max_e min_{i∈top-q}
|ω̂_i·e|) (4000 Fibonacci axes + the Λ-eigenvector candidate) plus the outlier-robust 99%-mass
cone θ\*₉₉, on both held GPU snapshots (tubes @ t=6.00 enstrophy peak). **Result: θ\* =
89.9–90.0° and θ\*₉₉ = 88.5–88.9° at both top-0.1% and top-1%, at both N=256 and N=512** (δ_Λ
0.49/0.448 — the latter exactly reproducing the NS-049 probe, a cross-instrument consistency
check). The spread is **bulk** (even the 99%-mass cone is ≈90°), not outlier-driven: resolved
intense cores hit every great circle ⇒ the LRT condition is **non-discriminating in the resolved
regime** — the NS-049/CF-family pattern, exactly as the kill criterion pre-stated. Caps: (i) this
does NOT refute the theorem — a regular flow violating a *sufficient* condition is consistent;
(ii) the kinematic confound (tube cores organized by construction) cuts both ways; (iii) vacuity
cap — resolved ≠ singular limit. *(Original entry below, kept for the record.)*
2501.08976-type conditions (ω̂ confined to a cone/half-space at regular points ⇒ exclusion) are
the analytic twin of what NS-038/NS-039 *measure* and what NS-049's δ_Λ probe quantifies.
- *First move:* check whether the resolved-DNS direction-field statistics already in the repo
  satisfy / violate the 2501.08976 hypotheses at the intense-vorticity cores — a cheap witness
  with the data in hand (within-truncation; vacuity cap applies).
  ▸CLAUDE: **the expected verdict is KILL, on data already in hand** — the GPU ξ N-trend shows
  direction-roughness at the cores *growing monotonically with resolution* (core/bulk
  0.57→2.62→**4.15**, N=64→256→512, unconverged) and δ_Λ stays multi-directional through N=512
  (0.448): pointwise direction-confinement at the cores looks generically violated — the NS-049
  pattern repeating, as this doc itself anticipates. Run the *exact* published hypotheses (cone
  angle, neighborhood) against the held snapshots before filing under the CF-family. Caution from
  the NS-013 triad: the kinematic confound (tube cores organized by construction) cuts both ways
  when comparing DNS statistics to confinement hypotheses.
- *Kill:* if the published conditions require pointwise confinement that the DNS shows is
  generically violated, the edge is a conditional-criterion family member, not an attack — file
  under the NS-049 verdict's CF-family.

**4.4 (Standing, not an edge) The monotonicity-formula hunt.** Not actionable as stated — recorded
as the *name* of Hole M4. Any candidate must pass CCATT admissibility (σ=0, nonlocal pressure
explicit, survives CKN localization, exports to an inequality). The NS-053 (d,α)-boundary
mechanism question is one structured way to hunt for it.

## 5. Relation to NS-053

NS-053's boundary-mechanism question ("what kills the blow-up mechanism as (d,α)→(3,1)?") and §4.4
are the same hunt run from opposite ends: NS-053 from the construction side (find the mechanism
where blowup *works*, track its death), §4.1–4.3 from the exclusion side (extend the proofs that
*work*, find what stops them). Convergence of the two on a single quantity would be the program's
first genuine candidate for M4. (Aspiration, not a claim.)

## 6. Honest summary

- The reduction machinery (M1–M2, M5–M6) is standard and done — *other people's theorems*.
- Solved: 2D, axisym-no-swirl, half-space-conditional, L³-sequential. All via scalar maximum
  principles. The pattern is the diagnosis.
- Open: general 3D bounded ancient Liouville (⟺ Type-I exclusion, by 2.7) — stated "out of reach
  of existing techniques" by its founding authors; the missing ingredient has a name
  (critical monotonicity formula) and no candidate.
- Three sharpenable edges (§4.1–4.3), each with a first move and a kill criterion.
- Type-II (M7) is untouched by everything in this doc — separate branch, see NS-050.

## 7. ▸CLAUDE — the re-ranked queue (post in-repo cross-check)

1. **4.1 line-read first** — gates everything; folds into the existing AB round-2 C3; carries the
   Carleman-ladder synergy.
2. **4.3 second, expect-kill** — one short session running the exact 2501.08976 hypotheses against
   the held ξ-trend/δ_Λ snapshots; the in-repo prior says the kill criterion is already met.
3. **4.2 third** — assembly from in-repo C3 material (port/route-i/combined docs) + the CSTY read;
   mostly consolidation, not new research.

`:proved` = 0. Distance to the prize: UNTOUCHED.
