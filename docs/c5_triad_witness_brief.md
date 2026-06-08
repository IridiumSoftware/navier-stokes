# Adversarial witness brief — C5 pass on two Navier–Stokes results (relay to the triad)

**You are an adversarial referee. Your job is to REFUTE.** Default for every claim below: **NOT
established / try to break it.** This brief is **self-contained** — everything you need is here; do not
assume the authors, or the prior reviewer, are right. Two jobs: **(1) try to DISPROVE the theorems**
(find an error, a gap, a hidden hypothesis, a counterexample) — especially in the deep cores a previous
*same-model* reviewer admitted it could not check; **(2) audit whether anyone has done — and published —
HARD verification** (formal proof-assistant / computer-algebra / rigorous-numerics / machine-checked), as
opposed to *social* verification (peer review + citation). Also (3) check whether the *use* described is
faithful, and (4) say what a same-model reviewer most likely MISSED.

A previous internal (same-model) adversarial pass concluded "both SURVIVED + our use is faithful + no
hard verification exists." **Do not rubber-stamp that. Verify it independently, challenge it, and find
what it missed.**

---

## TARGET A — the `|x₃|^α` axisymmetric regularity criterion

**Result (Wang–Huang–Wei–Yu, arXiv:2205.13893 / JMAA 2023, Thm 1.4).** For 3D axisymmetric Navier–Stokes
(cylindrical `(r,θ,z)`, swirl component `u^θ`, `x₃=z`): an axisymmetric solution with div-free
`u₀∈H²(ℝ³)` is smooth on `(0,T]` if the axially-weighted swirl satisfies
`‖|x₃|^α u^θ‖_{L^q_t L^p_x} < ∞` with `2/q+3/p = 1−α`, `0≤α<1/4`, `3/(1−α)<p≤∞`, `2/(1−α)≤q<∞`
(or the endpoint `|x₃|^α u^θ ∈ L^∞_t L^{3/(1−α)}` with small norm).

**Proof structure (as we read it):** a vorticity-energy estimate on `Φ=ω^r/r`, `Γ=ω^θ/r` → bound the
RHS by Hölder + an *anisotropic Hardy–Sobolev inequality* (their Thm 1.2) + fractional Gagliardo–Nirenberg
→ a **Gronwall inequality on `[0,T)`** `d/dt(‖Φ‖²+‖Γ‖²) ≤ C·g(t)·(‖Φ‖²+‖Γ‖²)` whose coefficient is
`L¹` in time *exactly because* `2/q+3/p=1−α` → integrate forward from `t=0`, with the bound depending on
the initial data `(Φ(0),Γ(0))` (seeded by `u₀∈H²`) → a finite-time continuation criterion finishes.

**Our use of it (the only thing we cite it for):** that this proof is **direct-Gronwall-anchored-to-`t=0`**,
hence it does **NOT** transfer to a *bounded ancient* solution (one defined on `(−∞,T]` with NO initial
time and NO `t=0` data) — so the analogous "Liouville" statement for ancient solutions is a genuinely
*different, open* problem, not a corollary.

**Internal-pass findings (verify or refute):** SURVIVED (no error found); the `α<1/4` is a range-choice
not a sharpness ceiling; `u₀∈H²` is a real, load-bearing hypothesis (a *finite-time smoothness criterion*,
not a bare Leray–Hopf result); our "doesn't transfer to ancient" reading is structurally faithful;
verification status = peer-reviewed-only (same-author JMAA 2023; no independent re-proof, no formal/CAP).
The one step it could NOT check: the **fractional-GN step chained with the near-axis identification
`‖∇∂_r(u_r/r)‖_{L²}≈‖∇Γ‖_{L²}`** (imports external lemmas; possible hidden constant blow-up as `α→1/4`).

**ATTACK A:**
- A1. Is there a gap or hidden constant blow-up in the anisotropic Hardy–Sobolev inequality or the
  fractional-GN/near-axis step (the part the internal pass flagged)? Does `α<1/4` actually keep all
  constants finite, or does something degenerate near the axis or near `α=1/4`?
- A2. Is `u₀∈H²` doing more than stated — i.e. is the result *really* a regularity *criterion* (conditional
  on the weighted bound) or does it secretly assume what it proves?
- A3. Is the "does not transfer to ancient solutions" inference correct, or could a compactness/limiting
  argument port it to ancient solutions after all (which would collapse our claimed open problem)?
- A4. Has anyone formalized (Lean/Coq/Isabelle) or independently re-proved this, or the anisotropic
  Hardy–Sobolev inequality? Any errata?

---

## TARGET B — the Type-II / quantitative-regularity blowup-rate lower bounds

**Results.** (i) **Tao 2019 (arXiv:1908.04958, Thm 1.4):** if a classical 3D NS solution blows up at finite
`T*`, then `limsup_{t→T*} ‖u(t)‖_{L³}/(\log\log\log\frac{1}{T*−t})^c = ∞` — a **triple-logarithm** lower
bound on the critical-`L³` norm. (ii) **Ożański–Palasek 2022 (arXiv:2210.10030, Cor 1.2):** for
*axisymmetric* solutions, the sharper `(\log\log\frac{1}{T*−t})^c` — a **double-log** lower bound on the
weak-`L³` (`L^{3,∞}`) norm.

**Proof structure (as we read it):** Tao: a quantitative regularity estimate
`‖u‖_{L³}≤A ⇒ |∇^j u| ≤ exp\,exp\,exp(A^{O(1)})·t^{−(j+1)/2}`, via **Carleman inequalities** (backward
uniqueness + unique continuation) + Bourgain energy-pigeonholing + locating many disjoint scales; invert
the triple-exponential to a triple-log rate. Palasek: replaces the Carleman step with a swirl/parabolic
(Nazarov–Ural'tseva Harnack) argument, giving a double-exponential → double-log, axisymmetric-only.

**Our use of it:** (i) these are **partial Type-II exclusion** — blowup-rate *lower* bounds (the critical
norm must diverge *at least* this fast), NOT exclusion; (ii) the gap to *full* Type-II exclusion is
**qualitative** — the bounds "diverge arbitrarily slowly" (iterated-log), and excluding blowup would mean
forcing the rate *faster than the equation permits*, which no result does.

**Internal-pass findings (verify or refute):** SURVIVED; Tao's three logs are *all* load-bearing
(consistency check: in `d≥4` you lose Leray's regularity epochs and gain *exactly one more* exponential →
quadruple-log, as predicted); genuine lower bound (a higher true rate wouldn't weaken it); Palasek is
genuinely double-log / plain-weak-`L³` / axisymmetric-only; our "partial exclusion, qualitative gap"
reading is exact; verification = peer-reviewed (strong venues) + a *partial independent cross-check of the
slow-divergence PHENOMENON* (Palasek's distinct method), but NOT of Tao's exact constant, and NO
formal/CAP verification. The steps it could NOT check: **Tao's Carleman inequalities (Props 4.2/4.3), the
pigeonholing constants, and Palasek's Hölder-exponent step.**

**ATTACK B:**
- B1. Is the triple-log genuinely the *proven* lower bound, or is "diverges arbitrarily slowly" an
  overstatement (does any result get a power/near-power rate, or actually *exclude* Type-II, anywhere —
  e.g. for axisymmetric or under extra hypotheses — which would mean we UNDERSTATED the exclusion)?
- B2. Conversely, is the bound vacuous/weaker than claimed — any error in the Carleman→rate inversion, the
  `exp↔log` bookkeeping, or the scale-counting?
- B3. Is our "the gap is qualitative, not a constant" framing correct, or is there a path from these rate
  bounds to actual exclusion that we're missing?
- B4. Has anyone formalized or computer-verified any of this (Carleman estimates, the rate bounds)? Any
  errata? Is Palasek a true independent check of Tao, or does it inherit Tao's framework?

---

## What to return (each witness, from your seat)

For **A1–A4** and **B1–B4**: a verdict {REFUTED / NOT-ESTABLISHED / SURVIVES-MY-ATTACK} with the specific
error/gap/counterexample or, if you can't break it, the single step you'd most want checked. Then: **(a)
the hard-verification status as you find it** (does any formal/machine/CAP verification exist? — independent
of our claim); **(b) is our *use* faithful?**; **(c) what did the same-model internal pass most likely
MISS?** Flag any place a step, if correct, would resolve the Clay problem (⇒ it's wrong). Be a hostile
referee; "looks fine" is not a verdict — either break it or name the irreducible black box.
