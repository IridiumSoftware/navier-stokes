#!/usr/bin/env julia
# ns046_gradxi_pressure_probe.jl — Idea-3 (NS-045 stress test / NS-046 diagnostics).
#
# Motivation. The MID + LOW#1 + NS-047 witness passes all converged: the regularity-relevant geometry
# is NOT the scalar strain–vorticity alignment c²_int (which our diagnostics measured) but the
# SMOOTHNESS of the vorticity-direction field ξ = ω/|ω| — the CFM object ∫|∇ξ|²|ω| — and the contest is
# the production vs the NONLOCAL pressure-Hessian counter-transport (NS-046). And the danger lives at
# ~zero helicity + maximal stretching, where the NS-045 Beltramization "safety valve" is weakest.
#
# So this probe measures, on three matched-context flows:
#   helical (ρ_H≈0.97) / control (ρ_H≈0.05)  [the NS-045 matched-spectrum pair]
#   tubes   (anti-parallel Kerr tubes, ρ_H≈0, MAXIMAL initial stretching — the weakest-Beltram regime)
# the genuinely new diagnostics:
#   • CFM  = ⟨|∇ξ|² |ω|⟩            (vortex-direction smoothness; the object the scalars are blind to)
#   • gx2w = enstrophy-weighted ⟨|∇ξ|²⟩
#   • pHess = enstrophy-weighted ⟨e₃ᵀ(∇²p)e₃⟩   (pressure on the MAX-stretch strain eigenvalue; <0 ⇒ the
#             nonlocal pressure DEPLETES stretching — the "counter-transport" of NS-046)
#   • selfstr = enstrophy-weighted ⟨λ₃²⟩         (local self-amplification it fights)
# alongside the NS-045 set (E,Z,H,ρ_H,P,S_ω,c²_int,Beltramization).
#
# Pressure: −Δp = ∂_iu_j ∂_ju_i = tr(G²) (G_{ij}=∂_j u_i), solved in Fourier (p̂ = Q̂/|k|²); Hessian
# (∇²p)_{ab} = −k_ak_b p̂. CFM: ξ=ω/max(|ω|,ε) guarded; ∇ξ via spectral derivatives.
#
# Scope: resolved 3D pseudospectral DNS truncation (Re=1600). NOT the PDE; within-truncation diagnostics
# only (the LOW#1 vacuity cap stands — a regular truncation cannot reach the singular limit). :proved=0.
#
# Reuses the NS-045 IC builder + the validated solver. Run: julia -t auto scripts/ns046_gradxi_pressure_probe.jl
# Env: NS_N (default 64), NS_T (6.0), NS_DT (0.01), NS_NU (1/1600), NS_SAMPLE (0.5).

using Printf, Random, LinearAlgebra
include(joinpath(@__DIR__, "ns045_helicity_mechanism.jl"))   # → solver + helical_pair_ic + field_diag (guarded)

# pressure Hessian (6 symmetric components, physical space) from the velocity-Fourier state
function pressure_hessian(U, op)
    uh,vh,wh = U
    dux=real.(ifft3(im.*op.kx.*uh)); duy=real.(ifft3(im.*op.ky.*uh)); duz=real.(ifft3(im.*op.kz.*uh))
    dvx=real.(ifft3(im.*op.kx.*vh)); dvy=real.(ifft3(im.*op.ky.*vh)); dvz=real.(ifft3(im.*op.kz.*vh))
    dwx=real.(ifft3(im.*op.kx.*wh)); dwy=real.(ifft3(im.*op.ky.*wh)); dwz=real.(ifft3(im.*op.kz.*wh))
    # Q = tr(G²) = ∂_iu_j ∂_ju_i ,  −Δp = Q  ⇒  p̂ = Q̂/|k|²
    Q = dux.^2 .+ dvy.^2 .+ dwz.^2 .+ 2 .*(duy.*dvx .+ duz.*dwx .+ dvz.*dwy)
    ph = fft3(Q) ./ op.k2p
    H(a,b) = real.(ifft3(.-a .* b .* ph))
    (xx=H(op.kx,op.kx), yy=H(op.ky,op.ky), zz=H(op.kz,op.kz),
     xy=H(op.kx,op.ky), xz=H(op.kx,op.kz), yz=H(op.ky,op.kz))
end

# CFM vortex-direction smoothness: ξ=ω/|ω| guarded, ∇ξ spectral. Returns ⟨|∇ξ|²|ω|⟩ and weighted ⟨|∇ξ|²⟩.
function gradxi(U, op)
    ωxh,ωyh,ωzh = curl_hat(U[1],U[2],U[3],op)
    ωx=real.(ifft3(ωxh)); ωy=real.(ifft3(ωyh)); ωz=real.(ifft3(ωzh))
    wmag = sqrt.(ωx.^2 .+ ωy.^2 .+ ωz.^2) .+ 1e-12
    ξx=ωx./wmag; ξy=ωy./wmag; ξz=ωz./wmag
    g2 = zeros(size(ωx))
    for ξh in (fft3(ξx), fft3(ξy), fft3(ξz))                  # Σ_a |∇ξ_a|²
        g2 .+= real.(ifft3(im.*op.kx.*ξh)).^2 .+ real.(ifft3(im.*op.ky.*ξh)).^2 .+ real.(ifft3(im.*op.kz.*ξh)).^2
    end
    (cfm = mean3(g2 .* wmag), gx2w = mean3(g2 .* (wmag.^2)) / mean3(wmag.^2))
end

# enstrophy-weighted pressure-Hessian projection on the max-stretch eigenvector + ⟨λ₃²⟩ (subsampled eigen)
function pressure_eigen(U, op, Hp)
    uh,vh,wh = U
    ωxh,ωyh,ωzh = curl_hat(uh,vh,wh,op)
    ωx=real.(ifft3(ωxh)); ωy=real.(ifft3(ωyh)); ωz=real.(ifft3(ωzh))
    dux=real.(ifft3(im.*op.kx.*uh)); duy=real.(ifft3(im.*op.ky.*uh)); duz=real.(ifft3(im.*op.kz.*uh))
    dvx=real.(ifft3(im.*op.kx.*vh)); dvy=real.(ifft3(im.*op.ky.*vh)); dvz=real.(ifft3(im.*op.kz.*vh))
    dwx=real.(ifft3(im.*op.kx.*wh)); dwy=real.(ifft3(im.*op.ky.*wh)); dwz=real.(ifft3(im.*op.kz.*wh))
    N=size(ωx,1); st=max(1,N÷64); wph=0.0; wls=0.0; wsum=0.0
    @inbounds for c in 1:st:N, b in 1:st:N, a in 1:st:N
        wω=ωx[a,b,c]^2+ωy[a,b,c]^2+ωz[a,b,c]^2; wω<1e-30 && continue
        s12=0.5*(duy[a,b,c]+dvx[a,b,c]); s13=0.5*(duz[a,b,c]+dwx[a,b,c]); s23=0.5*(dvz[a,b,c]+dwy[a,b,c])
        S=[dux[a,b,c] s12 s13; s12 dvy[a,b,c] s23; s13 s23 dwz[a,b,c]]
        F=eigen(Symmetric(S)); e3=F.vectors[:,3]; λ3=F.values[3]
        Hm=[Hp.xx[a,b,c] Hp.xy[a,b,c] Hp.xz[a,b,c]; Hp.xy[a,b,c] Hp.yy[a,b,c] Hp.yz[a,b,c]; Hp.xz[a,b,c] Hp.yz[a,b,c] Hp.zz[a,b,c]]
        wph += wω*(e3'*Hm*e3); wls += wω*λ3^2; wsum += wω
    end
    (pHess = wph/wsum, selfstr = wls/wsum)
end

function run_probe(label, U, N, ν, T, dt, op; sample=0.5)
    @printf("# %s  N=%d  nu=%.5e  T=%.1f\n", label, N, ν, T)
    println("# t      E         Z          rhoH    P           Sw       c2int  belt    CFM         gx2w    pHess       selfstr     ratio")
    flush(stdout); t=0.0; nexts=0.0
    while t <= T+1e-9
        if t >= nexts-1e-9
            d=diagnose(U,op,N); fd=field_diag(U,op); bl=beltram(U,op)
            gx=gradxi(U,op); pe=pressure_eigen(U,op,pressure_hessian(U,op))
            rhoH=d.H/(2*sqrt(max(d.E*d.Z,1e-30))); P=mean3(fd.Pd)
            ratio = pe.selfstr>1e-30 ? pe.pHess/pe.selfstr : 0.0   # pressure term relative to self-stretch
            @printf("%.3f  %.4e  %.4e  %+.4f  %+.4e  %+.5f  %.4f  %.4f  %.4e  %.4f  %+.4e  %.4e  %+.4f\n",
                    t, d.E, d.Z, rhoH, P, fd.Sw, fd.cos2int, bl.cos2, gx.cfm, gx.gx2w, pe.pHess, pe.selfstr, ratio)
            flush(stdout); nexts += sample
        end
        U=rk4(U,dt,ν,op); t+=dt
    end
end

function main()
    N=parse(Int,get(ENV,"NS_N","64")); T=parse(Float64,get(ENV,"NS_T","6.0"))
    dt=parse(Float64,get(ENV,"NS_DT","0.01")); ν=parse(Float64,get(ENV,"NS_NU",string(1/1600)))
    smp=parse(Float64,get(ENV,"NS_SAMPLE","0.5")); op=make_ops(N)
    UH,UC = helical_pair_ic(N,op; kmax=4)
    UT = vortex_tube_ic(N,op)                                   # anti-parallel tubes (rho_H~0, max stretch)
    dT=diagnose(UT,op,N)
    println("# NS-046/Idea-3 grad-xi + pressure-Hessian probe — helical/control/tubes")
    @printf("# tubes IC: E=%.4f Z=%.4f H=%+.4e rhoH=%+.4f divmax=%.1e (anti-parallel, max-stretch, ~zero helicity)\n",
            dT.E,dT.Z,dT.H, dT.H/(2*sqrt(dT.E*dT.Z)), dT.divmax)
    println(); run_probe("HELICAL", UH, N,ν,T,dt,op; sample=smp)
    println(); run_probe("CONTROL", UC, N,ν,T,dt,op; sample=smp)
    println(); run_probe("TUBES",   UT, N,ν,T,dt,op; sample=smp)
    println("# DONE")
end
if abspath(PROGRAM_FILE)==@__FILE__; main(); end
