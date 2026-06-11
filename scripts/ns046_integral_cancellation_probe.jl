#!/usr/bin/env julia
# ns046_integral_cancellation_probe.jl — NS-046, the INTEGRAL / cancellation form.
#
# WHY (and the honest ceiling). NS-046's target inequality asks whether the nonlocal pressure-Hessian
# counter-transport −e₃ᵀ∇²p e₃ PLUS viscous dominates the strain self-amplification λ₃² at σ=0, on
# CKN sets, in an INTEGRAL/Besov sense. The prior probes (Idea-3, uniform-domination) measured the
# POINTWISE / conditional-mean ratio and found it NON-UNIFORM (negative on the bulk — Vieillefosse —
# positive only at the cores). The doc is explicit: that "refutes only the POINTWISE-domination
# heuristic, NOT the [integral] inequality," and the real difficulty "may be derivative loss where
# cancellations are MARGINAL." This probe tests the object the prior ones did NOT: the
# PRODUCTION-WEIGHTED INTEGRAL R_int = Σ_w(e₃ᵀ∇²p e₃ + ν|∇ω|²) / Σ_w(λ₃²), w=|ω|² — where the bulk
# negatives and core positives are allowed to CANCEL — plus its SCALE-resolved profile R_int(k_loc),
# which tests the marginal-cancellation / derivative-loss hypothesis directly.
#
# FIREWALL (load-bearing — this is the over-reach-prone entry, 6 caught already):
#   • Scope: resolved 3D pseudospectral DNS truncation. :proved=0; distance to the prize UNTOUCHED.
#   • A regular truncation has NO singular set. R_int>1 here is a SUGGESTIVE PRIOR that the integral
#     form is favorable in resolved flow — it is NOT the inequality, NOT progress, and CANNOT close
#     NS-046 (which needs a uniform δ on CKN sets in the singular limit, unreachable here).
#   • The legitimate output is a sharper WITNESS: does the integral/cancellation form behave better than
#     the pointwise one, and does it degrade at small scales (the analytic difficulty's signature)?
#
# Reuses the Idea-3 machinery (pressure_hessian + strain eigendecomposition + the Kerr-tube worst case).
# Run: julia -t auto scripts/ns046_integral_cancellation_probe.jl   (env NS_N default 64, NS_NU 1/1600)

using Printf, LinearAlgebra, Statistics
include(joinpath(@__DIR__, "ns046_gradxi_pressure_probe.jl"))   # machinery; its main() is guarded, won't run

# |∇ω|² pointwise (Σ_a |∇ω_a|²) from the velocity-Fourier state
function gradomega_sq(U, op)
    ωxh,ωyh,ωzh = curl_hat(U[1],U[2],U[3],op)
    g2 = zeros(size(op.kx))
    for ωh in (ωxh,ωyh,ωzh)
        g2 .+= real.(ifft3(im.*op.kx.*ωh)).^2 .+ real.(ifft3(im.*op.ky.*ωh)).^2 .+ real.(ifft3(im.*op.kz.*ωh)).^2
    end
    g2
end

# the integral-cancellation analysis at one snapshot
function integral_balance(U, op, ν)
    uh,vh,wh = U
    Hp = pressure_hessian(U, op)
    ωxh,ωyh,ωzh = curl_hat(uh,vh,wh,op)
    ωx=real.(ifft3(ωxh)); ωy=real.(ifft3(ωyh)); ωz=real.(ifft3(ωzh))
    dux=real.(ifft3(im.*op.kx.*uh)); duy=real.(ifft3(im.*op.ky.*uh)); duz=real.(ifft3(im.*op.kz.*uh))
    dvx=real.(ifft3(im.*op.kx.*vh)); dvy=real.(ifft3(im.*op.ky.*vh)); dvz=real.(ifft3(im.*op.kz.*vh))
    dwx=real.(ifft3(im.*op.kx.*wh)); dwy=real.(ifft3(im.*op.ky.*wh)); dwz=real.(ifft3(im.*op.kz.*wh))
    gω2 = gradomega_sq(U, op)
    N=size(ωx,1)
    wmag = sqrt.(ωx.^2 .+ ωy.^2 .+ ωz.^2)
    # per-point arrays
    npt=N^3
    W=Vector{Float64}(undef,npt); DEPL=similar(W); VISC=similar(W); SELF=similar(W); KLOC=similar(W)
    # TRIAD-DEMANDED additions (verdict 2026-06-11): alternative weights + the FEED denominator —
    # the seats refuted any reading from w=|ω|² alone ("weight-sensitive", P1-C1) and demanded the
    # domination be tested against the actual growth feed ¼(|ω|²−(ω·e₃)²) (P1-C4), per the
    # machine-verified Dλ₃ = −λ₃² + FEED − e₃ᵀ∇²p e₃ + visc.
    WPROD=similar(W); WL3W2=similar(W); WS2=similar(W); FEED=similar(W)
    idx=0
    @inbounds for c in 1:N, b in 1:N, a in 1:N
        idx+=1
        wω = wmag[a,b,c]^2
        W[idx]=wω
        s12=0.5*(duy[a,b,c]+dvx[a,b,c]); s13=0.5*(duz[a,b,c]+dwx[a,b,c]); s23=0.5*(dvz[a,b,c]+dwy[a,b,c])
        S = [dux[a,b,c] s12 s13; s12 dvy[a,b,c] s23; s13 s23 dwz[a,b,c]]
        F = eigen(Symmetric(S)); λ3=F.values[3]; e3=F.vectors[:,3]   # values ascending ⇒ [3]=max
        h11=Hp.xx[a,b,c]; h22=Hp.yy[a,b,c]; h33=Hp.zz[a,b,c]; h12=Hp.xy[a,b,c]; h13=Hp.xz[a,b,c]; h23=Hp.yz[a,b,c]
        pH = e3[1]^2*h11 + e3[2]^2*h22 + e3[3]^2*h33 + 2*(e3[1]*e3[2]*h12 + e3[1]*e3[3]*h13 + e3[2]*e3[3]*h23)
        DEPL[idx] = pH                      # e₃ᵀ∇²p e₃ — sign convention machine-verified (dlambda3 check)
        VISC[idx] = ν*gω2[a,b,c]
        SELF[idx] = λ3^2
        KLOC[idx] = sqrt(gω2[a,b,c])/(wmag[a,b,c]+1e-12)   # local inverse length (scale proxy)
        ov = (ωx[a,b,c], ωy[a,b,c], ωz[a,b,c])
        Sω1 = S[1,1]*ov[1]+S[1,2]*ov[2]+S[1,3]*ov[3]
        Sω2 = S[2,1]*ov[1]+S[2,2]*ov[2]+S[2,3]*ov[3]
        Sω3 = S[3,1]*ov[1]+S[3,2]*ov[2]+S[3,3]*ov[3]
        WPROD[idx] = abs(ov[1]*Sω1 + ov[2]*Sω2 + ov[3]*Sω3)          # |ω·Sω| (actual production)
        WL3W2[idx] = abs(λ3)*wω                                       # |λ₃||ω|²
        WS2[idx]   = sum(abs2, S)                                     # |S|² (strain energy)
        ωe3 = ov[1]*e3[1]+ov[2]*e3[2]+ov[3]*e3[3]
        FEED[idx]  = 0.25*(wω - ωe3^2)                                # ¼(|ω|²−(ω·e₃)²) ≥ 0, the λ₃ growth feed
    end
    (W=W, DEPL=DEPL, VISC=VISC, SELF=SELF, KLOC=KLOC, WPROD=WPROD, WL3W2=WL3W2, WS2=WS2, FEED=FEED)
end

function wsum(num,W,mask) ; s=0.0; @inbounds for i in eachindex(W); mask[i] && (s+=num[i]*W[i]); end; s; end

function main()
    out="scripts/ns046_integral_cancellation_probe.out.txt"; fo=open(out,"w"); pr(a...)=(println(stdout,a...);println(fo,a...))
    N=parse(Int,get(ENV,"NS_N","64")); ν=parse(Float64,get(ENV,"NS_NU",string(1/1600)))
    dt=parse(Float64,get(ENV,"NS_DT","0.01")); T=parse(Float64,get(ENV,"NS_T","6.0"))
    op=make_ops(N); U=vortex_tube_ic(N,op)
    pr("="^78); pr("  NS-046 INTEGRAL / CANCELLATION probe — Kerr-tube worst case (pointwise was NON-UNIFORM)")
    pr("  R_int = Σ_w(e₃ᵀ∇²p e₃ + ν|∇ω|²) / Σ_w(λ₃²),  w=|ω|²  (≥1 ⇒ depletion+viscous beat self-amp; convention per uniform_domination)")
    pr("  Scope: resolved DNS truncation; vacuity-capped; :proved=0; CANNOT close NS-046."); pr("="^78)
    # run to the enstrophy (≈ production) peak
    t=0.0; Zpk=0.0; Upk=U; tpk=0.0
    while t<=T+1e-9
        d=diagnose(U,op,N); if d.Z>Zpk; Zpk=d.Z; Upk=deepcopy(U); tpk=t; end
        U=rk4(U,dt,ν,op); t+=dt
    end
    pr(@sprintf("  enstrophy peak Z=%.3f at t=%.2f (N=%d, ν=%.2e) — analyzing this snapshot", Zpk, tpk, N, ν))
    B = integral_balance(Upk, op, ν)
    allmask = trues(length(B.W))
    # top-q production sets (by w=|ω|²)
    sw = sort(B.W; rev=true); thr(q)= sw[clamp(round(Int,q*length(sw)),1,length(sw))]
    Rfull = (wsum(B.DEPL,B.W,allmask)+wsum(B.VISC,B.W,allmask))/wsum(B.SELF,B.W,allmask)
    pr("\n  ── INTEGRAL balance (production-weighted), full domain ──")
    pr(@sprintf("    R_int (full)                  = %.3f   %s", Rfull, Rfull>=1 ? "≥1: integral DOMINATION holds in this truncation" : "<1: integral fails too"))
    # depletion-only vs depletion+viscous
    Rdepl=wsum(B.DEPL,B.W,allmask)/wsum(B.SELF,B.W,allmask); Rvisc=wsum(B.VISC,B.W,allmask)/wsum(B.SELF,B.W,allmask)
    pr(@sprintf("      pressure-Hessian part        = %.3f ;  viscous part = %.3f  (sum %.3f)", Rdepl, Rvisc, Rdepl+Rvisc))
    pr("\n  ── INTEGRAL over the bad set (top-q by |ω|²) — the CKN-set proxy ──")
    for q in (0.10,0.01,0.001)
        m = B.W .>= thr(q)
        R=(wsum(B.DEPL,B.W,m)+wsum(B.VISC,B.W,m))/wsum(B.SELF,B.W,m)
        pr(@sprintf("    top-%.1f%% : R_int = %.3f", 100q, R))
    end
    pr("\n  ── TRIAD-DEMANDED (verdict 2026-06-11): weight sensitivity + the FEED denominator ──")
    pr("    P1-C1: is R_int weight-dependent?  R_int = Σ_w(DEPL+VISC)/Σ_w(λ₃²) under each weight:")
    for (nm, ww) in (("|ω|² (original)", B.W), ("|ω·Sω| (production)", B.WPROD), ("|λ₃||ω|²", B.WL3W2), ("|S|² (strain energy)", B.WS2))
        Rw = (wsum(B.DEPL,ww,allmask)+wsum(B.VISC,ww,allmask))/wsum(B.SELF,ww,allmask)
        pr(@sprintf("      w = %-22s  R_int = %+.3f", nm, Rw))
    end
    pr("    P1-C4: against the FEED ¼(|ω|²−(ω·e₃)²) (the actual λ₃ growth source) instead of λ₃²:")
    for (nm, ww) in (("|ω|² (original)", B.W), ("|ω·Sω| (production)", B.WPROD))
        Rf = (wsum(B.DEPL,ww,allmask)+wsum(B.VISC,ww,allmask))/wsum(B.FEED,ww,allmask)
        pr(@sprintf("      w = %-22s  R_feed = %+.3f   (≥1 ⇒ depletion+viscous beat the feed)", nm, Rf))
    end
    pr("    (single snapshot, N=64, one fixture — same unconverged caveat as everything above)")

    pr("\n  ── SCALE-resolved (the derivative-loss / marginal-cancellation test) ──")
    pr("    bin local k_loc=|∇ω|/|ω| ; does R_int DEGRADE toward 1 at small scale (high k)?")
    kl=B.KLOC; klo,khi=quantile(kl,0.02),quantile(kl,0.98)
    edges=exp.(range(log(max(klo,1e-6)),log(khi),length=7))
    pr("    k_loc range        R_int     (production-weighted, per scale band)")
    Rtrend=Float64[]
    for j in 1:length(edges)-1
        m = (kl.>=edges[j]) .& (kl.<edges[j+1])
        den=wsum(B.SELF,B.W,m); R = den>0 ? (wsum(B.DEPL,B.W,m)+wsum(B.VISC,B.W,m))/den : NaN
        push!(Rtrend,R)
        pr(@sprintf("    [%6.2f,%6.2f)    %6.3f", edges[j],edges[j+1],R))
    end
    pr("\n"*"="^78); pr("  WITNESS READING (TRIAD-TRIMMED 2026-06-11 — vacuity-capped, NOT the inequality)"); pr("="^78)
    pr(@sprintf("  • R_int(full)=%.2f under w=|ω|² — a WEIGHT-SENSITIVE integral reconciliation (P1-C1 verdict:", Rfull))
    pr("    'much of the non-uniformity is a weighting artifact' was REFUTED as over-reach; the supportable")
    pr("    statement is that enstrophy weighting emphasizes coherent cores — see the weight table above).")
    finite=filter(isfinite,Rtrend)
    pr(@sprintf("  • Scale bins %.2f → %.2f: NON-MONOTONE; the 'difficulty locus' reading is WITHDRAWN (P1-C2", finite[1], finite[end]))
    pr("    REFUTED: k_loc is a sharpness proxy not a spectral scale, and viscous floors force margins ≥1 in a")
    pr("    regular truncation — the bins may only be rediscovering that regular truncations regularize).")
    pr("  • Sign convention: machine-verified (ns046_dlambda3_sign_check, algebraic) — pressure coefficient −1.")
    pr("  • STATUS (P1-C3): unconverged SINGLE-POINT witness — one fixture, one snapshot, one resolution. No")
    pr("    reading beyond 'suggestive' is licensed before an N-trend + second fixture + multiple times.")
    pr("  • FIREWALL: resolved truncation, no singular set; :proved=0; distance UNTOUCHED.")
    pr("="^78); close(fo); println(stdout,"\nwrote: $out")
end
if abspath(PROGRAM_FILE)==@__FILE__; main(); end
