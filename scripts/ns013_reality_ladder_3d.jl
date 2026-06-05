#!/usr/bin/env julia
# ns013_reality_ladder_3d.jl — NS-013 reality-protection ladder, RUNG 4 (3D NS, the SUPERCRITICAL case).
#
# EXPERIMENTAL. **Scope: 3D pseudospectral ODE-truncation, complex data.** NOT the 3D-NS PDE.
# :proved=0; distance UNTOUCHED. Top rung of the ladder (1D Burgers/CLM → 2D → 3D). 3D NS has only
# ENERGY as a coercive control, and it is SUPERCRITICAL (NS-002): vortex stretching is active,
# enstrophy is NOT controlled. PREDICTION of the NS-013 obstruction-map: 3D should still *protect*
# at finite truncation (the real limit λ→∞ is the regular 3D truncation, NS-032), but its control is
# the weakest on the ladder.
#
# *** HARD CAVEAT (the honest ceiling) ***: at any FINITE truncation the real 3D dynamics are regular
# (NS-032 INCONCLUSIVE — no blowup), so a "reality protects" reading here is largely a statement that
# the TRUNCATION regularizes — it is NOT evidence about 3D-NS PDE regularity, and the criticality
# gradient (vs 2D) is confounded by N/ν/IC (the 2D rung already showed λ_c does not cleanly rank by
# criticality). Over-reach guard: FIRING. This rung maps the ladder's top, it does not touch the prize.
#
# Complex rotational-form NS (reuses spectral_3d_control.jl rhs, NO real() projection): the reality
# leakage −iλ·Im(u) is added to the Lamb vector BEFORE the Leray projection ⇒ incompressibility is
# preserved (we damp only the div-free part of Im(u)).

using Printf, Random

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
function fft3(A::Array{ComplexF64,3})
    B=copy(A); N=size(B,1)
    for b in 1:N, c in 1:N; r=B[:,b,c]; fft!(r); B[:,b,c]=r; end
    for a in 1:N, c in 1:N; r=B[a,:,c]; fft!(r); B[a,:,c]=r; end
    for a in 1:N, b in 1:N; r=B[a,b,:]; fft!(r); B[a,b,:]=r; end
    B
end
function ifft3(A::Array{ComplexF64,3})
    B=copy(A); N=size(B,1)
    for b in 1:N, c in 1:N; r=B[:,b,c]; fft!(r;inv=true); B[:,b,c]=r; end
    for a in 1:N, c in 1:N; r=B[a,:,c]; fft!(r;inv=true); B[a,:,c]=r; end
    for a in 1:N, b in 1:N; r=B[a,b,:]; fft!(r;inv=true); B[a,b,:]=r; end
    B
end
keff(k,N)= k<=N>>1 ? k : k-N
function make_ops(N)
    kx=[ComplexF64(keff(a-1,N)) for a in 1:N, b in 1:N, c in 1:N]
    ky=[ComplexF64(keff(b-1,N)) for a in 1:N, b in 1:N, c in 1:N]
    kz=[ComplexF64(keff(c-1,N)) for a in 1:N, b in 1:N, c in 1:N]
    k2=[Float64(keff(a-1,N)^2+keff(b-1,N)^2+keff(c-1,N)^2) for a in 1:N, b in 1:N, c in 1:N]
    k2p=copy(k2); k2p[1,1,1]=1.0
    cut=N÷3
    deal=[abs(keff(a-1,N))<=cut && abs(keff(b-1,N))<=cut && abs(keff(c-1,N))<=cut for a in 1:N,b in 1:N,c in 1:N]
    (kx=kx,ky=ky,kz=kz,k2=k2,k2p=k2p,deal=deal)
end
curl_hat(uh,vh,wh,op)=(im.*(op.ky.*wh.-op.kz.*vh), im.*(op.kz.*uh.-op.kx.*wh), im.*(op.kx.*vh.-op.ky.*uh))

# complex rotational-form RHS + reality leakage (pre-projection ⇒ stays div-free)
function rhs(uh,vh,wh,ν,λ,op)
    u=ifft3(uh); v=ifft3(vh); w=ifft3(wh)
    ωxh,ωyh,ωzh=curl_hat(uh,vh,wh,op)
    ωx=ifft3(ωxh); ωy=ifft3(ωyh); ωz=ifft3(ωzh)
    Cx=fft3(v.*ωz.-w.*ωy); Cx[.!op.deal].=0
    Cy=fft3(w.*ωx.-u.*ωz); Cy[.!op.deal].=0
    Cz=fft3(u.*ωy.-v.*ωx); Cz[.!op.deal].=0
    Cx .-= (im*λ).*fft3(ComplexF64.(imag.(u))); Cy .-= (im*λ).*fft3(ComplexF64.(imag.(v))); Cz .-= (im*λ).*fft3(ComplexF64.(imag.(w)))  # reality leakage
    kdotC=op.kx.*Cx .+ op.ky.*Cy .+ op.kz.*Cz                                                     # Leray project
    Px=Cx .- op.kx.*(kdotC./op.k2p); Py=Cy .- op.ky.*(kdotC./op.k2p); Pz=Cz .- op.kz.*(kdotC./op.k2p)
    (Px .- ν.*op.k2.*uh, Py .- ν.*op.k2.*vh, Pz .- ν.*op.k2.*wh)
end
function run3d(U0, ν, λ, op; dt=0.005, Tmax=6.0, thresh=50.0)
    uh,vh,wh=copy(U0[1]),copy(U0[2]),copy(U0[3]); n=round(Int,Tmax/dt)
    for i in 1:n
        a1,a2,a3=rhs(uh,vh,wh,ν,λ,op)
        b1,b2,b3=rhs(uh.+(dt/2).*a1,vh.+(dt/2).*a2,wh.+(dt/2).*a3,ν,λ,op)
        c1,c2,c3=rhs(uh.+(dt/2).*b1,vh.+(dt/2).*b2,wh.+(dt/2).*b3,ν,λ,op)
        d1,d2,d3=rhs(uh.+dt.*c1,vh.+dt.*c2,wh.+dt.*c3,ν,λ,op)
        uh=uh.+(dt/6).*(a1.+2 .*b1.+2 .*c1.+d1); vh=vh.+(dt/6).*(a2.+2 .*b2.+2 .*c2.+d2); wh=wh.+(dt/6).*(a3.+2 .*b3.+2 .*c3.+d3)
        m=maximum(abs.(ifft3(uh))); (m>thresh || !isfinite(m)) && return (i*dt,m)
    end
    (Inf, maximum(abs.(ifft3(uh))))
end

function main()
    out=joinpath(@__DIR__,"ns013_reality_ladder_3d.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^82; dsh="─"^82
    pr(bar); pr("  ns013_reality_ladder_3d.jl — RUNG 4 (3D NS, supercritical: energy-only control)")
    pr("  Scope: 3D complex pseudospectral truncation. NOT the PDE. :proved=0; prize UNTOUCHED.")
    pr("  CAVEAT: finite truncation ⇒ real 3D is regular anyway; protection here is truncation, not PDE.")
    pr(bar)

    N=32; op=make_ops(N)
    # complex div-free IC: random low-k complex amplitudes, Leray-projected, mean removed, normalized.
    Random.seed!(7)
    uh=zeros(ComplexF64,N,N,N); vh=copy(uh); wh=copy(uh)
    for a in 1:N, b in 1:N, c in 1:N
        k2=keff(a-1,N)^2+keff(b-1,N)^2+keff(c-1,N)^2
        if 1<=k2<=4
            uh[a,b,c]=complex(randn(),randn()); vh[a,b,c]=complex(randn(),randn()); wh[a,b,c]=complex(randn(),randn())
        end
    end
    kdot=op.kx.*uh .+ op.ky.*vh .+ op.kz.*wh                          # Leray-project the IC div-free
    uh.-=op.kx.*(kdot./op.k2p); vh.-=op.ky.*(kdot./op.k2p); wh.-=op.kz.*(kdot./op.k2p)
    uh[1,1,1]=0; vh[1,1,1]=0; wh[1,1,1]=0
    s=1.0/maximum(abs.(ifft3(uh))); uh.*=s; vh.*=s; wh.*=s          # normalize max|u|≈1
    U0=(uh,vh,wh)
    # div check
    dmax=maximum(abs.(op.kx.*uh .+ op.ky.*vh .+ op.kz.*wh))
    pr(@sprintf("\n  N=%d complex div-free IC (random low-k, Leray-projected). div check max|k·û|=%.1e", N, dmax))
    λs=[0.0,0.1,0.25,0.5,1.0,2.0,5.0]

    for (tag,ν,Tmax) in (("3D EULER (ν=0)",0.0,6.0), ("3D NS (ν=0.01)",0.01,6.0))
        pr("\n"*dsh); pr("  "*tag); pr(dsh)
        pr(@sprintf("    %-8s %-12s %-s","λ","T*(λ)","fate"))
        Ts=Float64[]
        for λ in λs
            T,m=run3d(U0,ν,λ,op; Tmax=Tmax); push!(Ts,T)
            pr(@sprintf("    %-8.3g %-12s %-s", λ, isinf(T) ? "∞" : @sprintf("%.3f",T),
                isinf(T) ? @sprintf("REGULAR to T=%.0f (max|u|=%.2f)",Tmax,m) : @sprintf("blowup (max|u|→%.0f)",m)))
        end
        i=findfirst(isinf,Ts); λc = i===nothing ? Inf : λs[i]
        pr(@sprintf("    ⇒ %s", all(isinf,Ts) ? "REGULAR at every λ (complex incl.)" :
            (isinf(λc) ? "no protection in sweep (blows up to λ=5)" : @sprintf("protection threshold λ_c ≈ %.3g",λc))))
    end

    pr("\n"*bar); pr("  READING (3D rung — top of the ladder)"); pr(bar)
    pr("  • Ladder λ_c so far: Burgers≈0.05, CLM=∞(none), 2D-NS≈0.1, 2D-Euler≈0.5. This rung adds 3D.")
    pr("  • BINARY result (robust): models with a coercive control protect; CLM (none) does not.")
    pr("  • The numeric λ_c does NOT cleanly rank by criticality (confounded by ν/N/IC) — claimed only")
    pr("    as the binary, per the 2D rung's finding.")
    pr("  • FIREWALL: 3D truncation ⇒ real fate regular regardless; this is NOT 3D-NS PDE evidence.")
    pr("    :proved=0; distance to the prize UNTOUCHED.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end
main()
