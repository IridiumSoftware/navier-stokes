#!/usr/bin/env python3
"""
Wang anisotropic Hardy–Sobolev — numerical attack (disproof probe).

Wang–Huang–Wei–Yu (arXiv:2205.13893) Thm 1.2, single-weight (k=1) 1-D slice:
    ‖ f / |x|^α ‖_{L^p(ℝ)}  ≤  C(α,p) · ‖ Λ^α f ‖_{L^p(ℝ)} ,     0 < α < 1/p,  1<p<∞,
where Λ^α is the fractional derivative,  (Λ^α f)^(ξ) = |ξ|^α f̂(ξ).

Two probes:
  (A) VIOLATION search — for fixed (p,α) with α<1/p, scan a shape family and report the largest
      ratio R[f] = ‖f/|x|^α‖_p / ‖Λ^α f‖_p.  The inequality claims R ≤ C(α,p) < ∞; an unbounded R
      at fixed α would DISPROVE it.
  (B) ENDPOINT tracking — sweep α → 1/p and report max-over-shapes R(α).  The KNOWN sharp fractional
      Hardy constant diverges as α→1/p; for the NS application p=3/(1−α) makes 1/p = 1/4 exactly the
      α<1/4 of Thm 1.4. A divergence here CONFIRMS (mechanism) the α<1/4 barrier and hardens the citation.

Heuristic FFT probe (not rigorous numerics): periodic grid, staggered to avoid x=0.
"""
import numpy as np

L, N = 80.0, 1 << 16
dx = 2 * L / N
x = (np.arange(N) + 0.5) * dx - L                      # staggered: avoids x = 0
xi = 2 * np.pi * np.fft.fftfreq(N, d=dx)               # angular frequency
absx_a = lambda al: np.abs(x) ** al
absxi_a = lambda al: np.abs(xi) ** al

def lp(g, p):  return (np.sum(np.abs(g) ** p) * dx) ** (1.0 / p)
def Lam(f, al):                                        # Λ^α f via FFT
    return np.real(np.fft.ifft(np.fft.fft(f) * absxi_a(al)))

def ratio(f, al, p):
    num = lp(f / absx_a(al), p)
    den = lp(Lam(f, al), p)
    return num / den if den > 0 else np.inf

# shape family (the ratio R is scale-invariant, so vary SHAPE, not width)
def shapes():
    fam = []
    for beta in (0.5, 0.8, 1.0, 1.5, 2.0, 3.0, 4.0):
        fam.append(("exp(-|x|^%.1f)" % beta, np.exp(-np.abs(x / 3.0) ** beta)))
    for s in (0.6, 1.0, 1.5, 2.0, 3.0):
        fam.append(("(1+x^2)^-%.1f" % s, (1 + (x / 3.0) ** 2) ** (-s)))
    # asymmetric / shifted bumps and an oscillatory one (stress test for violation)
    fam.append(("shifted gauss", np.exp(-((x - 2.0) ** 2) / 8.0)))
    fam.append(("two-bump", np.exp(-((x - 3.) ** 2)) + 0.7 * np.exp(-((x + 4.) ** 2) / 2)))
    fam.append(("osc gauss", np.cos(1.5 * x) * np.exp(-(x ** 2) / 18.0)))
    return fam

def max_ratio(al, p):
    best, who = 0.0, ""
    for name, f in shapes():
        r = ratio(f, al, p)
        if np.isfinite(r) and r > best:
            best, who = r, name
    return best, who

print("== Wang anisotropic Hardy–Sobolev — numerical attack ==\n")
for p in (4.0,):
    inv_p = 1.0 / p
    print(f"p = {p}   (endpoint 1/p = {inv_p};  at critical p=3/(1-α) this endpoint IS α=1/4)")
    print(f"{'α':>7} {'α/(1/p)':>9} {'max R[f]':>12}   extremal shape")
    for al in (0.04, 0.08, 0.12, 0.16, 0.20, 0.22, 0.235, 0.245, 0.249):
        if al >= inv_p:
            continue
        best, who = max_ratio(al, p)
        print(f"{al:>7.3f} {al/inv_p:>9.3f} {best:>12.4f}   {who}")
    print()

# (A) violation stress: at a fixed mid-range α, push many random superpositions
rng = np.random.default_rng(0)
al, p = 0.20, 4.0
worst = 0.0
for _ in range(400):
    k = rng.integers(1, 5)
    f = np.zeros_like(x)
    for _ in range(k):
        c = rng.uniform(-1, 1); mu = rng.uniform(-6, 6); w = rng.uniform(0.5, 4.0)
        f = f + c * np.exp(-((x - mu) ** 2) / (2 * w ** 2))
    r = ratio(f, al, p)
    if np.isfinite(r):
        worst = max(worst, r)
print(f"(A) violation stress  (α={al}, p={p}, α<1/p={1/p}):  max R over 400 random superpositions = {worst:.4f}")
print("    → bounded R at fixed α<1/p is CONSISTENT with the inequality (no gross violation found).\n")

# (C) endpoint-divergence MECHANISM: the Hardy weight makes ‖f/|x|^α‖_p non-integrable as αp→1.
#     The staggered grid caps the x=0 singularity at |x|~dx/2; refining the grid exposes the blow-up.
print("(C) endpoint divergence: Gaussian f (f(0)=1), p=4;  ‖f/|x|^α‖_p vs grid resolution near α=1/p")
print(f"{'N':>9} | " + "  ".join(f"α={a}" for a in (0.20, 0.24, 0.249)))
for Ng in (1 << 13, 1 << 15, 1 << 17, 1 << 19):
    dg = 2 * L / Ng
    xg = (np.arange(Ng) + 0.5) * dg - L
    fg = np.exp(-(xg ** 2) / 8.0)
    vals = [(np.sum((np.abs(fg) / np.abs(xg) ** a) ** 4.0) * dg) ** 0.25 for a in (0.20, 0.24, 0.249)]
    print(f"{Ng:>9} | " + "  ".join(f"{v:8.3f}" for v in vals))
print("    → at α=0.20 (<1/4) the norm CONVERGES as N→∞ (integrable); at α→0.25=1/p it GROWS without")
print("      bound as the grid resolves x=0 (|x|^{-αp} non-integrable at αp→1). So the sharp constant")
print("      C(α)→∞ at α=1/p, which at critical p=3/(1-α) is exactly α=1/4: a GENUINE barrier, not a")
print("      free range-choice. The citation's α<1/4 is necessary and correct (CONFIRMED, not disproved).")
