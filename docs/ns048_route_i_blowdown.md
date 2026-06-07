# NS-048 route (i) — blow-down / Liouville-rescaling on the `|x₃|^α` ancient conjecture: attempt + break

**Date:** 2026-06-07. **ATTEMPT / ANALYSIS. NO theorem.** `:proved`=0; distance UNTOUCHED; NS-048
unchanged. Default "not established." First artifact run under the **C0–C5 citation discipline** (tiers in
§8). Executes route (i) from `docs/ns048_anisotropic_z_port.md` §5/§8: attack the `|x₃|^α` ancient
Liouville conjecture by the blow-down / Liouville-via-rescaling device. **Outcome: route (i) does NOT
close it — and the attempt corrects an over-optimistic claim I made about route (i) in the port doc (14th
honesty-ledger item).** The break sharpens the two-tail picture and raises a counterexample suspicion.

---

## 1. The route and the conjecture

**Conjecture (`|x₃|^α` ancient port):** a bounded mild ancient axisymmetric solution on `ℝ³×(−∞,0]` with a
critical axial-swirl bound `‖|x₃|^α u^θ‖_{L^q_tL^p_x}<∞` (`2/q+3/p=1−α`, `0≤α<1/4`), or `‖|x₃|u^θ‖_∞`
small, is constant.

**Route (i):** the Liouville-via-rescaling device used by Lei–Zhang–Zhao (the KNSS "Lemma 6.1" blow-down)
[**C1** — known via LZZ's use, not line-read]: rescale the (already bounded) ancient solution to expose
its large-scale / spatial-infinity structure, use the critical (scale-invariant) bound for compactness,
and exclude the limit by rigidity. The port doc bet this route "sidesteps the radial-tail problem" because
the `|x₃|^α` norm is scale-critical. **Working it shows that bet was wrong.**

---

## 2. Scaling setup (what IS controlled)

The swirl `Γ=ru^θ` is scale-invariant: the swirl of `u_λ(x,t)=λu(λx,λ²t)` equals `Γ_λ(x,t)=Γ(λx,λ²t)`
[self-derived], so `‖Γ_λ‖_∞=‖Γ‖_∞≤M` for all `λ`. The `|x₃|^α` norm is scale-invariant
(`2/q+3/p=1−α`; port doc §2, verified). So the blow-down family `{u_λ}` is **uniformly bounded in the
critical axial norm** — the criticality is real and necessary. The question is whether it is *sufficient*
to extract and exclude a limit. It is not, for two reasons.

---

## 3. Break #1 (decisive) — the blow-down needs RADIAL decay; `|x₃|^α` gives AXIAL decay

The device exposes spatial-infinity structure by `λ→∞` (zoom out). Track `Γ` under it, saturating each
hypothesis:

- **LZZ (radial `L^p` ⇒ `|Γ|≲|x_h|^{−1/p}`):**
  `Γ_λ(x,t)=Γ(λx,λ²t) ≲ |λx_h|^{−1/p} = λ^{−1/p}|x_h|^{−1/p} → 0` as `λ→∞`. The far-field **concentrates
  to 0** — exactly the input the Liouville-rescaling needs to force `Γ≡0`. *This is why LZZ's route
  closes.*
- **`|x₃|^α` (axial `u^θ≲|x_3|^{−α}` ⇒ `Γ=|x_h|u^θ ≲ |x_h||x_3|^{−α}`):**
  `Γ_λ(x,t) ≲ |λx_h|·|λx_3|^{−α} = λ^{1−α}\,|x_h||x_3|^{−α} → ∞` as `λ→∞` (since `α<1`). The far-field
  **blows up**, not down — the *radial growth* of `Γ=ru^θ` (linear in `r`) is **amplified** by the
  blow-down (factor `λ^{1−α}`), not concentrated.

**The blow-down is intrinsically a radial-scaling operation; it is matched to radial decay (LZZ), and the
`|x₃|^α` axial decay is orthogonal to what it needs.** The scale-invariance of the *norm* does not rescue
this: a bounded critical norm with linearly-`r`-growing `Γ` still has an amplifying pointwise blow-down.

---

## 4. Break #2 — compactness fails (supercriticality reappears)

Even setting aside §3, the velocity blow-down is not uniformly bounded: `‖u_λ(·,t)‖_∞=λ‖u(·,λ²t)‖_∞≤λM`,
so on any fixed cylinder `u_λ` grows like `λ` — **no uniform local `L^∞`, no Arzelà–Ascoli.** The only
uniform control is the *critical* `|x₃|^α` norm, which is too weak to give the strong (`L³_loc`-type)
compactness needed to pass the NS nonlinearity to the limit. This is **supercriticality (NS-002) [C2]**:
the critical norm does not compactly embed. So the limit object cannot be extracted as a genuine NS
solution by this route.

---

## 5. Correction to the port doc (14th honesty-ledger item)

`docs/ns048_anisotropic_z_port.md` §5/§8 stated route (i) "**sidesteps the radial-tail problem of route
(ii)**" and that "the criticality is *exactly* what that device requires." **Both are wrong, and route (i)
itself refutes them:**
- Route (i) does **not** sidestep the radial tail — it is **more** dependent on radial control than the
  energy route, because the blow-down *scales `r`* and is defeated precisely by `Γ`'s radial growth (§3).
- Criticality (norm scale-invariance) is **necessary, not sufficient**: it gives a uniform norm-bound but
  neither compactness (§4) nor pointwise control of the radial blow-down (§3).

This was an over-optimistic framing of an untried route, deflated by trying it. (Ledger: 7th
geometry-re-tasking; 8th manufactured-theorem-declined; 9th sign-shortcut; 10th "no soft step"; 11th
"three independent convergent"; 12th weak-`L^p`-in-the-correction; 13th "incomparable" declined; **14th
"route (i) sidesteps the radial tail."**)

---

## 6. What route (i) reinforces — and a counterexample suspicion

**Two-tail reading confirmed from the dynamic side.** Both attack routes now agree: the energy route (port
§6) leaves a borderline *radial* tail; the blow-down route (here) is *defeated* by the radial tail. The
`|x₃|^α` condition supplies only the **axial** half of the control; **a closing condition needs axial +
radial together** (e.g. `|x₃|^α u^θ` **and** an LZZ-type radial decay of `Γ`).

**The `|x₃|^α`-ONLY conjecture is genuinely OPEN.** Saturating the bound gives `Γ ≲ r|x_3|^{−α}` — *linear*
radial growth of the swirl (`u^θ` merely bounded); no known closer reaches that with-swirl regime.
**[CORRECTED 2026-06-07 (Pan–Li verification — 16th honesty-ledger item):** this section originally
claimed the axial-only conjecture is "in doubt / possibly FALSE," citing Pan–Li's `α=1` sharpness. **That
support was wrong.** Pan–Li (now line-verified **C3**, NA:RWA 2020, arXiv:1908.11591) is the **NO-SWIRL**
case; its `α=1` counterexamples (Prop 1.5: `u^r=C₁r, u^z=−2C₁z+C₂(t)`) are **swirl-free**, so they do
**not** evidence a *with-swirl* bounded counterexample. The blow-down break (§3) stands regardless; only the
"possibly false" suspicion's basis is removed. Honest status: the axial-only conjecture is **OPEN /
unknown** — no closer covers it, and Pan–Li gives no counterexample there. See
`docs/pan_li_verification_2026-06-07.md`.**]**

---

## 7. Verdict

- **Route (i) does NOT close the `|x₃|^α` conjecture.** Two breaks: the blow-down is structurally matched
  to *radial* decay and is *amplified* by the axial condition's radial growth (§3, decisive); and
  compactness fails by supercriticality (§4).
- **It corrects my own port-doc over-reach** (route (i) ≠ radial-tail-sidestepping; criticality ≠
  sufficiency) — 14th ledger item.
- **It reinforces the two-tail conclusion** (need axial + radial). *(The "counterexample suspicion" first
  stated here was **withdrawn 2026-06-07** — it cited Pan–Li, which is NO-SWIRL and gives no with-swirl
  counterexample, §6 + `docs/pan_li_verification_2026-06-07.md`; the axial-only conjecture is **OPEN**, not
  "in doubt".)*
- **Honest reformulation:** the live conjecture *seemed* to be `|x₃|^α` (axial) + radial combined — **but
  that combined conjecture itself later COLLAPSED** (redundant where radial is strong, stuck where weak;
  `docs/ns048_combined_axial_radial.md`). Net standing: the axial-only conjecture is OPEN; NS-048's
  session-scale attacks are exhausted (bare conjecture + un-mechanised `S`-control route remain).
- **No theorem; `:proved`=0; NS-048 unchanged.**

---

## 8. Citation tiers (C0–C5) — first application of the discipline

- **Lei–Zhang–Zhao** radial-decay / blow-down mechanism (arXiv:1701.00868 §5): **C3** — proof read
  line-by-line this session.
- **KNSS blow-down device** (Acta 2009): **C3** — *line-verified 2026-06-07*
  (`docs/knss_verification_2026-06-07.md`). **Naming corrected:** KNSS's *Lemma 6.1* is the **compactness**
  lemma (uniform `|u_l|≤C` + `T_l↘−∞` ⇒ ancient-mild limit); the *blow-down* is an unlabeled procedure
  before Prop 6.1 + the §5 Liouville rigidity. **Crucially, its compactness input is a uniform `L∞` bound
  only** — which **C3-confirms break #2 above**: the `|x₃|^α` blow-down family fails exactly that
  (`‖u_λ‖_∞=λ‖u‖_∞→∞`), so the compactness genuinely cannot be supplied. (The verification was audit
  target #1, promoted by this very analysis pointing at it.)
- **Pan–Li** `α<1` constancy / `α=1` sharp counterexample: **C3** — *line-verified 2026-06-07*
  (`docs/pan_li_verification_2026-06-07.md`; NA:RWA 2020, arXiv:1908.11591). **CORRECTION: Pan–Li is
  NO-SWIRL** (we'd had "swirl allowed" via the review). Its `α=1` counterexamples are swirl-free ⇒ they do
  **not** support the (now-withdrawn) with-swirl counterexample suspicion.
- **Supercriticality / no-compact-embedding of the critical norm** (NS-002): **C2** — standard, mainstream.
- **Self-derived (no citation):** the `Γ_λ(x,t)=Γ(λx,λ²t)` scale-invariance and both blow-down scalings
  (§2–§3); the `‖u_λ‖_∞=λ‖u‖_∞` compactness obstruction (§4).

**Discipline note:** route (i)'s *decisive* break (§3) rests on **self-derived scaling + C3 LZZ contrast**
— evidentially solid. The *framing* of the device leans on **C1 (KNSS Lemma 6.1)**, and the counterexample
*suspicion* on **C2 (Pan–Li via review)** — both flagged, neither load-bearing for the negative verdict
(the verdict needs only the self-derived amplification + supercriticality).
