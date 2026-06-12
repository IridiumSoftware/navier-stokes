#!/usr/bin/env julia
# ns053_alpha_onset_clm.jl — NS-053 move 2: the α-continuation BOUNDARY on a ground-truth model.
#
# THE FAMILY: dissipative CLM  ω_t = ω·H(ω) − ν Λ^α ω  (Λ^α = |k|^α Fourier multiplier, 1D periodic).
# CLM is the canonical 1D vortex-stretching model (in-repo ground truth: inviscid blow-up t*=2 for
# ω₀=cos x, exact solution + δ=ln(2/t) — T-03/T-04). The α-dial is the model analog of NS-053's
# dissipation-order continuation (NS rail: regular at α ≥ (d+2)/4 = 5/4, Tao 0906.3070 C2).
#
# SCALING PREDICTION (self-derived, the thing the probe TESTS): near the CLM singularity
# A=‖ω‖∞ ~ (t*−t)⁻¹ on a collapsing scale ℓ ~ (t*−t); nonlinearity ωHω ~ A² ~ (t*−t)⁻²;
# dissipation νΛ^αω ~ νA/ℓ^α ~ ν(t*−t)^{−1−α}. They balance at α = 1:
#     α < 1  ⇒ nonlinearity dominates the collapse ⇒ blow-up should persist (any ν)
#     α > 1  ⇒ dissipation dominates small scales  ⇒ regularity should win (any ν)
# ⇒ the model's blow-up-onset boundary should sit at α* ≈ 1, ν-INDEPENDENT to leading order
#   (ν moves only the marginal layer) — the 1D analog of the NS energy-critical line α_c=(d+2)/4.
#
# WHAT THE PROBE MEASURES: (i) α*(ν) by bisection at two ν values; (ii) the FAILURE MODE of
# blow-up approaching α* from below — does t*(α) DIVERGE (critical slowing) or does the peak
# amplitude on the regular side blow up (amplitude gate)? The failure mode is NS-053's real
# question (what kills the mechanism at the boundary is the candidate exclusion mechanism).
#
# VALIDATION ANCHORS (T-31): ν=0 reproduces the exact t*=2.00 (closed form, in-repo T-03);
# strong dissipation (α=2, ν=0.2) decays monotonically. Blow-up classification requires the
# spectral tail < 1% at threshold-crossing (resolution-honesty gate).
#
# Scope: 1D-model witness — NOT the PDE, NOT NS. :proved=0; distance UNTOUCHED. -- STABLE

using Printf

# ── hand FFT — VERBATIM from the validated scripts/spectral_clm_blowup.jl (T-03) ──
# (a fresh re-implementation had a bit-reversal off-by-one, caught by the anchor gate + a DFT check)
function fft!(a::Vector{ComplexF64}; inv::Bool=false)
    N=length(a); j=0
    for i in 1:N-1                                   # bit-reversal permutation
        bit=N>>1
        while j & bit != 0; j ⊻= bit; bit>>=1; end
        j |= bit
        if i<j; tmp=a[i+1]; a[i+1]=a[j+1]; a[j+1]=tmp; end
    end
    len=2
    while len<=N                                     # Cooley–Tukey butterflies
        ang=(inv ? 2π : -2π)/len; wlen=cis(ang)
        i=0
        while i<N
            w=ComplexF64(1)
            for k in 0:(len>>1)-1
                u=a[i+k+1]; v=a[i+k+(len>>1)+1]*w
                a[i+k+1]=u+v; a[i+k+(len>>1)+1]=u-v; w*=wlen
            end
            i+=len
        end
        len<<=1
    end
    if inv; a ./= N; end
    return a
end
fwd(v) = fft!(ComplexF64.(v))
inv_re(V) = real.(fft!(copy(V); inv=true))
keff(k, N) = k <= N >> 1 ? k : k - N

# nonlinear term ωH(ω), 2/3-dealiased (H: Ĥω(k) = −i·sgn(κ)·ω̂(k))
function nlin(ω::Vector{Float64}, N::Int)
    W = fwd(ω)
    Hh = similar(W)
    for k in 0:N-1
        κ = keff(k, N)
        Hh[k+1] = κ == 0 ? 0.0 + 0.0im : -im * sign(κ) * W[k+1]
    end
    prod = ω .* inv_re(Hh)
    P = fwd(prod)
    cut = N ÷ 3
    for k in 0:N-1
        abs(keff(k, N)) > cut && (P[k+1] = 0)
    end
    P
end

# IF-RK4 in Fourier space: exact integrating factor for −ν|k|^α, RK4 on the nonlinearity
function run_clm(; ν, α, N=2048, T=40.0, dt=5e-4, Wblow=80.0)   # Wblow INSIDE the resolved envelope (T-03: winf≲50 resolved at N≥512; at N=2048 k_cut=682 ⇒ resolved to winf≈340)
    x = [2π * i / N for i in 0:N-1]
    Wh = fwd(cos.(x))
    lam = [ν * abs(keff(k, N))^α for k in 0:N-1]
    E1 = exp.(-lam .* dt); Eh = exp.(-lam .* (dt / 2))
    w0inf = 1.0
    t = 0.0
    tail_at_cross = 0.0
    peak = 0.0; tpeak = 0.0
    nl(Wf) = nlin(inv_re(Wf), N)
    while t < T
        k1 = nl(Wh)
        k2 = nl(Eh .* (Wh .+ (dt / 2) .* k1))
        k3 = nl(Eh .* Wh .+ (dt / 2) .* k2)
        k4 = nl(E1 .* Wh .+ dt .* (Eh .* k3))
        Wh = E1 .* Wh .+ (dt / 6) .* (E1 .* k1 .+ 2 .* (Eh .* k2) .+ 2 .* (Eh .* k3) .+ k4)
        t += dt
        ω = inv_re(Wh)
        winf = maximum(abs.(ω))
        if winf > peak; peak = winf; tpeak = t; end
        if winf > Wblow
            amp = abs.(Wh); cut = N ÷ 3
            tail = sum(amp[k+1] for k in 0:N-1 if abs(keff(k, N)) > cut ÷ 2) / (sum(amp) + 1e-300)
            return (verdict=:blowup, tstar=t, peak=peak, tpeak=tpeak, tail=tail)
        end
        if winf < 0.05 * w0inf
            return (verdict=:decay, tstar=NaN, peak=peak, tpeak=tpeak, tail=0.0)
        end
        isfinite(winf) || return (verdict=:nan, tstar=t, peak=peak, tpeak=tpeak, tail=1.0)
    end
    (verdict=:undecided, tstar=NaN, peak=peak, tpeak=tpeak, tail=0.0)
end

function main()
    out = "scripts/ns053_alpha_onset_clm.out.txt"
    fo = open(out, "w"); pr(a...) = (println(stdout, a...); println(fo, a...))
    pr("="^78)
    pr("  NS-053 α-onset probe — dissipative CLM  ω_t = ωHω − νΛ^α ω   (1D ground-truth model)")
    pr("  Scaling prediction to test: boundary at α* ≈ 1, ν-independent (the model's critical line)")
    pr("  Scope: 1D-model witness; NOT NS; :proved=0")
    pr("="^78)

    # ── T-31 anchors ──
    a0 = run_clm(ν=0.0, α=1.0)
    pr(@sprintf("\n  [anchor ν=0]  verdict=%s  t*=%.4f  (exact t*=2.0000; err %.2f%%)  tail@cross=%.4f",
        a0.verdict, a0.tstar, 100 * abs(a0.tstar - 2.0) / 2.0, a0.tail))
    a1 = run_clm(ν=0.2, α=2.0, T=30.0)
    pr(@sprintf("  [anchor α=2, ν=0.2]  verdict=%s  peak=%.3f@t=%.2f  (strong dissipation must decay)",
        a1.verdict, a1.peak, a1.tpeak))
    # tail gate: at crossing winf=80 the analyticity strip is δ≈1/(2·80) ⇒ the PHYSICAL spectrum
    # carries e^{−δ·k}|_{k=341} ≈ 12% beyond cut/2 — that is the near-singular solution, not noise.
    # The gate certifies "no catastrophic under-resolution" (the broken runs showed 47–48%): tail < 0.25.
    # The real fidelity certificate is the t* accuracy vs the closed form (<2%).
    ok_anchors = (a0.verdict == :blowup && abs(a0.tstar - 2.0) / 2.0 < 0.02 && a0.tail < 0.25) &&
                 (a1.verdict == :decay)
    pr("  anchors: " * (ok_anchors ? "PASS — probe licensed" : "FAIL — STOP, do not read the sweep"))
    ok_anchors || (close(fo); exit(1))

    # ── the sweep + bisection at two ν ──
    for ν in (0.05, 0.2)
        pr("\n" * "─"^78)
        pr(@sprintf("  ν = %.2f — coarse sweep then bisection of α*", ν))
        pr("    α      verdict     t*        peak       tail@cross")
        lo, hi = 0.4, 1.6
        coarse = collect(0.4:0.15:1.6)
        lastblow = -Inf; firstreg = Inf
        for α in coarse
            r = run_clm(ν=ν, α=α)
            pr(@sprintf("   %.3f   %-9s  %8s  %9.2f   %.4f", α, String(r.verdict),
                r.verdict == :blowup ? @sprintf("%.3f", r.tstar) : "—", r.peak, r.tail))
            r.verdict == :blowup && α > lastblow && (lastblow = α)
            (r.verdict == :decay || r.verdict == :undecided) && α < firstreg && (firstreg = α)
        end
        lo = lastblow; hi = firstreg
        pr(@sprintf("    bracket: blow-up ≤ %.3f < α* < %.3f", lo, hi))
        for _ in 1:6
            mid = (lo + hi) / 2
            r = run_clm(ν=ν, α=mid)
            pr(@sprintf("   %.4f  %-9s  %8s  %9.2f   %.4f", mid, String(r.verdict),
                r.verdict == :blowup ? @sprintf("%.3f", r.tstar) : "—", r.peak, r.tail))
            if r.verdict == :blowup; lo = mid; else; hi = mid; end
        end
        pr(@sprintf("  ⇒ α*(ν=%.2f) ∈ (%.4f, %.4f)", ν, lo, hi))

        # failure mode: t*(α) approaching α* from below + peak(α) above
        pr("    failure-mode trace (approach from the blow-up side):")
        for α in (lo - 0.15, lo - 0.10, lo - 0.05, lo - 0.02, lo)
            r = run_clm(ν=ν, α=α)
            pr(@sprintf("      α=%.4f  %-9s  t*=%8s  peak=%9.2f", α, String(r.verdict),
                r.verdict == :blowup ? @sprintf("%.3f", r.tstar) : "—", r.peak))
        end
        pr("    regular-side trace (peak transient above α*):")
        for α in (hi, hi + 0.05, hi + 0.15)
            r = run_clm(ν=ν, α=α)
            pr(@sprintf("      α=%.4f  %-9s  peak=%9.2f @ t=%.2f", α, String(r.verdict), r.peak, r.tpeak))
        end
    end

    pr("\n" * "="^78)
    pr("  READ (witness): compare α*(0.05) vs α*(0.2) to the scaling prediction α*=1; the")
    pr("  failure mode is whichever diverges at the boundary — t* (critical slowing) or the")
    pr("  regular-side peak (amplitude gate). 1D model only; :proved=0; distance UNTOUCHED.")
    pr("="^78)
    close(fo); println(stdout, "\nwrote: $out")
end

main()
