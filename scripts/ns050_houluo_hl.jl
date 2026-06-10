#!/usr/bin/env julia
# ns050_houluo_hl.jl — NS-050 (c, follow-up): the FAITHFUL 1D Hou–Luo (HL) model fixture.
#
# EXPERIMENTAL. **Scope: 1D-model + pseudospectral truncation. NOT the NS PDE.** :proved=0; distance to
# the Clay prize UNTOUCHED. The HL model is the canonical 1D reduction Luo & Hou proposed for the
# wall-stagnation singularity scenario of the 3D axisymmetric Euler / 2D Boussinesq equations on a solid
# boundary. Chen–Hou–Huang (arXiv:2308.01528) PROVED it has an EXACT self-similar finite-time blow-up with
# smooth profiles. So it is a faithful, NAMED Hou–Luo fixture with a KNOWN self-similar exponent — the
# strongest calibration target for the (c1) two-scale instrument beyond CLM (where the exponent was 1).
#
# ─── THE HL MODEL (verbatim, arXiv:2308.01528) ─────────────────────────────────────────────────────
#   ω_t + u·ω_x = θ_x ,    θ_t + u·θ_x = 0 ,    u_x = H(ω)   (Hilbert transform ⇒ û(k) = −ω̂(k)/|k|).
#   Symmetry (conserved): ω ODD, θ EVEN ⇒ u odd. Here on periodic [0,2π] with the symmetry point at x=π
#   (the Hou–Luo wall-stagnation point): ω odd about π, θ even about π, ω(π)=0.
#   Exact self-similar form: ω=(T−t)^{c_ω} Ω(x/(T−t)^{c_l}), c_ω=−1 (‖ω‖∞~(T−t)^{−1}), c_l∈(2,4.53).
#   ⇒ in the two-scale instrument, λ=1/A~(T−t)^1, ℓ~(T−t)^{c_l} ⇒ β=dlnℓ/dlnλ = c_l ∈ (2,4.53).
#
# Caveat: this is the 1D HL MODEL (the Hou–Luo reduction), not the literal 2D Boussinesq wall (a heavier,
# resolution-gated, IC-reconstruction-prone build — flagged as the further step). Std-lib only; FFT/Hilbert
# reused from ns050_twoscale_fit.jl.

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
ddx(ω)=(N=length(ω); W=fwd(ω); for k in 0:N-1; W[k+1]*=im*keff(k,N); end; inv_re(W))
hilbert(ω)=(N=length(ω); W=fwd(ω); for k in 0:N-1; W[k+1]*= -im*sign(keff(k,N)); end; inv_re(W))
velocity(ω)=(N=length(ω); W=fwd(ω); for k in 0:N-1; κ=keff(k,N); W[k+1]= κ==0 ? 0.0+0im : -W[k+1]/abs(κ); end; inv_re(W))
dealias(v)=(N=length(v); W=fwd(v); cut=N÷3; for k in 0:N-1; if abs(keff(k,N))>cut; W[k+1]=0; end; end; inv_re(W))
interp(ω,x)=(N=length(ω); h=2π/N; s=mod(x,2π)/h; i=floor(Int,s); f=s-i; (1-f)*ω[mod(i,N)+1]+f*ω[mod(i+1,N)+1])

# HL RHS: ω_t = −u ω_x + θ_x ; θ_t = −u θ_x  (advection dealiased; θ_x linear)
function rhs(ω,θ)
    u=velocity(ω)
    dω = -dealias(u.*ddx(ω)) .+ ddx(θ)
    dθ = -dealias(u.*ddx(θ))
    dω, dθ
end
function step_rk4!(ω,θ,dt)
    a1,b1=rhs(ω,θ); a2,b2=rhs(ω.+(dt/2).*a1,θ.+(dt/2).*b1)
    a3,b3=rhs(ω.+(dt/2).*a2,θ.+(dt/2).*b2); a4,b4=rhs(ω.+dt.*a3,θ.+dt.*b3)
    @. ω += (dt/6)*(a1+2a2+2a3+a4); @. θ += (dt/6)*(b1+2b2+2b3+b4); nothing
end
# two-scale fit (c1) at the symmetry point: center=argmax|ω_x| (=π by symmetry), A=‖ω‖∞, ℓ=A/‖ω_x‖∞
function twoscale(ω, xs; ηmax=4.0, Nη=161)
    N=length(ω); A=maximum(abs.(ω)); ωx=ddx(ω); sx=maximum(abs.(ωx)); ic=argmax(abs.(ωx))
    a0=abs(ωx[mod(ic-2,N)+1]); a1=abs(ωx[ic]); a2=abs(ωx[mod(ic,N)+1]); den=a0-2a1+a2
    x0=xs[ic]+clamp(den!=0 ? 0.5*(a0-a2)/den : 0.0,-1.0,1.0)*(2π/N)
    ℓ=A/sx; sgn=-sign(interp(ωx,x0)); sgn==0 && (sgn=1.0)
    ηs=range(-ηmax,ηmax;length=Nη); x0, A, ℓ, [sgn*interp(ω,x0+ℓ*η)/A for η in ηs]
end
linfit(x,y)=(xm=sum(x)/length(x); ym=sum(y)/length(y); sum((x.-xm).*(y.-ym))/sum((x.-xm).^2))

function main()
    out=joinpath(@__DIR__,"ns050_houluo_hl.out.txt"); fout=open(out,"w")
    pr(a...)=(println(stdout,a...);println(fout,a...);flush(fout)); bar="═"^86; dsh="─"^86
    pr(bar); pr("  ns050_houluo_hl.jl — faithful 1D Hou–Luo model (Scope: 1D-model + spectral truncation)")
    pr("  HL: ω_t+uω_x=θ_x, θ_t+uθ_x=0, u_x=Hω; ω odd/θ even @ x=π. Proven self-similar c_l∈(2,4.53).")
    pr("  Two-scale β should land in (2,4.53). :proved=0; within-truncation; does NOT touch 3D-NS.")
    pr(bar)
    let N=16,v=Float64.(1:N),W=fwd(v); mx=maximum(abs(W[k+1]-sum(v[j+1]*cis(-2π*k*j/N) for j in 0:N-1)) for k in 0:N-1)
        pr(@sprintf("\n  FFT self-check: max|fft−DFT|=%.1e %s", mx, mx<1e-10 ? "✓" : "✗")); end

    N=8192; xs=[2π*j/N for j in 0:N-1]
    θ0=[exp(-((x-π)/0.7)^2) for x in xs]              # even bump about π (θ even ✓)
    ω=zeros(N); θ=copy(θ0)
    pr(@sprintf("\n  IC: θ even bump @ x=π (σ=0.7), ω=0.  ∫θ=%.4f  ‖θ‖∞=%.3f", sum(θ)*2π/N, maximum(θ)))

    pr("\n"*dsh); pr("  EVOLVE (HL, inviscid): does ‖ω‖∞ blow up at x=π?  two-scale β → c_l∈(2,4.53)?"); pr(dsh)
    pr(@sprintf("    %-7s %-9s %-9s %-11s %-10s %-10s %-s","t","‖ω‖∞","x0(→π)","ℓ(spatial)","λ=1/A","tail","status"))
    dt=2e-4; t=0.0; thr=[2.0,4.0,8.0,16.0,32.0,64.0]; ti=1; As=Float64[]; Ls=Float64[]; ts=Float64[]; gated=false
    # θ-variance is NOT conserved (θ transported but ∫θ² conserved since θ_t=-uθ_x, ∇·u=... u_x=Hω≠0!)
    while t<6.0 && ti<=length(thr)
        step_rk4!(ω,θ,dt); t+=dt; A=maximum(abs.(ω))
        if A>=thr[ti]
            x0,Ai,ℓ,_=twoscale(ω,xs)
            Wh=fwd(ω); tot=sum(abs2,Wh); hi=sum(abs2(Wh[k+1]) for k in 0:N-1 if abs(keff(k,N))>N÷3*2÷3)
            tail=hi/tot
            if tail>0.02                                  # gated point: report but EXCLUDE from the β fit
                gated=true
                pr(@sprintf("    %-7.4f %-9.2f %-9.4f %-11.5f %-10.5f %-10.1e %s", t, Ai, x0, ℓ, 1/Ai, tail, "UNDER-RESOLVED — excluded from β"))
                pr("    ^ resolution gate: stop trusting past here (NOT used in β)."); break
            end
            push!(As,Ai); push!(Ls,ℓ); push!(ts,t)
            pr(@sprintf("    %-7.4f %-9.2f %-9.4f %-11.5f %-10.5f %-10.1e %s", t, Ai, x0, ℓ, 1/Ai, tail, "focusing")); ti+=1
        end
        (!isfinite(A)||A>1e7) && break
    end
    if length(As)>=3
        β=linfit(log.(1.0./As), log.(Ls))
        pr(@sprintf("\n    β = d lnℓ/d lnλ over the resolved window = %.3f", β))
        inrange = 2.0<β<4.53
        pr(@sprintf("    Chen–Hou–Huang admissible c_l ∈ (2, 4.53);  measured β %s the band %s",
            inrange ? "IS IN" : "is OUTSIDE", inrange ? "✓ (instrument validated on the HL anomalous exponent)" : "(see caveats)"))
    else
        pr("\n    fewer than 3 resolved thresholds — no β (run did not focus enough before the gate / tmax).")
    end

    pr("\n"*bar); pr("  READING (faithful Hou–Luo model)"); pr(bar)
    pr("  • The 1D HL model is the canonical Hou–Luo wall-stagnation reduction; Chen–Hou–Huang proved it")
    pr("    blows up self-similarly (smooth profiles) with ‖ω‖∞~(T−t)^{−1} and spatial exponent c_l∈(2,4.53).")
    pr("  • The (c1) two-scale instrument measures β=dlnℓ/dlnλ, which equals c_l for this scaling. If β lands")
    pr("    in (2,4.53), the instrument is validated on a KNOWN ANOMALOUS exponent (β≫1, unlike CLM's β=1) —")
    pr("    the strongest calibration in this arc. See the measured value above.")
    pr("  • FIREWALL: 1D HL MODEL (the Hou–Luo reduction), within-truncation, gated at the resolution wall.")
    pr("    NOT the literal 2D Boussinesq wall (heavier, IC-reconstruction-prone — the further step), and NOT")
    pr("    the Clay NS. :proved=0; distance UNTOUCHED.")
    pr(bar); close(fout); println(stdout,"\nwrote: $out")
end
main()
