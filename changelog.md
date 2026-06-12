# changelog — Navier–Stokes obstruction program

## v0.15.38 — 2026-06-12 — Carleman ladder-6b-α (substrate iii): the four-index identity `Δ⟪∇f,∇h⟫` — the spatial substrate COMPLETE

`Carleman.lean` +~90 lines (2724 total), completing `CommutatorSubstrate`. **Library
infrastructure; `:proved`=0 for the PDE.**
- **`fderiv_fderiv_dir`** — `∂_v(∂_d f) = iFD2 f ![v,d]` (the second-order coefficient bridge).
- **`laplacian_inner_grad` — THE FOUR-INDEX IDENTITY** (the engine of `Δ(∇g·∇u)`):
  `Δ⟪∇f,∇h⟫ = ⟪∇(Δf),∇h⟫ + 2·⟨D²f,D²h⟩_HS + ⟪∇f,∇(Δh)⟫` for `f,h` C³, with the
  Hilbert–Schmidt Hessian inner product as the basis double sum
  `Σᵢⱼ (iFD2 f ![eᵢ,eⱼ])(iFD2 h ![eᵢ,eⱼ])`. Proof: write `⟪∇f,∇h⟫` as `Σⱼ(∂ⱼf)(∂ⱼh)`
  (`inner_grad_eq_sum`), push `Δ` through the sum (`laplacian_fun_sum`), expand each
  `Δ((∂ⱼf)(∂ⱼh))` by the Leibniz rule (`laplacian_mul`), convert `Δ(∂ⱼ·) → ∂ⱼ(Δ·)` by the
  spatial Clairaut swap (`laplacian_deriv_swap`) and the cross term to the iFD2 double sum
  (`fderiv_fderiv_dir`), then reassemble (`Finset.sum_add_distrib` + `Finset.sum_comm` for the
  `Σᵢⱼ↔Σⱼᵢ` transpose, two `inner_grad_eq_sum` back-substitutions, `real_inner_comm`).
- **Soundness:** no `sorry`; the false variant (HS-term coefficient `1` instead of `2`) is
  REJECTED at `ring`; LEAN_EXIT=0 vs the lean4-cv Mathlib.
**The 6b-α spatial substrate is now COMPLETE** — Laplacian Leibniz rule, spatial Parseval,
finite-sum Laplacian, the full E-domain third-derivative swap chain, the spatial Clairaut swap,
and the four-index identity. **Next: 6b-β** — the S-curve time derivative `∂t(S(t)u(t))` (the
two Clairaut keystones + product/chain `HasDerivAt` algebra) → 6b-γ (the Bochner IBP collapse
`∫2Σᵢⱼgᵢⱼuᵢⱼ·u·ω → −2∫D²g(∇u,∇u)ω`, the `A+B = −2∫D²g(∇u,∇u)ω` exact cancellation) → 6b-δ
(assembly into Lemma 4.1's displayed inequality). `:proved`=0; distance UNTOUCHED.

## v0.15.37 — 2026-06-12 — NS-054 RUN AND CLOSED (the pre-registered kill fired): admissibility-on-the-conjunction = NS-048(+046) relabeled; residual = the coupling inventory; SPEC 38→39, v0.15.0

Aaron's pre-registration stub (`~/Desktop/NS-054_stub.md` — with its own RWC-054, kill criterion, and
over-reach pre-declaration) proposed the one unrun CFS-admissibility application: point the NS-037 lens at
the **MDAGC conjunction** `G1∧…∧G5` and ask for a *joint* obstruction. The stub had already pre-reduced the
move to a single question (a joint obstruction among {G1,G2,G5}×{G3,G4} beyond the used G3∧G4 link) — and
**the paper pass settled it (`docs/ns054_admissibility_companion.md`): all six cross-pairs enumerated, NO
new joint obstruction found.** Every real cross-edge is existing literature: **G1∧G4** (the ancient limit
must be critical-norm-wild backward in time — the sequential-`L³` family; *tier-pending*, gates on the
litmap §4.1 line-read, which this sharpens), **G2∧G4** (CKN-ε inside KNSS's compactness — already silently
used in the doc's own G4 text, now flagged), **G2∧G5** (the energy lane's exact ceiling: ≤1-D but not ∅);
the rest internal/none. **The pre-registered kill fired ⇒ NS-054 = `:falsified` as an attack-reduction:**
"is `A` empty?" is NS-048(+NS-046) in possibilistic vocabulary — the predicted exit, formally closed (not a
failure; it pins the move's prize-relevant content and prevents the relabeling hazard the NS-024/013
precedents name). **Residual banked:** the four-edge **cross-conjunct coupling inventory** as MDAGC **§5b**.
Caveat held: enumeration ≠ nonexistence proof; any return clears RWC-054 in full (joint-not-single,
hard-not-instantaneous, 3-seat-witnessed, emptiness ⇒ machine-checked). SPEC 38→39 (v0.14.0→v0.15.0);
guard 39/39. `:proved`=0; distance UNTOUCHED.

## v0.15.36 — 2026-06-12 — Carleman ladder-6b-α (substrate ii): the spatial Clairaut swap `Δ(∂_w f) = ∂_w(Δf)`

`Carleman.lean` +~115 lines (2636 total), in `CommutatorSubstrate`. **Library infrastructure;
`:proved`=0 for the PDE.**
- **The 5b-ii third-derivative swap chain, ported to the E-domain** (those proofs use nothing of
  the `ℝ × E` product structure): `eIFD3_eq_left`, `eIFD2_apply_dir`, `eIFD3_swap12` (scalar
  Schwarz on `p ↦ Df(p)·c`, dodging the un-stateable `IsSymmSndFDerivAt (fderiv f)`),
  `eIFD3_swap23`, and `fderiv_iFD2_coeff` (`∂_w(iFD2 f ·![a,b]) = iFD3 f ![w,a,b]`).
- **`laplacian_deriv_swap` — the spatial mixed-partial commutation:** `Δ(∂_w f) = ∂_w(Δf)` for
  `f` C³. Both sides expand to `iFD3` coordinates (`eIFD2_apply_dir` for the LHS via the basis
  Laplacian; `fderiv_fun_sum` + `fderiv_iFD2_coeff` for the RHS), reconciled per-basis-index by
  the two swaps `iFD3 f ![eᵢ,eᵢ,w] = iFD3 f ![w,eᵢ,eᵢ]` (swap23 then swap12).
- **Soundness:** no `sorry`; the false variant (`eIFD2_apply_dir` with the direction in the FIRST
  slot instead of the last) is REJECTED at `rfl`; LEAN_EXIT=0 vs the lean4-cv Mathlib.
**Next: ladder-6b-α substrate iii — the four-index identity**
`Δ⟪∇f,∇h⟫ = ⟪∇(Δf),∇h⟫ + 2Σᵢⱼ(∂ᵢⱼf)(∂ᵢⱼh) + ⟪∇f,∇(Δh)⟫` (all ingredients now in hand:
`inner_grad_eq_sum` + `laplacian_fun_sum` + `laplacian_mul` per-`j` + `laplacian_deriv_swap`).
Then 6b-β (the S-curve time derivative) / γ (Bochner IBP) / δ (assembly). `:proved`=0; distance
UNTOUCHED.

## v0.15.35 — 2026-06-12 — SPEC hygiene: GO-022's Hole-A cap woven into NS-046/NS-052 text; round-2 cross-confirmations into the NS-048 row

Closed the two porting gaps the grok-items accounting surfaced. **(1)** The SPEC's own text now carries
GO-022's outcome (it previously lived only in the registry/docs/dashboard): the **NS-046 entry** gains a
"witness-lane state" bullet — the full probe-lane history (pointwise → weight/feed-trimmed → shells/CKN
STRESSED → **the composed probe's kill met N-stably ⇒ the Hole-A DNS lane FULLY capped, zero licensed
probes remain in either map; what remains is the analytic target vs the FEED**) — and the **NS-052
paragraph's item (1)** records that the named composition was subsequently run as GO-022 with the kill met.
**(2)** The **NS-048 registry row** now cites the round-2 byte-identical cross-code confirmations: GO-017
(reproduces the route-i blow-down breaks), GO-014 python half (supports the C8 columnar reduction), GO-013
(blocks the saturating-candidate falsification route), GO-015 (clocks ↔ AB `I<∞` at proxy level), with the
Lean halves still flagged unverified. No status changes; no new entries; guard 38/38; `:proved`=0.

## v0.15.34 — 2026-06-12 — Go-Map verification ROUND 2: the ancient-Liouville wave + NS-053 instruments — ALL NINE BYTE-IDENTICAL

Re-verified the second Grok wave per the A7 protocol (`docs/gomap_verification_round2_2026-06-12.md`; pin
`grok-test@8e0e066`): GO-013..017 (the ancient-Liouville opportunities) + GO-023/024/025 (the NS-053
continuation instruments). **All nine re-runs byte-identical to the pin** (7 Python + 2 Julia; fresh
mtimes confirmed; `git diff` empty — grok-test needs no commit). **The merged NS-053 entry's
"re-verification pending" flag is CLEARED** for GO-023/024/025 (the Lean-free parts). **Cross-code
confirmations gained for in-repo work:** GO-017 independently reproduces the route-i blow-down breaks
(`λ^{1−α}` amplification, the LZZ-vs-axial contrast — a genuine cross-code check of
`ns048_route_i_blowdown.md`); GO-014's Python half numerically supports the C8 columnar reduction;
GO-015 ties the modulation clocks to the litmap §4.1 Albritton–Barker edge (proxy-level — flagged, do not
over-cite). **Standing flags:** the two Lean halves (AxisymColumnarBridge, CarlemanEssBridge) remain
unverified pending an isolated grok-test build (the `.lake` hazard — the concurrent Carleman session is
live); and GO-024/025's α≈1.07–1.08 (rigidity instrument) vs this repo's α*_eff(ν=0.2)≈0.93 (blow-up/decay
bisection) **bracket the asymptotic α*=1 and must not be conflated as one number**. No new catches —
the wave was ledgered with honest scope tags. `:proved`=0 in both repos; distance UNTOUCHED.

## v0.15.33 — 2026-06-12 — Carleman ladder-6b-α (substrate i): the Laplacian Leibniz rule + spatial Parseval + finite-sum Laplacian

`Carleman.lean` +~85 lines (2533 total), new section `CommutatorSubstrate`. **Library
infrastructure; `:proved`=0 for the PDE.** The pure-spatial calculus toward Tao §4's commutator
quadratic form `⟨[L,S]u,u⟩ = ∫(−2D²g(∇u,∇u) − ½(LF)u²)e^g`:
- **`laplacian_mul` — the Laplacian Leibniz rule** (a Mathlib gap; Mathlib has add/smul/neg/sub
  and CLM-comp but no product rule): `Δ(u·v) = u·Δv + v·Δu + 2⟪∇u,∇v⟫` for `u,v` C². Proof
  mirrors `laplacian_exp_comp`: expand `Δ` over the orthonormal basis, compute each `iFD2(uv)`
  term from the once-differentiated product `fderiv(uv) = u•∇v + v•∇u` via `HasFDerivAt.smul`
  + `smulRight_apply`, then reassemble with `laplacian_eq_iteratedFDeriv` and Parseval.
- **`inner_grad_eq_sum`** — spatial Parseval `⟪∇f,∇h⟫ = Σᵢ (∂ᵢf)(∂ᵢh)` named as a standalone
  (was an inline pattern).
- **`laplacian_fun_sum`** — `Δ(Σᵢ Fᵢ) = Σᵢ ΔFᵢ` for C² summands (`Finset.induction` over
  `ContDiffAt.laplacian_add`).
- **Soundness:** no `sorry`; the false variant (cross-term coefficient `1` instead of `2` in
  the Leibniz rule) is REJECTED at `ring`; LEAN_EXIT=0 vs the lean4-cv Mathlib.
**Next: ladder-6b-α (substrate ii–iii):** the spatial Clairaut swap `Δ(∂ⱼf) = ∂ⱼ(Δf)`
(E-domain iFD3 swaps — restated from the 5b-ii domain-generic proofs) → **the four-index
identity** `Δ⟪∇f,∇h⟫ = ⟪∇(Δf),∇h⟫ + 2Σᵢⱼ (∂ᵢⱼf)(∂ᵢⱼh) + ⟪∇f,∇(Δh)⟫` (assemble via
`laplacian_fun_sum` + `laplacian_mul` per j + the swap + `inner_grad_eq_sum`). Then 6b-β/γ/δ.
`:proved`=0; distance UNTOUCHED.

## v0.15.32 — 2026-06-12 — NS-053 LANDED (two independent attacks, merged): the (d,α) continuation boundary; SPEC 37→38, v0.14.0

Aaron's seed (the (d,α) plane embedding true NS=(3,1)) was attacked **twice in parallel by design** —
Grok (GO-023/024, `docs/ns053_continuation_boundary.md`) and Claude (independent, no peeking,
`docs/ns053_continuation_boundary_claude.md`) — and the resulting **SPEC ID collision (two NS-053 entries,
one spliced mid-NS-052) was caught by the ledger guard** and merged into one entry. **Independent
convergences (the strong findings):** (1) Hou's `n` is NOT ambient dimension — `n=1+2R(t)/Z(t)`,
operator-coefficient continuation preventing two-scale anisotropy (both attacks, separately); stabilized
n≈3.188 = margin +0.19 above NS, no published sensitivity. (2) The α-boundary on ground-truth CLM sits at
α≈1: Grok's rigidity monitor loses stability above ≈1.08; Claude's blow-up/decay bisection gives
**α*_eff(ν=0.2) ∈ (0.9297, 0.9320)** — two instruments bracketing the self-derived asymptotic prediction
α*=1. **Complementary:** (3) **the failure mode** (the entry's central question, Claude): a
**MARGINAL-STATE / saddle-node-like boundary** — t* diverges from below (3.4→5.2) and a near-singular
"ghost" transient diverges from above (peak 43.7) ⇒ blow-up dies by stalling, not mechanism-switch;
(4) the **1D n-proxy is FALSIFIED** (Grok kill #1 — scoped to proxies; the genuine d-dial = Hou's
coefficients on the validated `(r,z)` solver); (5) **binding methodology** (Claude): amplitude thresholds
cannot see the α>1 asymptotic boundary (α*_eff(ν=0.05)>1.6 — transients + the periodic IR floor) ⇒
**(d,α) mapping requires co-moving asymptotic certificates (the T-06 pattern)**. Tier pass: Tao 0906.3070
**C2** (α_c=(d+2)/4, log-soft — closes Grok's "line-read pending"); Katz–Pavlović dim≤5−4α C2; Hou
C2+formulation. **T-31** = the probe's anchor gate (it refused three broken configurations pre-read, incl.
a fresh-FFT bit-reversal bug caught by a DFT check — validated T-03 kernel now imported verbatim). Also
committed: `docs/ns048_ancient_liouville_litmap.md` (the Liouville literature map, filed with ▸CLAUDE
in-repo cross-check annotations + re-ranked queue 4.1→4.3→4.2; Aaron-approved). grok-side GO-023/024
witnesses pinned, **re-verification pending** (A7). SPEC 37→38 (v0.13.1→v0.14.0); guard 38/38.
`:proved`=0 everywhere; distance UNTOUCHED.

## v0.15.31 — 2026-06-12 — Carleman ladder-6a: the energy identity `⟨Su,u⟩ = −∫(‖∇u‖² + ½F·u²)e^g`

`Carleman.lean` +~100 lines (2435 total), new section `Lemma41`. **Library infrastructure;
`:proved`=0 for the PDE.**
- **`weightedPairing_S_self`** — Tao §4's `⟨Su,u⟩` display: for any test function `u` and
  smooth weight data, `⟨S_g(t)u, u⟩_g = −∫(‖∇u‖² + ½·F·u²)e^g` with
  `F = ∂tg − Δg − ‖∇g‖²` — the quadratic form of `S` is minus the weighted Dirichlet energy
  plus the F-potential term. One application of the weighted Green identity (B8) with
  `v := u`, plus the integrable-split boilerplate.
- **Soundness:** no `sorry`; the false variant (the identity WITHOUT the ½ on the F-term) is
  REJECTED at the split's `ring`; LEAN_EXIT=0.
- (Changelog repair in this commit: the concurrent session's GO-022 entry and my ladder-5c
  entry had both taken v0.15.28 — 5c renumbered to v0.15.29 and reordered; the NS-053 entry
  header used the spec-version track by mistake — renumbered v0.13.1 → v0.15.30, content
  untouched.)
**Next: ladder-6b** — the concrete commutator `⟨[L,S]u,u⟩ = ∫(−2D²g(∇u,∇u) − ½(LF)u²)e^g`,
staged: 6b-α spatial substrate (Laplacian Leibniz, iFD2 product rule, spatial Parseval +
third-derivative swaps, the four-index identity `Δ⟪∇f,∇h⟫`); 6b-β the S-curve time
derivative; 6b-γ the Bochner IBP collapse; 6b-δ assembly into Lemma 4.1's displayed
inequality. `:proved`=0; distance UNTOUCHED.

## v0.15.30 — 2026-06-12 — NS-053 ported (GO-023 Hou-n FALSIFIED; GO-024 α-only LIVE) *(header renumbered from v0.13.1 — spec-version track mixup; content untouched)*

grok-test NS-053 continuation instrument moves 1–3 + follow-on ledgered and ported per A7:
**GO-023 Hou n-proxy FALSIFIED** on CLM (stability min n_dyn≈2.75, not 3.188) and HL (n_obs→~1.09);
program kill #1 met ⇒ **drop n-family**. **GO-024 α-only v2 LIVE** — CLM rigidity transition α≈1.07,
before Katz–Pavlović rail α=5/4 (math/0104199, C2 partial; line-read in grok-test). **GO-021 hook #1**
(axisym ancient-Euler swirl) and **GO-019 M5** (quantitative no-split) tested LIVE at witness level.
New rows: `SPEC.md` NS-053, `docs/ns053_continuation_boundary.md`, `citation_tiers.md` Katz entry.
Scope: instrument witness; `:proved`=0; distance UNTOUCHED.

## v0.15.29 — 2026-06-12 — Carleman ladder-5c: `mem_S` DISCHARGED — the UNCONDITIONAL CommutatorMethod instance (`commutatorMethod_weighted_joint`)

`Carleman.lean` +~196 lines (2337 total). **Library infrastructure; `:proved`=0 for the PDE.**
- **Refactor:** `commutatorMethod_weighted` (ladder-4) generalized over the admissible class —
  now takes `{A} (hsub : A ⊆ Admissible)` and `hmemS` for `A`; old statement = `A := Admissible`.
- **New section `JointAdmissible`:**
  - `laplacian_slice_eq_iFD2` — slice Laplacian in joint `iteratedFDeriv` coordinates.
  - `inner_gradients_slice` — Parseval for slice gradients in joint coordinates
    (`OrthonormalBasis.sum_inner_mul_inner` + `fderiv_slice_apply` + `inner_gradient_left`).
  - **`AdmissibleJoint`** — test curves with jointly C^∞ uncurried function `(t,x) ↦ a(t)(x)`;
    the ONE membership requirement (spatial support rides on the codomain).
  - `admissibleJoint_subset : AdmissibleJoint ⊆ Admissible` — every ladder-4 witness DERIVES:
    the time-derivative curve is the horizontal joint derivative (`hasDerivAt_curve`), its
    slice smoothness and the joint continuities are inherited.
  - **`admissibleJoint_mem_S` — the `mem_S` discharge** (the toll identified at ladder-4): the
    S-curve's uncurried function is rewritten via the 5a/5b-ii slice calculus into joint
    `iteratedFDeriv`/`fderiv` coordinates — `Δₓ`-terms via `laplacian_slice_eq_iFD2` (both `a`
    and the weight), `∇·∇`-terms via `inner_gradients_slice`, the `∂tg`-term definitional —
    where joint smoothness is inherited termwise. The jointly smooth class is stable under
    `S_g(t)`.
  - **`commutatorMethod_weighted_joint` — THE UNCONDITIONAL INSTANCE:** for any jointly smooth
    weight `G : ℝ × E → ℝ` (single hypothesis `ContDiff ℝ ⊤ G`), the weighted pairing /
    backwards-heat `L` / Carleman `S` triple satisfies the FULL `CommutatorMethod` structure on
    `AdmissibleJoint` — every field proved, nothing assumed. The ladder-1 abstract chain
    `∂t⟨Su,u⟩ = ⟨[L,S]u,u⟩ + ½⟨Lu,Lu⟩ − ½⟨(L−2S)u,(L−2S)u⟩` and drop-the-square now hold
    unconditionally for the real weighted-L² objects.
- **Soundness:** no `sorry`; the false variant (the instance with the weight's time derivative
  in the ZERO direction `(0,0)` instead of `(1,0)`) is REJECTED — the discharge produces the
  genuine `(1,0)`-operator, which cannot match; LEAN_EXIT=0 vs the lean4-cv Mathlib.
- (Session note: a TCC/FDA flip interrupted the soundness checks mid-batch; state was
  checkpointed and the file survived untouched — the documented re-toggle restored access.)
**Next: ladder-6 = Lemma 4.1 in Tao's displayed form** — 6a: `⟨Su,u⟩ = −∫(‖∇u‖² + ½F·u²)e^g`
(Green with `v := u`); 6b: the concrete commutator `⟨[L,S]u,u⟩ = ∫(−2D²g(∇u,∇u) − ½(LF)u²)e^g`
(Hessian-bilinear integral calculus — the main remaining unknown). Then Props 4.2/4.3.
`:proved`=0; distance UNTOUCHED.

## v0.15.28 — 2026-06-12 — GO-022 (the composed probe) RAN: KILL MET — the Hole-A DNS lane is FULLY capped

The single DNS experiment both maps still licensed — **shell-localized R_feed** (GO-001's dominant-shell
localization on the top-0.1% production set × this repo's machine-verified FEED denominator
`¼(|ω|²−(ω·e₃)²)`) — was built and run in grok-test (`go022_shell_feed_domination.jl`, N=32 smoke + 64 +
128; briefly "GO-013", renamed on collision with Grok's concurrent ancient-Liouville wave GO-013..017).
**The pre-stated kill is MET:** worst-case `min_j R_feed(j) < 1`, **N-stable same-sign at 64↔128, all three
flows** (HELICAL −1.53→−1.16 @t=2; CONTROL +0.08→−0.15 @t=1; TUBES −1.92→−1.40 @t=0). ⇒ **the Hole-A
(NS-046) DNS integral-proxy lane is FULLY capped — zero licensed probes remain in either map**; what remains
is analytic (the true critical-Besov deformation inequality, against the FEED). **Secondary structure
recorded, NOT promoted** (it would post-hoc weaken the pre-stated criterion): the violations concentrate in
the early/transient epochs (the TUBES worst is the analytic IC at t=0); at the **peak-intensity epoch**
min-shell R_feed ≥ 1 at N=128 in all flows (+1.25/+1.79/+1.34), *strengthening* with N — a *pre-stated*
peak-epoch formulation would be a new experiment, not a rescue. Ledgered: grok-test GO_SPEC/GO_MAP GO-022
(`:falsified`, grok-test `385c9be`) + this repo's verification-doc addendum + NS-046 target-doc cap note +
NS-052 registry row. Scope: truncation witness; vacuity-capped; `:proved`=0; distance UNTOUCHED.

## v0.15.27 — 2026-06-12 — NS-052: the Grok-built Go Map VERIFIED + PORTED (cross-repo, A7 pattern); SPEC 36→37, v0.13.0

The Grok collaboration's **positive-attack map** (`~/grok-test`, GO-001..012 — the "go" complement to this
no-go ledger, with inherited firewall + pre-stated kill criteria) was verified and its durable rows ported.
**Verification first (the A7 substrate rule):** grok-test pinned at `241bc69` (it had no commits — initial
pin made); key results re-run against this repo's solver chain
(`docs/gomap_verification_2026-06-12.{md,out.txt}`, **T-30**): **GO-001 + GO-008 byte-identical** to the
pinned outputs, **GO-003 + GO-009 numeric-exact** (θ*=0.462; β=1.2199/2.4682/0.8771), GO-005 clean-run.
**Ported as NS-052** (`:tested`, Scope ≠ PDE): (1) the **Hole-A integral-proxy cap** — their
shell/CKN/soft-weight Rp probes STRESSED N-stable, **convergent with our triad-trimmed weight/feed result
from an orthogonal cut**; both maps independently leave exactly one licensed DNS probe: shell-localized
**R_feed**; (2) **GO-005 swirl-sign falsification** (corroborates our NS-048 cell — S dominant-sign flips
while Γ≥0); (3) **GO-008, new: the first quantitative NS-045↔NS-049 bridge** — Beltramization *delays* the
δ_Λ threshold (+1.5 on two thresholds; matched-intensity Δ small ⇒ delay is the robust datum; does NOT
rescue Lockwood); (4) **GO-003, new: W1 quantified** — production recovery continuous in coherence,
θ*≈0.46 (partially answers our triad's P2-C1 triviality attack); (5) **GO-009 β band-membership** added to
the NS-050 kit with the **calibration-window flag** (their CLM 1.22 whole-trajectory vs our T-24 asymptotic
1.00 — 22% window-dependence). **Catches flowed back to grok-test (`a8aa292`):** the HQWW attribution (the
misattribution we corrected here on 06-11 had propagated), the β-window flag, and a **`.lake`
build-isolation hazard** (their Lean bridge symlinks into the LIVE navier-stokes build cache — GO-011 left
NOT re-verified pending an isolated rebuild). SPEC 36→37 (v0.12.0→v0.13.0); registry + T-30 + dashboard +
CLAUDE counts updated; guard passes 37/37. `:proved`=0 in both repos; distance UNTOUCHED.

## v0.15.26 — 2026-06-12 — Carleman ladder-5b-ii: the slice-Laplacian Clairaut swap machine-verified (∂tΔₓ = Δₓ∂t) via the instance-safe iFD route

`Carleman.lean`'s `LaplacianSwap` section completed (~2141 lines total). **Library
infrastructure; `:proved`=0 for the PDE.**
- The redesign banked at v0.15.24 executed in full — every step routed through
  `iteratedFDeriv` (multilinear codomains), avoiding the unsynthesizable nested-CLM instance:
  - **(α) `hasDerivAt_iFD2_curve`** — time derivative of second-derivative coefficients via
    `ContinuousMultilinearMap.apply ∘ iFD2 ∘ curve` (the comp unifications needed tactic-mode
    `exact` — Mathlib's own "tricky unification" idiom).
  - **(δ) `iFD3_eq_left`** — `iFD3 U q ![a,b,c] = fderiv(iFD2 U) q a ![b,c]`
    (`iteratedFDeriv_succ_apply_left` + `congr`).
  - **(δ′) `iFD2_apply_dir`** — `iFD2 (p ↦ DU(p)·d) q ![a,b] = iFD3 U q ![a,b,d]`
    (`ContinuousLinearMap.iteratedFDeriv_comp_left` + `succ_apply_right` with a `conv_rhs`
    to keep the rewrite off the wrong occurrence).
  - **(β′) `iFD3_swap12`** — first-pair swap via SCALAR Schwarz on the auxiliary
    `V_c := p ↦ DU(p)·c` + `IsSymmSndFDerivAt.iteratedFDeriv_cons` — the key move that
    dodges `IsSymmSndFDerivAt (fderiv U)` (whose mere statement needs the blocked instance).
  - **(γ′) `iFD3_swap23`** — last-pair swap via differentiated pointwise Fin-2 symmetry
    (the 5a pattern with `CMM.apply`).
  - **(ε) `hasDerivAt_laplacian_slice` — THE SECOND CLAIRAUT KEYSTONE:**
    `∂t(Δₓ U)(x) = Δₓ(∂t U)(x)` for jointly C³ `U` — both sides in iFD2 coordinates,
    per-term curve derivatives, and the two pairwise swaps
    `iFD3(1,0)(0,eᵢ)(0,eᵢ) = iFD3(0,eᵢ)(0,eᵢ)(1,0)`.
- **Soundness:** no `sorry`; the false variant (the bridge with the direction in the FIRST
  slot, `![d,a,b]`) is REJECTED; LEAN_EXIT=0 vs the lean4-cv Mathlib.
**With both Clairaut keystones (5a: `∂t∂ₓ = ∂ₓ∂t`; 5b-ii: `∂tΔₓ = Δₓ∂t`) machine-verified, the
`mem_S` discharge for jointly-smooth curves is now assembly** (ladder-5c: the strengthened
admissible class + the witness computation for `∂t(S(t)u(t))`, needing `(gt,gtt)`-weight data).
Then the concrete commutator identification → Props 4.2/4.3. `:proved`=0; distance UNTOUCHED.

## v0.15.25 — 2026-06-12 — Plan move #6 found ALREADY EXECUTED (the anisotropic-z ancient-port thread, 2026-06-07); stale pointer fixed + citation rows sharpened

Reconciliation, not new research. The open-questions plan's move #6 ("port Yu + CFZ `|x₃|^α` conditions to
the ancient setting; decide S-control vs Γ-decay routing") turned out to be **fully executed on 2026-06-07**
across three docs the plan failed to register: `ns048_anisotropic_z_port.md` (the port — a genuine NEW
conjecture; the finite-time proof does NOT transfer: data-anchored Gronwall + finite-`T` continuation, both
vacuous on `(−∞,0]`; and the **CFZ attribution my plan repeated was already corrected there** — the axial
conditions are Yu / Wang–Huang–Wei–Yu; CFZ's are radial) → `ns048_route_i_blowdown.md` (route (i) attempted
and **broken**: the blow-down amplifies `Γ`'s radial growth `λ^{1−α}`; compactness fails by
supercriticality) → `ns048_combined_axial_radial.md` (the combined conjecture **collapsed**). Net standing
(already recorded there): *the axial-only ancient conjecture is OPEN; session-scale attacks exhausted; what
remains is the bare conjecture + the un-mechanised S-control route — analytic undertakings, not session
tasks.* **Root cause of the redundant plan item: `ns048_swirl_source_frontier.md` §7 still posed the port as
the "cleanest entry" — the stale pointer is now annotated EXECUTED** with the outcomes (the same stale-queue
pattern as the MFE catch). Residual real work applied: `citation_tiers.md` Yu/WHWY row **split + sharpened**
(WHWY 2205.13893 → **C3**, read in full per the port doc; Yu → C1 paywalled-via-restatement; CFZ 1802.08956
→ **C3**, radial-contrast class, the caught misattribution noted). Also resolved two changelog
version-number collisions from the concurrent sessions (renumbered to .22.1/.23/.24). No new NS-ID; no
status change; `:proved`=0; distance UNTOUCHED.

## v0.15.24 — 2026-06-12 — Carleman ladder-5b-i: second-order slice calculus landed + a NESTED-CLM INSTANCE GAP found (swap chain redesigned to iteratedFDeriv route)

`Carleman.lean` grows a `LaplacianSwap` subsection (~2011 lines total). **Library
infrastructure; `:proved`=0 for the PDE.**
- **`fderiv_fderiv_slice_apply`** — the second-order slice conversion: slice second directional
  derivatives are joint second derivatives in vertical directions,
  `∂ₓ(∂ₓ(U(t,·))·v)(x)·w = D²U(t,x)(0,w)(0,v)`.
- **`laplacian_slice_eq`** — the slice Laplacian in joint coordinates:
  `Δₓ(U(t,·))(x) = Σᵢ D²U(t,x)(0,eᵢ)(0,eᵢ)` — needed under ANY route to the slice-Laplacian
  Clairaut swap and to the `mem_S` discharge.
- **Soundness:** no `sorry`; the false variant (a horizontal slot `(1,w)` in the conversion) is
  REJECTED at `rfl`; LEAN_EXIT=0 vs the lean4-cv Mathlib.
- **FINDING (Mathlib instance gap, isolated by probe):** for GENERIC inner-product `E`,
  `NormedAddCommGroup ((ℝ×E) →L[ℝ] ((ℝ×E) →L[ℝ] ℝ))` FAILS to synthesize (it synthesizes for
  concrete `E := ℝ`) — so differentiability statements about the CLM²-valued map
  `fderiv(fderiv U)` cannot even be stated generically. The planned ∂tΔₓ-swap chain
  (`hasDerivAt_d2_curve` + the two pairwise swaps) is therefore REDESIGNED to route through
  `iteratedFDeriv` (multilinear codomain — instance-rich): the d2-coefficient curve via
  `CMM.apply ∘ iFD2 ∘ curve`, the outer swap via `iteratedFDeriv_succ_apply_right` + the Fin-2
  symmetry of `iFD2 (fderiv U)`, the last-two swap via differentiated pointwise Fin-2 symmetry
  (the 5a `d3_swap_last` pattern with `ContinuousMultilinearMap.apply` in place of the blocked
  nested CLM apply). Plan banked in memory; the cut chain is ladder-5b-ii.
`:proved`=0; distance UNTOUCHED.

## v0.15.23 — 2026-06-11 — GPU N-trend CLOSED (ξ monotone lift 0.57→2.62→4.15; δ_Λ N-stable) + queue/band-finding reconciliation

**The GPU session (open-questions plan move #3) is complete.** Both runs reproduce the committed trajectories
digit-for-digit (cross-run gates passed at N=256 and N=512). Final N-trend
(`scripts/ns013_cfm_gpu_trend.jl` + `.out.txt`, tubes @ t=6.00 peak): **core/bulk `⟨|∇ξ|²⟩_w` =
0.57 (N=64) → 2.62 (N=256) → 4.15 (N=512) — monotone lift, unconverged at 512.** The NS-013 claim-2 reading is
definitively dead (the seats' prediction, now measured at two refinements); what the trend witnesses (vacuity
cap intact) is that direction-roughness CONCENTRATES at the most intense set under refinement. **δ_Λ
ride-along: 0.49 → 0.448 — solidly multi-directional; the NS-049 wrong-way verdict is N-stable through
N=512** (registry row annotated). **Reconciliation (plan move #7's cleanup):** the queued MFE
causal-symmetrization test was found ALREADY DONE (2026-06-07, honest negative — the dashboard queue was
stale; marked done); band-finding items 2 (BKM gate = T-06 G3) and 5 (CKN guard = T-08) marked already-implemented;
item 3's **what-NOT-to-do checklist** added as `docs/ns_blowup_generator_class.md` §5a (six checkboxes, each
with its named killer, incl. the new FEED rule from the triad); item 8 documented-as-relative-only.
`:proved`=0; distance UNTOUCHED.

## v0.15.22.1 — 2026-06-11 — Triad VERDICT applied (NS-046 + NS-013): every strong reading trimmed; the seats' demands RUN and empirically vindicated

Both seats returned on `docs/ns046_ns013_triad_brief.md` (Grok Φ + synthesis; verdict
`docs/ns046_ns013_triad_verdict.md`; harsher seat governs). **NS-046:** P1-C1 "weighting artifact" REFUTED →
*weight-sensitive integral reconciliation*; P1-C2 "difficulty locus" WITHDRAWN (non-monotone, proxy, vacuity
confound); P1-C3 single-point status CORRECT; P1-C4 algebra stands but the R/λ₃² save NOT ESTABLISHED.
**NS-013:** P2-C1 scramble survives only as "quadratic invariants insufficient"; P2-C2 REFUTED (uptick
load-bearing + **kinematic confound** — tube cores organized by construction); P2-C3 the "reduction to CFM"
REFUTED as **relabeling** (CFM is necessary for any flow; the complex angle adds ~nothing); P2-C4 downgraded
to *:argued + two adjacent non-diagnostic witnesses*. **Then the seats' demands were RUN: (1)** the GPU ξ
N-trend **empirically confirmed P2-C2** — core/bulk ⟨|∇ξ|²⟩_w **0.57 (N=64) → 2.62 (N=256)**, the reading
REVERSES under refinement (NS-039 pattern; δ_Λ ride-along 0.49 — NS-049 verdict N-stable; N=512 in flight);
**(2)** the weight/feed recomputation (probe extended) **confirmed P1-C1/C4** — R_int = 2.42 (|ω|²) / 1.53
(|ω·Sω|) / **0.21 (|S|², BELOW 1)**, and against the machine-verified FEED `¼(|ω|²−(ω·e₃)²)` the margin is
**R_feed = 0.98–1.03 (MARGINAL)** — the 2.4 comfort was a denominator artifact. Stable landing adopted:
*reality's phase/Hermitian structure alone not protective; geometric organization the leading surviving
candidate; reduction to CFM argued, not witnessed.* Ledger trimmed everywhere (target doc, NS-013 doc,
registry ×2, dashboard ×2, probe report regenerated). What survives: the sign check (algebraic), the
calibrations, and the sharpened rule that future domination probes must measure against the FEED. The
NS-024 pattern, executed. `:proved`=0; distance UNTOUCHED.

## v0.15.22 — 2026-06-11 — Carleman ladder-5a: the Clairaut keystone machine-verified (∂t commutes with the slice derivative)

`Carleman.lean` grows a `SliceCalculus` section (~1945 lines total). **Library infrastructure;
`:proved`=0 for the PDE.**
- **`hasFDerivAt_slice` / `fderiv_slice_apply`** — the slice↔joint conversion: for jointly
  differentiable `U : ℝ × E → ℝ`, the spatial slice's derivative is the joint derivative in
  the vertical direction, `∂ₓ(U(t,·))(x)·v = DU(t,x)(0,v)`.
- **`hasDerivAt_curve`** — the time-curve derivative is the joint derivative in the horizontal
  direction, `∂t(U(·,x))(t₀) = DU(t₀,x)(1,0)`.
- **`hasDerivAt_fderiv_slice` — FIRST-ORDER CLAIRAUT FOR SLICES (the `mem_S` keystone):**
  for jointly C² `U`, `∂t(∂ₓU·v) = ∂ₓ(∂tU)·v` — proved by converting both sides to joint
  second derivatives (`D²U(1,0)(0,v)` vs `D²U(0,v)(1,0)`) and swapping via Mathlib's
  Schwarz theorem (`ContDiffAt.isSymmSndFDerivAt`).
- **Soundness:** no `sorry`; the false variant (the slice conversion with a horizontal
  component, `DU(1,v)` for `DU(0,v)`) is REJECTED at `rfl`; LEAN_EXIT=0 vs the lean4-cv
  Mathlib.
**The design insight banked:** discharging the ladder-4 `mem_S` hypothesis needs ONLY pairwise
second-derivative swaps — `∂t∂ᵢ∂ᵢU = ∂ᵢ∂t∂ᵢU = ∂ᵢ∂ᵢ∂tU`, each step a Schwarz swap on a
once-differentiated jointly-smooth function — no third-order symmetry theory. Ladder-5b
iterates this keystone: the slice-Laplacian swap (`∂tΔₓ = Δₓ∂t`), then the `mem_S` discharge
for jointly-smooth curves, then the concrete commutator identification. `:proved`=0; distance
UNTOUCHED.

## v0.15.21 — 2026-06-11 — NS-050/Type-II prior-art verification round: C1→C2 lifts + a MISATTRIBUTION caught + the DSS branch mapped

Move #5 of the open-questions plan (`docs/ns050_priorart_verification.md`). Read the primary statements of the
whole NS-050/Type-II citation block (previously all C1 "verify before citing"). **Confirmed C1→C2:** MRRS
1912.11009 (*"all blow up dynamics obtained for the Navier-Stokes problem are of type II"* — verbatim),
Chen–Hou 2210.07191 (with-boundary, smooth-data, stable *nearly* self-similar), Elgindi 1904.04795 (C^{1,α}
3D Euler on ℝ³; our "(Annals of PDE)" journal tag unconfirmed — dropped), Tao 1908.04958 (triple-log lower
bound, verbatim), Palasek 2101.08586 (double-log axisym `q∈(2,3]`), Seregin 2304.04045+**2507.08733** (the
conditional Type-II exclusion via Euler scaling + ancient-Euler Liouville — the NS-048 Hole-B machinery,
confirmed verbatim; author now pinned). **Errors caught:** (1) **arXiv:2308.01528 is Huang–Qin–Wang–Wei, NOT
"Chen–Hou–Huang"** (the Albritton–Barker misattribution pattern; purely *analytic* fixed-point, not
computer-assisted) — fixed at all six sites (SPEC, TEST_SPEC T-26, citation_tiers, HL companion ×4,
dashboard); (2) the `c_l∈(2,4.53)` band is a **full-text claim, not abstract** — line-read flag added;
(3) Hou 2405.10916 **under-stated** — *generalized* axisym NS (solution-dependent viscosity, effective
dimension ≈3.19), numerical; row sharpened. **DSS sweep (the M1 de-risk):** the DSS branch has real prior
art — Bradshaw–Tsai forward-DSS solution theory (1510.07504 / 1801.08060 / 1703.03480, after Chae–Wolf)
**and a conditional DSS-singularity-REMOVAL result (1610.09464)** — the DSS analog of G3; M1's DSS sub-branch
re-marked from "untested" to "mapped: partially obstructed, conditions citable" (rows added at C1).
Citation hygiene only; `:proved`=0; distance UNTOUCHED.

## v0.15.20 — 2026-06-11 — Carleman ladder-4: the CommutatorMethod INSTANCE — the abstract chain and the analysis SNAP TOGETHER

`Carleman.lean` grows a `CommutatorInstance` section (~1850 lines total). **Library
infrastructure; `:proved`=0 for the PDE.**
- **`smoothTestSubmodule K`** — the spatial test class (C^∞ functions vanishing off `K`) as a
  genuine `Submodule ℝ (E → ℝ)` (algebra for free); closure lemmas: **`contDiff_laplacian`**,
  **`contDiff_gradient`** (C^∞ ⇒ C^∞ Laplacian/gradient — more pointwise Mathlib gaps),
  `gradient_add`, `gradient_smul`.
- **`Sfun`/`Sop`** — the Carleman operator `S_g(t) = Δ + ∇g(t)·∇ − F(t)/2` bundled as a LINEAR
  ENDOMORPHISM of the test class (linearity via `ContDiffAt.laplacian_add`/`laplacian_smul` +
  the gradient rules; class-closure via the support lemmas).
- **`weightedPairing`** — `P_g(t)(u,v) = ∫u·v·e^{g t}` as a bilinear map (`LinearMap.mk₂`, all
  four (bi)linearity proofs with integrability discharged through the compact support).
- **`Admissible`** — curves valued in the class with spatially smooth time-derivative curves and
  jointly continuous data; **`Lop`** — `L = ∂t + Δ` on curves (junk off the class) with
  **`Lop_coe`** (on admissible curves it is genuinely `∂t + Δ`).
- **`commutatorMethod_weighted` — THE INSTANCE:** `CommutatorMethod (P_g) (L) (S_g) Admissible`
  with `symm`/`nonneg` proved directly, **`selfAdj` from the weighted Green identity (B9)**,
  **`deriv_pair` from the master differential identity (ladder-3b-iii)** — i.e. the ladder-1
  abstract chain `∂t⟨Su,u⟩ = ⟨[L,S]u,u⟩ + ½⟨Lu,Lu⟩ − ½⟨(L−2S)u,(L−2S)u⟩` and the drop-the-square
  inequality now HOLD FOR THE REAL OBJECTS. The ONE assumed input is `mem_S` (stability of the
  admissible class under `S`): its discharge = commuting `∂t` with the spatial operators — the
  mixed-derivative/Clairaut toll, explicitly documented as the next rung.
- **Soundness:** no `sorry`; the false variant (the selfAdj split's pointwise core with the
  `F`-sign of `S` flipped) is REJECTED by `ring`; LEAN_EXIT=0 vs the lean4-cv Mathlib.
**Remaining for Lemma 4.1 in Tao's displayed form:** discharge `mem_S` (Clairaut) + the concrete
commutator identification `⟨[L,S]u,u⟩ = ∫(−2D²g(∇u,∇u) − ½(LF)u²)e^g`; then Props 4.2/4.3.
`:proved`=0; distance UNTOUCHED.

## v0.15.19 — 2026-06-11 — Lean→citation bridge FIRED (channel a): the NRŠ H-identity Julia exact rung CLOSED

Move #4 of the open-questions plan — the bridge's first firing. New `formalization/nrs/` (collision-free; the
concurrent Lean session's files untouched): `h_identity_exact.jl` verifies the **corrected NRŠ H-identity**
`−νΔH + (U·∇)H + a(y·∇)H = −ν|ω|² ≤ 0` (H = ½|U|²+P+a(y·U), mod the profile equation + div-free) in exact
`Rational{BigInt}` — **200/200 random ℚ-points exactly zero** (Schwartz–Zippel over the 24-symbol polynomial
identity; the sympy symbolic zero `disproof/nrs_h_identity.py` already on record), **plus the false-variant
gate: the ORIGINAL transcription-error record comes out off by EXACTLY `3a²ν`, 200/200** — the rung verifies
both the truth and the catch (the ladder discipline's rejected-false-variant pattern). The reduction also
makes the identity's content transparent: the RHS is `−ν|curl U|²`, manifestly ≤0 — the maximum principle NRŠ
run through `H`, with the drift term `a(y·∇)H` load-bearing (its omission was the caught record error).
**Lean rung HANDED to the formalization track**; `docs/citation_tiers.md` NRŠ row annotated (tier rises past
hand-line-read C3 when Lean lands — close-out vi+vii). Evidence: algebraic; an identity of the profile
*system*, NOT regularity. `:proved`=0; distance UNTOUCHED.

## v0.15.18 — 2026-06-11 — Triad brief OPENED (two parts): NS-046 integral finding + NS-013 consolidated reduction

Move #2 of the open-questions plan: `docs/ns046_ns013_triad_brief.md` — a combined two-part adversarial brief
(one routing trip) subjecting this week's two witness findings to external seats before they are leaned on.
**Part 1 (NS-046):** the integral-cancellation reading — P1-C1 the weighting-artifact claim (is `w=|ω|²` the
right weight, or is the "artifact" itself an artifact of the favorable weight?), P1-C2 the scale-margin locus,
P1-C3 single-fixture/snapshot/resolution (pre-flagged unconverged), P1-C4 the −λ₃²-self-damping sharpening
(should domination be restated against the vorticity feed term?). **Part 2 (NS-013):** the consolidated
reduction — P2-C1 is the 97–99% phase-scramble collapse non-trivial or a calibrated Gaussianity restatement,
P2-C2 the core ξ-smoothness reading (**pre-flagged: the 1%→0.1% uptick 165→212 that the headline glossed**;
single-N), P2-C3 reduction-vs-relabeling (what does the complex angle add over plain CFM?), P2-C4 whether
"witness-supported" is honest or should downgrade to "two adjacent witnesses". Internal pre-screen included
with my own vulnerabilities flagged. **Awaiting Grok edge-witness Φ + synthesis seat (Aaron routes).**
`:proved`=0; distance UNTOUCHED.

## v0.15.17 — 2026-06-11 — NS-046 sign Required-Check CLOSED (algebraic): pressure-Hessian coefficient −1, convention CORRECT

Executed move #1 of the open-questions plan. The depletion convention all three NS-046 probes adopt
(`e₃ᵀ∇²p e₃>0 ⇒ depletes`) rested on the underived claim `Dλ₃ ⊃ −e₃ᵀ∇²p e₃` — flagged as a Required Check.
Now **machine-verified exactly** (`scripts/ns046_dlambda3_sign_check.{py,jl}` + `.out.txt`, evidence class
**algebraic**): sympy verifies the full chain symbolically — **I1** gradient-of-NS `DA/Dt=−A²−∇²p+νΔA`
(identity, no equations assumed), **I2** `sym(A²)=S²+Ω²`, **I3** `Ω²=¼(ω⊗ω−|ω|²I)`, **I4** the
eigen-derivative lemma `dλ₃/dt=e₃ᵀ(dS/dt)e₃` (λ₃ simple; rotation terms cancel exactly), **A1**
`e₃ᵀS²e₃=λ₃²`; Julia independently corroborates (Rational{BigInt} exact zeros for I2/I3; FD convergence rate
4.00 for I4; assembly to machine-ε). Result: `Dλ₃/Dt = −λ₃² + ¼(|ω|²−(ω·e₃)²) − e₃ᵀ∇²p e₃ + νe₃ᵀΔS e₃` —
the pressure enters with **coefficient −1**, so the probes' convention is **CORRECT** (and Brian's eigenframe
equation in the NS-046 registry row is confirmed, with the "+rot" terms shown to cancel exactly). **Honest
sharpening recorded, not over-read:** for λ₃ itself `−λ₃²` is **self-damping**; the growth feed is the
vorticity term `¼(|ω|²−(ω·e₃)²)` (maximal for ω⊥e₃) — the probes' ratio `R=e₃ᵀ∇²p e₃/λ₃²` stays a sensible
magnitude comparison, but "strain self-amplification *of* λ₃" is loose phrasing (the amplification runs
through ω-growth fed by λ₃>0). Caveat: λ₃ simple (a.e.). Scope: kinematic/structural identity of NS — NOT a
regularity statement; no status change; `:proved`=0; distance UNTOUCHED.

## v0.15.16 — 2026-06-11 — Carleman ladder-3b-iii: TAO'S MASTER DIFFERENTIAL IDENTITY machine-verified (∂t⟨u,v⟩ = ⟨Lu,v⟩+⟨u,Lv⟩−2⟨Su,v⟩)

`Carleman.lean` grows a `TimeLayer` section (~1376 lines total). **Library infrastructure;
`:proved`=0 for the PDE.**
- **`integral_green_split` / `integral_weight_split`** — the spatial relations in atom form
  (`∫Δu·(v·e^g) = −∫⟪∇u,∇v⟫e^g − ∫⟪∇g,∇u⟫(v·e^g)`; the weight identity on a product expanded
  by the gradient product rule).
- **`hasDerivAt_integral_weighted_pair`** — differentiation under the weighted pairing:
  `∂t ∫u·v·e^g = ∫(∂tu·v + u·∂tv + uv·∂tg)e^g` for curves with uniform spatial support in a
  compact `K` and jointly continuous data — via Mathlib's
  `hasDerivAt_integral_of_dominated_loc_of_deriv_le` with the bound `K.indicator(sup-on-slab)`
  (the slab `Icc(t₀±1) ×ˢ K` is compact; off `K` the derivative vanishes since `∂t` of the
  identically-zero time-slice is zero by `HasDerivAt.unique`).
- **`hasDerivAt_weighted_pairing_master` — TAO'S MASTER DIFFERENTIAL IDENTITY**
  (1908.04958 §4 Lemma 4.1, first display; the `deriv_pair` field of the ladder-1
  `CommutatorMethod`, realized):
  `∂t⟨u,v⟩_g = ⟨Lu,v⟩_g + ⟨u,Lv⟩_g − 2⟨Su,v⟩_g` with `L = ∂t + Δ`, `S = Δ + ∇g·∇ − F/2`,
  `F = ∂tg − Δg − ‖∇g‖²`, for test-function curves and C² weights. Assembly: the ∂t-value
  plus a spatial residue that the three Green/weight relations cancel exactly
  (`B1 − A1 − 2A2 − C1 = 0` by linarith).
- **Soundness:** no `sorry`; the false variant (the `F`-convention with `+‖∇g‖²` in place of
  `−‖∇g‖²`, same proof script) is REJECTED; LEAN_EXIT=0 vs the lean4-cv Mathlib.
**The entire §4 Lemma 4.1 substrate is now machine-verified end-to-end:** the abstract
commutator chain (ladder-1) + the master identity realizing its `deriv_pair` hypothesis
(ladder-3) + the weight calculus for Tao's two concrete weights (ladder-2 + 3a). Remaining for
Lemma 4.1 itself: bundling into a `CommutatorMethod` instance (the admissible-class design) and
the concrete commutator identification `⟨[L,S]u,u⟩ = ∫(−2D²g(∇u,∇u) − ½(LF)|u|²)e^g`; then
Props 4.2/4.3. `:proved`=0; distance UNTOUCHED. (Concurrent session's uncommitted v0.15.15
entry rides along unmodified.)

## v0.15.15 — 2026-06-11 — NS-013 consolidated: surviving reduction witness-supported (CFM-conditioned probe); open core is analytic

Worked NS-013 (the complex→real obstruction — original map triad-refuted + withdrawn; only a sharpened
`:argued` reduction survives: reality's protection ⟶ emergent CFM/Hou–Li geometric depletion). Built
`scripts/ns013_cfm_conditioned_probe.jl` to witness the reduction's **claim 2** (the CFM mechanism's local
content): the vorticity-direction roughness `⟨|∇ξ|²⟩_w` conditioned on `|ω|`-intensity is **LOWER in the
intense cores** (top-0.1% ≈212 vs bulk ≈369, ratio 0.57) — ξ is comparatively SMOOTH where `|ω|` peaks
(CFM-regular-leaning, consistent with NS-038's `c²_int≈0.72` Hou–Li alignment). The **N-trend** (does the core
ξ-geometry lift with N — the NS-039 D30 pattern) is **GPU-deferred** (N=256↔512). Consolidated the doc
(§Consolidation): **claim 1** (production=phase-coherence) was already SUPPORTED (`ns013_phase_production_3d`:
scramble kills 97–99% of `∫ω·Sω`); claim 2 now witnessed. **The open core is ANALYTIC** — the
Constantin–Fefferman / Hou–Li conditional-regularity criterion's *sufficiency for general data* (unproven; the
discipline forbids manufacturing it). NS-013 stays `:open`; the reduction is `:argued` + witness-supported but
**not re-witnessed** (a triad is the natural next verification). (Also: a power-of-2 FFT gotcha caught — N=96
broke the radix-2 hand-FFT; switched to N=64 + GPU-deferred trend.) Scope: resolved DNS witness, vacuity-capped;
no new NS-ID; `:proved`=0; distance UNTOUCHED.

## v0.15.14 — 2026-06-11 — Carleman ladder-3b-ii (spatial half): the SPATIAL MASTER IDENTITY machine-verified (+ Δ(e^g) chain rule, gradient product rule — more Mathlib gaps filled)

`Carleman.lean` grows a `WeightedGreenAux` section (~1016 lines total). **Library infrastructure;
`:proved`=0 for the PDE.**
- **Helpers (reusable):** `support_laplacian_subset` (Δ vanishes off the closed support — no
  smoothness needed; via `laplacian_congr_nhds`), `continuous_laplacian` (C² ⇒ Δ continuous),
  `continuous_gradient`, `support_gradient_subset`.
- **`gradient_exp_comp`** (`∇(e^g) = e^g•∇g`) and **`gradient_mul`** (`∇(uv) = u•∇v + v•∇u`) —
  pointwise product/chain rules for Mathlib's `gradient` (absent upstream).
- **`laplacian_exp_comp` — the Laplacian chain rule for the exponential weight (Mathlib gap):**
  `Δ(e^g) = (Δg + ‖∇g‖²)·e^g` pointwise for `g` C² — proved by differentiating the CLM-valued
  field `y ↦ e^{g(y)}•Dg(y)` (the same technique as the ladder-3a radial Hessian).
- **`integral_laplacian_mul'`** — the Green identity with compact support on the MULTIPLIER
  (`h` arbitrary C² growth, `w` compactly supported): the variant needed because the weight
  `e^g` is not compactly supported.
- **`integral_weight_laplacian`** — the B8 "double-IBP" half:
  `∫(Δg + ‖∇g‖²)·w·e^g = −∫⟪∇g,∇w⟫·e^g`.
- **`integral_laplacian_pair` — THE SPATIAL MASTER IDENTITY** (the space half of Tao's
  Lemma 4.1 display): `∫(Δu·v + u·Δv)·e^g = ∫((Δg + ‖∇g‖²)·uv − 2⟪∇u,∇v⟫)·e^g` for `u,v` C²
  compactly supported, `g` C². Proof: six integral atoms + the two Green identities + the
  weight-Laplacian identity expanded by the gradient product rule, closed by `linarith`.
  Combined with the time layer (`∂t` under the integral — ladder-3b-iii) this IS
  `∂t⟨u,v⟩ = ⟨Lu,v⟩+⟨u,Lv⟩−2⟨Su,v⟩` with `F = ∂tg − Δg − ‖∇g‖²`.
- **Soundness:** no `sorry`; the false variant (`Δ(e^g) = Δg·e^g`, the `‖∇g‖²` term dropped,
  same proof script) is REJECTED at the final `ring`; LEAN_EXIT=0 vs the lean4-cv Mathlib.
**Honest scope:** spatial (time-frozen). Remaining for the `CommutatorMethod` instance
(ladder-3b-iii): differentiation under the integral for `t ↦ ∫u(t)v(t)e^{g(t)}` + the `F`
bookkeeping + the instance assembly. `:proved`=0; distance UNTOUCHED.

## v0.15.13 — 2026-06-11 — G-4 done: SPEC entry-headers normalized (NS-050/051 pipe → prose; all 36 uniform)

Closed the cosmetic audit gap G-4. The SPEC had **2** entries (NS-050, NS-051) using a pipe-delimited header
line while the other **34** used the prose-header + status convention. Converted NS-050/051 to prose (every
field kept; ` | ` separators → prose punctuation), so all 36 entry headers are now uniform; clarified the
SPEC-header schema note (the `NS-ID | Class | …` line is a field *schema*, not a literal layout). The G-4
description's "NS-049/050/051" over-stated it — NS-049 was already prose; the real split was 34/2. No
status/count change; `:proved`=0; distance UNTOUCHED.

## v0.15.12 — 2026-06-11 — Carleman ladder-3b-i: the weighted Green identity machine-verified (B8/B9 INTEGRATED — S_g self-adjoint on test functions)

`Carleman.lean` grows a `WeightedGreen` section (~625 lines total). **Library infrastructure;
`:proved`=0 for the PDE.**
- **`integral_laplacian_mul` — the Green identity for Mathlib's pointwise `Δ` (another Mathlib gap
  filled, upstreamable):** `∫ Δu·w = −∫ ⟪∇u,∇w⟫` for `u` C² compactly supported, `w` C¹. Proof:
  `Δu = Σᵢ ∂ᵢ(∂ᵢu)` (orthonormal-basis formula + `iteratedFDeriv_two_apply`), per-direction
  n-dim IBP via Mathlib's `integral_mul_fderiv_eq_neg_fderiv_mul_of_integrable` (Gouëzel 2024 —
  the survey's "missing n-dim compact-support IBP" turned out to EXIST in integrability form;
  for compactly supported smooth functions every obligation is automatic), then pointwise
  Parseval `Σᵢ ∂ᵢu·∂ᵢw = ⟪∇u,∇w⟫` (`sum_inner_mul_inner` + `inner_gradient_left`).
- **`gradient_mul_exp`** — `∇(v·e^g) = e^g•∇v + (v·e^g)•∇g` (closed by the `module` tactic).
- **`integral_weighted_green` — record-audit B8 INTEGRATED:**
  `∫ (Δu + ⟪∇g,∇u⟫)·v·e^g = −∫ ⟪∇u,∇v⟫·e^g` — the weighted Green identity, whose RHS is
  symmetric in `u,v`.
- **`integral_Sg_symm` — record-audit B9 INTEGRATED:** the spatial Carleman operator
  `S_g = Δ + ∇g·∇` is **self-adjoint for the weighted pairing** `⟨u,v⟩_g = ∫uv·e^g` on
  compactly supported C² functions. This is the spatial core of Tao's master differential
  identity — the exact self-adjointness input of the ladder-1 `CommutatorMethod`.
- **Soundness:** no `sorry`; the false variant (`∇(v·e^g)` with the `e^g` factor dropped from the
  `∇g` term) is REJECTED by `module`; LEAN_EXIT=0 vs the lean4-cv Mathlib.
**Honest scope:** the spatial (time-frozen) half of the master identity. Remaining for the full
`CommutatorMethod` instance (ladder-3b-ii): the time layer — differentiation under the integral
for `t ↦ ∫ u(t)v(t)e^{g(t)}` and the `F = ∂tg − Δg − |∇g|²` bookkeeping. `:proved`=0; distance
UNTOUCHED.

## v0.15.11 — 2026-06-11 — NS-046 integral/cancellation probe: production-weighted integral form is favorable (witness, sign-caveated)

Ran the one legitimate within-truncation move on NS-046 (the static hole — 6 over-reaches caught; closing it
needs an analytic idea the discipline forbids manufacturing): the **integral/cancellation** object the target
doc names as untested, `scripts/ns046_integral_cancellation_probe.jl`. The PRODUCTION-WEIGHTED integral
`R_int = Σ_w(e₃ᵀ∇²p e₃ + ν|∇ω|²)/Σ_w(λ₃²)`, `w=|ω|²`, on the Kerr worst case: reproduces Idea-3's
enstrophy-weighted pressure ratio (≈1.5 at the peak — a consistency check) and adds (i) the integral
domination **STRENGTHENS on the high-production cores** (top-0.1% `R_int≈3.8`) — so the *production-weighted
integral* (the form the inequality takes) is favorable, *unlike* the uniform-domination probe's UNWEIGHTED
conditional means (non-uniform, negative on bulk); much of the apparent non-uniformity is a **weighting
artifact**; (ii) the scale-resolved margin **shrinks toward 1 at small scales** (≈2.5→1.4, staying >1),
consistent with the doc's "marginal cancellation at the critical scaling" hypothesis. **Witness discipline
caught my own sign sloppiness** (I'd negated `e₃ᵀ∇²p e₃` and double-confused the ratio → spurious R_int=−0.6;
fixed to the uniform-domination convention → R_int=+2.4). **Two guards held:** (a) the depletion SIGN
convention is *adopted* not re-derived — flagged a **Required Check** (pin `Dλ₃ ⊃ −e₃ᵀ∇²p e₃` before trusting
"depletes at cores"); (b) vacuity cap — regular truncation, no singular set, `R_int>1` is a suggestive prior,
NOT the inequality. **NS-046 stays `:open`**; sharpens only WHERE the difficulty sits (small scales). No new
NS-ID; no status change; `:proved`=0; distance UNTOUCHED.

## v0.15.10 — 2026-06-11 — Carleman ladder-3a: the norm-calculus substrate machine-verified (∇‖x‖, Hess‖x‖, the radial Laplacian — a Mathlib gap filled)

New file `formalization/lean-mathlib/NormCalculus.lean` (~180 lines). **Library infrastructure;
`:proved`=0 for the PDE. Generic inner-product-space facts — upstreamable.**
- **`hasFDerivAt_norm` / `hasGradientAt_norm`** — `D‖·‖(x) = ‖x‖⁻¹⟪x,·⟫`, `∇‖·‖(x) = x̂` (`x ≠ 0`;
  via `hasStrictFDerivAt_norm_sq` + the sqrt chain rule).
- **`hasFDerivAt_radial`** — the radial chain rule `D(φ∘‖·‖)(y) = (φ'(r)/r)⟪y,·⟫`.
- **`iteratedFDeriv_two_radial_apply`** — the radial Hessian:
  `D²(φ∘‖·‖)(x)[v,w] = (φ'/r)⟪v,w⟫ + (φ''/r² − φ'/r³)⟪x,v⟫⟪x,w⟫` — proved by differentiating the
  CLM-valued derivative field `y ↦ (φ'(‖y‖)·‖y‖⁻¹) • innerSL ℝ y` (smul/mul/inv FDeriv rules +
  `EventuallyEq.fderiv_eq` + `iteratedFDeriv_two_apply`).
- **`iteratedFDeriv_two_norm_apply`** — `Hess‖·‖ = (I − x̂x̂ᵀ)/‖x‖` (record-audit **B11c in genuine
  vector form**, upgrading the ladder-2 radial eigenvalue facts).
- **`laplacian_radial`** — **the ladder-2 → 3D identification:**
  `Δ(φ∘‖·‖)(x) = φ''(r) + ((d−1)/r)·φ'(r)` against Mathlib's pointwise `Laplacian` (Kebekus), via
  the orthonormal-basis formula + Parseval (`sum_sq_inner_left`); corollary `laplacian_norm`
  (`Δ‖·‖ = (d−1)/‖x‖`). With this, the ladder-2 radial F/LF displays ARE the d=3 vector-calculus
  quantities for Tao's weights.
- **Soundness:** no `sorry`; the false variant (`(d+1)/r` for `(d−1)/r`, same proof script) is
  REJECTED at the final field algebra; LEAN_EXIT=0 vs the lean4-cv Mathlib. Lakefile target added.
**Mathlib-gap note:** at the pinned rev Mathlib has the pointwise `Laplacian` + `contDiffAt_norm`
but no radial computation lemmas — this file is the missing layer and is upstreamable as-is.
`:proved`=0; distance UNTOUCHED. *Next: ladder-3b — the weighted-L² master identity.*

## v0.15.9 — 2026-06-11 — Triad VERDICT + (C0) gate: adaptive solver BANKED (B); NS-050 β transfers to the wall but is data-starved

Closed the triad pass on the adaptive-solver decision. Both seats (Grok edge-witness Φ + ChatGPT synthesis)
returned: **C1 REFUTED** (a full adaptive solver (A) is an infrastructure project disguised as witness
completion — dominated for the stated objective), **C3 CORRECT** (witness-tier ceiling; "closing in on the
singularity" is a category error), **C4 NOT ESTABLISHED** (completing the cells is incremental), and the
synthesis sharpened **C5** into a falsifiable gate **(C0 → C-if-valid → else B)**. Ran (C0)
(`scripts/ns048_c0_boundary_transfer.jl`): the NS-050 two-scale estimator **does transfer** to a clean
wall-pinned self-similar collapse (β recovered to **0.2%** — the synthesis was right vs Grok's "likely
invalid"; the boundary is an anchor, not a contaminant) BUT a competing **fixed** length-scale contaminates it
(32–52%), and the real wall DNS is too short / unclean to supply a clean window ⇒ **DECISION: bank (B)** —
cells (ii)/(iii) stay resolution-limited; **(C) is estimator-licensed but data-starved** (unlocked for a future
cleaner collapse); **(A) dominated**. Folded in two over-reach catches: tightened the map's "vacuous for the
actual mechanism" → "**non-discriminating in the resolved truncation**" (the seat's "vacuous ⇏ irrelevant to
PDE truth" catch). Artifacts: `docs/ns048_adaptive_solver_triad_{brief,verdict}.md`,
`scripts/ns048_c0_boundary_transfer.jl` (+`.out.txt`). No build; no new NS-ID; `:proved`=0; distance UNTOUCHED.

## v0.15.8 — 2026-06-11 — Triad brief OPENED: should we build the adaptive/moving-mesh swirl solver?

Before sinking a Chen–Hou-class effort into an adaptive solver to complete the vacuity map's resolution-limited
cells, subjected the *decision* to an adversarial triad pass: `docs/ns048_adaptive_solver_triad_brief.md`.
Frames three options — **(A)** full adaptive/moving-mesh solver (skeptic: reproduces Chen–Hou, multi-month,
stays vacuity-capped), **(B)** build nothing (bank the resolution-limited finding), **(C)** reuse the
*already-validated* NS-050 dynamic-rescaling instrument (CLM β=1, HL β=2.47) to read the `|x₃|^α` self-similar
exponent in a rescaled frame without a moving mesh. The crux claim for the seats (C2): does dynamic rescaling
around a **wall corner** preserve a well-defined self-similar exponent, or does the fixed wall length-scale
void the interior ansatz the instrument was validated on? Internal pre-screen leans **(C)-if-valid-else-(B);
(A) over-investment** — but flags two self-biases (sunk-cost-stop; tool-attachment to the author's own NS-050
instrument) for the external seats to break. **Awaiting Grok edge-witness Φ + Gemini synthesis.** No build
started; no new NS-ID; `:proved`=0; distance UNTOUCHED.

## v0.15.7 — 2026-06-11 — Hou–Luo wall fixture: swirl INTENSIFIES (mechanism confirmed) but goes unresolved (Chen–Hou regime)

Added a `wall` mode to `scripts/ns048_axisym_swirl_dns.jl` — the validated `(r,z)` swirl solver with a z-odd
wall-adjacent swirl IC (the Hou–Luo mechanism: the swirl gradient drives a convergent meridional flow that
compresses vorticity against the no-penetration wall + z-symmetry planes). **Result:** the flow **intensifies
hard** — ‖ω‖ 0→24.7, ‖ω^θ‖ 0→83 by t=0.5 (resolved), swirl concentrating **at the wall** (`r*`→3.34 of R=4) —
which the relaxing axis-blob never did, so the intensification mechanism is real. **But it goes UNRESOLVED**
(spurious energy growth `E/E0→1.32`, then NaN) by t≈0.75 even at ν=2.5e-3 / 192×160. Witness discipline caught
this: the apparent `ℓ_z` z-concentration and the ×100+ Type-I growth live entirely in the *unresolved* phase
(grid-scale spike); over the resolved phase `ℓ_z` does NOT narrow (1.82→1.97) and `I` grows only ×1.36. So the
vacuity-map cells **`|x₃|^α` + Type-I are RESOLUTION-LIMITED**, not measured — a clean read needs adaptive
ultra-resolution (the **Chen–Hou** regime). That negative is itself the finding: the witness numerically
reproduces *why* the Hou–Luo blowup required heavy computer-assisted machinery. Two earlier overclaim/garbage
readings (divide-by-~0 `ℓ_z`, unresolved-phase contamination) were caught and fixed before recording. Map doc
+ NS-048 source/registry/dashboard updated; no new NS-ID. `:proved`=0; Scope resolved-DNS witness.

## v0.15.6 — 2026-06-11 — Carleman ladder-2: the radial weight calculus machine-verified (Tao's F/LF/Hessian displays, B11/B12 lean-proved)

`formalization/lean-mathlib/Carleman.lean` grows a `WeightCalculus` section (~375 lines total).
**Library infrastructure; `:proved`=0 for the PDE.**
- Tao's two Carleman weights are radial; for `g = φ(t,‖x‖)` in `d = 3` the Lemma-4.1 quantities
  reduce to `F = ∂tφ − (∂rrφ + (2/r)∂rφ) − (∂rφ)²`, `LF = ∂tF + ∂rrF + (2/r)∂rF`, and the
  Hessian eigenvalues `∂rrφ` (radial) / `(∂rφ)/r` (tangential, double). This rung machine-verifies
  the paper's pp. 30/33 displays AT THE RADIAL LEVEL — every partial pinned by an explicit
  `HasDerivAt` witness, every display an exact field identity.
- **First weight** `φ = α(T₀−t)r + r²/(C₀T)` (Prop 4.2): witnesses for `∂t g`, `∂r g`, `∂rr g`,
  `∂t F`, `∂r F`, `∂rr F`; **`F42_eq` (= B11a)** and **`LF42_eq` (= B11b)** — the two p. 30
  displays; **`g42_radial_hess_lower` (= B11c radial)** — radial eigenvalue exactly `2/(C₀T)`,
  tangential `≥ 2/(C₀T)` when `α(T₀−t) ≥ 0 < r`: Tao's convexity input `D²g ≥ (2/C₀T)·I`.
- **Second weight** `φ = −r²/4(t+t₁) − (3/2)log(t+t₁) − α·log((t+t₁)/(T₀+t₁)) + α(t+t₁)/(T₀+t₁)`
  (Prop 4.3, the modified heat-kernel log): witnesses incl. the `Real.log` chain rules;
  **`F43_eq` (= B12a)** — the Gaussian and `3/(2τ)` contributions cancel exactly, `F` is
  `r`-INDEPENDENT; **`LF43_eq` (= B12b)** `LF = α/(t+t₁)²`; **`g43_radial_hess` (= B12c)** —
  the Hessian is exactly `−I/(2(t+t₁))` (both eigenvalues equal).
- **Soundness:** no `sorry`; the false variant (the `−8α(T₀−t)/(C₀Tr)` term of `LF42`
  sign-flipped, mirroring the sympy false variant) is REJECTED; LEAN_EXIT=0 vs the lean4-cv
  Mathlib.
**Honest scope:** radial level. The 3D identification `Δ(φ∘‖·‖) = ∂rrφ + (2/r)∂rφ` needs the
gradient/Hessian-of-norm substrate — verified to be a genuine Mathlib gap (Mathlib has a pointwise
`Laplacian` + `contDiffAt_norm` but no computation lemmas: no `Δ‖x‖²`, no product/chain rule, no
gradient-of-norm) — that substrate is ladder-3 alongside the weighted-L² master identity.
`:proved`=0; distance UNTOUCHED. *Next:* ladder-3 — norm-calculus substrate (∇‖x‖, Hess‖x‖,
`Δ(φ∘‖·‖)`) or the weighted-L² `CommutatorMethod` instance.

## v0.15.5 — 2026-06-10 — Carleman ladder-1: the commutator-method core machine-verified (Tao Lemma 4.1's operator algebra)

New file `formalization/lean-mathlib/Carleman.lean`. **Library infrastructure; `:proved`=0 for the PDE.**
- **`bilinear_expansion`** (= record-audit B10, now lean-proved): `⟨Lu,Sv⟩+⟨Su,Lv⟩−2⟨Su,Sv⟩ =
  ½⟨Lu,Lv⟩ − ½⟨(L−2S)u,(L−2S)v⟩` for ANY bilinear `B` — pure bilinearity, the algebraic pivot of
  Tao's chain.
- **`CommutatorMethod`** — the abstraction of Tao §4's setup: time-dependent symmetric
  positive-semidefinite pairing `P t`, evolution operator `L` on curves (may consume `∂t`),
  time-dependent `S` with (i) `P`-self-adjointness (= B9 integrated), (ii) stability of the
  admissible curve class under `S`, (iii) the **master differential identity**
  `∂t P(a,b) = P(La,b)+P(a,Lb)−2P(Sa,b)` (= B8/IBP integrated — Tao's first display).
- **`hasDerivAt_pair_S` — Tao's commutator chain, machine-verified:**
  `∂t⟨Su,u⟩ = ⟨[L,S]u,u⟩ + ½⟨Lu,Lu⟩ − ½⟨(L−2S)u,(L−2S)u⟩`, with `[L,S]u` the curve-level
  commutator `L(S∘u) − S∘(Lu)` (the paper's `u≡1` coefficient trick is not needed at this rung —
  divergence point (i) of the ladder-0 audit).
- **`deriv_pair_S_le`** — drop-the-square: `∂t⟨Su,u⟩ ≤ ⟨[L,S]u,u⟩ + ½⟨Lu,Lu⟩`, Lemma 4.1's
  driving differential inequality.
- **Soundness:** no `sorry`; the false variant (coefficient `1` for `½` in B10) is REJECTED;
  LEAN_EXIT=0 vs the lean4-cv Mathlib. Registered in the lakefile.
**Honest scope:** the algebra ONLY. The analytic instantiation (weighted-L² pairing on
test-function curves; the master identity via IBP + differentiation under the integral; the
concrete `⟨[L,S]u,u⟩ = ∫(−2D²g(∇u,∇u)−½(LF)|u|²)e^g`) is ladder-2/3. `:proved`=0; distance
UNTOUCHED. *Next:* ladder-2 — the weight calculus (B11/B12 as Lean lemmas) or the master identity.

## v0.15.4 — 2026-06-10 — Axisymmetric swirl DNS: closes the vacuity map's swirl-sign cell (Γ≥0 true-but-useless)

Built `scripts/ns048_axisym_swirl_dns.jl` — a faithful axisymmetric NS-with-swirl solver (Hou–Li nice
variables `u₁=u^θ/r, ω₁=ω^θ/r, ψ₁=ψ/r²`; cell-centered r, z-periodic FD, flux-form radial operator, sparse 2D
Poisson LU, RK4). **Validated 4/4**: radial operator 2nd-order vs analytic `(4r²−8)e^{−r²}` (rate 3.5),
divergence-free to 5.7e-4, `cos(kz)` diffusion = `exp(−νk²t)` to 3e-4, inviscid `‖Γ‖∞` max-principle conserved
(0% drift). This addresses the vacuity map's 3 deferred axisymmetric-swirl cells:
- **swirl-sign — CLOSED.** On a single-signed z-modulated swirl blob, Γ=r·u^θ stays **≥0** (max principle
  confirmed), but `sign(Γ)` predicts `sign(S=∂_z(u₁²)∝Γ∂_zΓ)` only **50%** of the time (**correlation 0**) —
  Γ≥0 is *true but useless* as a control on the source (structural: `sign S = sign ∂_zΓ`, indefinite).
  Numerically confirms `ns048_swirl_sign_condition_attack`. The map is now **8 criteria, none both true and
  useful**.
- **`|x₃|^α` growth + Type-I `I` — PARTIAL.** The no-boundary single-blob viscously relaxes (Γmax 0.376→0.366,
  scaled-energy decreases) rather than intensifying, so neither concentration develops. Honestly recorded as
  needing a genuinely intensifying fixture (a Hou–Luo **wall** / colliding-jet IC on the same validated
  solver) — its own DNS session. (A reporting bug — a divide-by-~0 growth ratio — was caught by the witness
  pass and fixed before recording.) Referenced from NS-048; no new NS-ID. `:proved`=0; Scope resolved-DNS witness.

## v0.15.3 — 2026-06-10 — Carleman ladder-0: Tao §4 full-text audit — "IBP-only" CONFIRMED, all §4 identities sympy-verified

Closes ladder-0 of the Carleman plan (the deep-research recalibration's bite zero: the "summit"
framing was challenged and collapsed; the one unverified reading was Tao §4's toolkit, known only
from a truncated fetch). Full PDF read end-to-end (arXiv 1908.04958 §4, pp. 27–36: Lemma 4.1 +
Props 4.2/4.3 **with complete proofs**).
- **VERDICT: CONFIRMED — no ψDO, no microlocal, no Fourier, no spectral theory, no compactness
  anywhere in §4.** Complete toolkit: weighted L² inner products + IBP (compact support, no
  boundary terms); S/A splitting + the commutator chain ∂t⟨Su,u⟩ = ⟨[L,S]u,u⟩ + ½⟨Lu,Lu⟩ −
  ½⟨(L−2S)u,(L−2S)u⟩; explicit weight calculus; smooth cutoffs; pigeonhole-in-time;
  integrating-factor energy method; one 1-variable max inequality; heavy constant bookkeeping.
- **record_audit.py B8–B13 (per the standing transcription rule), all PASS:** the Lemma-4.1 IBP
  divergence identity; S self-adjointness up to exact divergence (any F); the bilinear
  operator-algebra expansion; Prop 4.2's F/LF displays + Hess(|x|) = (I−x̂x̂ᵀ)/|x|; Prop 4.3's
  F/LF + D²g = −I/2(t+t1) exactly; the max inequality. A sign-flipped LF false variant is
  REJECTED (residual 16αs/C0Tr).
- Three formalization divergence points recorded (u≡1 commutator trick → direct coordinate
  computation; g smooth-near-supp(u) weakening; ∂t-under-∫ justification).
- Doc: `docs/carleman_ladder0_tao_sec4_audit.md`. Evidence: algebraic (sympy) for identities,
  manual for the toolkit inventory. No spec changes; `:proved`=0; distance UNTOUCHED.
*Next:* ladder-1 — Lemma 4.1's S/A commutator chain as Lean operator algebra (B8–B10 = blueprint).

## v0.15.2 — 2026-06-10 — Conditional-criterion vacuity map v1 (NS-048 witness): do the literature's exclusion hypotheses hold on real flow?

Built the prioritized batch study from the frontier review: `docs/ns048_conditional_vacuity_map.md` — a
witness-tier liveness matrix generalizing the NS-049 `δ_Λ` probe across **7 conditional blowup-exclusion
hypotheses**, measured on the resolved near-singular DNS fixtures (TG, vortex-tube / Kerr) by harvesting the
committed probe outputs + computing the W2 detector ratio (`Σⱼ‖Δⱼω‖∞/‖ω‖∞`) from the Besov shells.
**Finding (suggestive prior, NOT a proof — every cell is a regular truncation that cannot reach the singular
limit):** not one of the 7 holds cleanly — `δ_Λ` stays multi-directional at the cores (Lockwood's hypothesis
vacuous), the CKN ≤1 box-dimension **lifts 0.986→1.426 under N=256→512** (resolution artifact),
pressure-Hessian domination is bulk-negative / cores-only with the margin shrinking 10.9→1.5 as production
grows, Beltramization is helicity-conditional and de-Beltramizes, the Besov diagnostics are vacuity-capped.
Coherent read: the cheap *conditional* exclusion routes are plausibly vacuous for the actual mechanism — a
**where-not-to-look** prior that serves the search-efficiency mission. 3 axisymmetric-swirl cells (`Γ`-sign,
`|x₃|^α`, Type-I `I`) deferred — they need a new `(r,z)` fixture (a natural next DNS session). Referenced from
NS-048; **no new NS-ID** (a synthesis of existing witnesses, not a new claim). `:proved`=0; distance UNTOUCHED.

## v0.15.1 — 2026-06-10 — A7/W3 closed: substrate_source for NS-023/024/037 + Q₁₀₂ exact cross-build artifact

Located the canonical upstream — "closure-v5" is the repo **`closure-forces-structure`** (local folder
"Closure v5") — and added **real** `substrate_source` fields (no fabricated SHAs): NS-023 `@9e2f73c` (Q₁₀₂
data), NS-024 `@fa39070` (GPG/Order arc), NS-037 `@860a65a` (inverse-Born methodology). **W3 was mis-scoped:**
NS-022 is Waleffe-1992 (a published paper, not closure-v5) → dropped. **NS-023 fully A7-closed** with a
committed cross-build artifact `scripts/ns023_q102_exact_vs_fidelity.jl` (**T-29**): it sha256-pins the
canonical bytes (commit `9e2f73c`), verifies local Q₁₀₂ == canonical EXACTLY (n_cl=102=2×51, J²=+1, γ, 2571
edges, |C| extremes 2/72 reproducing the local v1 run), and proves the "too symmetric to localize a gate"
verdict is an EXACT symmetry — J is an exact automorphism of the coupling C (18 distinct |C| values among
2571 edges; sector degree-multisets J-identical) — so the original Float64 gating-null reflects exact
structure, not noise. **10/10 checks PASS.** NS-024/037 are `:argued`, so the field suffices (no artifact
required). Dashboard G-2 / W3 → DONE. `:proved`=0; Scope ≠ PDE throughout.

## v0.15.0 — 2026-06-10 — APPROXIMATION OF IDENTITY S_M → id: the Littlewood–Paley EXPANSION of 𝓢′ + full distributional nondegeneracy

The convergence layer, in `formalization/lean-mathlib/LittlewoodPaley.lean` (~1747 lines).
**Library infrastructure; `:proved`=0 for the PDE.**
- **`exists_seminorm_smulLeft_lpChiAtC_sub_le` — the analytic heart:** every Schwartz seminorm of
  `χ_M·ψ − ψ` is `≤ K(k,n,ψ)·2^{−M}`. Inside `‖ξ‖ ≤ 2^M` the cutoff difference vanishes identically
  (support argument through `tsupport` + `support_iteratedFDeriv_subset`); outside, the Leibniz rule
  (`norm_iteratedFDeriv_mul_le`) + **uniform-in-`M` bounds on the dilated-bump derivatives**
  (`‖iFD^i χ_M‖ ≤ B_i` since `‖L_M‖ ≤ 1` — dilation only shrinks) + ONE extra power of the Schwartz
  decay of `ψ` produce the `2^{−M}` gain.
- **`tendsto_smulLeftCLM_lpChiAtC`** — `χ_M·ψ → ψ` in the **Schwartz topology** (via
  `schwartz_withSeminorms.tendsto_nhds` + the decay estimate).
- **`tendsto_lpLowProjDAt`** — **`S_M u → u` in `𝓢′`** (genuine weak-* convergence in the
  pointwise-convergence topology, via `PointwiseConvergenceCLM.tendsto_iff_forall_tendsto` +
  continuity of `u` + continuity of `𝓕` on `𝓢`).
- **`tendsto_lowProjD_add_sum` — THE LITTLEWOOD–PALEY EXPANSION OF A TEMPERED DISTRIBUTION:**
  `S₀u + Σ_{j<M} P_{j+1}u → u` in `𝓢′` — every tempered distribution is the (weak-*) sum of its
  Littlewood–Paley series. (Combines the v0.14.0 exact finite decomposition with `S_M → id`.)
- **`eq_zero_of_lp_blocks_eq_zero`** — a tempered distribution with no LP content is zero
  (limit uniqueness; `𝓢′` is T2).
- **`besovNormD_eq_zero_iff` — FULL NONDEGENERACY ON ALL OF `𝓢′`:** `‖u‖_{B^s_{p,q}} = 0 ↔ u = 0`
  for EVERY tempered distribution (not just embedded Schwartz functions) — norm-zero kills every
  `Lᵖ`-representative block, and the LP expansion reassembles `u = 0`. With `besovNormD_coe`,
  **`B^s_{p,q}(𝓢′)` is a genuine normed space of tempered distributions.**
- **Soundness:** no `sorry`; the false window variant (`χ_M = 1` out to radius `2^{M+1}`) is
  correctly REJECTED (the `−M+(M+1)=1≠0` arithmetic fails); LEAN_EXIT=0 vs the lean4-cv Mathlib.
**Honest scope:** weak-* (pointwise) convergence — the conventional 𝓢′ topology (Mathlib's choice;
not the strong dual). Completeness of `B^s_{p,q}` and the embedding theorems remain open.
`:proved`=0; distance UNTOUCHED. *Next: CARLEMAN (the summit) — session pauses here.*

## v0.14.2 — 2026-06-10 — Pre-commit ledger guard (G-3): blocks count/stamp drift at commit time

Built the escalation the close-out clause called for after count drift was audit-caught twice:
`scripts/check_ledger_counts.sh` (POSIX, no deps, also runnable standalone for an audit) +
`.githooks/pre-commit` (activated by `core.hooksPath=.githooks`, version-controlled). It blocks a commit when
(1) SPEC entry-headers ≠ registry rows, (2) the "(N entries)" / "SPEC N entries" / "N ledger entries" claims
in SPEC / `dashboard.md` / `CLAUDE.md` disagree with the actual count, or (3) the SPEC header stamp ≠ the
`CLAUDE.md` Status stamp; a missing claim is a loud WARN (re-anchor the grep), not a block; bypass with
`git commit --no-verify`. Verified: PASS on the consistent tree (36 entries), FAIL + exit-1 on injected count
and stamp mismatches. `CLAUDE.md` is gitignored/local so its checks skip cleanly when absent. Dashboard
**G-3 → DONE**. `:proved`=0; distance UNTOUCHED.

## v0.14.1 — 2026-06-10 — A0–A7 cross-audit (post-NS-051) + count/stamp fix; gaps tabled in dashboard

Ran the A0–A7 cross-audit after the NS-051 ledger addition. **A1/A2/A3/A4 PASS** — 36 entries ↔ 36 registry
rows, 0 orphans; all 90 file refs + 9 NS-051 `formalization/` files exist; statuses consistent; `:proved`=0
genuine (NS-051 deliberately held at `:tested` though its evidence is `lean-proved`, since `:proved` is
reserved for Scope:PDE). **A6 PASS** (note: no automated CI; committed `.out.txt` + no-`sorry` compile are the
discipline). **3 gaps:** **A5/A0** — `dashboard.md` + `CLAUDE.md` still said "35 entries"/`v0.11.1` (the NS-051
close-out updated SPEC but missed these two) → **fixed to 36 / v0.12.0**; **A7 (W3)** — NS-022/023/024/037
cite closure-v5 without a `substrate_source` field (path public-unresolvable) → carried; **meta** —
count/stamp drift caught **again** (also 2026-06-09) → the close-out clause's escalation trigger (a pre-commit
count/stamp guard) is now recommended. Priorities + audit gaps + open items are tabled at the top of
`dashboard.md` (**Status board**). `:proved`=0; distance UNTOUCHED.

## v0.14.0 — 2026-06-10 — DISTRIBUTIONAL BESOV SPACE: B^s_{p,q} ⊂ 𝓢′ — membership, norm-extension, exact finite LP decomposition of 𝓢′

The distributional Besov layer, in `formalization/lean-mathlib/LittlewoodPaley.lean` (~1465 lines).
**Library infrastructure; `:proved`=0 for the PDE.**
- **`sum_range_lpSymbolAt`** — finite telescoping `Σ_{j<M} ψ_{j+1}(ξ) = χ(2^{−M}ξ) − χ(ξ)`, every `ξ`,
  every window `M` (the exact, no-limit form of the partition).
- **`lpLowProjD` / `lpLowProjDAt` / `lpProjD_eq_sub`** — the low-pass `χ(D)` and the dilated partial-sum
  low-passes `S_M = χ(2^{−M}·)(D)` on tempered distributions; each block is `P_{j+1} = S_{j+1} − S_j`.
- **`lpLowProjDAt_eq_add_sum` — the EXACT finite Littlewood–Paley decomposition of `𝓢′`:** as operators,
  `S_M = S₀ + Σ_{j<M} P_{j+1}` — every finite frequency window reassembles exactly; nothing is lost at
  any finite stage. (Via a new symbol-subtractivity lemma for Mathlib's
  `TemperedDistribution.fourierMultiplierCLM` + operator-level `Finset.sum_range_sub`.)
- **`lpProjD_coe` / `lpLowProjD_coe`** — the distributional projections **EXTEND the Schwartz ones**
  through the canonical embedding `ι : 𝓢 ↪ 𝓢′` (`P_j ∘ ι = ι ∘ P_j`).
- **`HasLpRep` + `lp_toTemperedDistribution_injective` + `lpNormD`** — "this distribution IS an `Lᵖ`
  function": the `Lᵖ→𝓢′` embedding is injective (Mathlib's `ker_toTemperedDistributionCLM_eq_bot`), so
  the `Lᵖ` representative is UNIQUE and `lpNormD` (its `eLpNorm`, `∞` if none) is well-defined
  (`lpNormD_eq_of_rep`); on embedded Schwartz functions it is the plain `Lᵖ` norm (`lpNormD_coe`).
- **`besovNormD` + `MemBesovD` — the distributional Besov space:** `u ∈ B^s_{p,q}(V;W) ⊂ 𝓢′` iff its
  blocks have `Lᵖ` representatives with finite weighted `ℓ^q` size. **Membership forces every block to
  BE an `Lᵖ` function** (`MemBesovD.hasLpRep_low` / `.hasLpRep_block`).
- **`besovNormD_coe` — the extension theorem:** `‖ι f‖_{B^s_{p,q}(𝓢′)} = besovNormI f` — the
  distributional norm restricted to Schwartz functions IS the v0.13.0 Schwartz Besov norm; with it,
  nondegeneracy transfers (`besovNormD_coe_eq_zero_iff`), membership reduces (`memBesovD_coe_iff`),
  and `0 ∈ B^s_{p,q}` with norm `0`.
- **Soundness:** no `sorry`; the false telescoping variant (low-pass term dropped — `Σψ = χ(2^{−M}ξ)`)
  is correctly REJECTED; LEAN_EXIT=0 vs the lean4-cv Mathlib.
**Honest scope:** the space, its norm, membership, and the exact finite decomposition — at the level of
`𝓢′` with `Lᵖ`-representative blocks. The remaining structural work: `S_M u → u` in `𝓢′` (the
approximation-of-identity limit, needs Schwartz-seminorm convergence estimates), completeness, and
embeddings. `:proved`=0; distance UNTOUCHED. *Next:* `S_M → id` convergence or Carleman.

## v0.13.2 — 2026-06-10 — Lean formalization ladder ledgered (NS-051) + Lean→citation bridge

Closed audit item **N2**: the `formalization/` Python→Julia→Haskell→Lean ladder — the repo's
strongest-evidence-class work (machine-verified) — was ledger-invisible (0 rows in SPEC/registry/TEST_SPEC).
Now captured as **NS-051** (PROGRAM, `:tested`, **Scope: methodology/formalization ≠ PDE**), with **T-27**
(Rung 0 scaling-criticality: `lean/Scaling.lean` hermetic + `lean-mathlib/ScalingUniversal.lean`
universal-∀-Mathlib, no-`sorry`, false-variant rejected; Julia exact + Haskell typed) and **T-28** (analysis
substrate `WeakLp`/`LittlewoodPaley`/Besov → Carleman, in progress). **Firewall preserved:** a `lean-proved`
*definition* is not a `Scope: PDE` statement, and this ledger reserves `:proved` for Scope:PDE — so NS-051
sits at `:tested`; `:proved`=0 / distance UNTOUCHED is unbroken. Per the sub-claim≠entry rule it hardens
NS-002/NS-034's *definitions* without upgrading their PDE status. **Lean→citation bridge** added (the upstream
half of `docs/citation_tiers.md`): when a Lean rung formalizes a *cited* theorem's core (the NRŠ H-identity
now; Carleman→ESS/NS-005 later) that citation's tier rises and the index updates (close-out item (vi)) —
currently wired, not yet fired. The concurrent Lean session's `formalization/lean-mathlib/*.lean` files were
left untouched; NS-051 is characterized from `formalization/README.md` + the changelog and held conservative
pending their confirmation. SPEC count 35→36 (3 PROGRAM), stamp v0.11.1→v0.12.0.

## v0.13.1 — 2026-06-10 — Consolidated citation-tier index (`docs/citation_tiers.md`)

Surfaced the C0–C5 citation discipline that was *practiced but scattered* — the per-citation tier
assignments lived inline across ~5 files (45 mentions in `SPEC.md` alone) with **no consolidated table**, a
gap once the public `README.md` claims "every load-bearing citation carries a C0–C5 tier." `docs/citation_tiers.md`
now gathers every load-bearing external citation → its tier, what was verified, and the dependent NS-IDs,
by category (hard obstructions G1–G5; soft framings S1/S2; the NS-048 ancient/Liouville frontier; NS-049
Lockwood; NS-050 modulation prior art; non-PDE related). It foregrounds the genuine value — the **errors the
verification caught** (the Albritton–Barker *misattribution* + the Type-I-conditioned scope correction; the
NRŠ H-identity record error; the Wang endpoint hardening) — and is honest about limits (no C4/C5 yet;
statement-level C2 flagged as not-separately-verified). Pointers added in the SPEC header (where C0–C5 is
defined) and the README (nav table + the tier-claim line). `:proved`=0; distance UNTOUCHED.

## v0.13.0 — 2026-06-10 — BESOV SPACE OPENED: the inhomogeneous partition + besovNormI is a genuine NORM + distributional P_j

The Besov-space layer, in `formalization/lean-mathlib/LittlewoodPaley.lean` (~1190 lines total).
**Library infrastructure; `:proved`=0 for the PDE.**
- **`hasSum_lpSymbolAt_nat`** — the **inhomogeneous partition of unity**: for EVERY `ξ` (including
  `ξ = 0`), `Σ_{j≥1} ψ_j(ξ) = 1 − χ(ξ)`. The low-pass `χ` absorbs the origin, so the inhomogeneous
  theory needs **no quotient by polynomials**. (At `0` all annulus symbols vanish and `χ(0)=1`;
  for `ξ≠0` a finite window + telescoping via `Finset.sum_range_sub`.)
- **`lpLowProj` (= `χ(D)`) and `besovNormI W s p q f`** — the inhomogeneous Besov norm on Schwartz
  functions: low block + `ℓ^q(ℕ)` of the weighted high blocks `2^{(j+1)s}‖P_{j+1}f‖_{Lᵖ}`.
- **`besovNormI_eq_zero_iff` — THE structural theorem: it is a genuine NORM** (`‖f‖_{B^s_{p,q}} = 0
  ↔ f = 0`, any `s`, `p ≠ 0`, `q ≠ 0`). Forward: norm-zero ⇒ every block vanishes (ENNReal
  `add/tsum/iSup/rpow`-zero extraction) ⇒ each block is the zero Schwartz function
  (`eLpNorm_eq_zero_iff` + `Continuous.ae_eq_iff_eq`, volume open-positive) ⇒ the multiplier
  identities kill `σ(ξ)•𝓕f(ξ)` pointwise (`smul_fourier_eq_zero_of_multiplier_eq_zero`, via
  `𝓕∘𝓕⁻ = id`) ⇒ the partition reassembles `𝓕f(ξ) = (χ + Σψ_j)(ξ)•𝓕f(ξ) = 0` (`HasSum.smul_const`
  + uniqueness) ⇒ `f = 𝓕⁻(𝓕f) = 0`. **This makes `B^s_{p,q}` a normed space on 𝓢.**
- **`lpProjD` + `lpProjD_comp_eq_zero`** — the Littlewood–Paley projections on **tempered
  distributions** (Mathlib's `TemperedDistribution.fourierMultiplierCLM`) with gap-2 disjointness —
  the door to the full distribution-level Besov space. (Quirk found: Mathlib's `𝓢'`-composition
  lemma is REVERSED relative to the Schwartz one — `mult g₂ ∘L mult g₁ = mult (g₁·g₂)`.)
- **Soundness:** no `sorry`; the false window-arithmetic variant (`M ≥ L` for `M ≥ L+1`) is rejected;
  LEAN_EXIT=0 vs the lean4-cv Mathlib.
**Honest scope:** norm + projections at Schwartz/distribution level; the full Besov *space* of
distributions (membership via `lpProjD`-blocks in `Lᵖ`, completeness, embeddings) is the remaining
structural work. `:proved`=0; distance UNTOUCHED. *Next:* Besov embeddings / distributional space →
Carleman.

## v0.12.0 — 2026-06-10 — SHARP Lᵖ BERNSTEIN machine-verified: ‖∂_m P_j f‖_p ≤ 2π·2^j·C(m)·‖P_j f‖_p, all 1 ≤ p < ∞

The Littlewood–Paley layer's capstone, in `formalization/lean-mathlib/LittlewoodPaley.lean`
(~930 lines total). **Library infrastructure; `:proved`=0 for the PDE.**
- **`eLpNorm_lineDerivOp_lpProj_le_lp_sharp`** — the sharp `Lᵖ` Bernstein inequality:
  `‖∂_m P_j f‖_{Lᵖ} ≤ 2π·2^j·C(m)·‖P_j f‖_{Lᵖ}` for every `1 ≤ p < ∞`, with
  `C(m) = ‖𝓕⁻σ₀‖_{L¹}` **j-independent** (finite: the kernel is Schwartz).
- **The assembly, machine-checked end-to-end:** (i) the fattened symbol `lpFat` (`≡1` on the annulus
  `1/2 ≤ ‖η‖ ≤ 2 ⊇ supp ψ`, supported in `1/4 < ‖η‖ < 4`); (ii) the Schwartz kernel-symbol family
  `bernSymbol j m = ⟨ξ,m⟩·χ̃(2^{−j}ξ)` (via `HasCompactSupport.toSchwartzMap`); (iii) the symbol
  identity `⟨ξ,m⟩ψ_j = σ_jψ_j` on `supp ψ_j` ⇒ `∂_m P_j = 2πi·σ_j(D)∘P_j` (the general ℝ/ℂ multiplier
  bridge `fourierMultiplierCLM_real_coe`); (iv) Stage A: the `Lᵖ` multiplier theorem gives the bound
  with `‖𝓕⁻σ_j‖_{L¹}` (`eLpNorm_lineDerivOp_lpProj_le_lp`); (v) Stage B, **the dilation**: the symbol
  identity `σ_j = 2^j·σ₀(2^{−j}·)` (`bernSymbolFun_eq_smul`), the kernel identity
  `(𝓕⁻σ_j)(x) = 2^{j(d+1)}(𝓕⁻σ₀)(2^jx)` (`fourierInv_bernSymbol_eq`, computed through
  `Real.fourierInv_eq` + the Haar change-of-variables `Measure.integral_comp_smul`), and the `L¹`
  scaling `‖𝓕⁻σ_j‖₁ = 2^j‖𝓕⁻σ₀‖₁` (`eLpNorm_fourierInv_bernSymbol` — the `2^{j(d+1)}·2^{−jd} = 2^j`
  collapse).
- **Soundness:** no `sorry`; the false dilation-exponent variant (`2^{2j}` for `2^j`) is rejected;
  LEAN_EXIT=0 vs the lean4-cv Mathlib.
**The Littlewood–Paley layer is now complete through sharp Bernstein:** partition of unity → `P_j` →
almost-orthogonality → Besov seminorm → Bernstein L² → Young + multiplier-convolution bridge →
**sharp Lᵖ Bernstein**. `:proved`=0; distance UNTOUCHED. *Next:* Besov space proper → Carleman.

## v0.11.1 — 2026-06-10 — Cross-audit #2 (A0–A7) + ledger the NS-050 instrument arc (public-repo integrity pass)

Second full cross-audit in two days (`audit_2026-06-10.md`), the day the repo went public. **Science intact:
`:proved`=0 genuine; no regularity-bearing entry above `:argued`; 35 entries / 35 registry rows.** But the
prior audit's recurrence prediction came true — the close-out checklist it recommended was never installed,
and a full new arc (NS-050 instrument: ~13 scripts + 7 docs) shipped to the **public** repo unledgered while
`README.md` points visitors at it. **Fixed:** (B1) **ledgered the NS-050 instrument+tooling arc** — SPEC
NS-050 entry + Source + registry row extended (b/c1/c2/c3 instrument, HL β=2.47, the validated 2D-wall
solver, the mapped-grid ℝ-operators, the 4-failure-mode profile-reconstruction wall), + **TEST_SPEC T-25**
(mapped-grid ξ∂_ξ + H_ℝ machine-precision) + **T-26** (HL β=2.47∈(2,4.53)); (W-D) SPEC stamp
v0.6.1→v0.11.1; (W-E) narrowed the NS-040 `metal/B_*abcpert*` glob (recurrence — registry was fixed last
audit, SPEC wasn't); (W-A/B/C) dashboard refreshed — NS-050 + public-flip bullet, stamp v0.6.2→v0.11.1,
breakdown corrected 30→35 (the 5 FORWARD-TARGETs were omitted from the itemization); CLAUDE.md stamp +
narrative extended through NS-050; (W-G) **installed the enforced large-session close-out checklist** in
CLAUDE.md (the meta-fix the last audit recommended but never landed). **Priority stack (now tracked):** W3
closure-v5 `substrate_source` (path now public-unresolvable), W5 DESIGN.md sync, N2 a fenced `formalization/`
Lean-ladder ledger entry (coordinate with the concurrent Lean session). `:proved`=0; distance UNTOUCHED.

## v0.11.0 — 2026-06-10 — YOUNG'S INEQUALITY + the multiplier–convolution bridge machine-verified: Schwartz-symbol multipliers are Lᵖ-bounded (the structural Lᵖ Bernstein)

Fourth bite of the Littlewood–Paley layer, in `formalization/lean-mathlib/LittlewoodPaley.lean`.
**Library infrastructure; `:proved`=0 for the PDE.** Young's inequality did NOT exist anywhere in
Mathlib (searched); the Schwartz convolution theorem did (`SchwartzMap.convolution` +
`fourier_convolution`, defined via 𝓕 — the same shape as `fourierMultiplierCLM`).
- **`eLpNorm_convolution_le` — Young `L¹⋆Lᵖ→Lᵖ`:** `‖k ⋆ g‖_{Lᵖ} ≤ ‖k‖_{L¹}·‖g‖_{Lᵖ}` for Schwartz
  `k` (scalar), `g` (vector-valued), `1 ≤ p < ∞`. The full classical proof, machine-checked: pointwise
  enorm domination → **Hölder** against the split `φ·ψ = φ^{1/q}·(φ^{1/p}ψ)`
  (`ENNReal.lintegral_mul_le_Lp_mul_Lq`, conjugate pair) → **Tonelli** swap → **translation
  invariance** of volume (`lintegral_add_right_eq_self`) → exponent bookkeeping
  (`p/q = p−1`, `A^{p−1}·A = A^p` with the `0`-base edge cases). `p=1` by direct Tonelli.
- **`fourierMultiplierCLM_schwartz_eq_convolution`** — a multiplier with **Schwartz symbol** `σ` IS
  convolution against the kernel `𝓕⁻σ` (both sides are `𝓕⁻ ∘ (σ·) ∘ 𝓕`; `smulLeftCLM σ = pairing
  lsmul σ` pointwise).
- **`eLpNorm_fourierMultiplierCLM_le`** — **the structural `Lᵖ` Bernstein:**
  `‖σ(D)g‖_{Lᵖ} ≤ ‖𝓕⁻σ‖_{L¹}·‖g‖_{Lᵖ}` for every `1 ≤ p < ∞` — Schwartz-symbol Fourier multipliers
  (incl. the LP blocks, whose symbols are smooth + compactly supported) are bounded on every `Lᵖ`,
  with the kernel `L¹`-norm as the constant. **The remaining step to sharp `Lᵖ` Bernstein** is the
  kernel-scaling computation `‖𝓕⁻σ_j‖_{L¹} = C·2^j` (fattened symbol + dilation covariance) — next.
- **Soundness:** no `sorry`; the false conjugate-exponent variant (`p/q = p+1` for `p−1`) is rejected;
  LEAN_EXIT=0 vs the lean4-cv Mathlib. `:proved`=0; distance UNTOUCHED.

## v0.10.0 — 2026-06-10 — BERNSTEIN INEQUALITY (L² case) machine-verified: a derivative of the frequency-2^j block costs 2π‖m‖·2^{j+1}

Third bite of the Littlewood–Paley layer, in `formalization/lean-mathlib/LittlewoodPaley.lean`.
**Library infrastructure; `:proved`=0 for the PDE.**
- **`eLpNorm_lineDerivOp_lpProj_le`** — **Bernstein, L²:**
  `‖∂_m P_j f‖_{L²} ≤ 2π‖m‖·2^{j+1}·‖P_j f‖_{L²}` for Schwartz `f`. Pure Plancherel: the symbol of
  `∂_m P_j` is `2πi⟨ξ,m⟩ψ_j(ξ)` (Mathlib's `lineDeriv_eq_fourierMultiplierCLM` + the multiplier
  composition law), Cauchy–Schwarz + the annulus bound `‖ξ‖ < 2^{j+1}` on `supp ψ_j` give the
  pointwise symbol estimate, and the L² isometry transfers it. **The honest scope:** this is the
  load-bearing case for NS (frequency-localized enstrophy estimates are L²); `Lᵖ` Bernstein needs the
  multiplier-as-convolution bridge + Young — a later bite.
- **Supporting lemmas:** `eLpNorm_fourierInv_two` (Plancherel on Schwartz, `eLpNorm` form, from the
  `Lp.fourierTransformₗᵢ` isometry + `toLp` compatibility); `lpProj_eq_realMultiplier` (the ℂ/ℝ-scalar
  multiplier bridge — the restricted-scalar smul is definitionally `(r:ℂ)•w`, closed by `rfl`);
  `hasTemperateGrowth_lpSymbolAt`.
- **Instance subtlety found + solved:** `SMulCommClass ℂ ℝ W` is not globally synthesizable (only the
  `ℝ ℂ` order is, via `SMulCommClass.complexToReal`); Mathlib's own lineDeriv theorem carries the
  symmetric form as an elided Prop-instance. Provided as a `local instance := SMulCommClass.symm ℝ ℂ W`.
- **Soundness:** no `sorry`; the false-constant variant (`2^{j−1}` for `2^{j+1}` — wrong, the annulus
  reaches `2^{j+1}`) is rejected at its load-bearing arithmetic; LEAN_EXIT=0 vs the lean4-cv Mathlib.
`:proved`=0; distance UNTOUCHED. *Next:* Lᵖ Bernstein (convolution+Young) → Besov space → Carleman.

## v0.9.0 — 2026-06-10 — P_j FREQUENCY PROJECTIONS + BESOV SEMINORM machine-verified (on Mathlib's Fourier-multiplier framework)

Second bite of the Littlewood–Paley layer, in `formalization/lean-mathlib/LittlewoodPaley.lean`.
**Search-first paid off:** Mathlib at our pin already has `SchwartzMap.fourierMultiplierCLM` /
`TemperedDistribution.fourierMultiplierCLM` (Moritz Doll, 2025 — `Analysis/Distribution/
FourierMultiplier.lean`), so `P_j` is THEIR multiplier applied to OUR symbol — no hand-rolled Fourier
machinery, and the tempered-distribution version comes from the same framework. (Also noted: the
Carleson project (van Doorn et al., finished 7/2025) is upstreaming weak/strong-type operators + real
interpolation — overlaps our WeakLp; flagged for the upstreaming conversation.)
**Library infrastructure; `:proved`=0 for the PDE.**
- **`lpProj j : 𝓢(V,F) →L[ℂ] 𝓢(V,F)`** — the Littlewood–Paley projection `P_j = ψ_j(D)`, the Fourier
  multiplier with our dyadic symbol; well-defined because `ψ_j` is smooth + compactly supported ⇒
  temperate growth (`hasTemperateGrowth_lpSymbolAtC`, via `HasCompactSupport.hasTemperateGrowth`;
  supporting lemmas `contDiff_lpSymbolAt`, `hasCompactSupport_lpSymbolAt`).
- **`lpProj_comp_eq_zero`** — `P_j ∘L P_k = 0` for `j+2 ≤ k`: the multiplier composition law
  (`fourierMultiplierCLM_compL_fourierMultiplierCLM`) + our symbol disjointness
  (`lpSymbolAt_mul_eq_zero`) + multiplier-of-const-0 = 0. The frequency-side almost-orthogonality.
- **`besovSeminorm s p q μ f`** — the **homogeneous Besov seminorm** `‖f‖_{Ḃ^s_{p,q}(μ)}` on Schwartz
  functions: `ℓ^q(ℤ)`-norm (tsum/iSup, eLpNorm-style `q=∞` split) of `j ↦ 2^{js}·‖P_j f‖_{L^p(μ)}` —
  **the space NS-046's target (`Ḃ⁰_{∞,1}`) is stated in is now formally definable.** + `besovSeminorm_zero`.
  (The full Besov *space* — tempered distributions mod polynomials, completeness — is a later layer.)
- **Soundness:** no `sorry`; the gap-1 false variant (adjacent annuli overlap, `P_jP_{j+1} ≠ 0`) is
  correctly rejected at its load-bearing arithmetic; LEAN_EXIT=0 vs the lean4-cv Mathlib.
`:proved`=0; distance UNTOUCHED. *Next:* Bernstein inequalities → Besov embeddings → Carleman.

## v0.8.1 — 2026-06-10 — SPEC header: Reading & audit guide + consolidated promotion rubric + independence note

Added a header audit-layer block to `SPEC.md` (prompted by an external naive adversarial read that
re-raised already-covered concerns). **No NS-ID, no status/count change; pure documentation; `:proved`=0.**
Three parts: (1) **Reading & audit guide** signposting where each discipline already lives — Class field =
claim taxonomy, `Scope:` tag = scope matrix, conjunctive-claim rule (sub-claim ≠ entry), witness≠evidence
(generator-class hard/soft/witness split), `:falsified`/kill-criteria/over-reach-ledger for negatives,
`tier×independence×scope-match` for citation force. (2) **Consolidated status-promotion rubric** — the
single state machine (→`:open`/`:argued`/`:cited`/`:tested`/`:falsified`/`:proved` with explicit gates;
`:proved` reserved+empty; a `:tested` model result never becomes a PDE statement without a separate
`:proved` limit argument; `:verified`/`:benchmarked` flagged as TCE-engine-only, not used here).
(3) **Independence note** — entry clusters that rephrase ONE obstruction count once, not as independent
confirmations (NS-002≡034≡036≡013-sharpening; NS-005↔036↔046; NS-046↔048 + 049/050; NS-010≡011;
NS-038/039/040/045), with the `G1–G5` of `docs/ns_blowup_generator_class.md` as the independent hard
constraints. Most of the external review's flags were already covered by mechanisms not visible in its
excerpts; this block exists to stop the next naive re-raise.

## v0.8.0 — 2026-06-09 — LITTLEWOOD–PALEY layer opened: the dyadic partition of unity machine-verified

First bite of the Besov/Littlewood–Paley layer — the foundational object everything downstream is
built on. `formalization/lean-mathlib/LittlewoodPaley.lean` (+ lakefile target). **Library
infrastructure; `:proved`=0 for the PDE; distance UNTOUCHED.**
- **Construction:** `lpChi` = canonical bump (`=1` on `‖ξ‖≤1`, supp `= {‖ξ‖<2}`, via Mathlib's
  `ContDiffBump`); **`lpSymbol ψ(ξ) = χ(ξ) − χ(2ξ)`**; dyadic family **`lpSymbolAt j ξ = ψ(2^{−j}ξ)`**.
  Generic over any real normed space with `[HasContDiffBump E]` (covers `ℝⁿ`/`EuclideanSpace`).
- **Machine-verified properties:** smoothness of every order (`contDiff_lpSymbol`); `0 ≤ ψ ≤ 1`
  (the nonnegativity via the support nesting `χ(2·)` alive ⇒ `χ = 1`); annulus support
  (`ψ = 0` for `‖ξ‖ ≤ 1/2` and for `2 ≤ ‖ξ‖`; `ψ_j` supported in `2^{j−1} < ‖ξ‖ < 2^{j+1}`);
  **support disjointness beyond gap 2** (`ψ_j·ψ_k = 0` for `j+2 ≤ k`); the telescoping
  representation `ψ_j = A_j − A_{j−1}`; and the **main theorem `hasSum_lpSymbolAt`**:
  `∀ ξ ≠ 0, HasSum (fun j : ℤ => ψ(2^{−j}ξ)) 1` — the **dyadic partition of unity on frequency
  space**, proved by locating the ≤3-term window `{L−1,L,L+1}`, `L = Int.log 2 ‖ξ‖`
  (`Int.zpow_log_le_self` / `lt_zpow_succ_log_self`), vanishing outside, telescoping inside.
- **Purely real-analytic** — no Fourier transform needed at this layer; the Fourier-side projections
  `P_j f = (ψ_j f̂)ˇ` and Besov norms `Ḃ^s_{p,q}` (the space the NS-046 target lives in) are the next
  bites, now definable on this object.
- **Soundness:** no `sorry`; the false variant (vanishing already for `‖ξ‖≤1` — wrong, `ψ(ξ)=1` at
  `‖ξ‖=1`) is rejected at its load-bearing arithmetic. Verified vs the lean4-cv Mathlib (LEAN_EXIT=0).
`:proved`=0; distance UNTOUCHED.

## v0.7.0 — 2026-06-09 — STRONG-TYPE MARCINKIEWICZ machine-verified (diagonal case, explicit constant): sublinear T of weak types (p,p),(q,q) maps Lʳ→Lʳ

The full interpolation theorem, in `formalization/lean-mathlib/WeakLp.lean` (~350 new lines).
**Library infrastructure; `:proved`=0 for the PDE; distance UNTOUCHED.**
- **`lintegral_rpow_le_of_hasWeakType`** — for sublinear `T` (`‖T(g+h)‖ₑ ≤ ‖Tg‖ₑ+‖Th‖ₑ` a.e., on
  `Lᵖ×L^q` pairs) of weak types `(p,p)`,`(q,q)` with finite constants, `0<p<r<q<∞`, `f∈Lʳ`:
  **`∫‖Tf‖ₑ^r ≤ K·∫‖f‖ₑ^r` with the explicit `K = r·(Cp^p·2^p/(r−p) + Cq^q·2^q/(q−r))`.**
- **`memLp_of_hasWeakType`** — membership form: `T : Lʳ → Lʳ` for all `p<r<q`.
- **Proof, machine-checked end to end:** layer-cake on `Tf` → **exact level-`t` truncation**
  (`truncGT/truncLE`, split exact-by-`if`, not a.e.) → sublinearity + the two weak-type bounds at
  threshold `t/2` (the `2^e` absorbed via a real-arithmetic identity) → **Tonelli swap** (product
  measurability via the strongly-measurable mate `g` — `T` is eliminated from the chain *before* the
  swap, so the mate trick is sound) → inner `t`-integral evaluation (`swap_eval_low/high`) →
  recombination to `∫‖f‖ₑ^r`. Supporting API landed: truncation measurability + `MemLp` (large ∈ `Lᵖ`
  for `p<r`, small ∈ `L^q` for `r<q`), model rpow integrals on `(0,c)` and `(c,∞)`, antitone-measurable
  tail functions.
- **Honest hypotheses:** `T f`-measurability assumed (does not follow from sublinearity); `[SFinite μ]`
  (Tonelli); `q<∞` (weak-L^∞ not covered by `wnorm`). **Soundness:** no `sorry`; a false exponent
  variant of the threshold-absorption identity is correctly REJECTED; verified vs the lean4-cv Mathlib.
- WeakLp.lean is now a **complete Lorentz/Marcinkiewicz nucleus** (quasinorm → … → full strong-type
  interpolation), a confirmed Mathlib gap, genuinely upstreamable. *Next:* Besov/Littlewood–Paley →
  Carleman. `:proved`=0; distance UNTOUCHED.

## v0.6.2 — 2026-06-09 — Cross-audit (A0–A7) + bookkeeping reconciliation

Full cross-audit after a 5-day / ~50-version gap (`audit_2026-06-09.md`, 3 parallel read-only agents).
**Science intact: `:proved`=0 is genuine** (per-entry tally 0 proved / 0 verified; the raw `grep ':proved'`
count of 39 is prose disclaimers, not statuses); **no regularity-bearing entry sits above `:argued`**; A0
confirms the firewall / Scope / evidence→status / witnessing disciplines are followed. Every finding was
bookkeeping drift. **Fixed:** (B1) added the missing **NS-049 registry row**; (B2) wrote the **NS-050 entry +
registry row + TEST_SPEC T-24** (the modulation/Type-II arc committed at 5966eeb had no ledger home); (B3)
entry count 30/32/33 → **35** across SPEC/dashboard/CLAUDE; (B4) refreshed stale status stamps (CLAUDE
v0.1.42→v0.6.2, dashboard v0.1.39, SPEC v0.1.0→v0.6.1); (W1) narrowed NS-040's over-specified `metal/B_*`
glob (`abcpert_512` never existed); (W2) added the **NS-045 TEST_SPEC row (T-23)**; (W4) corrected the stale
"no `Project.toml`/lockfile" line (both present). **Priority stack (deferred):** DESIGN.md sync with the
NS-045..050 + Lean-ladder + disproof arc (W5); closure-v5/Q_102 `substrate_source` fields for
NS-022/023/024/037 (W3 — provenance hygiene, Scope≠PDE, prize untouched). **Recurrence note:** B3/B4/W5 are
F1/F2/F3 from 2026-06-04 re-opened — point-fixes don't stick; standing recommendation (audit doc §end) =
fold count/stamp/registry/TEST_SPEC updates into the large-session close-out so they're enforced.

## v0.6.1 — 2026-06-09 — Marcinkiewicz OPERATOR form (qualitative) machine-verified: HasWeakType + weak-(p,p)+(q,q) ⇒ Lᵖ∩L^q → Lʳ

`formalization/lean-mathlib/WeakLp.lean` extended with the operator layer. **Library infrastructure;
`:proved`=0 for the PDE.**
- **`HasWeakType T p μ ν C`** — weak-type `(p,p)` with constant: `T` maps `Lᵖ(μ)` functions to
  AE-strongly-measurable functions with `wnorm (T f) p ν ≤ C·‖f‖_{Lᵖ}` (two measure spaces allowed).
- **`HasWeakType.memLp_interpolate`** — if `T` has weak type `(p,p)` and `(q,q)` with finite constants,
  then `T f ∈ Lʳ` for every `f ∈ Lᵖ ∩ L^q` and `p<r<q`. Direct wrapper over `eLpNorm_lt_top_of_wnorm`;
  **no sublinearity needed** at this qualitative level. Compiled first try; LEAN_EXIT=0, no sorry.
- **Honest scope (in-file docstring):** the *strong-type* `(r,r)` bound (`‖Tf‖_{Lʳ} ≲ ‖f‖_{Lʳ}` from
  `f ∈ Lʳ` alone) genuinely requires sublinearity + the level-dependent truncation
  `f = f·1_{|f|>s}+f·1_{|f|≤s}` inside the layer-cake — that is the next formalization level, NOT a
  wrapper; flagged, not started. `:proved`=0; distance UNTOUCHED.

## v0.6.0 — 2026-06-09 — Formalization ladder resumed: the MARCINKIEWICZ CORE machine-verified (weak-Lᵖ ∩ weak-L^q ⊆ Lʳ, layer-cake + two-tail split)

Resumed the Rung-2 bites (formalization as its own goal). Extended
`formalization/lean-mathlib/WeakLp.lean` with the function-level Marcinkiewicz interpolation core.
**Library infrastructure; `:proved`=0 for the PDE; distance UNTOUCHED.**
- **`meas_le_wnorm_div_rpow`** — the distribution-function bound `μ{s ≤ ‖f‖ₑ} ≤ (‖f‖_{p,∞}/s)^p` (the
  Chebyshev-type inequality that defines weak-Lᵖ; from the `iSup` via `ENNReal.le_div_iff_mul_le`).
- **`eLpNorm_lt_top_of_wnorm` + `MemWLp.memLp`** — **weak-Lᵖ ∩ weak-L^q ⊆ Lʳ for `0<p<r<q<∞`** (the
  computation inside Marcinkiewicz; the sublinear-operator form is a wrapper on it). Proof: (i) the
  `‖·‖ₑ`→real bridge (`enorm` of a normed-group value is never `∞`); (ii) Mathlib's layer-cake
  `lintegral_rpow_eq_lintegral_meas_lt_mul`; (iii) the **two-tail split at `t=1`** — on `(0,1]` the
  `p`-tail bound gives integrand `≲ t^{r−p−1}` (integrable at 0 since `r>p`, `intervalIntegrable_rpow'`),
  on `(1,∞)` the `q`-tail gives `≲ t^{r−q−1}` (integrable at ∞ since `r<q`, `integrableOn_Ioi_rpow_of_lt`).
- **Soundness sanity:** a false exponent variant (`r−e+1` for `r−e−1`) is correctly REJECTED (LEAN_EXIT=1);
  no `sorry` anywhere; verified vs the TCE `lean4-cv` Mathlib (LEAN_EXIT=0).
- Weak-Lᵖ now has: quasinorm, membership, `Lᵖ⊆L^{p,∞}`, monotonicity, quasi-triangle, distribution bound,
  and interpolation — a genuinely upstreamable `MeasureTheory.WeakLp` nucleus. *Next:* the Marcinkiewicz
  operator form → Besov/Littlewood–Paley → Carleman. `:proved`=0; distance UNTOUCHED.

## v0.5.2 — 2026-06-09 — Systematic record-audit: ALL 7 remaining transcribed closed-form identities VERIFIED — the NRŠ error was the only false transcription in the record

Swept every transcribed closed-form identity in the docs/SPEC that wasn't already machine-verified
(Rungs 0–1, NRŠ probe) through sympy. `disproof/record_audit.py` + `docs/record_audit_2026-06-09.md`.
**Record verification; `:proved`=0; distance UNTOUCHED.** All PASS:
- **B1** the `G=∂_zΓ` equation (sign-condition doc C-ii) — the recorded bracket
  `−[(∂_zu^r)∂_rΓ+(∂_zu^z)G]` is exactly `∂_z` of the Γ-equation, signs and all;
- **B2** `L_Γ(r²u₁)=r²(∂_r²+(3/r)∂_r+∂_z²)u₁` (the 4-D radial-heat substitution, §4);
- **B3** `Δ_axi−(2/r)∂_r=L_Γ` — the frontier doc's Γ-equation form and the sign-condition doc's `νL_Γ`
  form are consistent;
- **B4** pressure-Poisson `div(momentum)=Δp+∂_iu_j∂_ju_i` (ns046_target);
- **B5** the 3D vorticity equation `curl(momentum)=∂_tω+(u·∇)ω−(ω·∇)u−νΔω` (machinery:286; doc's `ν=1`
  is normalization);
- **B6** the production algebra `ωᵀ(∇u)ω=ωᵀSω` (SPEC NS-036 / ns046 production);
- **B7** the **M1 rescaling-covariance cornerstone** `NSop(u_λ,p_λ)(x,t)=λ³·NSop(u,p)(x₀+λx,T+λ²t)`
  (machinery:43) — exact in `λ`.
Method: generic functions (B1–B3) / generic polynomial instances with `u=curl A` div-free by construction
(B4/B5/B7), same standard as the Rung-1 checks. **Net: every closed-form identity in the program's record
is now machine-checked; one error total (NRŠ, corrected + verbatim-confirmed).** Standing rule instituted:
new transcribed identities get a symbolic check at transcription time (append to `record_audit.py`).
Inequalities/asymptotics (Carleman, CKN, GN, rate bounds) are out of this instrument's scope and keep
their C-tiers. `:proved`=0; distance UNTOUCHED.

## v0.5.1 — 2026-06-09 — NRŠ loop CLOSED: Lemma 3.3 verbatim-confirmed (Acta p. 290) — the symbolic finding matches the original term-for-term; both errors were ours

Re-fetched the NRŠ Acta original (scanned PDF, Tsinghua archive mirror; read visually) and confirmed Lemma
3.3 verbatim. **The original:** `Π=½|U|²+P+ay·U`; proof sets `Ũ=U+ay`, `P̃=P−½a²|y|²` (system becomes
`−νΔŨ+(Ũ·∇)Ũ+∇P̃=0`, `div Ũ=3a`) and derives `−νΔΠ+(Ũ·∇)Π = −ν|∇U+aI|²−νΔP+3νa² = −ν|∇U|²+ν(∂ᵢUⱼ)(∂ⱼUᵢ) ≤ 0`.
**Matches the sympy probe term-for-term:** (a) the advection is the full self-similar `Ũ=U+ay` — the
`a(y·∇)Π` drift IS in the original (our record dropped the `ay`); (b) NRŠ's final RHS is exactly
`−ν|∇U|²+ν cross` — our `−ν|∇U+aI|²` was their INTERMEDIATE line recorded as final (the `+3νa²` gap; the 3
= spatial dimension from `Δ(½a²|y|²)=3a²`). **Verdict: NRŠ correct; both errors ours.** Updated
`docs/disproof_probes_2026-06-08.md` (verbatim-confirmation block) + `docs/nrs_ess_verification_2026-06-07.md`
(correction note finalized). NS-007 stays C3 (now with the identity verified symbolically AND against the
verbatim source). `:proved`=0; distance UNTOUCHED. Next: systematic record-audit of all closed-form claims.

## v0.5.0 — 2026-06-08 — Disproof probes: NRŠ H-identity RECORD ERROR caught (symbolic) + Wang anisotropic Hardy–Sobolev HARDENED (numerical)

Re-pointed the formalization effort at its actual goal — **disproving / hard-verifying the citations** —
using the cheap instruments (computer-algebra + rigorous-numerics, the C5 bar), not bottom-up Lean infra.
`disproof/` (uv venv: numpy 2.4.6, sympy 1.14.0) + `docs/disproof_probes_2026-06-08.md`. **Citation
verification; `:proved`=0; distance UNTOUCHED.**
- **NRŠ H-identity — RECORD ERROR FOUND** (`disproof/nrs_h_identity.py`, sympy). Our C3 line-read recorded
  `−νΔH+(U·∇)H = −ν|∇U+aI|²+ν(∂ᵢUⱼ)(∂ⱼUᵢ)`. Symbolic check (substitute profile-eq `ΔU`, pressure-Poisson
  `ΔP`, `div U=0`): **false as written** — it (i) drops the `a(y·∇)H` self-similar drift, (ii) RHS off by
  `+3νa²`. **Corrected identity:** `−νΔH+(U·∇)H+a(y·∇)H = −νΣ_{i<j}(∂ᵢUⱼ−∂ⱼUᵢ)² ≤ 0`. The defect is in
  **our transcription only**; both RHS forms are `≤0` ⇒ NRŠ Thm 1 unaffected. Corrected
  `docs/nrs_ess_verification_2026-06-07.md` (flagged, not silently). A human-graded-C3 line-read recorded a
  false identity; a 2-min symbolic check caught it — the disproof rung working.
- **Wang anisotropic Hardy–Sobolev — HARDENED** (`disproof/wang_hardy.py`, numpy). Resolved the triad's
  "α→1/4" suspicion: for `|x₃|^α` (k=1) the Thm-1.2 constraint is `α<1/p`, and at critical `p=3/(1−α)` that
  is **exactly `α<1/4`** — the fractional-Hardy integrability endpoint, where the sharp constant diverges.
  Numerics: no gross violation (inequality holds; max ratio ≈1.9 over 400 random tests at fixed `α<1/p`);
  monotone growth toward the endpoint; divergence mechanism analytic (`∫|x|^{−αp}~1/(1−αp)→∞`). **Citation
  confirmed/necessary, not disproved.** `:proved`=0; distance UNTOUCHED.

## v0.4.1 — 2026-06-08 — Rung 2 bite 2: weak-Lᵖ quasinorm properties (MemWLp, monotonicity, quasi-triangle inequality) machine-verified

Extended `formalization/lean-mathlib/WeakLp.lean` with the weak-Lᵖ quasinorm's core properties.
**Library infrastructure; `:proved`=0 for the PDE.**
- **`MemWLp f p μ`** — weak-Lᵖ membership predicate (AE-strongly-measurable + finite `wnorm`), mirroring
  Mathlib's `MemLp`.
- **`wnorm_mono`** — monotonicity in the pointwise enorm (via `gcongr` reducing the superlevel-set measure
  to the pointwise inequality).
- **`wnorm_add_le`** — the **quasi-triangle inequality** `‖f+g‖_{p,∞} ≤ 2(‖f‖_{p,∞}+‖g‖_{p,∞})` for
  `1 ≤ p < ∞` (weak-Lᵖ is a *quasi*-normed space, not normed). Proof: the superlevel set of `f+g` at `t`
  splits into the half-level sets of `f`,`g` (`{t≤‖f+g‖ₑ} ⊆ {t/2≤‖f‖ₑ}∪{t/2≤‖g‖ₑ}`), then measure
  subadditivity + `ENNReal.rpow_add_le_add_rpow` (rpow subadditivity for exponent `1/p ≤ 1`) + the
  `t=2·(t/2)` rescaling against the sup.
- Verified via `lake env lean` against the TCE `lean4-cv` Mathlib; warning-free. *Next:* Marcinkiewicz
  interpolation → Besov/Littlewood–Paley → Carleman. `:proved`=0; distance UNTOUCHED.

## v0.4.0 — 2026-06-08 — Rung 2 STARTED: substrate survey corrects the "multi-year, field-wide" over-estimate + first library bite (weak-Lᵖ / Lorentz L^{p,∞}) machine-verified

**Substrate survey (web + grep of the actual Mathlib source)** corrected my earlier over-statement: NOT
"multi-year, field-wide". **Already formalized:** Sobolev spaces (`Mathlib/Analysis/Distribution/Sobolev`),
Gagliardo–Nirenberg–Sobolev (`Mathlib/Analysis/FunctionalSpaces/SobolevInequality`), De Giorgi–Nash–Moser
regularity (Armstrong–Kempe 2026, `scottnarmstrong/DeGiorgi`), Fefferman's NS Millennium statement
(`lean-dojo/LeanMillenniumPrizeProblems`), and the distribution-function/Chebyshev–Markov machinery.
**Confirmed gaps:** Lorentz/weak-Lᵖ, Littlewood–Paley/Besov, Carleman estimates, full Leray–Hopf weak
theory — each a discrete, load-bearing library addition. So Rung 2 = bite-by-bite, not a wall.

**First bite ✅ `formalization/lean-mathlib/WeakLp.lean`:** defined the **weak-Lᵖ (Lorentz `L^{p,∞}`)
quasinorm** `wnorm f p μ = ⨆ t, t · μ{t ≤ ‖f‖ₑ}^{1/p}` and machine-verified the foundational
**`Lᵖ ⊆ L^{p,∞}` embedding** `wnorm_le_eLpNorm` (`wnorm f p μ ≤ eLpNorm f p μ`, `0<p<∞`), proved directly
from Mathlib's `mul_meas_ge_le_pow_eLpNorm'`. Compiled first try; verified via `lake env lean` against the
TCE `lean4-cv` Mathlib. Confirmed Mathlib gap (no `wnorm`/`weakLp`/`MemWLp`) → **upstreamable**;
load-bearing (weak-`L³` = where the Ożański–Palasek double-log rate lives) + reusable (Marcinkiewicz).
Lakefile target added. *Next bites:* weak-Lᵖ quasinorm properties + Marcinkiewicz interpolation → Besov/
Littlewood–Paley → Carleman. `:proved`=0 for the PDE — library infrastructure, not an NS theorem; distance
UNTOUCHED.

## v0.3.3 — 2026-06-08 — Universal-Lean completeness: pressure elimination (mixed partials) + Biot–Savart added to AxisymUniversal; full Rung-1 operator set now ∀-quantified

Closed the two minor universal-Lean gaps in `formalization/lean-mathlib/AxisymUniversal.lean`.
**Definitional hardening, not PDE progress; `:proved`=0, stays 0.**
- **`pderiv_comm`** — mixed partials commute for ALL `p` and ALL `i,j`, proved by induction on the
  polynomial (`MvPolynomial.induction_on`; `mul_X` case via `Pi.single_apply` + targeted `apply_ite`
  + `ring`). Corollary **`pressure_elimination`** (`∂_z∂_r p = ∂_r∂_z p` ⇒ the curl kills `∇p`).
- **`biot_savart`** — the Stokes stream-function relation `ω^θ = −(∂_r²+(1/r)∂_r−1/r²+∂_z²)ψ`, cleared
  `×r²` (the `1/r` in `u^z=(1/r)∂_r(rψ)` cancels), for ALL `ψ`; `simp`+`ring`.
- **Rung 1 is now FULLY universal** — the entire operator structure of
  `∂_tΩ+b·∇Ω=ν(∂_r²+(3/r)∂_r+∂_z²)Ω+S` (incl. pressure elimination + Biot–Savart) is `∀`-quantified and
  machine-verified, matching the Julia/Haskell coverage. Verified via `lake env lean` against the TCE
  `lean4-cv` built Mathlib. All four layers AGREE across both rungs; the formalization ladder is complete
  for the foundational structural calculus. `:proved`=0; distance UNTOUCHED. (Remaining: Rung 2, the
  inequalities — the multi-year long-horizon.)

## v0.3.2 — 2026-06-08 — Rung 1 Lean theorems UNIVERSALIZED via Mathlib: axisymmetric structural identities proved ∀ fields (not a monomial grid)

`formalization/lean-mathlib/AxisymUniversal.lean` (+ lakefile target). The Rung-1 upgrade from
`native_decide`-on-a-monomial-grid to **universally-quantified** theorems over the polynomial ring.
**Definitional hardening, not PDE progress; `:proved`=0 for the PDE, stays 0.** For ALL
`u : MvPolynomial (Fin 3) ℚ` (r=X0,z=X1,t=X2), via `pderiv`+`ring`:
- **`gamma_source_free_operator`** — the Γ source-free operator identity (maximum-principle basis);
- **`gamma_transport`** — the Γ transport identity (with the above ⇒ `∂_tΓ+b·∇Γ−νL_ΓΓ=0`, source-free);
- **`omega_operator_transform`** — the `Ω=ω^θ/r` transform: **the `(3/r)∂_r` emerges, `1/r²` cancels**;
- **`source_chain`** (`∂_z(Γ²)=2Γ∂_zΓ`) + **`z_indep_r_power`** (`∂_z(rᵏf)=rᵏ∂_zf`) ⇒ `S=∂_z(u₁²)`, `u₁=Γ/r²`.
- **Denominator-clearing:** the `1/r`,`1/r²` identities are stated in `×rᵏ` polynomial form — equivalent to
  the `1/r` form for `r≠0`, and `∀`-quantified over all polynomial fields (the formal differential-algebraic
  content; the native_decide file checked only a monomial grid).
- **Verified** via `lake env lean` against the TCE `lean4-cv` built Mathlib. **Soundness sanity:** a false
  variant (`2/r ∂_r` for the correct `3/r`) was correctly **rejected** — `ring` reduced the true side to
  coefficient 3. (Mixed-partial commutativity / Biot–Savart left to the native_decide/Julia/Haskell layers —
  the former generic, the latter more denominator bookkeeping.)
- **Both Lean rungs now have universal Mathlib theorems**; all layers (algebraic / type-checked /
  native-machine / universal-machine) AGREE. `:proved`=0; distance UNTOUCHED.

## v0.3.1 — 2026-06-08 — Rung 0 Lean theorems UNIVERSALIZED via Mathlib: criticality proved ∀ α,p,q (not just exemplar triples)

Upgraded the Rung-0 Lean rung from concrete-instance `native_decide` to **universally-quantified** theorems.
`formalization/lean-mathlib/ScalingUniversal.lean` (+ lakefile, lean-toolchain, lake-manifest, README).
**Definitional hardening, not PDE progress; `:proved`=0 for the PDE, stays 0.**
- **`lebExp_critical_iff (α p q : ℚ)`** — `‖|x₃|^α u^θ‖_{L^q_t L^p_x}` scale-invariant **⇔ `2/q+3/p=1−α`**,
  for ALL α,p,q (the WHWY criticality, now a theorem not exemplars); **`sobExp_critical_iff`** (Ḣ^s critical
  ⇔ s=1/2, ∀); **`energy_supercritical`** (`[L²]<0`, NS-002) + `lebExp_eq`/`energy_gap`. Proofs: `linarith`/
  `norm_num` over ℚ (the iff is a linear rearrangement in the atoms {α,3/p,2/q}).
- **Verified** via `lake env lean` against the TCE `lean4-cv` built Mathlib (rev `5d69f04…`, toolchain
  v4.30.0-rc2). **Soundness sanity:** a deliberately-FALSE variant (`=2−α` for `1−α`) was correctly
  **rejected** by `linarith` — Mathlib genuinely loaded, checker not rubber-stamping.
- Reproducible standalone (`lake exe cache get && lake build`); pinned via lean-toolchain + lake-manifest
  mirroring `lean4-cv` so the populated `~/.cache/mathlib` is reused. Opt-in/heavy (the hermetic
  `native_decide` track at `lean/` stays the default). The 4 layers (algebraic / type-checked / machine /
  universal-machine) all AGREE. *(Rung 1 universal Lean would need Mathlib MvPolynomial/derivations — a
  heavier follow-on; the Rung-1 core stays `native_decide`-verified.)* `:proved`=0; distance UNTOUCHED.

## v0.3.0 — 2026-06-08 — Lean rung DONE: Rungs 0–1 machine-verified (native_decide); full Python→Julia→Haskell→Lean ladder realized for the foundational pieces

The machine-verification (`lean-proved`) capstone. `formalization/lean/Scaling.lean` + `Axisym.lean`.
**Definitional hardening, not PDE progress; `:proved`=0 for the PDE, stays 0.** Hermetic — `import Std`
ships with the Lean 4.30.0 toolchain (**no Mathlib, no external Batteries fetch**); facts proved by
`native_decide` (kernel-checked native evaluation). (Lean's `Rat` convention `x/0=0` *is* our `1/∞=0`
∞-sentinel — a free coincidence.)
- **Rung 0 (`Scaling.lean`):** the scaling-criticality theorems — `L³`/`Ḣ^{1/2}` critical, `L²` energy
  **supercritical** (NS-002), `L^∞` sub, `Ḣ⁰=L²`, the energy gap, and the `|x₃|^α` criticality at the
  weighted-critical / Serrin / control triples — all `native_decide`.
- **Rung 1 (`Axisym.lean`):** ported the tiny Laurent-polynomial engine to Lean and machine-verified the
  load-bearing core: **(I-op) `L_Γ(r u^θ)=r·lap_ang(u^θ)`** (Γ source-free operator, monomial-by-monomial
  ⇒ all fields), **(III-d) `L_visc(rΩ)=r·L_Ω(Ω)`** (the `(3/r)∂_r` emergence), and the source identities
  `(1/r⁴)∂_z(Γ²)=(2Γ/r⁴)∂_zΓ=∂_z(u₁²)`. (The full identity set remains in the Julia/Haskell layers; the
  Lean covers the load-bearing core.)
- **The full ladder Python→Julia→Haskell→Lean is now realized for both foundational rungs** (scaling
  calculus + axisymmetric structural calculus). Three independent layers (algebraic / type-checked /
  machine) AGREE. *Scope:* the structural definitions/identities are now `lean-proved`; the inequalities/
  theorems (Rung 2) remain the long-horizon. `:proved`=0; distance UNTOUCHED.

## v0.2.2 — 2026-06-07 — Rung 1 COMPLETE: full Ω-evolution operator + Biot–Savart verified (the (3/r)∂_r emergence, stretching cancellation, S source); Julia + Haskell agree

Completed Rung 1 (the deferred operator pieces). `formalization/axisym/axisym_operators.{jl,hs}` (+ README).
**Definitional/algebraic hardening, not PDE progress; `:proved`=0, stays 0.** Same hermetic Laurent-poly
engine (zero deps). Verified the full operator structure of the Ω-equation:
- **(III) ω^θ→Ω transform:** (a) the pressure drops because `∂_z,∂_r` commute (curl kills `∇p`); (b) the
  swirl source `∂_z((u^θ)²/r)=(1/r³)∂_z(Γ²)` (centrifugal origin); (c) the **stretching `(u^r/r)ω^θ`
  cancels** under `ω^θ=rΩ`; (d) **`L_visc(rΩ)=r·L_Ω(Ω)`** — the viscous operator
  `∂_r²+(1/r)∂_r−1/r²+∂_z² → ∂_r²+(3/r)∂_r+∂_z²` (the **`(3/r)∂_r` emerges**, `1/r²` cancels),
  monomial-by-monomial; (e) source transform → `S=(1/r⁴)∂_z(Γ²)`.
- **(IV) Biot–Savart:** stream function `ψ` ⇒ `ω^θ=−(∂_r²+(1/r)∂_r−1/r²+∂_z²)ψ` and `∇·b=0` identically.
- Julia (Base, **algebraic**) + Haskell (base, **type-checked/categorical**); **both pass and AGREE.**
- **Rung 1 is now complete** at the algebraic/categorical level — the full operator structure of
  `∂_tΩ+b·∇Ω=ν(∂_r²+(3/r)∂_r+∂_z²)Ω+S` is exact. Next: Lean (Rung 0→1 machine-verification). `:proved`=0.

## v0.2.1 — 2026-06-07 — Rung 1 BUILT + verified: axisymmetric structural calculus (Γ source-free, Ω source S=∂_z(u₁²)), exact Julia + Haskell; both agree

Second rung. `formalization/axisym/` (+ README). **Definitional/algebraic hardening, not PDE progress;
`:proved`=0 for the PDE, stays 0.** Verified the load-bearing differential identities of the NS-048 core
EXACTLY via a **hermetic tiny Laurent-polynomial engine** (no CAS — `Symbolics.jl` deliberately avoided;
the identities are formal differential-algebraic, exact on Laurent monomials/polys; both layers
zero-dependency):
- **(I) the swirl `Γ=r u^θ` obeys a SOURCE-FREE transport–diffusion equation** (the maximum-principle
  basis): operator identity `L_Γ(r u^θ)=r·lap_ang(u^θ)` (proved monomial-by-monomial ⇒ all fields) +
  transport identity, closed by the `u^θ` momentum equation ⇒ `∂_tΓ+b·∇Γ−ν L_Γ Γ=0`.
- **(II) the sole `Ω=ω^θ/r` source** `S=(1/r⁴)∂_z(Γ²)=(2Γ/r⁴)∂_zΓ=∂_z(u₁²)` (`u₁=Γ/r²`) + its
  **centrifugal origin** `(1/r)∂_z((u^θ)²/r)=(1/r⁴)∂_z((ru^θ)²)`.
- `axisym_structural.jl` (Julia Base, **algebraic** evidence) + `AxisymStructural.hs` (base,
  **type-checked/categorical** — the same algebra with `∂_r,∂_z,∂_t` verified to be **derivations**
  (Leibniz law), so the identities are equalities of algebra elements). **Both pass and AGREE.**
- *Scope:* the exact structural definitions/identities (what `Γ`,`Ω`,`u₁`,`S` are + how they relate) —
  the algebra the analysis stands on; NOT the inequalities/theorems. *Deferred:* the full `Ω`-evolution
  operator (vorticity curl) + Biot–Savart elliptic operator (the source *mechanism* (II) is verified; the
  full operator is a heavier symbolic step). Lean deferred per the depth decision. `:proved`=0.

## v0.2.0 — 2026-06-07 — Rung 0 BUILT + verified: scaling-criticality calculus, exact in Julia (algebraic) + Haskell (type-checked); both agree

First rung of the formalization ladder. `formalization/scaling/` (+ `formalization/README.md`).
**Definitional/algebraic hardening, not PDE progress; `:proved`=0 for the PDE, stays 0.** Decisions:
Rung 0 first; Julia + Haskell this pass (Lean deferred); home = `navier-stokes` formalization sub-track.
- **`scaling_criticality.jl` (algebraic evidence, Julia Base only):** derives each norm's scaling exponent
  `[X]` (`‖u_λ‖_X=λ^[X]‖u‖_X`) from the change-of-variables bookkeeping and verifies, as **exact `Rational`
  identities**: `L³`/`Ḣ^{1/2}` critical (`[X]=0`); `L²` energy **supercritical** (`[X]=−1/2` = the NS-002
  wall); `L^∞` subcritical; `Ḣ⁰=L²`; the energy gap `[L²]−[Ḣ^{1/2}]=−1/2`; and the anisotropic `|x₃|^α`
  criticality **`[X]=0 ⇔ 2/q+3/p=1−α`** (WHWY) — checked at genuine weighted-critical/Serrin/control
  triples. (Caught + fixed my own mislabeled test triple before recording.)
- **`Scaling.hs` (type-checked evidence, base only):** the same calculus with the **norm taxonomy as a
  total sum type**, the exponent map total on it, criticality as the kernel-structured classification, plus
  the `Ḣ⁰=L²` cross-family coherence the types make explicit.
- **Both pass and AGREE** (identical exponents + classifications) — cross-language verified. Hermetic
  (zero external deps; Julia 1.12.6 / GHC 9.6.7 pinned in the README).
- **Scope honesty:** verifies the **scaling-exponent facts underlying** NS-002/NS-034 (energy supercritical;
  critical spaces scale-invariant) — NOT the full obstruction narrative (that's NS-008/inequalities). Rung
  1 (axisymmetric `Γ`/`Ω`/source identities) is next. `:proved`=0; distance UNTOUCHED.

## v0.1.99 — 2026-06-07 — Formalization target SCOPED: Python→Julia→Haskell→Lean ladder; tractable = the algebraic IDENTITIES (not the inequalities)

Scoped the verification ladder for hardening the foundation past the C5 social floor.
`docs/formalization_scope_2026-06-07.md`. **Scoping only — not the formalization; `:proved`=0, stays 0 for
the PDE.** Key separation: the C5 black boxes are **inequalities** (Hardy–Sobolev, Carleman) — *analysis*,
which does NOT fit the algebra→category rungs and has no mathlib substrate (multi-year, field-wide; Rung
2+, not now). The **algebraic/differential IDENTITIES underneath** fit the ladder perfectly. Recommended
staged plan:
- **Rung 0 (warm-up, days–weeks):** the scaling-criticality calculus (= NS-034) — pure rational-exponent
  algebra (`‖u_λ‖`-scaling; `2/q+3/p=1−α` criticality; energy supercriticality). Establishes the
  4-language pipeline on a cheap, load-bearing target.
- **Rung 1 (substantive, weeks→months):** the axisymmetric structural calculus — the `Γ` (source-free) /
  `Ω` (source `S=∂_z(u₁²)`) / Biot–Savart identities, the NS-048 core; already C4-re-derived, so
  formalizing is the C5→machine step; pins down every axisymmetric definition.
- **Rung 2+ (years, flagged not-now):** the inequalities.
Per-language: Python explore → Julia exact-`Rational`/`Symbolics.jl` (**algebraic** evidence) → Haskell
typed/categorical (**type-checked**) → Lean (**lean-proved**); each rung a gate. Maps onto the program's
evidence-type discipline; reuse TCE Lean `Category`/Julia/Haskell scaffolding; lockfile discipline.
**Honest:** completing Rungs 0–1 machine-hardens the DEFINITIONS + algebraic skeleton (the program's own
identities become `lean-proved`), NOT the PDE theorems (the inequalities stay socially-verified). Awaiting
target/depth/home decision before building. `:proved`=0; distance UNTOUCHED.

## v0.1.98 — 2026-06-07 — C5 triad verdict metabolized: both targets SURVIVE all 3 model families; no hard verification (external-confirmed); 2 gentle self-corrections + 2 scope conditions

Metabolized the external triad pass (Grok edge-Φ / **Gemini synthesis / Venice naive** — the seat swap)
on the C5 brief. `docs/c5_triad_witness_verdict.md`. **Foundation-hardening, not PDE progress; `:proved`=0.**
**No disproof — both targets (`|x₃|^α`; Type-II rates) SURVIVE all three; "use faithful + NO hard
verification" is UNANIMOUS** (externally confirming the C5 social-floor finding). The external pass earned
its keep:
- **2 gentle self-corrections:** (i) `α<1/4` "range-choice, not a ceiling" → "established `p`-range
  constraint; whether the constant `C(α)` *also* diverges at the endpoint is an **un-tracked black box**
  (paper doesn't track it; triad *suspects* divergence)" — endpoint possibly a genuine barrier (immaterial
  to our use). (ii) **Palasek upgraded** "partial cross-check" → "**structurally-independent**
  (Harnack-vs-Carleman) cross-check of the *phenomenon*" (we'd under-claimed its independence).
- **2 new scope conditions:** `|x₃|^α` is an **`H²`-continuation theorem**, not a weak-solution criterion
  (`Φ(0),Γ(0)` need `ω(0)∈H¹`); **Tao's triple-log is tied to the Leray–Hopf class** (pigeonholing needs
  the global energy inequality). Both: our use is within scope.
- **Black boxes located more precisely (not cracked):** A1 = constant-tracking near `α→1/4` and the axis;
  B2 = whether Tao's Carleman constant is solution-*independent* (Venice: if it secretly depends on
  `‖u‖_{L³}`, the triple-log could weaken — but still slow-divergence, so our qualitative use holds).
- **One challenge DECLINED:** Venice's "Type-II closed for axisym bounded swirl" conflates *conditional
  regularity* (CSTY/LZZ — the closers we mapped) with *unconditional* exclusion; the latter stays OPEN.
No over-reach caught this round (use confirmed faithful); the refinements are sharpenings + 2
generous-direction adjustments. Tier label stands: **"C5-adversarial-survived (internal+external);
hard-verification = none."** Updated: c5-pass doc (triad-update), Type-II doc. `:proved`=0; distance
UNTOUCHED.

## v0.1.97 — 2026-06-07 — C5 triad witness brief drafted (external-independence layer on the C5 pass) — awaiting relay

Drafted a self-contained adversarial witness brief for the external triad (Grok edge-Φ / Venice.ai
synthesis / ChatGPT naive) — the genuinely-independent layer the internal C5 pass lacked.
`docs/c5_triad_witness_brief.md`. Two targets (`|x₃|^α` criterion; Type-II triple/double-log rate bounds),
each with: try-to-DISPROVE (especially the deep cores the same-model pass admitted it couldn't check —
Carleman estimates, near-axis GN, pigeonholing constants), independent hard-verification audit, scope-check,
and an explicit "verify-or-challenge the internal findings + say what a same-model pass MISSED." Self-contained
(no doc/spec access) for adversarial independence; primed to refute. Awaiting relayed responses → will
metabolize into a verdict. `:proved`=0; distance UNTOUCHED.

## v0.1.96 — 2026-06-07 — C5 adversarial pass on |x₃|^α + Type-II rates: both SURVIVED + faithful use; hard/machine verification = NONE exists (the social-verification floor, stated plainly)

C5 pass (high bar: try to DISPROVE; audit for HARD verification — formal/machine/CAP/rigorous-numerics vs
SOCIAL = peer-review+citation; scope-check) on the two recent load-bearing results. Four hostile/audit
agents. `docs/c5_adversarial_pass_2026-06-07.md`. **Foundation-hardening, not PDE progress; `:proved`=0.**
- **`|x₃|^α` (Wang–Huang–Wei–Yu Thm 1.4): SURVIVED.** Adversary independently re-derived the scaling, the
  `α<1/4` constraint (range-choice, not a ceiling), the Gronwall closing (criticality used correctly,
  nothing dropped). **Use FAITHFUL** — the proof is forward-Gronwall-from-`t=0` (anchored to `u₀∈H²`), so
  "doesn't transfer to ancient" is structurally correct. (`u₀∈H²` is a real hypothesis — a finite-time
  smoothness criterion, not bare Leray–Hopf; immaterial to our use.)
- **Type-II rates (Tao triple-log + Palasek double-log): SURVIVED.** Tao's three logs all load-bearing
  (the `d≥4` quadruple-log is the decisive consistency check); genuine lower bound; `Thm 1.2⇒1.4` verified.
  Palasek double-log confirmed (plain weak-`L³`, axisymmetric-only). **Use FAITHFUL** ("partial exclusion,
  qualitative gap, diverges arbitrarily slowly" = exact content); keep the double-log "axisym weak-`L³`"-tagged.
- **HARD-VERIFICATION ANSWER (the user's key question): NONE.** No formal/machine (Lean NS = a
  problem-statement scaffold only; no Carleman/parabolic-NS in any proof assistant), no CAP (non-explicit
  constants), and for `|x₃|^α` not even an independent re-proof (same-author JMAA 2023). Type-II has a
  *genuine partial independent cross-check of the slow-divergence PHENOMENON* (Palasek's distinct method),
  not of Tao's exact constant. Both honestly **declined to fake a verdict** on the deepest cores (Carleman
  estimates, near-axis GN, pigeonholing constants — beyond text-level checking).
**The epistemic floor, stated plainly:** the obstruction manifold's load-bearing foundation is **socially
verified**, not machine-verified; the C5 pass confirms internal consistency + faithful use but cannot
substitute for formal verification that does not exist (a multi-year Lean+mathlib effort, field-wide, not
a session task). Honest tier going forward: **"C5-adversarial-survived; hard-verification = none (social
floor)."** Pass was INTERNAL (weaker than external by our own confirmation-bias rule). `:proved`=0;
distance UNTOUCHED.

## v0.1.95 — 2026-06-07 — NRŠ + ESS originals LINE-READ: both global anchors C2→C3; no load-bearing citation now rests on an un-line-read C2

Line-read the two previously-paywalled/Russian originals (the last load-bearing C2s). `docs/nrs_ess_verification_2026-06-07.md`.
**Foundation-hardening, not PDE progress; `:proved`=0.** Both promote to **C3**:
- **NRŠ (Acta Math. 176, 1996) → C3** — fetched the genuine Acta scan via **Project Euclid open access**.
  Thm 1 (p.291): weak `U∈L³(ℝ³)⇒U≡0`; the `H=½|U|²+P+a(y·U)` max-principle + `L³`→`O(|y|⁻²)`-decay (CKN
  ε-reg) + energy identity, all read. **Confirms our records:** hypothesis is exactly `L³`; the
  local-energy case is explicitly LEFT OPEN (p.284) = genuinely Tsai's domain. ("Backward" is a downstream
  adjective; substance = Thm 1.)
- **ESS (Russ. Math. Surveys 58, 2003) → C3** — read the authors' **verbatim English version** (UMN
  Conservancy 11299/3858); published-RMS metadata (title/abstract/TOC) visually confirmed (mathnet.ru;
  prose is legacy-font mojibake). **Endpoint space confirmed `L_{3,∞}` (weak-`L³`), not `L³`** (Thm 1.3);
  the §3 blow-up→ancient-limit + §4 unique-continuation + §5 backward-uniqueness + §6 Carleman structure
  confirmed; the original uses a blow-up/compactness step (vs Tao's quantitative-Carleman-only).
**Net:** of the five load-bearing global anchors — NS-002 (self-derivable via NS-034), **NS-005 ESS (C3
now)**, NS-006 CKN (C2 statement, mainstream; C1 `ε₀` constants unused), **NS-007 NRŠ (C3 now)**, NS-008
Tao (result C3, scope C2) — **none now rests on an un-corroborated, un-line-read C2.** The obstruction
manifold's load-bearing foundation is C3 (or self-derivable / mainstream-statement) end to end. Updated:
audit rows 2/6, Type-II §7. `:proved`=0; distance UNTOUCHED.

## v0.1.94 — 2026-06-07 — Probed Lockwood's δ_Λ→0 internally: the resolved DNS drives the anisotropy defect UP at reconnection, not toward 0 — the question reduces to the ancient/Type-I limit (links NS-049→NS-048)

Internal DNS probe of the NS-049 verification's sharpest question — "what forces `δ_Λ→0` along a blow-up?".
New `scripts/ns049_anisotropy_defect_probe.jl` (+ `.out.txt`), companion
`docs/ns049_anisotropy_defect_companion.md`; NS-049 verification entry + memo Q2 + dashboard sharpened.
Within-truncation witness (Re=1600, REGULAR, vacuity cap); NOT the PDE; `:proved`=0; prize UNTOUCHED.

**Object:** Lockwood's defect `δ_Λ=1−λ_max(M_Λ)/tr(M_Λ)`, `M_Λ=Σ_{|ω|≥Λ}ω⊗ω` (sign-blind), over the top-`q`
`|ω|` set (`q∈{1,0.1,0.01,0.001}`), per time. N=1 gate passes (synthetic one-directional δ=0.000 / planar
0.490 / isotropic 0.654).

**Result — the resolved dynamics drive `δ_Λ` UP at the intense events, not toward 0.** TUBES (Kerr
reconnection, the most singular-like event) *starts* one-directional (anti-parallel tubes ⇒ rank-1 `M`,
δ≈0.008, the sign-blindness in Lockwood's favour) and `δ_Λ` of the top-0.1% cores then **rises 0.008 → 0.35
(winf peak, t=5.5) → 0.59** as the reconnection bridge adds the perpendicular directions (structure rank-1
→ 3D, λmax/tr 0.99→0.41). At peak intensity the cores sit at δ≈0.32 (TG — planar/sheet, rank-2) / 0.35
(tubes) / 0.54 (helical) — bounded well above one-directional in every flow. Consistent with NS-038's
intermediate-eigenvector alignment: the physically-realized intense geometry is multi-directional.

**Bearing.** The internal answer to "what forces `δ_Λ→0`?" is: *nothing in the resolved flow — it runs the
other way at the events where a singularity would form.* This sharpens NS-049 from "the `δ_Λ→0` hypothesis
is assumed, not derived" to "…and the DNS drives `δ_Λ` up at intense events." **Synthesis:** therefore
`δ_Λ→0` could hold (if at all) only on the **rescaled ancient / Type-I blow-up limit**, not the resolved
geometry — so Lockwood's anisotropy hypothesis is really a claim about the ancient solution's directional
structure, **linking NS-049 to NS-048**. The precise, fair, non-dismissive question for Lockwood: *does the
Type-I rescaled limit one-directionalize even though resolved reconnections drive `δ_Λ` up?* **Vacuity cap
(the steelman for him):** resolved evidence, NOT proof about the singular limit; N=64 coarse (trend
robust). Brief outreach framing still left to Aaron's call. `:proved`=0; distance UNTOUCHED.

## v0.1.93 — 2026-06-07 — Type-II branch MAPPED (exclusion ⊕ construction, primary-read): both sides OPEN; it is the complement of the program's Type-I machinery

Engaged the Type-II branch — the harder half of the exclusion program (machinery study M7), the part the
NS-048 ancient-Liouville machinery structurally CANNOT reach. `docs/ns048_type_ii_frontier.md`. **No
theorem; `:proved`=0; NS-048 unchanged.** Two parallel primary-source sweeps (mostly C3):
- **Exclusion side (quantitative regularity = partial Type-II exclusion):** ESS (singularity ⇒
  `‖u‖_{L³}→∞`); Tao 2019 **triple-log** rate; Barker–Prange **single-log + parabolic-localization**
  (Type-I); Palasek **double-log** (axisym weak-`L³` / weighted). **THE GAP is qualitative:** rates diverge
  *arbitrarily slowly* (loglog/logloglog); excluding Type-II needs forcing the rate faster than the
  equation permits — the whole open problem. General Type-II exclusion = NONE (only conditional
  scenario-exclusions, Seregin). *(Honest correction: my "near-`(T−t)^{−1/2+}` axisym exclusion" intuition
  was wrong — it's double-log; conflated with the Leray Type-I criterion.)*
- **Construction side: NO rigorous true-NS blowup (class (a) = NONE).** Hou = numerical only (2024 needs
  `d≈3.188`); Chen–Hou CAP = Euler/Boussinesq-WITH-BOUNDARY (not viscous NS); rigorous blowups (Tao
  averaged, Córdoba forced+fractional, Q.Zhang forced, Li–Sinai complex) are all DIFFERENT equations;
  modulation toolkit (Raphaël–Schweyer/KST/MRR) is other-equations. **Viscosity is the obstacle.**
- **Structural observations:** (i) the blowup *rate* is the single shared object (exclusion `rate≥slow` vs
  construction `rate=faster`; the gap IS the problem); (ii) **viscosity is tool-AND-obstacle** (supplies
  exclusion rate bounds — `d≥4` worse = fewer Leray intervals — and is the construction barrier); (iii)
  **axisymmetric is the sharpest arena both sides**; (iv) NS-048's machinery has a **Type-I ceiling** —
  Type-II is its complement (global statement). Type-II is where a real NS singularity, if any, MUST live
  (ESS).
- **Tractable entry (named, research-scale):** push the axisym weak-`L³` double-log → single-log / critical
  Besov `Ḃ^{-1}_{∞,∞}` (Palasek's explicit conjecture, 2210.10030).
Both sides genuinely open; the program maps Type-II precisely but cannot resolve it. Search-space
compression, honestly scoped. SPEC NS-048 pointer added. `:proved`=0; distance UNTOUCHED.

## v0.1.92 — 2026-06-07 — Engaged the Lockwood math (line-read I–V): the program is CONDITIONAL on δ_Λ→0 (assumed, not derived); a conditional anisotropic criterion, not the unconditional proof its framing implies

Adversarial line-read of *Singularity Surgery* Parts I–V (the substantive engagement flagged in v0.1.91).
New memo `docs/ns049_lockwood_verification.md`; NS-049's caution sharpened from generic "unverified" to the
specific finding; dashboard note. **`:proved`=0; this is verification of an external object, not PDE
progress.** Posture caveat recorded: I am an AI reading unrefereed AI-assisted working papers — the
validator-confirmation-bias discipline applies to *me*; findings are framed as questions, not verdicts.

**Headline (C3 on line-read of the stated hypotheses).** The whole program is conditional on the weighted
anisotropy defect vanishing, **`δ_Λ(0,1)→0`, ASSUMED in every theorem, never derived:** Part III Thm 8.1's
two-scale contraction holds only "with `δ_Λ(0,1)≤ε`"; Part IV Lemma 3.1 (eq 21) converts *absolute* defect
smallness to *relative* (`Y_b/Z_n ≤ (ℓM_ω/4m_*)δ_Λ(0,1)`) via the Case-B enstrophy lower bound, but the
`→0` is still driven by the external `δ_Λ(0,1)→0`. The complementary **`δ_Λ` bounded-below
(multi-directional intense vorticity)** case is nowhere addressed and not on his remaining-problem list —
and **our NS-038** (intermediate-eigenvector alignment, sheet/tube reconnection, NOT a frozen direction) is
direct evidence that this *unhandled* case is the physically-indicated geometry.

**Secondary findings.** The depletion lemma is a **sound-but-unfinalized skeleton** (his own framing —
mechanism clean, interpolation arithmetic checks `3/10+3/10+2/5=1` etc., CZ at `L^{10/3}` not the `L^∞`
trap; but cutoff commutators "harmless" + harmonic remainder "lower-order" are asserted, not estimated).
The strict-core "rigidity" is essentially the **definitional** identity `∫χ|ω×e|²=tr(M_Λ)·δ_Λ` (so `δ_Λ→0`
⟺ weighted-`L²` alignment; soft once that holds — Lockwood half-agrees, "no longer a global regularity
miracle"). Part V's selection problem is downstream of and conditional on `δ_Λ→0`.

**Honest verdict.** Read as unconditional regularity, "Part I corners the program" overstates it (unremoved,
physically-suspect `δ_Λ→0` + two skeletons). Read as a **conditional anisotropic regularity criterion**
(small weighted anisotropy defect ⇒ regular), it is a **genuine, citable contribution** in the
Constantin–Fefferman family, with a *weaker, integral* one-directionality trigger than CF's pointwise
Lipschitz-ξ — NOT the Millennium problem. NS-049 stays C0/C1 `:open` UNVERIFIED; caution sharpened to
"conditional on an underived, physically-suspect defect-vanishing hypothesis." Three sharp questions for
Lockwood recorded (conditional-vs-unconditional; what forces `δ_Λ→0`; does the `δ_Λ→0` regime capture the
DNS geometry) — the brief's outreach framing left to Aaron's call. `:proved`=0; distance UNTOUCHED.

## v0.1.91 — 2026-06-07 — Lockwood "Singularity Surgery" read + added as NS-049 (live/conditional, C0-C1 UNVERIFIED); external-review brief prepared with a related-work bridge

Prep for ③ external forcing — the obstruction map / generator-class is going to **James Lockwood**, who
works analytically on NS. Read all five parts of his *Singularity Surgery* (2026-04-13 working papers).
Added SPEC entry **NS-049**, a dashboard note, and a "related work" section to
`docs/ns_external_review_brief.md`. **`:proved`=0; prize UNTOUCHED.** (Numbered v0.1.91 — concurrent
NS-048 audit arc holds 85–90.)

**What Lockwood's program is.** A serious CKN-deformation attack: **anisotropy of the high-vorticity set
depletes vortex stretching**, made local via the Riesz/CZ identity that the principal strain is a CZ
operator on the *perpendicular* vorticity (`S₃₃=R₁R₃ω₂−R₂R₃ω₁`) and a weighted anisotropy defect `δ_Λ`.
Case A (low-activity) is closed; across Parts I–V the open content is *isolated* (never a completed proof,
his own framing) to a compactness-rigidity strict-core theorem and, by Part V, two "final selection"
theorems — reducing regularity to "the identification of the admissible trace class."

**Citation verdict (answering the question put):** (a) **no new external literature** — his papers are
self-contained, no bibliography, only standard tools (CKN/CZ/Aubin–Lions/De Giorgi, all already in the
map); (b) **his program itself is the new citation**, added as NS-049 at **tier C0/C1, status :open,
UNVERIFIED** — explicitly NOT treating his depletion lemma or strict-core theorem as established (they are
his stated unresolved inputs, in unrefereed AI-assisted working papers; the structured-local-coherence
caution applies maximally). Verifying them (line-reading Parts III–V) would be the substantive engagement,
not a citation.

**Why it's the right recipient (and the brief's related-work bridge):** his depletion mechanism is a
candidate for exactly the σ=0 production control we frame as NS-046, and uses the CZ/Riesz structure we
flagged live in NS-047. Two convergences put to him in the brief: (i) his depletion via **weighted
perpendicular-vorticity smallness** (weaker than the pointwise Constantin–Fefferman Lipschitz-ξ) is a
**weighted/integral** control — independently matching our NS-046 conclusion that any closing inequality
must use Besov/integral controls, not pointwise domination; (ii) his **anisotropy** trigger vs our
**helicity/Beltramization** trigger (NS-040/045) — relation open. The two convergences are framed as
questions for him, with the within-truncation vacuity cap stated.

## v0.1.90 — 2026-06-07 — Pan–Li verified C3 (last audit thread): it is NO-SWIRL — corrects "swirl allowed"; route-(i) counterexample suspicion WITHDRAWN (16th); combined verdict sharpened

Verified the last loose citation thread — Pan–Li, read line-by-line. `docs/pan_li_verification_2026-06-07.md`.
**Foundation-hardening, not PDE progress; `:proved`=0.** Two corrections; the combined-conjecture verdict
(v0.1.88) is confirmed + sharpened:
- **Pan–Li is NO-SWIRL** (Thm 1.1 assumes `u^θ≡0`); it extends the *KNSS no-swirl bounded* case to sublinear
  *growth* (`|u|≤C(√(−t)+|x|)^α`, `α<1`). **C2 → C3.** Venue corrected: **NA:RWA 56 (2020)** (arXiv:1908.11591),
  not Bull. Sci. Math.; and "axisym swirl allowed" (a review-drift, ~C1) corrected to **no-swirl**. Resolves
  the scope puzzle: it doesn't prove the open conjecture because it's the no-swirl regime.
- **Load-bearing answer:** Pan–Li does **not** close the weak-radial *with-swirl* regime — it doesn't even
  apply (nonzero swirl). So that regime is **genuinely OPEN** (not redundant); the combined verdict's
  dichotomy resolves to the **open** branch — combined still ≠ a new closer.
- **16th honesty-ledger item:** route (i)'s "axial-only conjecture SUSPECT/possibly-false" cited Pan–Li's
  `α=1` counterexamples — but those are **swirl-free** (Prop 1.5), so they give **no** with-swirl
  counterexample. **Suspicion WITHDRAWN;** the axial-only conjecture is **OPEN**. The route-(i) blow-down
  break itself stands (self-derived); only the suspicion's basis is removed.
**Verification campaign FULLY CLOSED:** #1 KNSS, #1b Albritton–Barker, #2 NS-007, #3 LRZ+Thm3.7, Pan–Li —
all C2/C3, with **four** citation-supply-chain errors caught + corrected (Albritton–Barker≠S–Š; ⟺
"general"→"Type-I-conditioned"; Lemma-6.1 naming; Pan–Li "swirl-allowed"→"no-swirl"). NS-048 standing:
session-scale attacks exhausted; residue = bare conjecture (`Γ∈L^∞` with swirl) + un-mechanised `S`-control
route. Corrected: route (i) §6/§7/§8, combined doc §4/§6, audit (Pan–Li row). `:proved`=0; distance
UNTOUCHED.

## v0.1.89 — 2026-06-07 — MDAGC synthesis: the global no-go's assembled into the positive "what a blowup must be" object; the phase arc gets a global home (sharpens S1, not a new no-go)

Implements the meta-review's endorsed direction (forward value = global method-exclusion / generator-class
reduction, not more local probes). New synthesis artifact `docs/ns_blowup_generator_class.md`; pointer
added to the SPEC MDAGC-framing header + dashboard. **Reorganization, NOT PDE progress; `:proved`=0; prize
UNTOUCHED.** (Numbered v0.1.89 — v0.1.85–88 taken by the concurrent NS-048 attack arc.)

**The object.** A 3D-NS finite-time singularity, if one exists, must satisfy a conjunction of
necessary conditions, each tier-tagged (C0–C5) and labelled hard/soft/witness:
- **HARD (theorem-backed):** G1 blows a critical σ=0 norm (NS-005/ESS C2; GKP C1) · G2 singular set ≤1-D
  (CKN C2) · G3 not exactly self-similar (NRŠ C2 / Tsai C3) · G4 Type-I ⇒ a nontrivial **Type-I-conditioned**
  bounded ancient solution, else Type-II (Albritton–Barker C3 — conditioning made explicit; KNSS C3) ·
  G5 not energy-only-excludable (Tao C2, a method-class exclusion).
- **SOFT (framing/reduction):** S1 supercritical descent failure (NS-002/034) · S2 the vortex-stretching
  production `∫ω·Sω` is the σ=+1-rung breaker (NS-036).
- **WITNESS (within-truncation, heuristic):** W1 the production is a phase-coherence object · W2 sharpest
  detector is the vorticity `Ḃ⁰_{∞,1}` (the recent four-probe arc, subordinated as generator-structure).

**Compression:** dead = energy-/spectrum-only methods, exact self-similar, region-filling singularities;
live attack must engage the σ=0 production (NS-046 static) or the ancient/Type-II objects (NS-048 dynamic)
— one wall, two structures; the class is heavily constrained but non-empty (= the prize, holes A/B).

**② The phase-blindness test (run honestly inside, §4).** Could W1 upgrade to a new hard method-exclusion?
**No — declined.** Rigorous part (a genuine *sharpening of S1*): the phase-scramble is an explicit
counterexample family — div-free fields with identical `(E,Z,H, full spectrum)` whose production differs
~30× — so `P` is provably **not a function** of the coercive invariants or the amplitude spectrum (stronger
than NS-002's scaling argument; broadens it from energy to any amplitude-spectrum quantity; ~C4). But a
regularity *method* uses the time-evolution (carrying phase info), not the instantaneous spectrum, so
"phase-blind methods can't work" conflates instantaneous insufficiency with dynamic impossibility — an
over-reach declined (soft≠hard). Net: the recent NS-013/046 arc earns a **global home** as a
counterexample-backed sharpening of supercriticality, answering the meta-review's structured-local-coherence
critique by subordinating the local findings to the necessary-conditions object — without over-claiming a
new barrier.

Honest scope: the hard constraints are others' tier-tagged theorems; the soft/witness ones may change
representation; the witnesses are within-truncation (vacuity cap). Independent uptake, not internal
elegance, is the only test that this is compression and not coherent narrative.

## v0.1.88 — 2026-06-07 — The "combined axial+radial" conjecture COLLAPSES (redundant/stuck); 15th over-reach retired; NS-048 session-scale attacks exhausted

Worked the live "combined axial+radial" conjecture (from route (i) / the port doc).
`docs/ns048_combined_axial_radial.md`. **No theorem; `:proved`=0; NS-048 unchanged.** The scaling resolves
it as a structural **collapse**, not a target:
- **Self-derived two-tail scaling:** any radial decay `u^θ≲r^{−β}`, `β>0`, kills the source's `r`-tail
  (`∫|S| r dr ~ ∫r^{−1−2β}dr` converges); axial `|x₃|^α` kills the `z`-tail ⇒ `∫|S|<∞`.
- **But STRONG radial ⇒ REDUNDANT (C3):** `Γ∈L^p` (LZZ) or `|u|≤C/r` (KNSS Thm 5.3) each **close ALONE**;
  the blow-down machinery needs radial `Γ`-decay and then finishes without any axial input. The axial
  condition is never the binding constraint.
- **WEAK radial ⇒ STUCK (robust to Pan–Li scope):** the combined condition yields only `∫|S|<∞` — the
  **`S`-control route, which the verification campaign showed has no known mechanism** (everyone bypasses
  `S`); and the weak-radial regime's solo status is open either way (Pan–Li C2, scope-uncertain). Either
  branch ⇒ not a new closer.
- **Verdict:** route (i)/port's "a complete closer needs axial+radial combined" was over-optimistic —
  **15th honesty-ledger item, retired.** The axial half never becomes load-bearing.
**NS-048 session-scale attacks now exhausted:** every concrete attack (energy, max-principle, sign,
blow-down, axial port, combined) reduces to one of two genuinely-open cores — the *bare* conjecture
(`Γ∈L^∞`) or the *un-mechanised* `S`-control route — both needing ideas the program does not have. Honest
next options: verify Pan–Li primary (C2→C3, sharpens the weak-radial niche), or accept the frontier needs
a new idea. `:proved`=0; distance UNTOUCHED. Updated: route-(i) SPEC pointer (combined retired).

## v0.1.87 — 2026-06-07 — Audit #3 DONE → verification campaign COMPLETE: LRZ + Thm 3.7 both bypass S (C3); the "every closer bypasses S" universal HOLDS, hedge lifted

Executed the last audit target #3. `docs/citation_verification_round3_2026-06-07.md`. **Foundation-
hardening, not PDE progress; `:proved`=0.** A clean confirmation (no correction):
- **Lei–Ren–Zhang (ℝ²×T¹, arXiv:1911.01571) → C3:** bounded mild ancient axisym + Γ bounded + z-periodic ⇒
  v≡c e_z, via DGNM/oscillation-Harnack on the Γ-transport eq (z-periodicity + ∇·b=0 supply the critical
  scaling) forcing Γ≡0 → swirl-free → KNSS. **Bypasses S.**
- **"Thm 3.7" → C3** (identified as Thm 1.2 of arXiv:1902.11229, the preprint [70] was split from;
  hypothesis byte-identical): small radial oscillation ⇒ lim_{r→∞}Γ=0 via a weighted Γ-energy estimate →
  swirl-free → Lei–Zhang–Zhao → KNSS. **Bypasses S.**
- **Universal HOLDS:** "every known with-swirl closer bypasses S / forces Γ-decay → swirl-free" is now
  **C3 for all three** (LZZ + LRZ + Thm 3.7); the meta-review §4 C1 hedge on "every" is **LIFTED**. The
  frontier doc's "controlling S is a road not taken" is strengthened; the review independently corroborates
  ("Γ-in-isolation fails without ∇·b=0" — every route tames Γ-transport, never the Ω-source).
**Verification campaign COMPLETE:** #1 KNSS C3 (foundation hypothesis-clean) · #1b Albritton–Barker C3
(⟺ reattributed + Type-I-conditioned) · #2 NS-007 (NRŠ C2, Tsai C3) · #3 LRZ+Thm3.7 C3. Net: 1
over-attribution + 1 scope overstatement caught/corrected, 3 load-bearing claims confirmed; the
obstruction manifold's foundations hardened. Remaining (optional, low-priority): S–Š 2009 CPDE 34;
NRŠ Acta primary C2→C3. Updated: audit (#3 row + §2 + campaign-complete), frontier doc (hedge lifted).
`:proved`=0; distance UNTOUCHED.

## v0.1.86 — 2026-06-07 — Audit #1b + #2 DONE: the Type-I ⟺ is ALBRITTON–BARKER (not Seregin–Šverák; corrects v0.1.85) and Type-I-conditioned; NS-007 confirmed (NRŠ C2, Tsai C3)

Executed audit targets #1b (Type-I ⟺) and #2 (NS-007 self-similar). `docs/citation_verification_round2_2026-06-07.md`.
**Foundation-hardening, not PDE progress; `:proved`=0.** The C0–C5 discipline caught two supply-chain
errors — both in my own v0.1.85:
- **CORRECTION (severe, corrects v0.1.85's title): the Type-I ⟺ is Albritton–Barker (arXiv:1811.00502,
  2019), NOT Seregin–Šverák.** v0.1.85 parroted the M4-calibration "Seregin–Šverák" label without checking
  the arXiv id (secondary-source drift, failure-mode #2). `1811.00502` resolves to **Albritton–Barker**;
  the S–Š paper of near-identical title is a *different*, **2009 axisymmetric** Type-I paper (CPDE 34). The
  ⟺ (Albritton–Barker Thm 1.1) is **C3** (line-verified), **general 3D**, no swirl/smallness.
- **SCOPE CORRECTION: the ⟺ is Type-I-CONDITIONED.** The ancient hypothesis is the scaled-energy `I<∞`
  (not pointwise `C/√(−t)`, which is explicitly insufficient for ⇐). So the linchpin claim holds only in
  its narrower form: **NS-048 (Type-I exclusion) ≡ Type-I-conditioned ancient Liouville** — the
  *unconditioned* KNSS conjecture is strictly stronger and open. v0.1.85's "general Liouville" framing
  overstated (wrong-emphasis, failure-mode #3). (The machinery-study §5 "for the Type-I case" hedge was
  right.)
- **#2 NS-007 CONFIRMED:** NRŠ `U∈W^{1,2}_loc∩L³ ⇒ U≡0` (the `Π=½|U|²+P+a y·U` max-principle + `L³`-decay
  mechanism) — **C2** via Tsai's faithful primary reproduction (Acta 1996 paywalled, not line-read); Tsai
  ARMA 1998 (`L^q` `q∈(3,∞]`; local-energy strictly weaker than `L³`) — **C3** line-read. Our `L³` cite is
  faithful; the local-energy version was correctly attributed to Tsai.
Corrected docs: knss_verification §3b/§5/§6 (banners), machinery study §5, audit (#1b/#2 rows + §2).
Remaining audit target: **#3** (Lei–Ren–Zhang + Thm 3.7). New low-priority: S–Š 2009 axisym Type-I.
`:proved`=0; distance UNTOUCHED.

## v0.1.85 — 2026-06-07 — KNSS line-verified to C3 (audit target #1 DONE): foundation hypothesis-clean; Type-I ⟺ reattributed to Seregin–Šverák [SUPERSEDED by v0.1.86 — it is Albritton–Barker, Type-I-conditioned]; route (i) break #2 C3-confirmed

Executed citation-audit target #1: read KNSS (Acta 2009, arXiv:0709.3599) line-by-line (curl +
pdftotext). `docs/knss_verification_2026-06-07.md`. **Foundation-hardening, not PDE progress; `:proved`=0.**
All five items promoted C2/C1 → **C3**. The don't-bluff check did real work:
- **POSITIVE (firms the chain):** the **swirl-free reduction (Thm 5.2)** — the terminal step of *every*
  axisymmetric closer — is **C3 and HYPOTHESIS-CLEAN** (exactly bounded+weak+axisym+no-swirl; regularity
  *derived* from boundedness §4; no hidden decay/suitability). mild ⊂ weak, mild ⇒ literally constant
  (Remark 6.1). Downstream "bounded mild axisym swirl-free ⇒ trivial" is faithful.
- **CORRECTION:** the Type-I **⟺** is **not KNSS** — KNSS **Prop 6.1** is **⇒ only** (C3); the full **⟺**
  is **Seregin–Šverák arXiv:1811.00502** (held at **C1**, not primary-read) ⇒ **new target #1b**. Fixed
  the machinery-study §5 attribution + the audit KNSS row.
- **route (i) break #2 C3-CONFIRMED:** KNSS's Lemma 6.1 (the *compactness* lemma — naming corrected; it is
  not the rescaling) needs a **uniform-`L∞` input only**; route (i)'s `|x₃|^α` blow-down fails exactly
  that (`‖u_λ‖_∞=λ‖u‖_∞→∞`). So the compactness break is now verified against KNSS's actual input.
- **Caveats attached:** 2D is `u=b(t)`(weak)/constant(mild); the Type-I *exclusion* (Thm 6.2) requires the
  off-axis `|u|≤C/r` decay (KNSS flags dropping it fails).
Net: the arc's foundation is solid (C3, clean); one over-attribution corrected (⟺ → Seregin–Šverák);
route (i) firmed; a new C1 target (#1b) surfaced. `:proved`=0; distance UNTOUCHED.

## v0.1.84 — 2026-06-07 — Critical-norm detector race: vorticity Besov Ḃ⁰_{∞,1} is the sharpest σ=0 detector; the velocity L³ (ESS endpoint) is the bluntest

*(Numbered v0.1.84 — the requested "v0.1.81" was already taken by the concurrent citation-audit arc, now at v0.1.83.)*

Within-truncation witness for NS-005 (critical-norm criterion) / NS-010 (diagnostics), folded into SPEC
(NS-005 detector bullet), dashboard, this entry. **DNS truncation; `:proved`=0; prize UNTOUCHED.**

**The probe** (`scripts/ns046_critical_norm_race.jl` + `.out.txt`; companion
`docs/ns046_critical_norm_race_companion.md`). GKP (2016) + ESS: *every* σ=0 critical norm must blow up at a
singularity — but they differ as practical DETECTORS. Raced four critical norms (+ contrast/reference) on
the Kerr anti-parallel-tube reconnection (Re=1600, N=64, the most singular-like resolved event, NS-038),
ranked by peak/baseline sharpness:

- **`‖ω‖_{Ḃ⁰_{∞,1}}` (Kozono–Taniuchi, vorticity): 2.5× — the SHARPEST**, peaks exactly at the reconnection.
- `‖u‖_{Ḃ⁻¹_{∞,∞}}` (Koch–Tataru): 1.6×; `‖u‖_{Ḣ^{1/2}}`: 1.1×.
- **`‖u‖_{L³}` (the ESS endpoint): 1.0× — the BLUNTEST**, monotonically *decays* through the event.
- Contrast: energy `‖u‖_{L²}` (σ−1, controlled) flat (blind, as it must be); enstrophy (σ+1) 1.5×; `‖ω‖∞`
  (BKM ref) 2.6× (sharpest overall — it *is* the blowup norm).

**The finding: the theorem-norm ≠ the detector-norm.** `L³` carries the celebrated ESS theorem yet is the
worst practical detector; the vorticity Besov `Ḃ⁰_{∞,1}` is ~2.5× sharper. Mechanism: the reconnection is a
localized small-scale vorticity event, and the velocity-integral critical norms (`L³`, `Ḣ^{1/2}`) are
large-scale-dominated, so the spike is a tiny fraction of their budget — sharp in theory (σ=0), blunt in
practice. That **large-scale-dominance blindness is another face of supercriticality (NS-002)** and of the
phase/intermittency arc (the sharp detectors are exactly the intermittency-sensitive ones). Practical
upshot: hunting blowup in a DNS, monitor `Ḃ⁰_{∞,1}`/`‖ω‖∞`, not `L³`.

Caps: within-truncation, REGULAR flow — a sensitivity ranking on an intense transient, NOT a blowup race;
N=64 (ranking likely strengthens with resolution). Closes a four-probe exploration arc (real-vs-complex →
phase-production → phase-norm-split → detector-race) that maps the production object `∫ω·Sω` as a
phase-coherence / small-scale object the controlled quantities are blind to. `:proved`=0.

## v0.1.83 — 2026-06-07 — Program citation audit (C0–C5): ranked verification targets; KNSS (swirl-free reduction + Lemma 6.1) is the #1 leverage point

First program-level application of the C0–C5 discipline. `docs/program_citation_audit_2026-06-07.md`.
**Foundation-hardening, not PDE progress; `:proved`=0.** Tiered the load-bearing external citations and
ranked verification targets by `load-bearing × (gap to C3) × (global>local)`:
- **#1 KNSS (Acta 2009): swirl-free reduction + Lemma 6.1 blow-down (C2/C1→C3).** Highest leverage — the
  terminal reduction of *every* axisymmetric closer and the device route (i) leaned on; the whole ancient
  approach (incl. the Type-I⟺ancient equivalence) rests on it.
- **#2 NS-007 NRŠ/Tsai exact hypotheses (C1→C2)** — a global no-go whose exact spaces are paraphrased, not
  primary-read; per the global>local framing, firming a global anchor is top-priority.
- **#3 Lei–Ren–Zhang + Thm 3.7 (C1→C2/C3)** — firms (or reshapes) the arc universal "every known closer
  bypasses S" (currently C3-for-LZZ, C1-for-these).
- Tier-3: Pan–Li (counterexample suspicion), Tao-2016 scope, ESS/CKN details, Yu/CFZ-2017 (not
  load-bearing). Solid C3 (no action): LZZ §5, Wang et al., CFZ multi-scale.
Discharges the meta-review's deferred "global-no-go anchors first" retrofit as a *plan*: NS-002 solid,
NS-005/006 C2-statements/C1-details, NS-007 = the one global anchor genuinely under-verified (#2), NS-008
C2 (Tier-3). Recommendation: attack #1 (KNSS) first. Raises confidence of the obstruction manifold;
distance UNTOUCHED.

## v0.1.82 — 2026-06-07 — Route (i) blow-down on the |x₃|^α conjecture: does NOT close it; corrects my own port-doc over-reach (14th); axial-only conjecture now SUSPECT

Attacked the `|x₃|^α` ancient Liouville conjecture by the blow-down / Liouville-via-rescaling device.
`docs/ns048_route_i_blowdown.md`. **No theorem; `:proved`=0; NS-048 unchanged.** First artifact under the
C0–C5 citation discipline (tiers in §8). Result is a clean, informative **negative**:
- **Decisive break (self-derived scaling + C3-LZZ contrast):** the blow-down `λ→∞` exposes spatial-infinity
  structure and is matched to **radial** decay. Saturating the bounds: LZZ's radial `L^p` gives
  `Γ_λ≲λ^{−1/p}|x_h|^{−1/p}→0` (concentrates — why LZZ closes); the axial `|x₃|^α` gives
  `Γ_λ≲λ^{1−α}|x_h||x_3|^{−α}→∞` (the *radial growth* of `Γ=ru^θ` is AMPLIFIED, not concentrated). The
  blow-down is intrinsically radial-scaling; the axial condition is orthogonal to what it needs.
- **Second break:** compactness fails — `‖u_λ‖_∞=λ‖u‖_∞→∞`, and the critical norm is too weak to give
  strong compactness for the NS nonlinearity (supercriticality NS-002 reappearing).
- **14th honesty-ledger item — corrects my OWN port doc:** I'd claimed route (i) "sidesteps the radial-tail
  problem" and "criticality is exactly what the device requires." Both wrong — route (i) is *more*
  dependent on radial control (blow-down scales `r`); criticality is necessary, not sufficient. Deflated by
  trying it.
- **Reinforces the two-tail reading** (both energy + blow-down routes need radial control; `|x₃|^α` is only
  the axial half) and **raises a counterexample suspicion:** saturating gives `Γ~r|x_3|^{−α}` (linear
  radial growth, `u^θ` bounded), and Pan–Li [C2, via review] make `α=1` velocity growth the *sharp*
  threshold with non-constant counterexamples ⇒ the **axial-only conjecture may be FALSE** (not
  constructed; honest hedge). Sharp sub-question: construct or exclude a linear-radial-growth, `z`-decaying
  non-constant ancient solution.
Honest reformulation: the live conjecture is `|x₃|^α` (axial) **+ radial (LZZ-type) combined**; the
axial-only version shifts from "open" to "suspect." Citation discipline note: the negative verdict rests on
**self-derived scaling + C3**, solid; the device-framing (KNSS Lemma 6.1) is **C1** and the counterexample
suspicion **C2** — flagged, neither load-bearing for the verdict.

## v0.1.81 — 2026-06-07 — Program meta-review metabolized: 3 upgrades (record + C0–C5 citation tiers + generator-class/global-no-go framing)

Metabolized a ChatGPT meta-review of the whole program (`~/Desktop/chatgpt-ns.rtf`) into three upgrades.
`docs/program_meta_review_chatgpt_2026-06-07.md` (recorded with critical annotations). **No PDE progress;
`:proved`=0.** Critical posture: the review read our own artifacts, so its praise of the "discipline" is
**discounted as partial echo** (validator-confirmation-bias rule); the **critiques** are the value and are
accepted without defense — (1) no theorem-level movement (the bar); (2) numerics capped; (3) **"highly
structured local coherence"** = the permanent risk (internal elegance > external necessity; independent
uptake is the only test). Adopted self-description: *a search-space-compression / obstruction-and-
methodology lab, not a proof-contender.*
Three upgrades, two now in the `SPEC.md` header:
- **Recorded** — the meta-review doc + annotations.
- **Instituted — Citation reliability C0–C5:** every externally-cited theorem carries a tier (C0 unverified
  → C5 adversarially checked); a no-go's confidence is gated by `tier × independence × scope-match`;
  citations are witnessable objects, not trusted primitives (echo≠convergence for citations). The
  don't-bluff rule, typed. **Worked on the NS-048 arc** (meta-review §4): immediately did informational
  work — the conclusion "every known with-swirl closer bypasses `S`" is **C3 for Lei–Zhang–Zhao**
  (line-read) but only **C1 for Lei–Ren–Zhang / Thm 3.7** (review-paragraph only) ⇒ the universal "every"
  now carries a C1 hedge; the `|x₃|^α` transfer verdict rests on C3 sources (solid).
- **Adopted — mission framing:** the ledger is a **generator-class reduction engine (= ORSI MDAGC)**; the
  map's acceleration is **global no-go** (NS-002/007/008) over **local**; **soft no-go ≠ hard no-go**
  (never conflate). Note: the review independently re-derived MDAGC from the artifacts (mild signal, or
  echo — flagged).
Not done (avoid export surplus): full-ledger C0–C5 retrofit (future bookkeeping; global-no-go anchors
first). Route (i) proceeds with the C0–C5 discipline now governing its citations.

## v0.1.80 — 2026-06-07 — Production is a PHASE-COHERENCE object (3D): two phase-scramble probes → supercriticality gets a phase-blindness face

Two within-truncation witnesses extending the NS-013 phase/reality arc to 3D, folded into SPEC (NS-013
bullet + an NS-002 phase-space-face note), dashboard, this entry. **DNS truncation; `:proved`=0; prize
UNTOUCHED.** Sequel to v0.1.75's 1D real-vs-complex result (production `∫g³≡0` on the one-sided
complex-blowup class; reality activates it), which flagged: *does reality's spectral/phase structure gate
the 3D production?*

**(1) Phase-production** (`scripts/ns013_phase_production_3d.jl` + `.out.txt`; companion
`docs/ns013_phase_production_3d_companion.md`). A random-phase surrogate `û→e^{iφ(k)}û`, `φ(−k)=−φ(k)`
preserves `|û(k)|` ⇒ E, enstrophy Z, **and helicity H** exact (verified ~1e-16 per α) + div-free, while
destroying the cubic/triadic phase coherence; `α:0→1` sweeps coherent→scrambled, 5 seeds, on TG (H=0) and a
helical field (H≠0) developed to t=4. **Result:** the production `∫ω·Sω` collapses **97% (TG) / 99%
(helical)** and `S_ω→~0` while E,Z,H are pinned to machine precision ⇒ the 3D production is a
PHASE-COHERENCE object, not a spectrum object — the 3D shadow of the 1D `one-sided ⇒ ∫g³=0` result. The
"what transfers to 3D" question is answered **YES**.

**(2) Phase-norm split** (`scripts/ns013_phase_norm_split.jl` + `.out.txt`; companion
`docs/ns013_phase_norm_split_companion.md`). Under the SAME surrogate, which norms are phase-blind vs
phase-sensitive? The a-priori-coercive L² invariants E,Z,H (Leray's controlled quantities, NS-003) are
**exactly phase-BLIND** (Parseval); the regularity-deciding production `∫ω·Sω`/`S_ω` are **phase-SENSITIVE**
(collapse in both flows). ⇒ supercriticality (NS-002) gets a concrete phase-space face: **the controlled
quantities are blind to the phase coherence carrying the production.** HONEST NUANCE: the BKM/critical-Besov
norms `‖ω‖∞`,`Ḃ⁰_{∞,1}` are phase-sensitive only for the COHERENT flow (TG `‖ω‖∞`→0.44) and flat for the
already-incoherent random-helical IC — an intermittency effect, NOT a universal collapse. Claiming "the
Besov norm collapses under scramble" would have been the **14th over-reach this arc** (caught + declined);
the clean robust claim is production-vs-controlled, not Besov-vs-controlled.

**Synthesis (the maximum-insight payoff).** Three cheap within-truncation probes (v0.1.75 real-vs-complex
1D, and these two) now converge on the production object `∫ω·Sω` (which the no-go map funnels everything to,
NS-036): it lives in the phase coherence (reality's conjugate/triadic structure), and the quantities we can
control a priori are precisely the ones blind to it — a fresh lens on the keystone wall (NS-002:
controlled = phase-blind, deciding = phase-coherent). Each is a content-location diagnostic (a phase
surrogate), not an analytic step; vacuity cap stands; `:proved`=0.

## v0.1.79 — 2026-06-07 — Anisotropic-z port to ancient Liouville: GENUINE new question, transfer-gap located, condition is the z-half of a likely z+r fix

Executed the entry sub-question from v0.1.78 — port the finite-time anisotropic-z swirl regularity
criterion to the bounded-ancient setting. `docs/ns048_anisotropic_z_port.md`. **No theorem; `:proved`=0;
NS-048 unchanged.** A focused research pass read the proofs line-by-line:
- **Citation correction:** the `|x₃|^α u^θ` (axial-weighted) criterion is **Yu (Appl. Anal. 2020) /
  Wang–Huang–Wei–Yu (arXiv:2205.13893 Thm 1.4)**, NOT Chen–Fang–Zhang (CFZ are *radial*-weighted `r^d u^θ`).
  Corrects the attribution in v0.1.78's frontier doc.
- **Criticality verified:** `‖|x₃|^α u^θ‖_{L^q_tL^p_x}` scale-invariant ⇔ `2/q+3/p=1−α` (Thm 1.4's line);
  `‖|x₃|u^θ‖_∞` critical. So it's the right kind of condition for a Liouville translation.
- **Transferability verdict (key):** the finite-time proof is **direct Gronwall-on-`[0,T)`** (vorticity
  energy → anisotropic Hardy–Sobolev → Gronwall anchored to initial data `(Φ₀,Ω₀)` → finite-`T`
  continuation lemma) — **NO blow-up/ancient-limit.** So the ancient Liouville is **NOT implicit/
  extractable**; the port is a **genuine new question**, gap = exactly those two finite-`T`/initial-data
  steps (vacuous on `(−∞,0]`). (Hedge: CFZ's critical *radial* endpoint does route through Lei–Zhang
  ancient Liouville — but that's `r`-weighted, not `|x₃|^α`.)
- **Scoped positive + its limit:** the `|x₃|^α` bound gives `z`-decay of `u^θ` ⇒ `z`-decay of the source
  (`S≲|z|^{−2α−1}/r²`, heuristic), killing the **dominant `z`-tail** of `S` (the identified obstruction) —
  BUT the **borderline radial-log tail survives** (`∫dr/r`). Structural reading: the obstruction has two
  tails (z dominant, r borderline); LZZ's radial `L^p` kills the r-tail, `|x₃|^α` kills the z-tail; a
  **complete closing condition likely combines axial + radial control.** Heuristic, flagged.
- Comparison disciplined: `|x₃|^α` excludes the columnar case; "incomparable to radial" NOT claimed
  (13th-over-reach discipline holds). Honest next step: attempt the blow-down/Liouville-rescaling route
  under the critical `|x₃|^α` bound (criticality is exactly what that device needs). Both horns open.

## v0.1.78 — 2026-06-07 — The swirl-source closing problem: precise formulation + positioning (the witnesses' open target, REFRAMED)

Sharpened the open problem the external triad crystallized (weighted space controlling `∂_zΓ` that closes
the source `S=(2Γ/r⁴)∂_zΓ`) into a precisely-posed, literature-positioned target —
`docs/ns048_swirl_source_frontier.md`. **No theorem; `:proved`=0; NS-048 unchanged.** A focused research
pass read Lei–Zhang–Zhao (arXiv:1701.00868) §5 line-by-line, which **reframes the target:**
- **Every known with-swirl ancient-Liouville closer bypasses `S` entirely.** LZZ runs De Giorgi–Nash–Moser
  on the *source-free* `Γ` equation, uses `L^p` *purely geometrically* (ball-packing around the radius-`r`
  circle) to get radial decay `|Γ|≤Cr^{−1/p}→0`, kills `Γ`, then invokes the swirl-free reduction. `Ω`,
  `S`, `∂_zΓ` never appear. Same shape for Lei–Ren–Zhang (z-periodic) and Thm 3.7 (small radial
  oscillation) — all conditions **on `Γ`**, all reduce to swirl-free, **none controls `S`**.
- So the witnesses' "close `S` via weighted `∂_zΓ`" is a **road not taken** — a structurally different
  strategy than the entire literature, not a weakening of it.
- **"Strictly weaker than KNSS" is unjustified** — and the tempting "incomparable" claim is **declined as
  a 13th over-reach**: the columnar case (`S≡0⇒Γ≡0`, via C8) suggests `S`-control may actually *force*
  `Γ`-decay, so the comparison is genuinely open.
- The `z`-anisotropic / `∂_z`-swirl machinery (`J=−∂_zv^θ/r`; Yu `|x₃|u^θ`; Chen–Fang–Zhang `|x₃|^α u^θ`
  mixed-norm) **exists but only in finite-time regularity — never ported to ancient Liouville.**
- **Cleanest concrete entry sub-question:** port those anisotropic-`z` swirl conditions to the ancient
  setting (a bounded first step using existing machinery, no new gadget).
Both horns (find such a space / prove none exists) remain open. Genuine contribution = the reframing +
the verified "source-control is a road not taken" + the entry sub-question. (Session interrupted by a
macOS TCC/sandbox EPERM after the doc was written; changelog/SPEC/commit completed on restart.)

## v0.1.77 — 2026-06-07 — EXTERNAL witness triad on the axisym-swirl arc: trim CONFIRMED + 2 refinements (12th over-reach caught)

External adversarial pass (Grok edge-Φ / Venice.ai synthesis-seat, swapped for Gemini / ChatGPT naive;
`~/Desktop/triad.rtf`) on `docs/ns048_axisym_swirl_witness_brief.md`. Metabolized into
`docs/ns048_axisym_swirl_witness_verdict.md`. **Across three independent model families the external pass
CONFIRMED the internal trim** — math clean (C1/C2/C3/C5/C6/C8 correct); **C9 "three independent convergent
attacks" = ECHO (refuted unanimously)**; C4 "no soft step" overstated; no closing path found ("no theorem"
stands); firewall intact. The pleasing meta-instance: what I'd called convergence really was echo — the
NS-024 lesson, re-derived by the witnesses. **Two refinements the same-model pre-screen could not produce:**
- **12th over-reach (external-caught, Venice): my own C4 correction over-reached.** I'd floated "weak-`L^p`
  swirl plausibly closable" — but the production is `S=(2Γ/r⁴)∂_zΓ`, so `L^p` on `Γ` gives NO control of
  `∂_zΓ`. Corrected: the open frontier is a **weighted/mixed-norm condition controlling `∂_zΓ` in `z`**,
  strictly weaker than KNSS — or a proof none exists. (The C4 *direction* stands: `ℝ²×T¹` proven
  intermediate; small-swirl plausible.) Even the correction needed correcting — vindicating the external
  layer over a same-model pre-screen ([[feedback_validator_confirmation_bias]]).
- **C7 sharpened (Venice stall-analysis): "dead end" → "no known closure mechanism," localized.** The
  candidate bootstrap `Ω≤C ⇒ |ω^θ|≤Cr ⇒` Biot–Savart `⇒ Γ`-transport `⇒` feedback stalls at TWO concrete
  points: (1) CZ needs `1<p<∞`, fails for linearly-`r`-growing `ω^θ∉L^∞`; (2) div-free drift + isotropic
  diffusion generate no `z`-decay. "No theorem" stands; the negative is softer and now localized.
Docs corrected: `ns048_axisym_swirl_attack.md` (C4), `ns048_swirl_sign_condition_attack.md` (C7);
verdict doc added. `:proved`=0; NS-048 unchanged. Honesty ledger now 7th–12th.

## v0.1.76 — 2026-06-07 — WITNESS PASS on the axisym-swirl arc: math clean, but 2 over-reaches CAUGHT + corrected (10th, 11th)

Adversarial witness pass on the whole axisymmetric-with-swirl attack arc (v0.1.73/74).
`docs/ns048_axisym_swirl_witness_brief.md` (self-contained, primed-to-refute, for external relay) + an
internal three-reviewer pre-screen (math-checker / closing-path-hunter / over-reach-critic). **Outcome:
the mathematics is CLEAN** — the C2 source scalings (`S=O(1)` at the axis via `Γ=O(r²)`; `O(1/r²)` at
`r→∞`; the `z`-tail divergence), the C6 `G=∂_zΓ` equation, the C7 subsolution sign, and the C8 columnar
reduction all independently re-derived as correct; firewall intact (no step proves the bare conjecture).
**But two interpretive over-reaches were caught and are corrected in place** (committed+pushed records,
honest correction):
- **10th over-reach — "no soft step beyond the frontier" (v0.1.73 §5): REFUTED.** Self-contradictory —
  `ℝ²×T¹` was listed as a *known* result while claiming the target collapses onto the bare conjecture, yet
  `ℝ²×T¹` *is* a proven intermediate class. Plausibly-tractable softer classes also exist (weak-`L^p`/
  Lorentz swirl; small-swirl perturbing the complete swirl-free KNSS proof). Corrected to: the three
  *specific* frontier hypotheses are near-endpoint, but the restricted-class space is not exhausted.
- **11th over-reach — "three independent convergent attacks" (v0.1.74 §5): TRIMMED to ~1.5 + echo.** The
  energy attack and the sign attack fail on the *literally identical* term `S=(2Γ/r⁴)∂_zΓ` (two failure
  modes of one obstruction = echo, not independence); only the max-principle carries near-distinct info
  (non-attainment on non-compact `ℝ³`). Plus a selection effect (these soft methods predictably fail on
  any supercritical non-compact problem) and the localization merely re-derives the known hypotheses.
  Corrected to "method-failure localization, consistent with known structure," NOT "z-dependence is THE
  irreducible difficulty." This is exactly the NS-024 lesson (convergence is echo until witness-trimmed)
  applied to our own claim.
Also corrected: C2's "NOT the axis" clause (the *source* is benign at `r=0`, not "the axis is
irrelevant"). C7 SURVIVED (sign is on the source, not on the non-sign-definite `Ω`; 5D-Laplacian
structure real but insufficient; a crack only under the stronger `ω^θ`-one-signed hypothesis). C6 vacuity
SURVIVED. Two presentational fixes adopted (C6: the decisive non-preservation term is the inhomogeneity
`−(∂_zu^r)∂_rΓ`; C8: cleanest via `u₁=Γ/r²` → non-degenerate 4-D radial heat ⇒ constant). The witness
pass worked as designed — it caught this arc's own over-reaches. Docs corrected:
`ns048_axisym_swirl_attack.md`, `ns048_swirl_sign_condition_attack.md`; SPEC NS-048 pointers; brief
records the pre-screen for external verification. `:proved`=0; NS-048 unchanged.

## v0.1.75 — 2026-06-07 — Two exploratory probes: critical-Besov smallness (NS-046/047) + real-vs-complex on the production object (NS-013)

Two witness/counter-witness probes off the no-go map, folded into SPEC (NS-013, NS-046 bullets) and
dashboard. **Both within-truncation/1D-model; `:proved`=0; prize UNTOUCHED.**

**(1) Critical-Besov smallness probe** (`scripts/ns046_besov_smallness_probe.jl` + 6 `.out.txt`; companion
`docs/ns046_besov_smallness_companion.md`). Turns NS-047's two analytic claims into measured dyadic
Littlewood–Paley numbers on a resolved DNS. **C1 (no-log CZ boundedness) CORROBORATED & N-robust:** the
Riesz/pressure-Hessian ratio `R_j=‖Δ_j∇²p‖_∞/‖Δ_jQ‖_∞` is flat across shells ([0.60–0.74], no upward drift
with `j`) and N-stable to ~1% (N=64↔128) ⇒ the CZ operator is `Ḃ⁰_{∞,1}`-bounded with no log, exactly the
framework choice that keeps the harmonic-analytic route live. **C2 (local-Reynolds smallness) EXHIBITED &
resolution-gated:** a Reynolds sweep {1600,400,100,25} moves the smallness frontier `j*` from the grid edge
(Re=1600, `Re_tail`≫1, dissipation unresolved) to the interior (Re=100, `Re_tail`≪1, `j*=3`, tail
absorbed). N-convergence splits cleanly — at Re=1600 `j*` tracks the grid (4→5, Class-I); at Re=100 `j*` is
**fixed at the same physical shell N=64↔128** (`k∈[8,16)`, Class-II/scope-coupled) ⇒ a resolution-STABLE
diagnostic when the dissipation scale is resolved (unlike the δ-fit). Honest limits: vacuity cap; global
Besov can't localize to the CKN set (complements the physical-space uniform-domination probe). The genuine
positive: the critical-Besov framework is computationally consistent — a witness-level reason to keep
NS-046/047 standing rather than retire it.

**(2) Real-vs-complex on the production object** (`scripts/ns013_realcomplex_production.jl` + `.out.txt`;
companion `docs/ns013_realcomplex_production_companion.md`). Runs the NS-013 comparison ON the production
object. The exact 1D gradient budget `d/dt½∫g²=−½∫g³−ν∫g_x²` makes `P≡−½∫g³` the shadow of the 3D `∫ω·Sω`
(budget identity verified, rel.err 2.8e-4). **Exact result by Fourier support:** the complex-blowup class =
Cole–Hopf ANALYTIC SIGNALS (one-sided spectrum) ⇒ `∫g³=2π·(g³)_{k=0}=0` (three positive wavenumbers cannot
sum to 0) ⇒ the production object is **identically zero** through the entire complex blowup (`|P|≈1e-16`,
`Skew≡0` while `∫|g|²→∞`, `δ→0`); a second one-sided IC confirms it. **Imposing reality (λ↑) restores the
two-sided conjugate-symmetric spectrum ⇒ `∫g³≠0`, Skew climbs 0→0.67** — reality does NOT deplete
production, its two-sidedness CREATES it. So the complex-blowup channel (off-axis analyticity) and the
real-flow production channel are **disjoint objects**, corroborating the NS-013 triad "complex⇏real is
vacuous." Honest non-transfer: the Fourier-support cubic argument is 1D-specific (3D `∫ω·Sω` is not a
single one-sided cubic), so "identically zero" does NOT carry to 3D — what transfers is the *question*
(does reality's spectral structure gate the 3D production?). A sharper framing of the NS-013→NS-046 link,
recorded as a direction, not a result.

Method note: both probes ran the N=1-before-fan-out discipline (smoke/identity gate, then Re-sweep /
IC-robustness), and the real-vs-complex probe caught + corrected one of its own framings mid-run (the
"single-mode residue" worry → the general Fourier-support theorem). No status changes; SPEC entry counts
unchanged.

## v0.1.74 — 2026-06-07 — NS-048 attack (C): the swirl SIGN-CONDITION class — doesn't help (9th hope deflated)

Worked the one genuinely new restricted class from v0.1.73 §6(C) — a one-sided/monotone swirl sign
condition meant to make the source `(1/r⁴)∂_z(Γ²)` signed and drive a maximum principle for `Ω=ω^θ/r`.
`docs/ns048_swirl_sign_condition_attack.md`. **No theorem; `:proved`=0; NS-048 unchanged.** The decisive
filter is dynamical consistency: (C-i) one-signed swirl `Γ≥0` IS preserved (sourceless `Γ` eq ⇒ max+min
principle) and non-vacuous — but does **not** sign the source; (C-ii) the monotonicity `∂_zΓ≤0` that
*would* sign `S` is **NOT preserved** — differentiating the `Γ` equation in `z` gives
`∂_tG+b·∇G=νL_ΓG−[(∂_zu^r)∂_rΓ+(∂_zu^z)G]`, `G=∂_zΓ`, whose bracket (a no-sign zeroth-order term + a
no-sign source) lets the meridional shear manufacture either sign — so `∂_zΓ≤0` is artificial and
plausibly vacuous among genuinely-3D ancient solutions. And even granting `S≤0`, `Ω` is only a
*subsolution* ⇒ one-sided (sup) control, never `Ω≡0`. The sole closable instance is the degenerate
`∂_zΓ≡0` (columnar / `z`-independent) endpoint: `S≡0` ⇒ no-swirl KNSS ⇒ trivial — but that is essentially
the already-known periodic-in-`z` reduction (Lei–Ren–Zhang arXiv:1911.01571; ancient-periodic
arXiv:1902.11229), **not new** (targeted lit search found no one-signed/monotone-swirl Liouville).
**Payoff:** (C) independently re-lands on the SAME crux as the prior two attacks — the `z`-dependence of
the swirl. Three convergent diagnostics now: energy-tail uncontrolled in `z` (§4.1), max-principle
temporal-not-spatial on non-compact `z` (§4.3), and the signing quantity `∂_zΓ` dynamically
uncontrollable (here). The 9th tidy hope deflated by working it through; sanity check held (no step would
prove the bare conjecture).

## v0.1.73 — 2026-06-06 — NS-048 ATTACK (axisym-with-swirl ancient Liouville): wall LOCALIZED, no theorem (8th over-reach declined)

Attacked the most tractable NS-048 sub-target — a restricted non-self-similar Liouville theorem —
honestly: `docs/ns048_axisym_swirl_attack.md`. **No theorem; `:proved`=0; distance UNTOUCHED; NS-048
unchanged.** Two literature-verified research passes pinned (a) the exact frontier (KNSS conjecture =
bounded mild ancient axisym WITH swirl on ℝ³ ⇒ constant, OPEN; proven with-swirl only via decay/compact:
Lei–Zhang–Zhao `Γ=ru^θ∈L^∞_tL^p_x` `1≤p<∞`, Pan–Li sublinear `α<1` optimal, Lei–Ren–Zhang on ℝ²×T¹) and
(b) the exact axisymmetric structure: `Γ` transport-diffusion (no source ⇒ maximum principle,
`‖Γ(t)‖_∞`↓); `Ω=ω^θ/r` whose ONLY production is `(1/r⁴)∂_z(Γ²)`; the closed loop Γ→Ω→(u^r,u^z)→Γ.
Three honest attempts, each broken at the place the literature buys its hypothesis: (4.1) Caccioppoli —
bounded-v gives `Γ=O(r)` growth, source tail borderline-non-integrable in r and uncontrolled in z;
(4.2) **the `1/r⁴` axis singularity is NOT the obstruction** — smooth flows have `Γ=O(r²)` so the source
is `O(1)` at the axis; the wall is at `|z|→∞`, the non-compact AXIAL direction (the source is a
`z`-derivative) — corrects a naive near-axis reading; (4.3) the Γ maximum principle gives TEMPORAL
monotonicity not SPATIAL decay, and non-attainment on non-compact ℝ³ kills the strong-max-principle
route — which is exactly why Lei–Ren–Zhang compactify the axis to T¹. **Verdict:** with-swirl Liouville =
controlling that single source in the non-compact `z` direction; there is **no soft "just-beyond" step**
(each frontier axis is at its endpoint; the targets collapse onto the bare conjecture with a thin
technical collar = decay/compactness of swirl in z). §6 names the three real multi-paper assaults (a
`p=∞` Lorentz refinement of LZZ; a `T¹→ℝ` z-decay mechanism; a one-sided swirl sign condition). Sanity
check held throughout (no step would prove the full conjecture). The 8th over-reach — a manufactured
restricted theorem — was available and declined.

## v0.1.72 — 2026-06-06 — NS-048 machinery STUDIED (literature-verified): the exclusion/no-split apparatus, learned

Learned the NS-048 machinery for real — `docs/ns048_machinery_study.md`, a STUDY artifact (not
progress; `:proved`=0, distance UNTOUCHED; NS-048 stays `:open`/unengaged, no ledger change). Seven
modules, each verified against the literature via a six-way parallel sweep + calibration search:
M1 rescaling/ancient solutions (the MBAS object; Type-I/II; parabolic compactness),
M2 CKN ε-regularity (the compactness engine; `𝒫¹(S)=0`),
M3 self-similar exclusion DONE (Nečas–Růžička–Šverák/Tsai + the DSS-existence nuance that makes general
exclusion hard),
M4 Liouville for ancient solutions = THE OPEN CORE (KNSS: 2D + axisym-no-swirl done, general 3D "out of
reach"; the **Type-I-singularity ⟺ nontrivial mild bounded ancient solution** equivalence),
M5 concentration-compactness / profile-decomposition / no-split (Gallagher 2001, Kenig–Merle,
Rusin–Šverák / Gallagher–Koch–Planchon / Jia–Šverák minimal-norm data; NS is dissipative ⇒ adapted not
transplanted),
M6 backward uniqueness + unique continuation (ESS `L^{3,∞}` endpoint via Carleman; Tao 2019 triple-log
rate),
M7 the Type-II frontier (separate, mostly OPEN; honestly fenced from the other-equation analogues +
Hou numerics).
§9 assembles the **conditional** exclusion argument and locates the two holes to the theorem level
(general 3D Liouville ⟺ Type-I exclusion; the whole Type-II branch). §10 names the three real
sub-targets (a restricted non-self-similar Liouville is most tractable). Don't-bluff enforced: §12 is a
16-item flagged appendix of everything not primary-source-verified (incl. corrections: Gallagher is
2001 not 1998; Korobkov–Tsai is half-space; "Choe–Wolf–Yang Type-I" UNVERIFIED — do not assert;
Hou's boundary scenario is Luo–Hou Euler not NS). The 7th-over-reach correction stands: the
within-truncation geometry (NS-045/046/`∇ξ`) is a suggestive prior on *where* to probe the ancient
limit, never a rigidity input.

## v0.1.71 — 2026-06-06 — NS-048 MAPPED (the exclusion frontier's machinery) + its geometry-re-tasking hope deflated (7th over-reach, caught by thinking)

Engaged NS-048 the disciplined way — *map the machinery, don't manufacture an exclusion*
(`docs/ns048_exclusion_frontier.md`). Laid out the attack shape (assume singularity → rescale → ancient
limit → exclude via Liouville + no-split + backward-uniqueness; Type-I vs Type-II), where the pieces sit
(NS-007 = the self-similar sub-case DONE [Nečas–Růžička–Šverák/Tsai]; NS-006 = CKN/rescaling; NS-005 =
the backward-uniqueness exemplar [ESS]), the gap (general non-self-similar Liouville + the no-split
control + the Type-II branch), and the one-sentence obstruction + sub-targets. Lineages named at the
literature level, flagged for verification (no bluffed citations).

- **Honest correction (caught by working it through, not by the witness):** NS-048's own
  "re-task our geometry as rigidity constraints on the ancient limit" is **over-optimistic — the same
  vacuity cap.** Our geometry (NS-045/046/sub-probe) is *within-truncation*; the ancient limit is a
  singular-limit PDE object the truncation can't reach. So the geometry is a **suggestive prior** (where
  to probe), **not** an exclusion input; any Liouville rigidity must be proven analytically on the
  ancient solution. The **7th tidy hope of the arc, deflated.**
- Engaging NS-048 for real = learning the machinery (concentration-compactness, Liouville theorems,
  backward uniqueness) + attacking one sub-target — a research undertaking, not a session task. NS-048
  stays `:open`. No status change; `:proved`=0; distance UNTOUCHED.

## v0.1.70 — 2026-06-06 — NS-048 recorded: the exclusion / no-split frontier (dynamic complement to NS-046)

A math-physics colleague's NS-attack notes (relayed 2026-06-06) independently re-derived this program's
discipline (firewall, scaling, the stretching battlefield = our P, nonlocality, the kill-list) — and
diagnosed our failure mode ("don't invent geometry / sacred ratios useless / reduce DOF not add" = the
six over-reaches). The one cluster we had **not** engaged: the colleague's mindset shift — *corner the
hypothetical singularity into a regime so rigid it's impossible* — i.e. the **singularity-exclusion /
blowup-rescaling / Liouville-for-ancient-solutions / no-split** attack, the *dynamic* frontier.

- **NS-048 added** (`:open`, unengaged candidate direction — NOT a claim): generalize NS-007's
  self-similar exclusion to the general rescaled-limit (ancient-solution) exclusion + the no-split
  (concentration-compactness) machinery; **reframe NS-046 from domination → exclusion**, re-tasking the
  mapped geometry (Beltramization NS-045, pressure-Hessian NS-046, ∇ξ NS-013/CFM) as *rigidity
  constraints* on the rescaled limit rather than uniform-domination targets.
- **Connection to our findings:** the uniform-domination sub-probe's non-uniform/concentrated-at-cores
  depletion is the **no-split problem's shadow** — the truncation observed the concentration; the
  no-split machinery would resolve which rescaled limit it selects. NS-046 (inequality) and NS-048
  (exclusion) are two faces of the same wall.
- **Honest scope:** an attack *shape* + machinery to LEARN (concentration-compactness/Aubin–Lions,
  Liouville theorems, backward uniqueness) — not a result, not a new gadget. SPEC (count→33) + registry.
  Not yet in the TCE corpus (unengaged). `:proved`=0; distance UNTOUCHED.

## v0.1.69 — 2026-06-06 — NS-032 N>512 push SIZED (10.4 s/step @N=512) + DEFERRED (poor trade)

Smoke-measured the GPU cost before committing to a multi-hour run: `metal/dns_gpu.swift` inviscid TG is
**10.4 s/step at N=512** (no dissipation ⇒ the spectrum fills the grid ⇒ full FFT every step). So the
N>512 push prices at **~10–15 hr @N=768** to **~33 hr @N=1024** (+ OOM risk). **Deferred** — the verdict
would be vacuity-capped (a truncation can't settle the PDE) and most likely another gated INCONCLUSIVE
(the N=256↔512 δ-fit was already 42–48% non-converged; the near-singularity needs N≫1024). NS-032 stays
the open computational frontier with a concrete price tag attached. Disciplined call: don't burn a
half-day of GPU for a within-truncation result that can't move the prize. No status change; `:proved`=0;
distance UNTOUCHED.

## v0.1.68 — 2026-06-06 — TCE self-map v3 (32-node): NS-045/046 slot in self-consistently; §9 resolved-DNS arm completed

Re-ran the TCE self-map on the matured 32-node ledger (added NS-045 + NS-046 to the corpus). The new
entries disturb no established cluster:
- **NS-045 (Beltramization) joins the resolved-DNS family — {NS-038,039,040,045} is now a tight
  HIGH-band clique @0.90–0.95** ("multi-angle on one object" = the resolved-DNS empirical map of vortex
  stretching at Re=1600). Folded into the mature map §9 (the arm now runs verdicts→artifact-correction→
  depletion→*mechanism*), with the honest collective scope: methodology + one removed false signal + one
  mechanism, NOT regularity progress (the HIGH coordination is structural, not a discovery).
- **NS-046 (the deformation-inequality target) lands MID on the criticality cluster {NS-034,036,046}
  @0.83** — the apex of the hinge.
- **NS-045↔NS-046 reads LOW** ({NS-040,045,046} @0.68) — the engine independently rates the
  mechanism↔target link as *loose*, corroborating the §10 witness verdict (the "complementarity" is
  IC-specific, not a tight law).
- Corpus → 32 nodes; NS-031 run-log regenerated (v3, 280 lines); NS-031 v3 note. No status change
  (`:tested`); closure tier-wall intact. `:proved`=0; distance UNTOUCHED.

## v0.1.67 — 2026-06-06 — ORSI top-level architecture recorded (docs/orsi_reference.md) — the governance parent of CCATT

Transcribed + analyzed Brian's ORSI Top-Level Architecture (source: a one-page spec on Aaron's Desktop),
recorded in `docs/orsi_reference.md` so it is not a hidden primitive (it surfaced via Grok's "ORSI lens"
NS-046 commentary). ORSI is a constraint-first **epistemic-governance** framework — axiom
"Constraint→Regime→Truth; truth does not license constraint"; output the MDAGC (Minimal Decontaminated
Admissible Generator Class); 10 governance components. **It is the parent architecture of CCATT** (ORSI
= the constitution; CCATT = its transport layer), and this program's firewall+witness discipline is a
concrete instance of ORSI's "Formalism Legitimacy Audit" (quarantine of *export surplus*) — the arc's
six over-reaches were export surplus. Recorded as a referenced framework, not an in-spec primitive; the
O-R-S-I acronym expansion is not given and not guessed. Cross-project reference memory added. No spec
change; `:proved`=0; distance UNTOUCHED.

## v0.1.66 — 2026-06-06 — NS-046 arc triad-witnessed → interpretations REFUTED (6th over-reach), record corrected

Routed the un-witnessed NS-046-arc synthesis claims (recorded data-driven last sessions) to the triad
(Grok + Gemini + naive ChatGPT). **Convergent 3/3: the interpretations over-reached; the within-
truncation data stands as phenomenology.** Honesty step — these were committed+pushed claims, so the
record is corrected:

- **C1 (complementarity) → REFUTED as general; IC-specific.** The random zero-helicity control bursts
  (no pressure dominance); only the symmetric Kerr-tube IC shows it. "zero-H ⇒ pressure dominates" is
  false. NS-045 §extension corrected.
- **C2 (uniform-domination) → data holds, interpretation corrected.** A regular truncation has no
  singular set ⇒ its non-uniform *pointwise* ratios don't bear on the *analytic* inequality (which can
  hold via Besov/integral/cancellation). "Blocks the analytic reduction / C2 computationally visible"
  removed; genuine residue kept: the probe refutes only the *pointwise-domination heuristic* (any closing
  inequality must use Besov/integral controls).
- **C3 (target framing) → "the irreducible difficulty IS the non-uniformity" refuted as established.**
  Softened to "*a* natural remaining target *if* the Besov-endpoint is set aside" (the real difficulty
  could be elsewhere — derivative loss at marginal-cancellation scaling). `docs/ns046_target.md` §3 +
  the NS-046 pause note corrected.
- **Meta:** probe-first caught the *naive* over-reach, but the recorded *interpretations* over-reached
  again — only the adversarial witness caught them. **6th over-reach this arc** (4 witness-, 1 probe-,
  1 witness-). Brief + verdict: `docs/ns046_arc_triad_{brief,verdict}.md`. No status change (NS-045
  `:tested`, NS-046 `:open`). `:proved`=0; distance UNTOUCHED.

## v0.1.65 — 2026-06-06 — NS-046 precise target recorded; PAUSED at the standing frontier

Wrote the crisp, admissible standing statement of the open problem (`docs/ns046_target.md`): the
critical coercive deformation inequality — critical-Besov framework (NS-047, BKM-escaped), CKN
localization, the nonlocal pressure-Hessian + viscosity dominating the production at σ=0, the CCATT
loss ledger, and the §11 kill criteria. The single irreducible difficulty is the **non-uniformity**
(the depletion is core-concentrated with bulk-enhancement, viscosity ≪1 on the intense set —
computationally pinned by the Idea-3 + uniform-domination probes; = NS-047's C2). NS-046 is **held
paused at this statement** — closing it needs a genuine analytic idea the program does not have, and
the discipline forbids manufacturing one. NS-046 stays `:open`. `:proved`=0; distance UNTOUCHED.

## v0.1.64 — 2026-06-06 — NS-046 uniform-domination sub-probe: the depletion is NON-UNIFORM (probe-first blocks the 5th over-reach)

Before attempting any analytic NS-046 reduction, measured whether the depletion dominates the production
*uniformly on the intense set* (`scripts/ns046_uniform_domination_probe.jl`) — the load-bearing
uniformity the would-be coercive inequality needs. **Answer: no, not even in the truncation.**

- Conditioning `⟨e₃ᵀ∇²p e₃⟩/⟨λ₃²⟩` and `⟨ν|∇ω|²⟩/⟨ω·Sω⟩` on top-{100,10,1,0.1}% production (N=64,
  helical/control/tubes): the pressure ratio is **negative on the full field** (it *enhances* the
  max-stretch on the bulk — Vieillefosse), turns strongly positive **only at the extreme high-`|ω|`
  cores** (top-0.1%: 8–16 tubes, →2.6 late-helical; control never dominates), and viscosity is **≪1 on
  the intense set** (supercriticality).
- **The domination is concentrated, NOT uniform** — exactly NS-047's C2 obstacle (uniformity is the
  gap), now computationally visible. This **blocks the tempting "pressure dominates ⟹ coercive
  inequality closes" reduction** (it would have been the 5th tidy over-reach this session) — and it
  **qualifies Idea-3**: "dominant in the worst case" was an enstrophy-weighted statement about the
  cores; conditioned across intensity, the domination is non-uniform.
- Probe-first (the user's call) caught the over-reach *computationally before the claim* — the
  discipline is now self-correcting, not just witness-corrected. No new entry; NS-046 stays `:open`,
  sharpened; Idea-3 NS-046-witness note qualified. Companion
  `docs/ns046_uniform_domination_companion.md`. Scope: DNS truncation, within-truncation only.
  `:proved`=0; distance UNTOUCHED.

## v0.1.63 — 2026-06-06 — Idea-3 probe: depletion is helicity-dependent — Beltramization (high-H) vs pressure counter-transport (zero-H)

Ran the zero-helicity stress test (`scripts/ns046_gradxi_pressure_probe.jl`): the ∇ξ-CFM smoothness +
the pressure-Hessian-vs-self-stretching balance, across helical (ρ_H=0.97) / control (ρ_H≈0) /
anti-parallel tubes (ρ_H=0-exact, max-stretch = weakest Beltramization). Motivated by the LOW#1/NS-047
residue (the danger is at zero-H / in ∇ξ; the contest is vs the nonlocal pressure).

- **Finding: the two depletion mechanisms are COMPLEMENTARY, anti-correlated with helicity.**
  Beltramization (NS-045) dominates at high H; at the **zero-helicity maximal-stretch (Kerr-tube)** case
  where Beltramization is weakest, the **nonlocal pressure-Hessian counter-transport is DOMINANT**
  (`⟨e₃ᵀ∇²p e₃⟩` = 1.5–11× `⟨λ₃²⟩`; it enters as `−e₃ᵀ∇²p e₃` ⇒ depletes), and the tubes attain the
  *lowest* enstrophy growth despite maximal stretching. The control (neither mechanism strong) bursts
  most (Z→11.4). **N-converged 64↔128** (ordering IC-identical, resolution-robust).
- **This is a DNS witness for NS-046's framing:** its `−e₃ᵀ(∇²p)e₃` counter-transport object is the
  operative depletion in the worst-case geometry where the analytic battle sits — and answers the LOW#1
  zero-H residue (what holds the worst case regular, in the truncation, is the nonlocal pressure).
- **Recorded as notes (NO new entry — NS-047 lesson):** NS-045 §extension (the complementarity, stays
  `:tested`) + a DNS-witness note on NS-046 (stays `:open`). Companion
  `docs/ns046_gradxi_pressure_companion.md`. Scope: DNS truncation, within-truncation only (vacuity
  cap — observes the term, does not bound it). `:proved`=0; distance UNTOUCHED.
- **"Both 1+3" complete:** Idea-1 (LP-route obstruction, NS-047 refuted, v0.1.62) + Idea-3 (this).

## v0.1.62 — 2026-06-05 — Idea-1 (LP-route) obstruction: NS-047 candidate witnessed → REFUTED, folded into NS-046

Tested whether the Littlewood–Paley/paraproduct-local route to NS-046 escapes the wall or reduces to it
(the §11 ∇ξ-frontier kill-criterion test). Drafted a refute-don't-endorse brief, witnessed 3/3 (Grok +
Gemini[fast-model] + naive ChatGPT, convergent). **Candidate NS-047 REFUTED; folded into NS-046 as a
note, no new entry** (panel-unanimous).

- **C1 REFUTED (load-bearing):** "controlling the pressure Hessian must hit the BKM L^∞-endpoint" is a
  *false dichotomy* — CZ/Riesz operators are bounded on critical Besov `Ḃ⁰_{∞,1}` (no log-penalty), and
  LP machinery slices around the L^∞ endpoint. A critical-Besov coercive bound need never invoke BKM.
- **C2 HOLDS (modestly):** the maximal-function tail-absorption needs a local-Reynolds smallness that
  CKN generates only on already-regular cylinders ⇒ the gap relocates to the ≤1-D singular set (NS-006);
  a restatement of the known supercritical difficulty, not a new barrier.
- **Net (cuts against the over-reach):** the harmonic-analytic route to NS-046 is **NOT blocked at BKM**
  (the kill-criterion does NOT fire — a harmonic-analytic route is genuinely live); its real obstacle is
  the supercritical smallness on the CKN singular set, and the correct framework is **critical Besov,
  not L^∞**. NS-046 stays `:open`, sharpened.
- **Meta: the 4th tidy-"reduces to the wall" over-reach this session** (LOW#1 → MID → §5-"≡" → NS-047-C1);
  the naive seat + Gemini both made the surface-level catch. The discipline worked.
- Docs `docs/ns047_lp_route_{brief,verdict}.md` + the NS-046 note. No new spec entry; no status change.
  `:proved`=0; distance UNTOUCHED.

## v0.1.61 — 2026-06-05 — External program-review (ChatGPT) metabolized: kill criteria + §5 reconciled + §6→appendix

Treated ChatGPT's strong program-level critique as a Required Witness Check and acted on it.
Recorded in `docs/program_review_chatgpt_2026-06-05.md`; corrections to the write-up + SPEC.

- **§5 ↔ §10 reconciled (and NS-036 SPEC).** "(a) ≡ (b)" → "the *same bottleneck* (enstrophy
  non-coercivity) through two different structures, at different logical levels — mutually illuminating,
  not one fact"; "the question collapses to enstrophy" → "a *sufficient*, most-natural route, NOT the
  unique framing" (consistent with §10's MID refutation). This was the **third totalizing-word over-reach
  this session** ("exhibits/line up" → "irreducibly/ENTIRE" → "≡"), caught on a cold read.
- **§11 added — "What would falsify this map?"** Pre-registered kill criteria for the load-bearing
  framings (retire NS-036-centrality / the ∇ξ frontier / P-centrism / the scaling–Casimir reading; or
  the happy `Scope: PDE` `:proved` falsification). Answers the unfalsifiability failure mode; makes the
  map killable.
- **Pressure elevated, P de-fetishized** in §10 (P is the local breaker; the contest is P vs the
  nonlocal pressure-Hessian counter-transport; NS-046 stated as that balance).
- **§6 (closure/GPG residue) → Appendix A** (demoted, non-load-bearing; the trimming record retained,
  not deleted; banner + roadmap updated). Main body is now the disciplined map (§2–5, §9–11).
- Deferred (style, offered): the ~40% prose compression. No spec status changes (NS-036 still `:argued`).
  `:proved`=0; distance UNTOUCHED.

## v0.1.60 — 2026-06-05 — The mature map: obstruction_program_writeup.md brought current (NS-001..046)

Updated the standalone write-up `docs/obstruction_program_writeup.md` (382→488 lines) from its
2026-06-01 state (NS-001..034) to the mature 32-entry map. Header + §0 roadmap refreshed; §7 ledger
summary brought current; two new sections appended, preserving the existing §0–§8 narrative:

- **§9 — the resolved-DNS arm (NS-037–040):** resolved N=256/N=512 verdicts; NS-039 *removed* the false
  ≤1-D "approach to a singular set" signal (the D30 0.986→1.426 N-lift); NS-040 helicity depletion; all
  REGULAR resolved diagnostics, not blowup tests.
- **§10 — the 2026-06-05 sharpening:** the TCE self-map + the two adversarially-witnessed **refutations**
  (LOW#1 geometric-consistency; MID "irreducibly geometric") that *sharpened* rather than weakened the
  map; the analytic frontier **NS-046** (the coercive critical deformation inequality on the nonlocal
  pressure Hessian — the honest "where the prize sits"); the **NS-045** Beltramization mechanism; and the
  **CCATT** governance lens. The recurring over-reach tell (totalizing words) recorded.

Consolidation of already-logged results (v0.1.41–59); no new claims. `:proved`=0; distance UNTOUCHED.

## v0.1.59 — 2026-06-05 — CCATT defined: lifted the pending-primitive flag on NS-045/046

Brian supplied the **CCATT** definition (= **Certified Constraint-Access Transport Theory**), the
load-bearing classifier flagged "pending def" in NS-045/046. Recorded faithfully (with provenance) in
`docs/ccatt_reference.md` so it is not a hidden primitive; lifted the pending flags in SPEC (§FORWARD
TARGETS header + both entries) and the registry.

- CCATT is a constraint-first **admissibility** framework (Constraint / Access / Transport /
  Certification / Closure): existence is open, finite systems close only via costed/bounded access; no
  global closure licensed; primitives must survive selection-theater **decontamination** (dominance /
  elegance / predictive success do NOT license); authorization is inverted (admissible generator classes
  explain exports, not vice versa).
- Honest framing recorded: NS-045's result IS a CCATT-style **certified transport** (the explicit
  H-geometry → Beltramization → Lamb-suppression → depletion chain, with the within-truncation loss
  ledger), not a smuggled scalar-conservation certificate; NS-046 is a CCATT-admissible analytic target.
- Noted (as observations, not claims) the structural parallels with the program's own discipline: "no
  global closure" ≈ the firewall; "decontamination" ≈ the witness protocol + the totalizing-word lesson;
  "subtract computational artifacts" ≈ LOW#1 vacuity / NS-039; "loss-ledger transport" ≈ substrate
  provenance; "invert authorization" ≈ inverse-Born (NS-037). CCATT does not validate the program nor
  vice versa. Epistemic framework only — `:proved`=0; distance UNTOUCHED. Canonical upstream source TBD.

## v0.1.58 — 2026-06-05 — NS-045 mechanism audit RUN → :tested: helicity depletes via BELTRAMIZATION

Ran Brian's NS-045 helicity-depletion mechanism audit (`scripts/ns045_helicity_mechanism.jl`,
reusing the validated CPU pseudospectral solver). **Verdict: the mechanism is (b) Beltramization, not
(a) ω–S alignment.** Status `:open` → `:tested`.

- **Matched-spectrum pair, exact.** Rebuilt NS-040's helical/control pair in the Craya–Herring ±
  helical basis (random amplitude on `h₊` everywhere vs random `h±` ⇒ identical `E(k)`, hence `Z₀`,
  helicity flipped). Verified: `|ΔE|=1.4e-17`, `|ΔZ|=2.2e-16`, `ρ_H=+0.968` vs `−0.069`, `div≈1e-13`.
- **The mechanism.** The *only* large helical-vs-control difference present **from t=0** is the
  Lamb-vector geometry: `⟨|u×ω|²⟩/⟨|u|²|ω|²⟩ = 0.026 vs 0.69` (~26×), `cos²(u,ω)=0.92 vs 0.32`. Since
  `u×ω` *is* the nonlinear driver, strong helicity (u∥ω) geometrically switches off the production ⇒
  enstrophy growth delayed; the depletion ends as the field de-Beltramizes (helical `lamb²` 0.026→0.48,
  `ρ_H` 0.97→0.80 by t=8). The ω–S alignment `c²_int` develops **near-identically** in both members
  (0.33→0.56 vs 0.33→0.66) ⇒ mechanism (a) is a *lagging consequence*, not the cause.
- **N-converged 16↔64↔128** (the signal is IC-geometry-fixed, not small-scale ⇒ not a resolution
  artifact). PASSES Brian's condition (a delay correlating with a mechanism diagnostic beyond scalar
  helicity conservation). **Sharpens NS-040**: "delay+concentration" → "delay = Beltramization-suppressed
  Lamb vector; burst = post-de-Beltramization".
- Scope: resolved 3D DNS truncation — NOT the PDE; certifies the within-truncation mechanism only
  (LOW#1 cap). Optional follow-ups: the full sector-transfer tensor `T^{++→+}` and the GPU N=256↔512
  pass. SPEC (NS-045 :tested) + registry + companion `docs/ns045_helicity_mechanism_companion.md`.
  `:proved`=0; distance UNTOUCHED.

## v0.1.57 — 2026-06-05 — Brian's extension recorded: NS-045 (mechanism audit) + NS-046 (deformation-closure target)

Folded Brian's two extension ideas into the obstruction ledger (his draft labelled both "NS-041" on an
older spec; re-numbered NS-045/046, skipping the contested sim range). The ledger is now 32 entries;
`:proved`=0 unchanged.

- **NS-045 — Helicity-depletion mechanism audit (`:open`, DNS-scope).** Extends NS-040: certify *how*
  helicity depletes (ω–S alignment / Beltramization / helical-sector transfers / delayed flux) via
  P(t), S_ω(t), c²_int(t), spectral transfers Π_E/Z/H, and a helical-mode decomposition u₊/u₋ with
  sector transfers, on the matched-spectrum pair. PASS = a mechanism beyond scalar helicity
  conservation; FAIL = depletion is correlation. Caveat: within-truncation mechanism only (LOW#1 cap).
- **NS-046 — Critical coercive deformation inequality (`:open`, PDE-analysis target).** The admissible
  analytic object after the criticality–Casimir hinge: a coercive bound where the **nonlocal pressure
  Hessian** `−e₃ᵀ(∇²p)e₃` + viscosity control a σ=0 norm / the production at the deformation level,
  localized to CKN-compatible sets. Notably this **independently incorporates this session's MID-witness
  Q2 lesson** (local ∇ξ-alignment must survive the nonlocal pressure counter-transport) — strong
  corroboration — and adds the missing object (the pressure Hessian). A sharp formulation of the hard
  core, NOT progress.
- **CCATT** (Brian's load-bearing classifier in both) is recorded as a **pending external primitive —
  NOT used as a defined term** until Brian supplies its spec (named-but-undefined-primitive rule).
- SPEC (count→32) + registry rows + this entry. Next: **run the NS-045 mechanism audit** (per the
  user's direction). `:proved`=0; distance UNTOUCHED.

## v0.1.56 — 2026-06-05 — MID coordination "irreducibly geometric (∇ξ)": witnessed → C4 REFUTED

Attacked the TCE MID-band coordination {NS-005, NS-008, NS-033, NS-034, NS-036} (the critical-norm /
enstrophy-hinge center). Witness brief with a new wrinkle — **ChatGPT as a naive core witness**
alongside the adversarial triad — run as Grok (adversarial) + ChatGPT (naive); Gemini's MID synthesis
seat did not run.

- **Survives:** the exact production identity `P = ∫ω·Sω = ∫|ω|²(ξ·Sξ)` (the σ=+1 enstrophy-rung
  breaker is the enstrophy-weighted strain-alignment of the vortex direction ξ), and `regularity ⟺
  enstrophy-bounded ⟸ ∫P dt` (last arrow sufficient-only; the regularity⟺enstrophy half is tight given
  the a-priori energy bound — correcting Grok's Q3, which mislocated the slack).
- **WITHDRAWN (C4):** "the ENTIRE deficit is irreducibly geometric (∇ξ)." Refuted convergently:
  (Q1) NS-008 rules out energy-*only* but does not make ∇ξ-control *unique* (harmonic-analysis/Besov,
  dispersive, probabilistic routes survive); (Q2) the identity is *pointwise* alignment ξ·Sξ, not ∇ξ —
  smuggling CFM sufficiency in as necessity (the LOW #1 proxy gap one level up).
- **Decisive signal:** the *naive* seat (ChatGPT, un-primed) independently circled the same
  over-reaching sentence the adversarial seat broke ⇒ surface-level over-reach, NOT the
  confirmation-bias signature. Negative robust even without the Gemini seat.
- **Softened survivor:** ∇ξ-smoothness (CFM/Hou–Li) is the best-supported candidate handle NS-008
  points to, not the unique route. NS-005/034/036 unchanged.
- **Meta (2nd over-reach this session):** self-audit passed a totalizing-word synthesis the witness
  broke — LOW #1 ("exhibits"/"line up") then MID ("irreducibly"/"ENTIRE").
- Docs `docs/ns_mid_geometric_deficit_{brief,verdict}.md` + synthesis §C.7/§D landed in commit
  `c31eef0`; this entry recorded separately to avoid a concurrent-edit collision with the live sim
  session's changelog writes. No spec status change. `:proved`=0; distance UNTOUCHED.

## v0.1.55 — 2026-06-05 — Active-turbulence AT-7: the creatures are path-dependent (hysteresis)

Triggered by watching the live app — the creatures are path-dependent and "hard to replicate". Made
it rigorous. `:proved`=0; **distance UNTOUCHED.** Scope: phenomenology.

- **AT-7** (`scripts/active_turbulence_multistability.jl`). Probed two faces of multistability on the
  faithful active system (fixed brain, N=64):
  - **Not fixed-point basin multiplicity** — a 16-IC ensemble at fixed strong cohesion all settles
    into one foam-like phase (density CV≈2.2; nClumps 14–21 = stochastic spread, not distinct basins).
  - **It is HYSTERESIS** — ramping `cohesion` 0→50→0 (no reset, density-CV order parameter) traces a
    clean loop: clumps **form** (up-ramp) at coh≈25–35 but **persist** (down-ramp) to coh≈5–15.
    **Loop area ∮CV d(coh)=15.4; max gap 0.59 at coh 30.** In the transition zone (coh≈10–35) the
    state is **bistable** — dispersed if approached from below, clumped if from above.
- **Reading:** the interesting creatures are hard to replicate because they live in the **hysteretic
  transition zone** — the configuration is a function of the *path*, not the parameters. Mechanism:
  once a clump forms it deposits density whose gradient self-stabilizes it (positive feedback),
  enriched by the faithful fluid's real viscous memory. Rigorous corroboration of the live observation
  + the original fluoddity study's "multistable transition zone", now a first-order-like hysteretic
  transition on the faithful fluid.
- Ledger: AT-7 (`:tested`, SIM_SPEC.md) + AT-# registry row; TEST_SPEC T-22; companion §AT-7. Arc
  entries AT-1..7 + the interactive app.

## v0.1.54 — 2026-06-05 — Active-turbulence Phase 4b: faithful fluid in the interactive app (cross-repo)

The "watch" half of Phase 4 — a cross-repo deliverable, not a new ledger claim (no AT entry; this
applies AT-1..6). `:proved`=0; **distance UNTOUCHED.** Scope: phenomenology.

- Retrofitted the faithful fixes into the interactive `fluoddity-metal` app
  (`IridiumSoftware/fluoddity-metal` commit `6a3d9bf`, `docs/faithful_fluid.md`): its **uniform drag →
  ν∇² viscosity** (scale-selective, `diffuse_velocity` kernel) and **monopole splat → net-zero force
  dipole** — the AT-1/AT-3 fixes, grid-discretized for the live render loop. Its existing **chemotaxis**
  (`cohesion`, the AT-5 ingredient) + **Hodge/Leray projection** are kept; new live knobs `viscosity`
  + `dipoleLen`. Headless `--simtest` PASS (stable + projected, 0.64 ms/step).
- ⇒ the creatures can now be **watched live on a real NS fluid**: `swift run fluoddity-metal`.
  The interactive form of the same physics AT-6 validated spectrally. **Active-turbulence arc fully
  complete (AT-1..6 + the interactive app).** Dashboard updated.

## v0.1.53 — 2026-06-05 — LOW #1 geometric-consistency lemma: triad-witnessed → REFUTED (2/2)

Metabolized the TCE LOW-band #1 coordination {NS-013, NS-039, NS-040} (the CFM/Hou–Li-reduction ↔
DNS-`c²_int` geometric-depletion link). Drafted a refute-don't-endorse witness brief and ran the
two-seat adversarial pass (Grok edge-Φ + Gemini synthesis). **Both seats converged on REFUTED.**

- **The geometric-consistency lemma (synthesis §C.3) is WITHDRAWN.** Refuted on: (Q1) the DNS is
  regular-by-construction, so the observed depletion is *forced* — empty agreement; (Q2) `c²_int` and
  the box-dimension are *proxies* that decouple from CFM's actual object (`∫|∇ξ|²|ω|`, the smoothness
  of the vorticity direction) — alignment can relax while `∇ξ` kinks; (Q3) the conditional-alignment-
  persistence probe is structurally undecidable at reachable N. (Q4) NS-040 *weakens*, not supports —
  depletion is helicity-(constraint-)dependent, hence less relevant to the zero-helicity worst case.
- **Firewall catch (Gemini):** the lemma's own phrasing ("the DNS exhibits the depletion theory needs;
  theory and data line up") crossed the firewall. Confirmed; §C.3 phrasing corrected. This is the
  validator-confirmation-bias pattern caught *in committed+pushed text* by the adversarial pass.
- **Residue (diagnostics, not PDE):** a singular scenario, if any, must live at ~zero helicity and in
  `∇ξ` — invisible to our `c²_int`/`D` diagnostics. The probe is dropped.
- **NS-013 stays `:argued`** (the witness refuted a consistency *corollary*, not the reduction).
- Docs: `docs/ns_lowf1_geometric_consistency_{brief,verdict}.md`; synthesis §C.3 + §B corrected.
  No spec status change. `:proved`=0; distance UNTOUCHED.

## v0.1.52 — 2026-06-05 — Active-turbulence AT-6: GPU faithful-fluid core, Phase 4a (SIM_SPEC.md)

The GPU port, Phase 4a of "validate then watch". `:proved`=0; **distance UNTOUCHED.** Scope:
phenomenology, NOT the PDE, NOT the obstruction map.

- **AT-6** (`metal/active_turbulence_gpu.swift`). The faithful 2D vorticity IF-RK4 solver (AT-1/AT-2)
  re-implemented on the GPU in **MPSGraph** — the same engine as the NS-038→039 GPU DNS (built-in
  `fastFourierTransform`, GPU-resident ping-pong, **no hand-written Metal kernels**) — and
  cross-validated against the CPU Julia.
- **GPU(float32) ≡ CPU(float64) to ~6 digits:** AT-01 inviscid invariants conserved to **3.8e-6**
  (CPU 1.3e-14); AT-02 viscous single-mode decay matches `exp(−ν|k|²t)` to **2.95e-6** (CPU 7.3e-16) —
  the integrating factor is exact on GPU. Forced run reproduces the forward enstrophy cascade
  (slope **−3.48, R²=0.99** vs CPU −3.36 — different forcing realization, same universal −3).
- **~100× faster:** 3100 steps (N=128, forced) in **3.1 s** on an M5 Max (~1 ms/step) vs ~3 min CPU.
  Mirrors the NS-038→NS-039 GPU≡CPU discipline. Bug found + fixed en route: Swift `String(format:)`
  with `%s` + a Swift `String` segfaults (use plain strings / `+` concatenation).
- Ledger: AT-6 (`:tested`, SIM_SPEC.md) + AT-# registry row; TEST_SPEC T-21; companion §Phase-4a;
  `metal/README.md` updated; binary gitignored (mirrors `dns_gpu`). **This is the validated core for
  Phase 4b** (wire into the interactive fluoddity-metal app for live watching) — the only remaining
  strand. Arc entries AT-1..6.

## v0.1.51 — 2026-06-05 — Active-turbulence AT-5: chemotaxis closes the question (SIM_SPEC.md)

The decisive follow-up AT-4 flagged. `:proved`=0; **distance UNTOUCHED.** Scope: phenomenology, NOT
the PDE, NOT the obstruction map.

- **AT-5** (`scripts/active_turbulence_chemotaxis.jl`). AT-4 found velocity-sensing agents do not
  cluster (g(r)≈1) and hypothesised the fluoddity "creatures" needed (a) chemotaxis or (b) the
  non-physical monopole forcing. This isolates (a): on the SAME faithful incompressible fluid + SAME
  net-zero dipole forcing, agents deposit a density field and **steer up its gradient** (toward each
  other). Control = dumb swimmers (cohesion=0).
- **Result — CHEMOTAXIS CLUSTERS:** pair-correlation **g(r) peaks 4.0× at contact** (r≈0.03), 1.86×
  near-field, decaying to uniform by r≈0.3; the dumb control stays a uniform gas (g≈1.0). Near-field
  ⟨g⟩ = 1.31 (chemo) vs 1.00 (dumb).
- **Closes the question:** lifelike organization **does** survive on a faithful incompressible NS
  fluid — but via **chemotaxis (aggregation), not active turbulence**. Because clustering appears on a
  **divergence-free** fluid, it is **not** the compressible-monopole sink artifact ⇒ **AT-4 candidate
  (b) RULED OUT.** The fluoddity creatures were genuine chemotaxis-driven aggregation — a real,
  substrate-independent mechanism — layered on a fluid that itself self-organizes into vortices
  (AT-2/AT-4). Active turbulence makes the vortices; chemotaxis makes the creatures; they're separate.
- Ledger: AT-5 (`:tested`, SIM_SPEC.md), AT-# registry row, TEST_SPEC T-20, companion updated.
  **Active-turbulence arc COMPLETE (AT-1..5; Phase 4 GPU deferred).**

## v0.1.50 — 2026-06-05 — Re-home the active-turbulence track to a fenced AT-# ledger (SIM_SPEC.md)

Integration/bookkeeping: the active-turbulence simulator entries shared the NS-### sequence + `SPEC.md`
with the *obstruction map* (a different program). Re-homed into their own fenced track so the
obstruction ledger stays clean. **No content/Scope changes; no NS-001..040 touched; firewall intact.**

- **New `SIM_SPEC.md`** — "Active-turbulence phenomenology track. Scope: phenomenology / 2D
  active-turbulence truncation — NOT the obstruction map, NOT the NS PDE; the obstruction program's
  `:proved`=0 firewall does not gate this track." Holds the four entries **NS-041→AT-1, NS-042→AT-2,
  NS-043→AT-3, NS-044→AT-4** (verbatim content, Scope lines, deps re-pointed to AT-#) + its own
  AT-# artifact-registry sub-table.
- **`SPEC.md`** — removed the NS-041..044 entries + the "ACTIVE TURBULENCE" section; count reverted to
  **30 entries** (NS-001..040 = the obstruction map); added a pointer: "Active-turbulence
  phenomenology track → SIM_SPEC.md (AT-1..4), Scope ≠ PDE."
- **`artifact_registry.md`** — removed the four NS-04x rows (now in SIM_SPEC.md); added a pointer note.
- **`TEST_SPEC.md`** — T-15..T-19 re-pointed from NS-04x to AT-1..4 (the checks are unchanged; AT-01..04
  check names kept).
- **`dashboard.md`** — the active-turbulence milestone now references AT-#/`SIM_SPEC.md`, not NS-###.
- The historical Phase-0..3 entries below (v0.1.46–49, "NS-041..044") are left as immutable changelog
  history. AT tests re-run green post-renumber.

## v0.1.49 — 2026-06-05 — Active-turbulence Phase 3: organization NULL, reframes fluoddity (NS-044)

The climax of the active-turbulence arc — an honest NULL with a sharp payoff. `:proved`=0; **distance
UNTOUCHED.** Scope: phenomenology, NOT the PDE.

- **Phase 3** (`scripts/active_turbulence_organization.jl`). Cranked to a vigorous active flow
  (forceGain=25, N=2000 agents ⇒ u_rms≈0.6 > swim 0.35, **42% vortex-dominated** by Okubo–Weiss — the
  *fluid* self-organizes into coherent vortices). Censused the agents for self-organization: pair-
  correlation g(r), Okubo–Weiss, brain-agents vs a dumb-swimmer control.
- **Result — NULL:** **g(r) ≈ 1.0 everywhere** for both brain-agents and the dumb control (ratio 1.00).
  No clustering, no creatures. Lifelike organization does **not** emerge from active velocity-sensing
  agents on a faithful incompressible fluid.
- **The payoff — it reframes the fluoddity engine:** its "creatures/vacuoles" were **not** emergent
  active turbulence. They required (a) **chemotaxis** (cohesion: steering up the density gradient —
  this port senses velocity only) and/or (b) the **non-physical momentum-monopole forcing** (which
  makes convergence/sink regions agents pile into — *impossible* on a divergence-free fluid). The
  lifelikeness was chemotaxis + a compressible-forcing artifact.
- **Decisive follow-up, flagged UNTESTED:** add the chemotaxis term and re-census — does
  density-aggregation reproduce clustering on the faithful fluid?
- Ledger: NS-044 (`:tested`, honest NULL, Scope phenomenology), registry row, TEST_SPEC T-19, companion.
  Count 33→34. **Active-turbulence arc Phases 0–3 COMPLETE** (Phase 4 GPU deferred).

## v0.1.48 — 2026-06-05 — Active-turbulence Phase 2: discrete active-dipole agents (NS-043)

The active-matter coupling — the rigorous fluoddity. `:proved`=0; **distance UNTOUCHED.** Scope:
phenomenology, NOT the PDE.

- **Phase 2 — discrete active-dipole agents** (`scripts/active_turbulence_agents.jl`). N=1500
  self-propelled agents swim in the faithful fluid (NS-042), sense the velocity at two body-frame
  sensors, steer by the **ported fluoddity Fourier brain** (10-center mirror-symmetric sum-of-sines),
  are advected + **co-rotated by local ω/2**, and force the fluid back as **net-zero force DIPOLES**
  (+f ahead/−f behind, normalized Gaussian IB spread) through NS-041's curl hook.
- **AT-03 (→ T-18) — the faithful-forcing check:** the dipole forcing injects net grid momentum
  **relative 9.5e-18 = MACHINE ZERO** (the defining active-swimmer property), while the fluoddity
  **monopole** injects O(1) (relative 3.7e-2). *That number is the precise sense in which fluoddity's
  splat was unphysical — now fixed and verified.*
- **Stable coupled run** (1500 steps, E/Z bounded, agents swim ≈0.32). Honest: the active flow is
  weak at these params (E≈5e-4 — net-zero dipoles inject little large-scale energy ⇒ fluid speed ≪
  swim speed); Phase 3 cranks `forceGain`/density toward u_rms ~ swim, where collective
  self-organization would live.
- Ledger: NS-043 (`:tested`, Scope phenomenology), registry row, TEST_SPEC T-18, companion updated.
  Count 32→33. **Next:** Phase 3 — *does lifelike organization emerge?* (Okubo–Weiss vortex census,
  agent pair-correlation g(r), E(k) shift vs the passive control).

## v0.1.47 — 2026-06-04 — Active-turbulence Phase 1: forced-turbulence control (NS-042)

The faithful fluid (NS-041) is a **real turbulence engine.** `:proved`=0; **distance UNTOUCHED.**
Scope: phenomenology, NOT the PDE.

- **Phase 1 — passive forced-turbulence control** (`scripts/active_turbulence_forced.jl`). Drive the
  NS-041 fluid with a steady band-limited (passive, random-phase) vorticity forcing at `k_f=8`,
  dissipate by `ν∇²` + a low-k Rayleigh drag, run to a statistically steady state (N=128, E≈0.68,
  Z≈33), time-average `E(k)`.
- **Result:** a **clean forward enstrophy cascade `E(k)~k^−3`** — measured slope **−3.36, R²=0.99**
  over k∈[10,25] (steeper-than-−3 from coherent vortices, as real 2D DNS shows). A *universal*
  Kraichnan exponent — the decisive contrast with the fluoddity engine, whose slope was a
  forcing-controlled *dial* (−1.4..−3.1, no universal value). The faithful fluid turbulates like
  real 2D NS.
- **Honest scope:** the inverse-energy range is the shallow energy-containing pileup (slope ≈ +0.4),
  **not** a resolved −5/3 inverse-inertial range — that needs ≥1 decade below `k_f` ⇒ N≥256 at high
  `k_f` (deferred). The dual-cascade *structure* (steep forward, shallow inverse) is present.
- Ledger: NS-042 (`:tested`, Scope phenomenology), registry row, TEST_SPEC T-17 (AT-04), companion
  updated. Count 31→32. **Next:** Phase 2 (discrete active-dipole agents + ported Fourier brain).

## v0.1.46 — 2026-06-04 — Active-turbulence track, Phase 0: the faithful fluid (NS-041)

New **phenomenology** track — the rigorous version of the fluoddity agent engine: a faithful 2D
Navier–Stokes fluid driven by active agents (active turbulence), to explore self-organization.
`:proved`=0; **distance UNTOUCHED.** Scope: phenomenology, NOT the PDE.

- **Phase 0 — the faithful fluid** (`scripts/active_turbulence_fluid.jl`). Extends the validated 2D
  vorticity–streamfunction solver (NS-010, `spectral_2d_control.jl`) with the two pieces active
  matter needs: (1) **exact `ν∇²` viscosity via IF-RK4** (integrating factor `exp(−νk²dt)`; the
  cascade-bearing fix over fluoddity's scale-independent uniform drag); (2) a **curl-of-force
  coupling hook** — a body force enters as `(∇×f)_z`, which auto-discards the compressive part, so
  active forcing couples with no extra projection (`f≡0` here; agents in Phase 2).
- **Validated:** AT-01 (unforced-inviscid energy+enstrophy conserved 1.3e-14, T-15), AT-02
  (single-mode viscous decay ≡ `exp(−ν|k|²t)` to 7.3e-16, T-16).
- Ledger: NS-041 (`:tested`, Scope phenomenology), registry row, TEST_SPEC T-15/T-16, companion
  `docs/active_turbulence_companion.md`. Count 30→31. Plan `~/.claude/plans/jazzy-zooming-horizon.md`.
- **Next:** Phase 1 (passive forced dual-cascade control, NS-042) → Phase 2 (active-dipole agents).

## v0.1.45 — 2026-06-04 — Consolidation: TCE self-map v2 (30-node) + corollaries of the no-go map

Stepped back to consolidate the mature no-go map. `:proved`=0; distance UNTOUCHED. No spec status changes.

- **TCE self-map v2 (NS-031 re-run, 30-node ledger).** Re-encoded `discovery/ns_obstruction_corpus.json`
  to 30 nodes (NS-001..040; added the geometric/possibilistic tour + resolved-DNS/GPU cluster + NS-013
  sharpened deps) and re-ran the TCE `Discovery.Triadic` engine. The engine independently recovered the
  new clusters — **{NS-038,039,040} resolved-DNS** and **{NS-010,011,032} diagnostic→hunt** (HIGH) —
  and elevated the **critical-norm cluster {NS-005,008,033,034}**: NS-005 (the one open backward path
  NS-002 leaves) is the structural HUB. The enstrophy-rung convergence reads as a *loose MID coordination*
  (reduction chain, not a tight triad); the NS-013↔DNS-c²_int geometric link surfaces at LOW. Tier-wall
  holds. Full log regenerated (`discovery/ns_triad_discovery.out.txt`, 30-node).
- **Corollaries synthesis** (`docs/ns_corollaries_synthesis.md`): the 6 scoped structural/methodological
  lemmas the no-go understanding yields — the necessary-conditions bundle for blowup, the dead-paths
  checklist, the geometric-consistency lemma (DNS c²_int ↔ CFM), the exact scaling lemmas, the
  possibilistic impossibilities, the box-dimension N-convergence methodology.
- **Indicated next direction** (synthesis + TCE agree): the **critical-norm path NS-005**, plus the
  re-witness of the NS-013 CFM/Hou–Li reduction. Consolidation only; no new claims.

## v0.1.44 — 2026-06-04 — NS-013 attacked: obstruction-map triad-REFUTED, sharpened to a geometric reduction

Took on NS-013 (does complex-data blowup inform real-data regularity?). `:proved`=0; UNTOUCHED.

- **Analytic obstruction-map drafted** (`docs/ns013_complex_real_obstruction.md`): Li–Sinai exploits
  the absent energy bound; reality = energy bound + conjugate-phase symmetry ⇒ complex⇏real vacuous,
  real-protection ⟺ the NS-002/036 enstrophy wall.
- **Falsification ladder** (`scripts/ns013_reality_ladder{,_2d,_3d}.jl`): complex data + reality
  leakage `−iλ·Im` across Burgers/CLM/2D/3D. Binary held (controlled models protect; CLM never);
  an apparent monotone λ_c gradient with dimension.
- **Triad-witnessed → REFUTED on all four checks** (`docs/ns013_triad_brief.md`, `ns013_triad_verdict.md`;
  Grok edge-Φ + Gemini synthesis, convergent): "vacuous" asserted-not-argued; reduction loose;
  ladder definitional / gradient a mode-density artifact; firewall over-reach. **Map withdrawn.**
- **Sharpened, witness-survivable reduction (recorded `:argued`):** reality's Hermitian phase does NOT
  generically deplete the cascade (real turbulence cascades) — so the protective direction reduces to
  the **emergent Constantin–Fefferman / Hou–Li geometric depletion** (conditional, open), connecting
  NS-013 → NS-006 → NS-038's measured `c²_int`. **NS-013 PDE question stays `:open`**; status moved
  `:open`→`:argued` (the argued content is the reduction, flagged post-witness/not-re-witnessed).
- Ledger: SPEC NS-013 + registry + TEST_SPEC T-14 (ladder solvers PASS; gradient REFUTED) + dashboard.
  A clean demonstration of the witness discipline catching over-reach. Distance UNTOUCHED.

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
