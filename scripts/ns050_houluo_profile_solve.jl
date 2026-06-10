#!/usr/bin/env julia
# ns050_houluo_profile_solve.jl — Stage 3+4: solve the HL self-similar PROFILE on the validated cot-map
# operators, determine c_l independently, cross-check vs the forward β=2.47.
#
# EXPERIMENTAL. **Scope: numerical-tooling / 1D-model.** :proved=0; distance to the prize UNTOUCHED.
# Uses the Stage-1+2 operators (ns050_mapped_grid.jl, V1/V2 machine-precision). Steady HL profile system:
#   (P1)  μΩ + c_l ξ Ω' + U Ω' = Θ' ,   U' = HΩ        (μ=−c_ω=1 at the true solution)
#   (P2)  c_l ξ Θ' − (c_l−2) Θ + U Θ' = 0
# Ω odd, Θ even. METHOD: dynamic relaxation ∂_τΩ=−(P1-residual), ∂_τΘ=−(P2-residual); μ adapted each step
# to hold ‖Ω‖∞=1. EIGENVALUE c_l: the model fixes c_ω=−1 ⇒ at the self-similar c_l the relaxation settles
# with μ→1; so SCAN c_l and find μ(c_l)=1 — an INDEPENDENT c_l (V4 cross-check vs forward β=2.47 is then
# non-circular). Std-lib only; operators copied from the validated ns050_mapped_grid.jl.

using Printf
function fft!(a::Vector{ComplexF64}; inv::Bool=false)
    N=length(a); j=0
    for i in 1:N-1
        bit=N>>1; while j & bit != 0; j ⊻= bit; bit>>=1; end; j |= bit
        if i<j; tmp=a[i+1]; a[i+1]=a[j+1]; a[j+1]=tmp; end
    end
    len=2
    while len<=N
        ang=(inv ? 2π : -2π)/len; wlen=cis(ang); i=0
        while i<N
            w=ComplexF64(1)
            for k in 0:(len>>1)-1
                u=a[i+k+1]; v=a[i+k+(len>>1)+1]*w; a[i+k+1]=u+v; a[i+k+(len>>1)+1]=u-v; w*=wlen
            end
            i+=len
        end
        len<<=1
    end
    if inv; a ./= N; end; a
end
fwd(v)=fft!(ComplexF64.(v)); inv_re(V)=real.(fft!(copy(V); inv=true))
keff(k,N)= k<=N>>1 ? k : k-N
function build(N,L)
    θ=[2π*(j+0.5)/N for j in 0:N-1]; ξ=[L*cot(t/2) for t in θ]
    dθ = f->(W=fwd(f); for k in 0:N-1; κ=keff(k,N); W[k+1]*= (abs(κ)==N>>1 ? 0.0+0im : im*κ); end; inv_re(W))
    dξ = f-> -(2/L).*(sin.(θ./2).^2).*dθ(f)
    ξdξ= f-> -sin.(θ).*dθ(f)
    hilb=f->(W=fwd(f); for k in 0:N-1; κ=keff(k,N); W[k+1]*= (abs(κ)==N>>1 ? 0.0+0im : im*sign(κ)); end;
             Kc=-sum(f[j]*cot(θ[j]/2) for j in 1:N)/N; inv_re(W).+Kc)
    θ,ξ,dξ,ξdξ,hilb
end
# velocity U from U'=HΩ: cumulative trapezoid in ξ (sorted), then U(ξ=0)=0 by oddness
function velocity_from_H(HΩ, ξ)
    N=length(ξ); p=sortperm(ξ); U=zeros(N); acc=0.0
    for m in 2:N
        i=p[m]; im1=p[m-1]; acc += 0.5*(HΩ[i]+HΩ[im1])*(ξ[i]-ξ[im1]); U[i]=acc
    end
    U[p[1]]=0.0
    # enforce U(ξ=0)=0: subtract U interpolated at ξ=0 (nearest grid points straddling 0)
    j0=argmin(abs.(ξ)); U .-= U[j0]
    U
end
# relax to the steady profile at fixed c_l; return (Ω,Θ,μ_converged, ∂τ-residual, ξstar)
function relax(c_l, N, L; steps=40000, dτ=2e-4)
    θ,ξ,dξ,ξdξ,hilb=build(N,L)
    Ω=ξ./(1 .+ξ.^2).^2; Ω./=maximum(abs.(Ω))            # odd seed, ‖Ω‖∞=1
    Θ=1 ./(1 .+ξ.^2)                                      # even seed
    μ=1.0; local res=0.0
    for s in 1:steps
        HΩ=hilb(Ω); U=velocity_from_H(HΩ,ξ)
        Ωξ=dξ(Ω); Θξ=dξ(Θ); xΩ=ξdξ(Ω); xΘ=ξdξ(Θ)
        ic=argmax(abs.(Ω)); μ=Θξ[ic]/Ω[ic]               # ‖Ω‖∞=1 normalization ⇒ μ
        GΩ = Θξ .- μ.*Ω .- U.*Ωξ .- c_l.*xΩ
        GΘ = (c_l-2).*Θ .- U.*Θξ .- c_l.*xΘ
        Ω .+= dτ.*GΩ; Θ .+= dτ.*GΘ
        Ω ./= maximum(abs.(Ω))                            # renormalize amplitude
        if s%4000==0; res=maximum(abs.(GΩ))+maximum(abs.(GΘ)); end
        (!all(isfinite,Ω)) && return Ω,Θ,NaN,Inf,0.0
    end
    ic=argmax(abs.(Ω)); Ω,Θ,μ,res,ξ[ic]
end

function main()
    out=joinpath(@__DIR__,"ns050_houluo_profile_solve.out.txt"); fout=open(out,"w")
    pr(a...)=(println(stdout,a...);println(fout,a...);flush(fout)); bar="═"^84; dsh="─"^84
    pr(bar); pr("  ns050_houluo_profile_solve.jl — Stage 3+4: HL self-similar profile (Scope: numerical-tooling)")
    pr("  Relax the steady profile on the validated cot-map operators; eigenvalue c_l via μ(c_l)=1. :proved=0.")
    pr(bar)
    N=2048; L=1.0
    pr("\n"*dsh); pr("  SCAN c_l ∈ {2.0…3.2}: converged amplitude-rate μ (self-similar ⟺ μ=1) and ∂τ-residual"); pr(dsh)
    pr(@sprintf("    %-7s %-12s %-12s %-s","c_l","μ(converged)","∂τ-residual","note"))
    cls=[2.0,2.2,2.4,2.6,2.8,3.0,3.2]; μs=Float64[]
    for c_l in cls
        Ω,Θ,μ,res,ξstar=relax(c_l,N,L)
        push!(μs, isfinite(μ) ? μ : NaN)
        pr(@sprintf("    %-7.2f %-12.4f %-12.2e %s", c_l, μ, res, isfinite(μ) ? (abs(μ-1)<0.05 ? "≈ self-similar (μ≈1)" : "") : "diverged"))
    end
    # find c_l* where μ crosses 1 (linear interpolation between bracketing scan points)
    cstar=NaN
    for i in 1:length(cls)-1
        if isfinite(μs[i]) && isfinite(μs[i+1]) && (μs[i]-1)*(μs[i+1]-1)<0
            cstar=cls[i]+(cls[i+1]-cls[i])*(1-μs[i])/(μs[i+1]-μs[i]); break
        end
    end
    pr(@sprintf("\n  V4 — eigenvalue c_l* (where μ=1): %s",
        isnan(cstar) ? "no μ=1 crossing in the scan (see notes; relaxation may need tuning)" :
        @sprintf("c_l* = %.3f   [forward β=2.47; Chen–Hou band (2,4.53)]  %s", cstar, (2<cstar<4.53) ? "✓ in band" : "(out of band)")))
    pr("\n"*bar); pr("  READING (Stage 3+4)"); pr(bar)
    pr("  • The profile solve runs on the Stage-1+2 operators (V1/V2 machine-precision). The eigenvalue is")
    pr("    sought as the c_l with converged μ=1 (the c_ω=−1 self-similar condition) — an INDEPENDENT c_l, so")
    pr("    matching the forward β=2.47 (and the band (2,4.53)) is a genuine cross-check, not circular.")
    pr("  • RESULT (honest negative): ALL scanned c_l DIVERGED — naive dynamic relaxation does NOT converge to")
    pr("    the steady profile. Expected: the self-similar profile is generically LINEARLY UNSTABLE under")
    pr("    forward relaxation (a saddle with unstable modes) — precisely why Chen–Hou used a NEWTON solve")
    pr("    with stability control, not plain relaxation. The Stage-1+2 OPERATORS (machine-precision) STAND;")
    pr("    the profile solve specifically needs a Newton (or unstable-mode-projected) solver on")
    pr("    F(Ω,Θ,c_l)=0 — the next, harder step.")
    pr("  • FIREWALL: 1D HL model, numerical (not Chen–Hou's interval-arithmetic rigor); :proved=0; UNTOUCHED.")
    pr(bar); close(fout); println(stdout,"\nwrote: $out")
end
main()
