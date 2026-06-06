#!/usr/bin/env julia
# ns046_uniform_domination_probe.jl — Idea-3.5 / NS-046 sub-probe (computational, BEFORE any analytic claim).
#
# The would-be NS-046 coercive inequality needs the depletion (nonlocal pressure Hessian + viscosity) to
# dominate the production NOT just on average but UNIFORMLY on the intense-production set — the
# singular-set proxy where, if anywhere, blowup would lurk. NS-047 said the analytic uniformity is the
# gap; Idea-3 showed the GLOBAL (enstrophy-weighted) pressure domination is real in the tube worst case.
# This probe asks the decisive measurable question: CONDITIONED on the top-X% production set, and tracked
# toward the most intense 0.1%, do the depletion ratios stay ≥1 (domination holds uniformly ⇒ the
# inequality COULD hold) or collapse (the gap is real even in the truncation)?
#
# Two ratios, on top-{100,10,1,0.1}% of |ω·Sω| (the production), for helical/control/tubes:
#   Rp = ⟨e₃ᵀ(∇²p)e₃⟩ / ⟨λ₃²⟩   — deformation level: pressure depletion vs strain self-amplification
#                                  (enters as −e₃ᵀ∇²p e₃ ⇒ Rp>0 depletes; Rp≥1 ⇒ pressure beats self-amp)
#   Rv = ⟨ν|∇ω|²⟩ / ⟨ω·Sω⟩       — enstrophy level: viscous dissipation vs production (the classic budget)
#
# Scope: resolved 3D DNS truncation (Re=1600); within-truncation only (vacuity cap — a regular truncation
# cannot reach the singular limit; this tests only whether the domination is uniform AT THESE scales).
# NOT the PDE. :proved=0. Reuses the Idea-3 probe machinery (pressure_hessian etc.).
# Run: julia -t auto scripts/ns046_uniform_domination_probe.jl    Env: NS_N(64) NS_T(6) NS_DT(.01) NS_NU(1/1600) NS_SAMPLE(0.5)

using Printf, Random, LinearAlgebra
include(joinpath(@__DIR__, "ns046_gradxi_pressure_probe.jl"))   # → solver + helical_pair_ic + pressure_hessian (guarded)

# per-point collect (P_loc=ω·Sω, D_p=e₃ᵀ∇²p e₃, λ₃², ν|∇ω|²), then ratios conditioned on top-X% production
function domination_profile(U, op, Hp, ν)
    uh,vh,wh = U
    ωxh,ωyh,ωzh = curl_hat(uh,vh,wh,op)
    ωx=real.(ifft3(ωxh)); ωy=real.(ifft3(ωyh)); ωz=real.(ifft3(ωzh))
    dux=real.(ifft3(im.*op.kx.*uh)); duy=real.(ifft3(im.*op.ky.*uh)); duz=real.(ifft3(im.*op.kz.*uh))
    dvx=real.(ifft3(im.*op.kx.*vh)); dvy=real.(ifft3(im.*op.ky.*vh)); dvz=real.(ifft3(im.*op.kz.*vh))
    dwx=real.(ifft3(im.*op.kx.*wh)); dwy=real.(ifft3(im.*op.ky.*wh)); dwz=real.(ifft3(im.*op.kz.*wh))
    # |∇ω|² (dissipation density ν|∇ω|²): need ∇ of each ω-component
    gw2 = zeros(size(ωx))
    for ωh in (ωxh,ωyh,ωzh)
        gw2 .+= real.(ifft3(im.*op.kx.*ωh)).^2 .+ real.(ifft3(im.*op.ky.*ωh)).^2 .+ real.(ifft3(im.*op.kz.*ωh)).^2
    end
    N=size(ωx,1); st=max(1,N÷96)            # near-full field (st=1 at N≤96) so top-0.1% has enough points
    Ps=Float64[]; Dp=Float64[]; L2=Float64[]; Vs=Float64[]
    @inbounds for c in 1:st:N, b in 1:st:N, a in 1:st:N
        s12=0.5*(duy[a,b,c]+dvx[a,b,c]); s13=0.5*(duz[a,b,c]+dwx[a,b,c]); s23=0.5*(dvz[a,b,c]+dwy[a,b,c])
        S=[dux[a,b,c] s12 s13; s12 dvy[a,b,c] s23; s13 s23 dwz[a,b,c]]
        ox=ωx[a,b,c]; oy=ωy[a,b,c]; oz=ωz[a,b,c]
        Sω=(S*[ox,oy,oz]); Ploc = ox*Sω[1]+oy*Sω[2]+oz*Sω[3]      # ω·Sω
        F=eigen(Symmetric(S)); e3=F.vectors[:,3]; λ3=F.values[3]
        Hm=[Hp.xx[a,b,c] Hp.xy[a,b,c] Hp.xz[a,b,c]; Hp.xy[a,b,c] Hp.yy[a,b,c] Hp.yz[a,b,c]; Hp.xz[a,b,c] Hp.yz[a,b,c] Hp.zz[a,b,c]]
        push!(Ps,Ploc); push!(Dp,e3'*Hm*e3); push!(L2,λ3^2); push!(Vs,ν*gw2[a,b,c])
    end
    ord = sortperm(Ps; rev=true); n=length(ord)
    out = NamedTuple[]
    for fr in (1.0, 0.1, 0.01, 0.001)
        m=max(1, round(Int, fr*n)); idx=@view ord[1:m]
        sumP=sum(@view Ps[idx]); sumDp=sum(@view Dp[idx]); sumL2=sum(@view L2[idx]); sumV=sum(@view Vs[idx])
        Rp = sumL2>1e-30 ? sumDp/sumL2 : 0.0
        Rv = sumP>1e-30 ? sumV/sumP   : 0.0          # dissipation / production on this set
        push!(out, (fr=fr, Rp=Rp, Rv=Rv, RpRv=(sumDp>0 && sumV>0 && sumP>0) ? (sumDp+0.0)/sumL2 : Rp))
    end
    out
end

function run_dom(label, U, N, ν, T, dt, op; sample=0.5)
    @printf("# %s  N=%d  nu=%.5e\n", label, N, ν)
    println("# t    Rp@100% Rp@10%  Rp@1%   Rp@.1%  | Rv@100% Rv@10%  Rv@1%   Rv@.1%   (Rp=pressure/selfamp, Rv=dissip/production)")
    flush(stdout); t=0.0; nexts=0.0
    while t <= T+1e-9
        if t >= nexts-1e-9
            pr=domination_profile(U,op,pressure_hessian(U,op),ν)
            @printf("%.2f  %+7.3f %+7.3f %+7.3f %+7.3f | %7.3f %7.3f %7.3f %7.3f\n",
                t, pr[1].Rp,pr[2].Rp,pr[3].Rp,pr[4].Rp, pr[1].Rv,pr[2].Rv,pr[3].Rv,pr[4].Rv)
            flush(stdout); nexts += sample
        end
        U=rk4(U,dt,ν,op); t+=dt
    end
end

function main()
    N=parse(Int,get(ENV,"NS_N","64")); T=parse(Float64,get(ENV,"NS_T","6.0"))
    dt=parse(Float64,get(ENV,"NS_DT","0.01")); ν=parse(Float64,get(ENV,"NS_NU",string(1/1600)))
    smp=parse(Float64,get(ENV,"NS_SAMPLE","0.5")); op=make_ops(N)
    UH,UC = helical_pair_ic(N,op; kmax=4); UT = vortex_tube_ic(N,op)
    println("# NS-046 uniform-domination sub-probe — does depletion dominate production on the INTENSE set?")
    println("# Rp≥1 ⇒ pressure beats strain self-amplification; Rv≥1 ⇒ dissipation beats production. Watch the @.1% column (most intense).")
    println(); run_dom("HELICAL",UH,N,ν,T,dt,op;sample=smp)
    println(); run_dom("CONTROL",UC,N,ν,T,dt,op;sample=smp)
    println(); run_dom("TUBES",  UT,N,ν,T,dt,op;sample=smp)
    println("# DONE")
end
if abspath(PROGRAM_FILE)==@__FILE__; main(); end
