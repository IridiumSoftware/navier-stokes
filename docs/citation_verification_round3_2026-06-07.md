# Citation verification round 3 — target #3 (LRZ + Thm 3.7) — campaign complete — 2026-06-07

Executes the last audit target **#3**: the two remaining with-swirl ancient-Liouville closers, held at C1
(Q.S. Zhang review only). Both **line-read at primary** and promoted to **C3**. **Foundation-hardening,
NOT PDE progress; `:proved`=0; distance UNTOUCHED.** Unlike round 2, this round is a **clean
confirmation** — no correction; the load-bearing universal HOLDS.

---

## 1. Lei–Ren–Zhang (ℝ²×T¹) — **C3**

**Source:** arXiv:1911.01571 ("A Liouville Theorem for Axi-symmetric NS on ℝ²×T¹"), line-read. **Statement
(Thm 1):** a bounded mild ancient axisymmetric solution with `Γ=rv^θ` bounded and **`z`-periodic** ⇒
`v≡c e_z`. **Mechanism — BYPASSES `S`:** the stated goal is "show `Γ≡0`"; the entire proof is a
De Giorgi–Nash–Moser / oscillation-Harnack iteration on the **`Γ`-transport equation**
`∂_tΓ + b·∇Γ + (2/r)∂_rΓ = ΔΓ`, with the load-bearing trick that `z`-periodicity + `∇·b=0` gives
`v_r∈(L^∞)^{−1}` (the missing critical scaling). Forces `Γ≡0` → swirl-free → KNSS. The `Ω=ω^θ/r`
equation and its source `S=(1/r⁴)∂_z(Γ²)` **never appear**.

## 2. "Theorem 3.7" (small radial oscillation) — **C3**

**Source identified + read:** review ref [70] (Lei–Ren–Zhang, *Another Liouville type theorem…*, Sci.
China Math., Chinese) was **split from the preprint arXiv:1902.11229**, where it is **Theorem 1.2** with a
**byte-identical** hypothesis to the review's (3.7). Read 1902.11229 §4 line-by-line. **Statement:** bounded
mild ancient axisym, `Γ` bounded, + the small-radial-oscillation rate
`|Γ²−limsup_{r→∞}Γ²| ≤ (ε₀/r)·limsup Γ²` ⇒ `v=c e_z`. **Mechanism — BYPASSES `S`:** a weighted energy
estimate on the **`Γ`-equation** (`∂_r²Γ+∂_z²Γ−v_r∂_rΓ−v_z∂_zΓ−(1/r)∂_rΓ−∂_tΓ=0` — the `(1/r)` here is
the linear `Γ`-drift, *not* the `Ω`-source); the oscillation hypothesis kills the `v_r∂_rΓ` cross-term,
forcing `lim_{r→∞}Γ=0` → swirl-free → Lei–Zhang–Zhao [9] → KNSS. `S` **never appears**.

---

## 3. Universal-claim verdict: **HOLDS — now C3 for all three closers**

The NS-048-arc universal — *every known with-swirl ancient-Liouville closer bypasses the source `S`,
forcing `Γ`-decay/triviality → swirl-free reduction → KNSS; none controls `S` directly* — is now
**C3-verified for all three**: Lei–Zhang–Zhao (round 1), Lei–Ren–Zhang (here), Theorem 3.7 (here). None
estimates `S`; none even writes the `Ω`-equation. The **C1 hedge** the meta-review §4 placed on the
universal ("C3 for LZZ, C1 for the others") is **LIFTED** — the "every" is now fully C3.

The frontier doc's central reframing — *"controlling `S` directly via `∂_zΓ` is a road not taken; the
literature kills `Γ` instead"* (`docs/ns048_swirl_source_frontier.md`) — is therefore **strengthened, not
threatened**. Independent corroboration: the review (arXiv:2101.04905 p.16) states *"to study the equation
of `Γ` in isolation is likely to fail … without the divergence-free condition on `b`"* — i.e. every known
route leans on `∇·b=0` to tame the `Γ`-transport, never on the `Ω`-source.

---

## 4. Verification campaign — COMPLETE

| Target | Result | Tier |
|---|---|---|
| #1 KNSS (swirl-free reduction + compactness lemma) | foundation **hypothesis-clean**; Lemma 6.1 = uniform-`L∞` compactness (C3-confirmed route (i)) | **C3** |
| #1b Albritton–Barker (Type-I ⟺) | **corrected**: not Seregin–Šverák; **Type-I-conditioned** (not general Liouville) | **C3** |
| #2 NS-007 (NRŠ + Tsai self-similar) | confirmed; `L³` faithful; local-energy = Tsai | NRŠ **C2** · Tsai **C3** |
| #3 LRZ + Thm 3.7 | confirmed; both bypass `S` via `Γ`-decay → swirl-free | **C3** both |

**Net of the campaign:** the obstruction manifold's foundations are hardened — one over-attribution
caught and corrected (#1b: ⟺ = Albritton–Barker, Type-I-conditioned), one scope overstatement corrected
(#1b: not "general Liouville"), and three load-bearing claims confirmed (#1 foundation clean; #2 NS-007;
#3 the "every closer bypasses `S`" universal, hedge lifted). `:proved`=0; distance UNTOUCHED throughout —
this was epistemic-supply-chain integrity, exactly as the program meta-review prescribed.

**Remaining (low-priority, optional):** Seregin–Šverák 2009 (CPDE 34, axisym Type-I) — title only, not
load-bearing; NRŠ Acta 1996 primary (C2→C3) if the self-similar branch is ever pushed.

---

## 5. Sources + flags

**Verified (C3, line-read via curl + `pdftotext -layout`):** arXiv:1911.01571 (LRZ ℝ²×T¹);
arXiv:1902.11229 (= the preprint Thm 3.7 was split from, hypothesis byte-identical to the review's [70]);
review arXiv:2101.04905 (provenance of [70]; the "`Γ`-in-isolation fails without `∇·b=0`" remark).

**Flagged:** the published Sci. China Math. (Chinese) version of [70] not fetched — mitigated: read the
canonical preprint 1902.11229 §4, whose Thm 1.2 hypothesis is character-identical to the review's (3.7),
and whose energy-method matches the review's "weight-function/adapted-PDE" description. No discrepancy; no
`S`-control route in either paper.
