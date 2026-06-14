# Citation tiers (C0–C5) — the consolidated index

**The single place every load-bearing external citation's reliability tier is recorded.** The C0–C5 scale is
*defined* in the `SPEC.md` header (the "Citation reliability" block); the per-citation assignments were
previously scattered inline across entries and `docs/ns_blowup_generator_class.md` — this table gathers them.
**`:proved`=0; distance to the prize UNTOUCHED** — tiering a citation says how well *we* checked someone
else's theorem, never that *we* proved anything. A no-go's force in the obstruction map is
`tier × independence × scope-match` (*echo ≠ convergence*).

## The scale

| Tier | Meaning |
|---|---|
| **C0** | unverified mention |
| **C1** | secondary-source / restatement only (incl. paywalled-original-via-survey) |
| **C2** | primary statement read |
| **C3** | proof line-verified |
| **C4** | core mechanism independently re-derived |
| **C5** | adversarially checked |

> **Why this matters (the genuine value).** Verifying — not just citing — caught real errors the
> literature/our-own-transcription introduced: a **misattribution** (the Type-I⟺ancient equivalence was
> cited as *Seregin–Šverák*; it is **Albritton–Barker**, and is **Type-I-*conditioned***, not the general
> Liouville we'd implied), a **transcription/record error** in an NRŠ H-identity, and a **hardened endpoint**
> for a Wang fractional-Hardy bound. Citations are objects to verify, not trust.

---

## Hard obstructions (the `G1–G5` of the generator class — others' theorems)

| Citation | Tier | What we checked | Used by |
|---|---|---|---|
| Leray (1934); Hopf (1951) — weak solutions | **C2** (statement-level; not separately verified) | foundational; cited at statement level | NS-003 |
| Beale–Kato–Majda (1984) — BKM blow-up criterion | **C2** (statement-level) | the `∫‖ω‖∞` mechanism; standard | NS-004, the δ↔BKM diagnostic |
| Prodi (1959) / Serrin (1962) / **Escauriaza–Seregin–Šverák (2003)** — critical / `L³` endpoint | **ESS C2**; Gallagher–Koch–Planchon (every critical Besov) **C1** | the σ=0 critical-norm criterion (G1) | NS-005, G1 |
| **Caffarelli–Kohn–Nirenberg (1982)** — partial regularity, singular set ≤1-D | **C2** (statement; the `ε₀` constants **C1**) | the ≤1-D / `𝒫¹(S)=0` localization (G2) | NS-006, G2 |
| **Nečas–Růžička–Šverák (1996)** + **Tsai (1998)** — self-similar exclusion | **NRŠ C2** / **Tsai C3** (line-read); **H-identity core: Julia exact rung ✅** (Lean pending) | no nontrivial `(−1/2)`-self-similar profile in `L³` (G3); `docs/nrs_ess_verification_2026-06-07.md` (an H-identity **record error caught + fixed**). **Bridge fired (2026-06-11):** the corrected H-identity `−νΔH+(U·∇)H+a(y·∇)H = −ν\|ω\|²` verified exactly (`formalization/nrs/h_identity_exact.jl`, 200/200 ℚ-points + false-variant gate reproducing the `3a²ν` error); **Lean rung handed to the formalization track** — tier rises past hand-line-read C3 when it lands | NS-007, G3 |
| **Tao (2016, JAMS)** — averaged-NS blow-up | **C2** (statement; the killed method-class C2, *not* line-verified) | energy-only methods are insufficient (G5) | NS-008, G5 |
| **Albritton–Barker (arXiv:1811.00502, 2019)** — Type-I ⟺ ancient (Thm 1.1) + **sequential-`L³` Liouville (Thm 1.2)** | Thm 1.1 **C3** (line-verified); Thm 1.2 **C2 + proof-architecture mapped** (2026-06-12 line-read; the [3]-core backward-uniqueness NOT line-verified — flagged) | ⚠ **MISATTRIBUTION CAUGHT** (Thm 1.1 was cited as Seregin–Šverák) + scope corrected to **Type-I-conditioned (`I<∞`)**. **Thm 1.2 attribution CONFIRMED 2026-06-12** (`docs/ab_sequential_l3_verification_2026-06-12.md`): `L³` along a backward *sequence* ⇒ ≡0; sequentiality powers COMPACTNESS; backward uniqueness enters one layer down (Prop 4.2 ← AB ARMA 2018 ← Barker–Seregin–Šverák CPDE 2018 — C1, named; persistence ← Rusin–Šverák JFA 2011 — C1). **The gap to unconditional KNSS = the `L³`-decay structure itself, not the sequence** (constants witness) ⇒ a sharpened σ=0 wall-restatement; residual reduction: *σ=0 backward decay ⇒ Type-I exclusion* | G4, NS-048, NS-054 (G1∧G4) |
| **KNSS — Koch–Nadirashvili–Seregin–Šverák (Acta 2009)** — ancient-solution Liouville foundation | **C3** (hypothesis-clean; Lemma 6.1 compactness) | the rescaling/compactness device; `docs/knss_verification_2026-06-07.md` | G4, NS-048 |
| Constantin–E–Titi (1994); Isett (2018); BDLSV (2019); Onsager (1949) — the 1/3 inviscid picture | **C2** (statement-level) | Onsager regularity / dissipation | NS-009 |

## Soft framings (`S1, S2` — in-repo arguments, not external theorems)

| Citation | Tier | What we checked | Used by |
|---|---|---|---|
| Supercriticality / scaling (Tao expositions) | **C2+ consensus**; exact exponents **algebraic (in-repo)** | the σ-calculus pinning critical ↔ supercritical | NS-002 / NS-034, S1 |
| Production-is-the-breaker (criticality–Casimir hinge) | **in-repo argued + algebraic** | the interpolation `‖u‖²_{Ḣ^{1/2}} ≤ ‖u‖_{L²}‖u‖_{Ḣ¹}` + ideal-flow Casimirs | NS-036, S2 |

## Live / complex-data + the dynamic (NS-048) frontier

| Citation | Tier | What we checked | Used by |
|---|---|---|---|
| **Li & Sinai (2008, JEMS)** — complex-data 3D-NS finite-time blow-up | **C2** (statement-level) | the credibility of the complex-plane backward path | NS-012 |
| **Lei–Ren–Zhang / Lei–Zhang–Zhao (Thm 3.7)** — swirl-free reduction | **C3** (both) | "every known closer bypasses the `S`-source via `Γ`-decay"; `docs/citation_verification_round3_2026-06-07.md` | NS-048 |
| **Pan–Li** — sublinear-growth axisym Liouville | **C3** (line-verified) | the blow-down/Liouville-rescaling contrast; `docs/pan_li_verification_2026-06-07.md` | NS-048 (route-i) |
| **Tsai** — asymptotically-self-similar / Type-II | **C2/C3** | the Type-II ceiling on the ancient-Liouville machinery | NS-048 (type-II) |
| **Wang–Huang–Wei–Yu** (arXiv:2205.13893) — `|x₃|^α u^θ` mixed-norm criterion (Thm 1.4) | **C3** (read in full: statement + proof — anisotropic Hardy–Sobolev → Gronwall → continuation; `docs/ns048_anisotropic_z_port.md` §9) | the anisotropic-`z` port (a genuine new ancient question, NOT implicit — the finite-time proof does not transfer) | NS-048 |
| **Yu** (Appl. Anal. 99 (2020)) — `\|x₃\|u^θ` smallness | **C1** (paywalled; via its faithful restatement in 2205.13893) | the `α=1` endpoint of the axial family | NS-048 |
| **Chen–Fang–Zhang** (arXiv:1802.08956) — *radial* `r^d u^θ` criteria | **C3** (read in full; the data-anchored Gronwall + continuation lemma + the "analogously to Lei–Zhang" critical-endpoint remark) | the radial contrast class (an earlier misattribution of the `\|x₃\|^α` conditions to CFZ was caught + corrected in the port doc) | NS-048 |
| **Type-II blow-up-rate lower bounds** (= *partial* Type-II exclusion): Tao 1908.04958 (**triple-log**, plain `L³`); Ożański–Palasek 2210.10030 (axisym weak-`L³` **double-log**, best plain-critical); Palasek 2101.08586 (axisym **weighted** `‖r^{1−3/q}u‖_{L^q}`, `q∈(2,3]`, **double-log**); Palasek 2111.08991 (`d≥4`, `L^d`, **quadruple-log**) | **C3** (primary line-reads + triad-refined — `docs/ns048_type_ii_frontier.md` §2, `c5_triad_witness_verdict.md`; Tao + Palasek headline statements **re-confirmed verbatim vs arXiv 2026-06-13**, `docs/ns048_typeii_rate_verification.md`) | the gap-to-exclusion is a quantitative **rate-race** (exclusion proves `rate ≥` slow loglog-class divergence; a construction would show `rate =` — so Type-II is *not* a clean Type-I/II dichotomy, frontier §4) whose closing demands a **qualitative leap in growth class** (iterated-log → faster than the equation's `∼(T−t)^{−1/2}` scaling, *not* a constant — frontier §2); no method makes the leap (the open problem). *Caveat:* "double-log improves triple-log" is a correct rate-inference (`loglog ≻ logloglog`) but in a *different* (weighted/axisym) norm — not strictly apples-to-apples | NS-048 (type-II) |
| **Lei–Ren–Tian** (arXiv:2501.08976) — double-cone direction-confinement ⇒ regularity | **C2** (hypothesis verbatim) | the litmap §4.3 census (`scripts/ns048_direction_cone_census.jl`): resolved cores violate cone-confinement **bulk-wise** — θ\*≈90°, θ\*₉₉≈88.5–88.9°, N-stable 256↔512 ⇒ non-discriminating in the resolved regime (CF-family filing; does NOT refute the theorem) | NS-048 (litmap §4.3) |
| **Chen–Strain–Tsai–Yau I / II** (math/0701796, IMRN 2008; 0709.4230, CPDE 34:3 2009) — Type-I-rate exclusions, axisym **with swirl** | **C2** (statements verbatim, both) | `\|v\| ≤ C₊(r²−t)^{−1/2}` ⇒ regular (I); `\|v\| ≤ C₊\|t\|^{−1/2}` or `C₊r^{−1+ε}\|t\|^{−ε/2}` ⇒ regular (II) — litmap §4.2 sub-table rows d/e | NS-048 (litmap §4.2) |
| **Lei–Zhang lineage** — the `\|v\| ≤ C/r` borderline (no t-decay) | **C1** (named; verify before citing) | the critical scale-invariant *open* borderline — litmap §4.2 sub-table row f | NS-048 (litmap §4.2) |

## NS-049 — Lockwood "Singularity Surgery" (the one external regularity-*attack*)

| Citation | Tier | What we checked | Used by |
|---|---|---|---|
| Lockwood, *Singularity Surgery* Parts I–V (2026, self-contained working papers, no bibliography) | **C0/C1** (UNVERIFIED working papers) | **our** C3-on-line-read verdict (`docs/ns049_lockwood_verification.md`): a *conditional* anisotropy-depletion criterion (assumes `δ_Λ→0`, never derived; a resolved-DNS probe drives `δ_Λ` the *wrong* way) — **NOT** the unconditional proof its framing implies | NS-049 |

## NS-050 — modulation/Type-II prior art (verification round 2026-06-11, `docs/ns050_priorart_verification.md`)

| Citation | Tier | Note | Used by |
|---|---|---|---|
| **Merle–Raphaël–Rodnianski–Szeftel** (arXiv:1912.11009; Annals 2022 I/II; non-radial 2310.05325) | **C2** | smooth imploding **compressible** Euler/NS; *"all blow up dynamics obtained for the Navier-Stokes problem are of type II (non self-similar)"* (verbatim); quantized-speed self-similar Euler profiles | NS-050 |
| **Elgindi** (arXiv:1904.04795) | **C2** | `C^{1,α}` 3D Euler on ℝ³, finite-time singularity from simple flows (journal tag dropped — unconfirmed on arXiv) | NS-050 |
| **Chen–Hou** (arXiv:2210.07191 Analysis + 2305.05660 Rigorous Numerics) | **C2** | stable *nearly* self-similar blowup, 2D Boussinesq / 3D axisym Euler **with boundary**, smooth finite-energy data | NS-050 |
| **Huang–Qin–Wang–Wei** (arXiv:2308.01528) — ⚠ **MISATTRIBUTION CAUGHT** (was "Chen–Hou–Huang") | **C2** (statement); the `c_l∈(2,4.53)` band is a **full-text claim, line-read pending** | exact self-similar HL blowup, smooth profiles, **purely analytic** fixed-point (not computer-assisted); `c_ω=−1` | NS-050 (T-26) |
| **Seregin** — conditional Type-II exclusion (arXiv:2304.04045 scenario; **2507.08733** *"under some assumptions, such blowups cannot happen"*) | **C2** | Euler scaling + **ancient-Euler Liouville** = the NS-048 Hole-B machinery, confirmed verbatim | NS-050, NS-048 |
| **Hou** — *generalized* axisym NS (arXiv:2405.10916) | **C2 / numerical** | ⚠ sharpened: **solution-dependent viscosity, effective dimension ≈3.19** (→3 as background ν→0), O(10³⁰) vorticity growth — *not* clean 3D NS; numerical | NS-050 |
| **Bradshaw–Tsai** DSS solution theory (arXiv:1510.07504 weak-`L³`; 1801.08060 `L²_loc`; 1703.03480 Besov; after Chae–Wolf) | **C1** | the DSS function class has an existence theory — the M1 DSS branch is not virgin territory | NS-050 (M1-DSS) |
| **DSS-singularity removal** (arXiv:1610.09464) | **C1** | conditional *removal* of DSS singularities for 3D NS — the DSS analog of G3's role; any DSS-profile attempt must engage it | NS-050 (M1-DSS), NS-048 |
| **Tao** triple-log rate (arXiv:1908.04958) | **C3** | `L³` must blow up at `(log log log 1/(T*−t))^c` or faster along a sequence (verbatim, **re-confirmed vs arXiv 2026-06-13**); via Carleman — **= the ladder's target** (NS-051; the same paper). Consolidated at the NS-048 Type-II-rate row + `ns048_type_ii_frontier.md` §2 | NS-048 (type-II), NS-050 |
| **Palasek** double-log axisym (arXiv:2101.08586) | **C3** | weighted critical `‖r^{1−3/q}u‖_{L^q}`, axisym `q∈(2,3]` ⇒ double-exponential subcritical bounds (Tao's strategy) ⇒ **double-log** rate — a *stronger* lower bound than Tao's triple-log, but in a **weighted** norm ("improves" is our rate-inference, not an explicit abstract claim; re-confirmed vs arXiv 2026-06-13). Consolidated at the NS-048 row + `ns048_type_ii_frontier.md` §2 | NS-048 (type-II), NS-050 |
| **Katz–Pavlović** hyperdissipation (arXiv:math/0104199) | **C2** (partial 1<α<5/4); **C1** (α≥5/4 global regularity corollary — proof skim pending) | Hausdorff dim of singular set ≤5−4α for hyperdissipative NS; GO-024 line-read 2026-06-12 | NS-053 |

## Related (non-PDE — kinship only, fenced)

| Citation | Tier | Note | Used by |
|---|---|---|---|
| Gosme (arXiv:2512.09352, 2025) — causal-symmetrization | **C1** | software-ecosystems / phenomenology; NOT PDE | NS-025 |
| Ryan (arXiv:nlin/0609011, 2006) — emergence coupled to scope not resolution | **C1** | conceptual lens behind the σ=0 diagnostic; NOT PDE | NS-035 |

---

## Honesty notes

- **"Statement-level (C2, not separately verified)"** means we read/know the primary statement but have no
  in-repo line-verification artifact; foundational theorems (Leray, BKM, CKN-statement, Onsager, Li–Sinai)
  sit here by default — high confidence in the *statement*, no claim of an independent proof-check.
- **C3 entries have a named verification doc** (`*_verification_2026-06-07.md`) recording the line-read.
- **No C4/C5 yet** — no external theorem has been independently re-derived (C4) or adversarially stress-tested
  to C5 in-repo (the over-reach discipline would require that bar before claiming it).
- **Machine-verification (Lean) sits *above* the social C5 floor — wired in, not yet fired.** A Lean proof of a
  cited theorem's identity or inequality core is stronger than a human adversarial check. The formalization
  ladder (`SPEC.md` **NS-051**, `formalization/`) is the upstream: it currently machine-verifies *general*
  library lemmas (scaling-criticality — done; Lorentz / Littlewood–Paley / Besov toward **Carleman** — in
  progress), **not yet any cited theorem here**, so no tier has changed. When it reaches a citation's core —
  the **NRŠ H-identity** (algebra rung, available now) or **Carleman** behind **ESS / NS-005** (analysis
  substrate, multi-year) — that citation's row is updated and its tier rises past C3.
- Tiers can rise; when a citation is pushed to C3+, log the verification doc here and update the inline tag.

**Source/maintenance:** assignments collected from `docs/ns_blowup_generator_class.md` (G1–G5/S1–S2), the
`*_verification_2026-06-07.md` campaign docs, `docs/ns049_lockwood_verification.md`,
`docs/ns050_modulation_type2_scope.md`, and the SPEC entries. The C0–C5 scale + force-rule are defined in the
`SPEC.md` header.
