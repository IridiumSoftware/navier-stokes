#!/usr/bin/env julia
# ns049_anisotropy_defect_probe.jl — does Lockwood's anisotropy defect δ_Λ → 0 along the most intense events?
#
# WHY. The NS-049 verification (docs/ns049_lockwood_verification.md) found Lockwood's "Singularity Surgery"
# program is CONDITIONAL on the weighted anisotropy defect vanishing, δ_Λ→0 (the high-vorticity set becoming
# one-directional), ASSUMED in every theorem, never derived; the multi-directional (δ bounded-below) case is
# unaddressed. THE sharp question to put to him is "what forces δ_Λ→0 along a blow-up?" — probe it internally
# first, with the validated DNS, on the most singular-like resolved event (the Kerr-tube reconnection).
#
# THE OBJECT. Lockwood's defect at threshold Λ over a region:  δ_Λ = 1 − λ_max(M_Λ)/tr(M_Λ),  with the
# high-vorticity second-moment tensor  M_Λ = Σ_{|ω|≥Λ} ω⊗ω  (3×3 symmetric, SIGN-BLIND — anti-parallel
# tubes read as aligned). Eigen-ratios λ_i/tr (sum 1) read the structure: (0,0,1)=one-directional (δ=0),
# (0,½,½)=planar/sheet (δ=½), (⅓,⅓,⅓)=isotropic (δ=⅔). We use an intensity-adaptive "high-vorticity set" =
# the top-q fraction by |ω|, q∈{1,0.1,0.01,0.001} (the cleanest scale-free version of |ω|≥Λ), per time.
#
# THE TEST. Does δ_q → 0 as q→0 (the most intense vorticity) AND at the intensity peak of the reconnection?
#   • δ→0 at high threshold/peak ⇒ the extreme vorticity IS one-directional — SUPPORTS Lockwood's regime.
#   • δ bounded below ⇒ multi-directional even at the cores — the case his machinery does NOT cover, and
#     evidence (with NS-038's intermediate-eigenvector alignment) that his δ→0 regime misses the physics.
#
# HONEST SCOPE. Resolved-ish DNS truncation (Re=1600); REGULAR flow — cannot reach the singular limit r→0
# (vacuity cap), so this tests whether the *physically-realized resolved intense geometry* is one-directional,
# NOT whether δ→0 at a true singularity. A witness for the NS-049 question, not a proof either way. :proved=0.
# Reuses the validated dns_tg256 chain. CHAIN_CONVENTION: n/a. Run: julia -t auto scripts/ns049_anisotropy_defect_probe.jl
# Env: NS_N(64) NS_T(6.0) NS_DT(0.01) NS_NU(1/1600) NS_SAMPLE(0.5)

using Printf, LinearAlgebra
include(joinpath(@__DIR__, "dns_tg256.jl"))   # → solver + diagnose + ICs + ffts + mean3

# anisotropy defect of the top-q-fraction (by |ω|) high-vorticity set: returns (δ, λmid/tr, λmax/tr, |ω|_thr)
function defect_topq(ωx, ωy, ωz, wmag, q)
    v = sort(vec(wmag); rev=true); n = length(v)
    m = max(1, round(Int, q*n)); thr = v[m]
    M = zeros(3,3)
    @inbounds for i in eachindex(wmag)
        wmag[i] >= thr || continue
        o = (ωx[i], ωy[i], ωz[i])
        for a in 1:3, b in 1:3; M[a,b] += o[a]*o[b]; end
    end
    tr = M[1,1]+M[2,2]+M[3,3]
    tr < 1e-30 && return (0.0, 0.0, 1.0, thr)
    λ = sort(eigen(Symmetric(M)).values)         # ascending: λ1≤λ2≤λ3
    (1 - λ[3]/tr, λ[2]/tr, λ[3]/tr, thr)
end

function ω_fields(U, op)
    ωxh,ωyh,ωzh = curl_hat(U[1],U[2],U[3],op)
    ωx=real.(ifft3(ωxh)); ωy=real.(ifft3(ωyh)); ωz=real.(ifft3(ωzh))
    ωx, ωy, ωz, sqrt.(ωx.^2 .+ ωy.^2 .+ ωz.^2)
end

# ── N=1 gate: δ on synthetic one-directional vs isotropic vorticity ──
function smoke()
    println("── SMOKE (N=16): anisotropy-defect δ_Λ sanity ──")
    N=16
    # one-directional: ω = f(x)·e_3  ⇒ M rank-1 ⇒ δ≈0
    z=zeros(N,N,N); a=randn(N,N,N).^2 .+ 0.1
    d1=defect_topq(z, z, a, abs.(a), 1.0)
    @printf("  one-directional (ω∥e₃): δ=%.4f  λmax/tr=%.4f   (expect δ≈0)\n", d1[1], d1[3])
    # isotropic random: ω components iid ⇒ M≈(tr/3)I ⇒ δ≈2/3
    bx=randn(N,N,N); by=randn(N,N,N); bz=randn(N,N,N); bm=sqrt.(bx.^2 .+ by.^2 .+ bz.^2)
    d2=defect_topq(bx,by,bz,bm, 1.0)
    @printf("  isotropic random:        δ=%.4f  λmax/tr=%.4f   (expect δ≈0.67)\n", d2[1], d2[3])
    # planar (sheet): ω in e1-e2 plane ⇒ δ≈1/2
    px=randn(N,N,N); py=randn(N,N,N); pm=sqrt.(px.^2 .+ py.^2)
    d3=defect_topq(px,py,z,pm, 1.0)
    @printf("  planar (sheet, e₁-e₂):   δ=%.4f  λmax/tr=%.4f   (expect δ≈0.5)\n", d3[1], d3[3])
    ok = d1[1]<0.02 && abs(d2[1]-2/3)<0.08 && abs(d3[1]-0.5)<0.08
    println(ok ? "  SMOKE PASS ✓" : "  SMOKE FAIL ✗")
end

function run_flow(label, U, op, N, ν, T, dt, pr; sample=0.5)
    qs = (1.0, 0.1, 0.01, 0.001)
    pr(@sprintf("# %s  N=%d  Re=%.0f", label, N, 1/ν))
    pr("# t      winf      δ@100%   δ@10%    δ@1%     δ@.1%    | structure @.1%: (λmid/tr, λmax/tr)")
    t=0.0; nexts=0.0; peak=(-1.0, 0.0, NamedTuple[])
    while t<=T+1e-9
        if t>=nexts-1e-9
            ωx,ωy,ωz,wmag = ω_fields(U,op); winf=maximum(wmag)
            ds = [defect_topq(ωx,ωy,ωz,wmag,q) for q in qs]
            pr(@sprintf("%.2f   %8.3f  %.4f   %.4f   %.4f   %.4f   | (%.3f, %.3f)",
                t, winf, ds[1][1],ds[2][1],ds[3][1],ds[4][1], ds[4][2],ds[4][3]))
            winf>peak[1] && (peak=(winf, t, ds))
            nexts+=sample
        end
        U=rk4(U,dt,ν,op); t+=dt
    end
    ds=peak[3]
    mind = minimum(d[1] for d in ds)
    pr(@sprintf("# %s PEAK t=%.2f winf=%.2f: δ@{100,10,1,.1%%}=(%.3f,%.3f,%.3f,%.3f)  min-over-q=%.3f  %s",
        label, peak[2], peak[1], ds[1][1],ds[2][1],ds[3][1],ds[4][1], mind,
        mind<0.1 ? "→ one-directional at the cores (SUPPORTS δ→0)" : "→ MULTI-directional even at the cores (δ bounded below)"))
    (peak_t=peak[2], peak_winf=peak[1], peak_defects=[d[1] for d in ds])
end

function main()
    if get(ENV,"SMOKE","")=="1"; smoke(); return; end
    N=parse(Int,get(ENV,"NS_N","64")); T=parse(Float64,get(ENV,"NS_T","6.0"))
    dt=parse(Float64,get(ENV,"NS_DT","0.01")); ν=parse(Float64,get(ENV,"NS_NU",string(1/1600)))
    smp=parse(Float64,get(ENV,"NS_SAMPLE","0.5")); op=make_ops(N)
    out=joinpath(@__DIR__,"ns049_anisotropy_defect_probe$(N==64 ? "" : "_N$(N)").out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...);flush(fout);flush(stdout))
    pr("# NS-049 anisotropy-defect probe — does Lockwood's δ_Λ→0 at the most intense resolved events?")
    pr("# δ_Λ=1−λmax(M)/tr(M), M=Σ_{top-q |ω|}ω⊗ω. δ=0 one-directional, ½ planar/sheet, ⅔ isotropic.")
    pr(@sprintf("# N=%d Re=%.0f T=%.1f  Scope: DNS truncation, REGULAR (vacuity cap); NOT the PDE; :proved=0.", N, 1/ν, T))
    for (lbl,U0) in (("TUBES (Kerr reconnection)", vortex_tube_ic(N,op)),
                     ("TG (H=0)", taylor_green_ic(N,op)),
                     ("HELICAL (H≠0)", random_helical_ic(N,op)))
        pr(""); run_flow(lbl, U0, op, N, ν, T, dt, pr; sample=smp)
    end
    pr("")
    pr("# READ: the question is whether δ_Λ falls toward 0 as the threshold tightens (top-q, q→0) and at the")
    pr("# intensity peak — the regime Lockwood's machinery requires. If δ stays bounded below at the cores,")
    pr("# the multi-directional case his program does NOT cover is the physically-realized one (cf. NS-038's")
    pr("# intermediate-eigenvector alignment). Within-truncation witness for the NS-049 question; :proved=0.")
    pr("# DONE")
    close(fout); println(stdout,"wrote: $out")
end

if abspath(PROGRAM_FILE)==@__FILE__; main(); end
