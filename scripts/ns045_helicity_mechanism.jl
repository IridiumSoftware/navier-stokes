#!/usr/bin/env julia
# ns045_helicity_mechanism.jl — NS-045: HOW does helicity deplete vortex stretching (NS-040)?
#
# NS-040 established (matched-spectrum pair) that strong helicity depletes stretching. NS-045 audits
# the MECHANISM. Candidates: (a) reduced ω–S alignment; (b) increased Beltramization (u∥ω ⇒ the Lamb
# vector u×ω, which DRIVES the nonlinearity, is suppressed); (c) modified helical-sector transfers;
# (d) delayed flux. This script tests (a) and (b) directly from the fields, with the global controls
# P(t), S_ω(t), ρ_H(t), and the ± helical energy split (a basic sector diagnostic).
#
# Matched-spectrum pair, built in the Craya–Herring ± helical basis h±(k) (curl eigenvectors,
# ik×h±=±|k|h±): each independent mode gets a random complex amplitude A(k) placed on
#   helical : h₊ for EVERY mode      ⇒ ρ_H≈1 (maximally helical),
#   control : h₊ or h₋ at random      ⇒ ρ_H≈0,  SAME |û(k)| per mode ⇒ IDENTICAL E(k) and Z₀.
# Reality enforced by û(−k)=conj(û(k)). Both rescaled to the SAME E₀ ⇒ E₀ and Z₀ matched by construction.
#
# Mechanism read: compare the helical-vs-control divergence of (a) c²_int and (b) cos²(u,ω)/the
# Lamb-vector magnitude against the P(t)/Z(t) depletion — whichever co-moves is the mechanism.
#
# Scope: resolved 3D pseudospectral DNS truncation (Re=1600). NOT the 3D-NS PDE. Per the LOW#1 lesson
# this certifies the WITHIN-TRUNCATION mechanism only; it cannot inform the singular limit. :proved=0.
#
# Reuses the validated solver (rk4/rhs/curl_hat/diagnose) + field_diag (Sw/Pd/cos2int) from dns_tg256.jl.
# Run:  julia -t auto scripts/ns045_helicity_mechanism.jl
# Env:  NS_N (default 64), NS_T (6.0), NS_DT (0.01), NS_NU (1/1600), NS_SAMPLE (0.5), NS_KMAX (4), NS_SEED.

using Printf, Random, LinearAlgebra
include(joinpath(@__DIR__, "dns_tg256.jl"))   # → solver (spectral_3d_control.jl) + field_diag + fft3

cross3(a,b) = (a[2]*b[3]-a[3]*b[2], a[3]*b[1]-a[1]*b[3], a[1]*b[2]-a[2]*b[1])

# Craya–Herring ± helical unit vectors at wavevector k (curl eigenvectors).
function hbasis(kx,ky,kz)
    km = sqrt(kx^2+ky^2+kz^2)
    khat = (kx/km, ky/km, kz/km)
    ref = abs(khat[3]) < 0.9 ? (0.0,0.0,1.0) : (1.0,0.0,0.0)
    e1 = cross3(ref, khat); n1 = sqrt(e1[1]^2+e1[2]^2+e1[3]^2); e1 = e1 ./ n1
    e2 = cross3(khat, e1)                              # unit, ⊥ k and e1
    hp = ((e1[1]+im*e2[1])/sqrt(2), (e1[2]+im*e2[2])/sqrt(2), (e1[3]+im*e2[3])/sqrt(2))
    hm = ((e1[1]-im*e2[1])/sqrt(2), (e1[2]-im*e2[2])/sqrt(2), (e1[3]-im*e2[3])/sqrt(2))
    (hp, hm)
end

# Matched-spectrum helical/control pair (see header). Returns (U_helical, U_control), both at E₀.
function helical_pair_ic(N, op; kmax=4, seed=20260605, E0=0.125)
    Random.seed!(seed)
    z() = zeros(ComplexF64,N,N,N)
    uhH,vhH,whH = z(),z(),z(); uhC,vhC,whC = z(),z(),z()
    cidx(a) = a==1 ? 1 : N+2-a
    for c in 1:N, b in 1:N, a in 1:N
        kx=op.kx[a,b,c]; ky=op.ky[a,b,c]; kz=op.kz[a,b,c]; k2=kx^2+ky^2+kz^2
        (k2 < 0.5 || k2 > kmax^2+0.5) && continue
        # set each independent mode once (positive half-space), mirror the conjugate at −k
        pos = (kz>0) || (kz==0 && ky>0) || (kz==0 && ky==0 && kx>0)
        pos || continue
        hp,hm = hbasis(kx,ky,kz)
        A = randn(ComplexF64)                 # SAME amplitude spectrum for both members
        hc = rand(Bool) ? hp : hm             # control: random helical sign per mode
        ac,bc,cc = cidx(a),cidx(b),cidx(c)
        for (arr,h) in (((uhH,vhH,whH),hp), ((uhC,vhC,whC),hc))
            arr[1][a,b,c]=A*h[1]; arr[2][a,b,c]=A*h[2]; arr[3][a,b,c]=A*h[3]
            arr[1][ac,bc,cc]=conj(arr[1][a,b,c]); arr[2][ac,bc,cc]=conj(arr[2][a,b,c]); arr[3][ac,bc,cc]=conj(arr[3][a,b,c])
        end
    end
    function normE(U)
        u=real.(ifft3(U[1])); v=real.(ifft3(U[2])); w=real.(ifft3(U[3]))
        E=0.5*mean3(u.^2 .+ v.^2 .+ w.^2); s=sqrt(E0/E)
        (U[1].*s, U[2].*s, U[3].*s)
    end
    (normE((uhH,vhH,whH)), normE((uhC,vhC,whC)))
end

# Beltramization: ⟨cos²(u,ω)⟩ (u∥ω ⇒ →1) + signed ⟨cos(u,ω)⟩ + the normalized Lamb-vector magnitude
# ⟨|u×ω|²⟩/⟨|u|²|ω|²⟩ (the actual nonlinear driver; →0 as the field Beltramizes).
function beltram(U,op)
    u=real.(ifft3(U[1])); v=real.(ifft3(U[2])); w=real.(ifft3(U[3]))
    ωxh,ωyh,ωzh=curl_hat(U[1],U[2],U[3],op)
    ωx=real.(ifft3(ωxh)); ωy=real.(ifft3(ωyh)); ωz=real.(ifft3(ωzh))
    uω = u.*ωx .+ v.*ωy .+ w.*ωz
    u2 = u.^2 .+ v.^2 .+ w.^2; ω2 = ωx.^2 .+ ωy.^2 .+ ωz.^2
    lx = v.*ωz .- w.*ωy; ly = w.*ωx .- u.*ωz; lz = u.*ωy .- v.*ωx   # Lamb vector u×ω
    den = max.(u2.*ω2, 1e-30)
    (cos2 = mean3((uω.^2)./den),
     cossigned = mean3(uω ./ sqrt.(den)),
     lamb2 = mean3(lx.^2 .+ ly.^2 .+ lz.^2) / mean3(u2.*ω2))
end

# ± helical energy split E₊,E₋ (projection onto h±) — confirms the sector structure of each member.
function pm_split(U,op; kmax=4)
    N=size(U[1],1); Ep=0.0; Em=0.0
    for c in 1:N, b in 1:N, a in 1:N
        kx=op.kx[a,b,c]; ky=op.ky[a,b,c]; kz=op.kz[a,b,c]; k2=kx^2+ky^2+kz^2
        (k2 < 0.5 || k2 > kmax^2+0.5) && continue
        hp,hm = hbasis(kx,ky,kz)
        û=(U[1][a,b,c],U[2][a,b,c],U[3][a,b,c])
        ap = û[1]*conj(hp[1]) + û[2]*conj(hp[2]) + û[3]*conj(hp[3])
        am = û[1]*conj(hm[1]) + û[2]*conj(hm[2]) + û[3]*conj(hm[3])
        Ep += abs2(ap); Em += abs2(am)
    end
    (Ep, Em)
end

function run_audit(label, U, N, ν, T, dt, op; sample=0.5)
    @printf("# %s  N=%d  nu=%.5e  T=%.1f  dt=%.3f\n", label, N, ν, T, dt)
    println("# t      E           Z           H            rhoH    P            Sw       c2int  c2max  beltcos2 cosUW    lamb2")
    flush(stdout)
    t=0.0; nexts=0.0
    while t <= T+1e-9
        if t >= nexts-1e-9
            d=diagnose(U,op,N); fd=field_diag(U,op); bl=beltram(U,op)
            rhoH = d.H/(2*sqrt(max(d.E*d.Z,1e-30))); P=mean3(fd.Pd)
            @printf("%.3f  %.6e  %.6e  %+.6e  %+.4f  %+.6e  %+.5f  %.4f  %.4f  %.4f  %+.4f  %.4f\n",
                    t, d.E, d.Z, d.H, rhoH, P, fd.Sw, fd.cos2int, fd.cos2max, bl.cos2, bl.cossigned, bl.lamb2)
            flush(stdout); nexts += sample
        end
        U = rk4(U,dt,ν,op); t += dt
    end
    U
end

function main()
    N   = parse(Int,    get(ENV,"NS_N","64"))
    T   = parse(Float64,get(ENV,"NS_T","6.0"))
    dt  = parse(Float64,get(ENV,"NS_DT","0.01"))
    ν   = parse(Float64,get(ENV,"NS_NU",string(1/1600)))
    smp = parse(Float64,get(ENV,"NS_SAMPLE","0.5"))
    kmax= parse(Int,    get(ENV,"NS_KMAX","4"))
    seed= parse(Int,    get(ENV,"NS_SEED","20260605"))
    op=make_ops(N)
    UH,UC = helical_pair_ic(N,op; kmax=kmax, seed=seed)
    dH=diagnose(UH,op,N); dC=diagnose(UC,op,N)
    EpH,EmH=pm_split(UH,op;kmax=kmax); EpC,EmC=pm_split(UC,op;kmax=kmax)
    println("# NS-045 helicity-depletion mechanism audit — matched-spectrum pair (kmax=$kmax, seed=$seed)")
    @printf("# IC helical: E=%.6f Z=%.6f H=%+.6f rhoH=%+.4f  E+/-=(%.4f,%.4f) frac+=%.3f  divmax=%.1e\n",
            dH.E,dH.Z,dH.H, dH.H/(2*sqrt(dH.E*dH.Z)), EpH,EmH, EpH/(EpH+EmH), dH.divmax)
    @printf("# IC control: E=%.6f Z=%.6f H=%+.6f rhoH=%+.4f  E+/-=(%.4f,%.4f) frac+=%.3f  divmax=%.1e\n",
            dC.E,dC.Z,dC.H, dC.H/(2*sqrt(dC.E*dC.Z)), EpC,EmC, EpC/(EpC+EmC), dC.divmax)
    @printf("# matched-spectrum check: |dE|=%.2e |dZ|=%.2e (want ~0)\n", abs(dH.E-dC.E), abs(dH.Z-dC.Z))
    println(); run_audit("HELICAL", UH, N,ν,T,dt,op; sample=smp)
    println(); run_audit("CONTROL", UC, N,ν,T,dt,op; sample=smp)
    println("# DONE")
end
if abspath(PROGRAM_FILE)==@__FILE__; main(); end
