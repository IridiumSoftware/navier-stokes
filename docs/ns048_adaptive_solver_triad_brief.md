# Adversarial triad brief — should we build the adaptive / moving-mesh swirl solver?

**You are an adversarial referee. Your job is to REFUTE.** Default verdict for every claim below is
**"NOT established."** This is a **decision/scope brief**, not a math-proof brief: the question is whether to
spend a large effort building an adaptive axisymmetric-NS-with-swirl solver, what it would actually establish,
and whether a cheaper path exists. Be especially hostile to (i) sunk-cost / momentum reasoning in *either*
direction (build it because we built the precursor; or stop because we're tired), (ii) over-reach narratives
("we'd be closing in on the singularity" — false: `:proved`=0, distance UNTOUCHED), (iii) reinventing
published work, and (iv) a bias toward an option *because it reuses the author's own tooling*.

Self-contained. Do not assume the author is right.

---

## 0. The setting (all established; assume given)

- **The vacuity map** (`docs/ns048_conditional_vacuity_map.md`) tests whether the literature's *conditional*
  blowup-exclusion hypotheses hold on resolved near-singular flow. WITNESS-tier, vacuity-capped: a resolved
  truncation cannot reach the singular limit; verdicts are *suggestive priors*, never proofs. `:proved`=0.
- **The axisym-swirl cells.** A faithful Hou–Li `(r,z)` NS-with-swirl solver was built and **validated 4/4**
  (`scripts/ns048_axisym_swirl_dns.jl`). Cell **(i) swirl-sign is CLOSED** (Γ≥0 holds but ⊥ `sign S`, corr 0
  — true-but-useless). Cells **(ii) `|x₃|^α` axial-swirl growth** and **(iii) Type-I scaled-energy `I`** are
  **RESOLUTION-LIMITED**: the **Hou–Luo wall fixture** (`wall` mode) *confirms the intensification mechanism*
  (‖ω‖ 0→24.7, swirl→wall) but goes **unresolved** (spurious energy growth `E/E0→1.32`, then NaN) by t≈0.75
  even at ν=2.5e-3 / 192×160. In the resolved phase the ω z-width does NOT narrow and `I` grows only ×1.36;
  the apparent concentration is unresolved grid-scale garbage.
- **Prior art — Chen–Hou.** The Hou–Luo finite-time blowup (2D Boussinesq / 3D axisym Euler **with boundary**,
  smooth data) was **proven** by Chen–Hou (arXiv:2210.07191 analysis + 2305.05660 rigorous numerics) via
  adaptive / self-similar computer-assisted methods. The self-similar profile + blow-up rate are *known*.
- **In-repo tooling — the NS-050 dynamic-rescaling instrument** (`scripts/ns050_*`, validated): a two-scale
  / dynamic-rescaling fit that reads a self-similar exponent `β = d lnℓ/d lnλ = c_l` from an intensifying
  flow **in a rescaled frame that stays bounded as the physical flow concentrates** — calibrated to machine
  agreement on CLM (`β=1`) and the 1D Hou–Luo model (`β=2.47 ∈` the proven Chen–Hou–Huang band `(2,4.53)`),
  plus machine-precision ℝ-variable cot-map dilation + line-Hilbert operators (`scripts/ns050_mapped_grid.jl`).

## The three options on the table

- **(A) Full adaptive / moving-mesh solver** (Chen–Hou-class: moving mesh or refined spectral near the wall
  corner) to push the wall fixture past the resolution wall and measure `|x₃|^α` + Type-I directly.
- **(B) Build nothing** — record cells (ii)/(iii) as RESOLUTION-LIMITED (mechanism confirmed, clean read
  beyond a uniform-grid witness) and bank it as the final witness status.
- **(C) Reuse the validated NS-050 dynamic-rescaling instrument** on the wall fixture's intensifying phase —
  rescale around the concentrating corner so the profile stays resolved in the rescaled frame, and read the
  self-similar exponent (the `|z|^α` rate) the way HL's `β=2.47` was read — *without* a moving mesh.

---

## 1. The claims to refute

**C1 — (A) is the right path.** A full adaptive/moving-mesh solver is the correct way to complete cells
(ii)/(iii). *(Refute by: it reproduces Chen–Hou at lower rigor — they already computed the self-similar
profile/rate with adaptive numerics; it is a multi-month research-numerics build; and the output stays
WITHIN-TRUNCATION / vacuity-capped, so it cannot upgrade the map past "witness". Net value per unit effort?)*

**C2 — (C) is valid and much cheaper.** The NS-050 dynamic-rescaling instrument can read the `|x₃|^α` /
self-similar exponent of the wall fixture's intensification in a rescaled frame, reusing validated tooling,
at a tiny fraction of (A)'s cost. *(Refute by: the Hou–Luo self-similarity is at a BOUNDARY corner `(r,z)=(R,0)`,
not an interior point; dynamic rescaling around a fixed wall is not the same as the CLM/HL interior rescaling
the instrument was validated on — the wall is a fixed length scale that does not rescale. Does the instrument
transfer, or does the boundary break the self-similar ansatz the fit assumes? Is `β` even well-defined here?)*

**C3 — scope ceiling.** Whatever is built, the result is `Scope: resolved-DNS / within-truncation witness`,
`:proved`=0, distance UNTOUCHED — it cannot bear on the Clay PDE; the only legitimate payoff is a sharper
*witness* entry in the vacuity map. *(Refute by: find a way any of (A)/(C) could be mis-read as PDE progress —
the trap to name explicitly.)*

**C4 — completing (ii)/(iii) materially improves the map.** A measured `|x₃|^α` exponent + Type-I trend is a
real upgrade over "RESOLUTION-LIMITED". *(Refute by: is it marginal? "mechanism confirmed but unresolved on a
uniform grid — reproduces why Hou–Luo needed Chen–Hou" may already be the honest, sufficient verdict for these
cells; a measured exponent that merely *agrees with Chen–Hou* adds little to a where-NOT-to-look map.)*

**C5 — THE RECOMMENDATION (META).** The honest call is: **try (C) first** (cheap, reuses validated tooling,
novel-to-this-repo) — and if its self-similar ansatz fails the boundary test (C2), fall back to **(B)** and
bank the resolution-limited finding; **(A) is over-investment** that reproduces Chen–Hou. *(Refute by: TWO
opposite biases to test — is "do (C)/skip (A)" rationalizing away hard work, OR is the author over-keen on
(C) precisely because it reuses HIS OWN NS-050 instrument (tool-attachment bias)? Is (B) actually the right
answer and (C) a dressed-up way to keep going? Or is (A) genuinely worth it for a reusable asset and you're
all under-valuing it?)*

---

## 2. What to return

For EACH of C1–C5: a verdict in {REFUTED, NOT ESTABLISHED, CORRECT-AS-STATED} with the specific
error / over-reach / hidden assumption / missed alternative, or — if you cannot break it — why.

**Highest-priority targets:**
- **C2** — the load-bearing technical question. Does dynamic rescaling around a **wall corner** preserve a
  well-defined self-similar exponent, or does the fixed wall length-scale void the ansatz the NS-050
  instrument fits? If (C) is invalid, the recommendation collapses to (B). *Settle this concretely.*
- **C5** — name the dominant bias (sunk-cost-stop, tool-attachment to NS-050, or under-valuing a reusable
  adaptive asset) and give the call you'd actually make.
- **C1/C4** — is there ANY witness-tier finding (A) would produce that (C) or the current state would not?
  If not, (A) is dominated.

Flag any place a step, if correct, would constitute PDE progress — that would mean it is wrong (the problem
is open).

---

## 3. Internal pre-screen (Claude, confirmation-bias-prone — verify, challenge, find what it MISSED)

- **C1: lean REFUTED.** (A) reproduces Chen–Hou at lower rigor, is multi-month, stays vacuity-capped. Hard to
  see the marginal witness-value. *Challenge: is a reusable adaptive axisym-swirl solver worth it as
  infrastructure for OTHER NS-048 routes, independent of this one cell?*
- **C2: NOT ESTABLISHED (the crux).** Attractive but UNVERIFIED — the wall-corner boundary may break the
  interior self-similar rescaling the instrument was validated on. I do **not** currently know that (C) is
  valid. This is the single question that decides build-vs-bank. *Settle it before any build.*
- **C3: CORRECT-AS-STATED** — but the "closing in on the singularity" narrative is the live over-reach trap;
  name it in any write-up.
- **C4: lean NOT ESTABLISHED** — "resolution-limited + mechanism-confirmed + reproduces-why-Chen–Hou-was-needed"
  may already be the honest, sufficient cell verdict.
- **C5: my call is (C)-if-valid-else-(B); (A) over-investment** — but I flag my **tool-attachment bias** to the
  NS-050 instrument and my **sunk-cost-stop bias** (I just did a lot of honest work and may be rationalizing
  stopping). The triad exists to break exactly this. AGREE / DISAGREE each, with reasons, and surface the bias
  I'm not seeing.
