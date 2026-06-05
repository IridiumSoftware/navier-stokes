#!/usr/bin/env julia
# ns013_reality_ladder_2d.jl — NS-013 reality-protection ladder, RUNG 3 (2D NS, the CRITICAL control).
#
# EXPERIMENTAL. **Scope: 2D pseudospectral ODE-truncation, complex data.** NOT the 3D-NS PDE.
# :proved=0; distance UNTOUCHED. Extends the 1D ladder (ns013_reality_ladder.jl). 2D NS has TWO
# coercive controls (energy AND enstrophy — no vortex stretching; the Tier-1 invariants that make
# 2D globally regular). PREDICTION of the NS-013 obstruction-map: the criticality gradient ⇒ 2D
# should protect MORE robustly than 1D viscous Burgers (a stronger/critical control), and the real
# limit (λ→∞) is regular. Over-reach guard armed: protection here is about 2D's control, NOT 3D-NS.
#
# Complex 2D NS, vorticity form (reuses spectral_2d_control.jl structure, but NO real() projection —
# the field is genuinely complex): ω_t = −u·∇ω + νΔω − iλ·Im(ω), u=∇⊥ψ, Δψ=−ω. λ→∞ forces ω real.

using Printf

function fft!(a::Vector{ComplexF64}; inv::Bool=false)
    N=length(a); j=0
    for i in 1:N-1
        bit=N>>1
        while j & bit != 0; j ⊻= bit; bit>>=1; end
        j |= bit
        if i<j; t=a[i+1]; a[i+1]=a[j+1]; a[j+1]=t; end
    end
    len=2
    while len<=N
        wlen=cis((inv ? 2π : -2π)/len); i=0
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
    a
end
function fft2(A::Matrix{ComplexF64})
    B=copy(A); N=size(B,1)
    for i in 1:N; r=B[i,:]; fft!(r); B[i,:]=r; end
    for jc in 1:N; c=B[:,jc]; fft!(c); B[:,jc]=c; end
    B
end
function ifft2(A::Matrix{ComplexF64})
    B=copy(A); N=size(B,1)
    for i in 1:N; r=B[i,:]; fft!(r;inv=true); B[i,:]=r; end
    for jc in 1:N; c=B[:,jc]; fft!(c;inv=true); B[:,jc]=c; end
    B
end
keff(k,N)= k<=N>>1 ? k : k-N
function make_ops(N)
    kx=[ComplexF64(keff(a-1,N)) for a in 1:N, b in 1:N]
    ky=[ComplexF64(keff(b-1,N)) for a in 1:N, b in 1:N]
    k2=[Float64(keff(a-1,N)^2+keff(b-1,N)^2) for a in 1:N, b in 1:N]
    k2p=copy(k2); k2p[1,1]=1.0
    cut=N÷3; deal=[abs(keff(a-1,N))<=cut && abs(keff(b-1,N))<=cut for a in 1:N, b in 1:N]
    (kx=kx,ky=ky,k2=k2,k2p=k2p,deal=deal)
end

# COMPLEX 2D NS vorticity RHS + reality leakage (no real() — genuinely complex)
function rhs(ω::Matrix{ComplexF64}, ν, λ, op)
    W=fft2(ω); ψ=W./op.k2p; ψ[1,1]=0
    u=ifft2(-im.*op.ky.*ψ); v=ifft2(im.*op.kx.*ψ)
    ωx=ifft2(im.*op.kx.*W); ωy=ifft2(im.*op.ky.*W)
    A=fft2(u.*ωx .+ v.*ωy); A[.!op.deal].=0
    .-ifft2(A) .- ν.*ifft2(op.k2.*W) .- (im*λ).*imag.(ω)
end
function run2d(ω0, ν, λ, op; dt=0.004, Tmax=8.0, thresh=200.0)
    ω=copy(ω0); n=round(Int,Tmax/dt)
    for i in 1:n
        k1=rhs(ω,ν,λ,op); k2=rhs(ω.+(dt/2).*k1,ν,λ,op)
        k3=rhs(ω.+(dt/2).*k2,ν,λ,op); k4=rhs(ω.+dt.*k3,ν,λ,op)
        ω=ω .+ (dt/6).*(k1.+2 .*k2.+2 .*k3.+k4)
        m=maximum(abs.(ω)); (m>thresh || !isfinite(m)) && return (i*dt,m)
    end
    (Inf, maximum(abs.(ω)))
end

function main()
    out=joinpath(@__DIR__,"ns013_reality_ladder_2d.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^82; dsh="─"^82
    pr(bar); pr("  ns013_reality_ladder_2d.jl — RUNG 3 (2D NS, critical control: energy+enstrophy)")
    pr("  Scope: 2D complex pseudospectral truncation. NOT the PDE. :proved=0; prize UNTOUCHED.")
    pr(bar)

    N=64; op=make_ops(N); x=[2π*(i-1)/N for i in 1:N]
    # complex IC: real part = smooth 2D vorticity (real 2D NS regular); imaginary part damped by λ
    cc=0.8
    ω0=[ComplexF64(sin(x[a])*cos(x[b]) + 0.5*sin(2x[a]+x[b]),
                   cc*(sin(x[a]+2x[b]) + 0.4*cos(3x[a]))) for a in 1:N, b in 1:N]
    pr(@sprintf("\n  N=%d, complex IC (Re = smooth 2D vorticity, Im·=%.1f). λ→∞ ⇒ real 2D NS ⇒ regular.", N, cc))
    λs=[0.0,0.05,0.1,0.25,0.5,1.0,2.0,5.0]

    for (tag,ν,Tmax) in (("2D EULER (ν=0)",0.0,8.0), ("2D NS (ν=0.01)",0.01,8.0))
        pr("\n"*dsh); pr("  "*tag); pr(dsh)
        pr(@sprintf("    %-8s %-12s %-s","λ","T*(λ)","fate"))
        Ts=Float64[]
        for λ in λs
            T,m=run2d(ω0,ν,λ,op; Tmax=Tmax); push!(Ts,T)
            pr(@sprintf("    %-8.3g %-12s %-s", λ, isinf(T) ? "∞" : @sprintf("%.3f",T),
                isinf(T) ? @sprintf("REGULAR to T=%.0f (max|ω|=%.1f)",Tmax,m) : @sprintf("blowup (max|ω|→%.0f)",m)))
        end
        i=findfirst(isinf,Ts); λc = i===nothing ? Inf : λs[i]
        allreg = all(isinf,Ts)
        pr(@sprintf("    ⇒ %s", allreg ? "REGULAR at EVERY λ (incl. complex λ=0) — 2D's control protects even without reality" :
            (isinf(λc) ? "no protection in sweep (blows up to λ=5)" : @sprintf("protection threshold λ_c ≈ %.3g",λc))))
    end

    pr("\n"*bar); pr("  READING (2D rung — criticality gradient)"); pr(bar)
    pr("  • Compare to the 1D rungs (ns013_reality_ladder.jl): viscous Burgers protected above λ_c≈0.05;")
    pr("    inviscid CLM never protected. 2D NS has a STRONGER (critical) coercive control — energy AND")
    pr("    enstrophy (no vortex stretching). The result above places 2D on the criticality gradient.")
    pr("  • FIREWALL: 2D truncation, complex data. About 2D's control, NOT 3D-NS regularity. :proved=0.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end
main()
