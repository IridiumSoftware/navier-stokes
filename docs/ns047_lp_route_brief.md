# Witness brief — NS-047 candidate: does the LP/paraproduct-local route to NS-046 escape the wall?

**Panel:** Grok (edge-Φ, adversarial) + Gemini (synthesis, adversarial) + ChatGPT (NAIVE core witness).
**From:** Aaron + Claude (metabolism). **Date:** 2026-06-05. **Repo:** navier-stokes.
**Outcome:** candidate REFUTED (see `ns047_lp_route_verdict.md`); folded into NS-046 as a note, not a
new entry.

**Your job is to REFUTE, not endorse.** This is the fourth synthesis this session; the previous three
over-reached (a cold reader caught two). Treat that as a prior: the author reaches for tidy "reduces to
the wall" claims. Default to "not established" unless you cannot break it.

**Firewall.** Obstruction-program claim. It asserts NO regularity-or-blowup result and NO new estimate —
only that a *proposed technique* relocates rather than escapes. `:proved`=0; distance UNTOUCHED. If any
part reads as progress (or as ruling out more than the *straightforward* scheme), that is over-reach.

---

## Context

NS-046 (the open analytic target): a coercive critical (σ=0) deformation inequality in which the
nonlocal pressure Hessian `−e₃ᵀ(∇²p)e₃` + viscosity dominate the production `P = ∫|ω|²(ξ·Sξ)`,
localized to CKN-compatible sets. Proposed route (Grok/Gemini): control `P` locally via LP + Bony
paraproducts, CZ boundedness of the pressure singular integral, and Hardy–Littlewood maximal-function
absorption of the nonlocal tail into the viscous term under a local-Reynolds smallness.

## The claim under witness (REFUTE C3)

- **C1 (pressure = CZ; its endpoint is BKM).** `−Δp = |S|²−½|ω|²`, so `−e₃ᵀ(∇²p)e₃ = R₃R₃(|S|²−½|ω|²)`,
  a Riesz (CZ, zeroth-order, σ=0) operator. CZ is bounded `Lᵖ→Lᵖ` (1<p<∞) but fails the L^∞ endpoint
  (`L^∞→BMO`, log), and that failure is the BKM inequality `‖∇u‖_∞ ≲ ‖ω‖_∞(1+log⁺‖ω‖_{Hˢ})` (NS-004).
- **C2 (maximal-function absorption needs anti-supercritical smallness).** `M` is bounded `Lᵖ→Lᵖ`
  (p>1), not at the endpoints. Absorbing the nonlocal pressure tail into `ν·dissipation` needs a small
  local Reynolds number; at σ=0 production and dissipation are scale-balanced (∼λ³), so it is O(1)
  exactly where smallness is needed (NS-002/034).
- **C3 (the synthesis — to be broken).** The *straightforward* LP/paraproduct-local-coercivity scheme
  generates no new critical coercivity: it reduces to the CZ/BKM L^∞-endpoint (NS-004) ∩ the
  supercritical local-Reynolds balance (NS-002/034). A no-go for the straightforward harmonic-analytic
  shortcut — sibling to NS-008. Scope: the straightforward scheme, NOT all of harmonic analysis.

## Adversarial seats — Grok + Gemini

**Q1 (load-bearing — Besov / sub-endpoint escape).** C1 asserts the bound must live at the L^∞/BMO
endpoint, where CZ fails = BKM. But CZ is bounded on `Lᵖ` (finite p) and on critical
Besov/Triebel–Lizorkin/Lorentz spaces; Kozono–Taniuchi already refine BKM with `BMO`/`Ḃ⁰_{∞,∞}`. Can
the coercive critical bound be closed in a critical *Besov* norm (`Ḃ⁰_{∞,1}`, or `Ḣ^{1/2}`/`L³`) where
CZ is bounded and the L^∞ log-endpoint is never invoked? If so, C1 is false.

**Q2 (null-structure / cancellation escape).** `|S|²−½|ω|² = tr((∇u)²)` under `div u=0` is not generic.
Does a null-form / cancellation argument let the pressure contribution be controlled *below* critical,
escaping C1? Strongest candidate, or argue none survives at σ=0.

**Q3 (CKN ε-regularity generates the smallness — does it escape C2?).** CKN gives smallness on cylinders
with scaled local energy `< ε`. Does the LP-local scheme inherit it, legitimizing the maximal-function
absorption — or does the smallness fail *precisely on the singular set* (local energy not small), so CKN
relocates the gap to NS-006's ≤1-D set rather than closing it?

**Q4 (over-reach / scope / "is NS-047 even a result?").** Is C3 honestly scoped, or does it read as
ruling out *all* harmonic-analytic routes? Is calling this a new obstruction (NS-047) real content, or a
restatement that "NS-046 is hard / pressure is nonlocal"? Flag over-claim. (Prior: three over-reaches
this session.)

## Naive core witness — ChatGPT (cold read; do NOT refute or endorse)

(N1) real insight or relabeling of "NS-046 is hard"? (N2) where does it move too fast (C1's endpoint? C2's
smallness?) (N3) first objection before thinking hard. (N4) would you naively believe the LP route
"doesn't escape," or does it feel like the author *wants* it not to escape?
