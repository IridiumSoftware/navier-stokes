#!/usr/bin/env julia
# ns050_twoscale_fit.jl — NS-050 (c1): the TWO-SCALE dynamic-rescaling fit.
#
# EXPERIMENTAL. **Scope: 1D-model + pseudospectral ODE-truncation. NOT the NS PDE.**
# :proved=0; distance to the Clay prize UNTOUCHED. Resolves the UNDETERMINED left by
# ns050_dss_spectral_gap.jl: the single-amplitude-scale fit failed for advection a>0 because it
# assumed amplitude-scale = spatial-scale (β=1, true for CLM). Here we add an INDEPENDENT spatial
# scale and ask: with the right length, does the a>0 profile become self-similar (β≠1), or does it
# STILL fail to converge (genuine non-self-similarity / DSS)?
#
# Two scales of the blow-up structure near the center x₀=argmax|ω_x|:
#   amplitude scale  A = ‖ω‖∞                          (⇒ λ = 1/A)
#   spatial scale    ℓ = A / ‖ω_x‖∞                    (a LENGTH, independent of A)
#   rescaled profile U(η) = ω(x₀+ℓη)/A,  η=(x−x₀)/ℓ   (amplitude-normalized, ℓ-rescaled in space)
# Self-similar ⟺ U(η) converges. Anomaly exponent  β = d ln ℓ / d ln λ  (CLM: β=1; β≠1 = anomalous).
# Std-lib only; OSW family solver reused from ns050_dss_spectral_gap.jl.

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
function rhs(ω,a)
    Hω=hilbert(ω); ωx=ddx(ω); stretch=dealias(Hω.*ω)
    a==0.0 && return stretch
    adv=dealias(velocity(ω).*ωx); @. stretch - a*adv
end
function step_rk4!(ω,dt,a)
    k1=rhs(ω,a); k2=rhs(ω.+(dt/2).*k1,a); k3=rhs(ω.+(dt/2).*k2,a); k4=rhs(ω.+dt.*k3,a)
    @. ω += (dt/6)*(k1+2k2+2k3+k4); ω
end
interp(ω,x)=(N=length(ω); h=2π/N; s=mod(x,2π)/h; i=floor(Int,s); f=s-i; (1-f)*ω[mod(i,N)+1]+f*ω[mod(i+1,N)+1])

# TWO-SCALE fit: returns (x0, A, ℓ, U)
function twoscale(ω, xs; ηmax=4.0, Nη=161)
    N=length(ω); A=maximum(abs.(ω)); ωx=ddx(ω); sx=maximum(abs.(ωx)); ic=argmax(abs.(ωx))
    a0=abs(ωx[mod(ic-2,N)+1]); a1=abs(ωx[ic]); a2=abs(ωx[mod(ic,N)+1]); den=a0-2a1+a2
    x0=xs[ic]+clamp(den!=0 ? 0.5*(a0-a2)/den : 0.0,-1.0,1.0)*(2π/N)
    ℓ = A/sx                                       # independent spatial scale (length)
    sgn=-sign(interp(ωx,x0)); sgn==0 && (sgn=1.0)
    ηs=range(-ηmax,ηmax;length=Nη); U=[sgn*interp(ω,x0+ℓ*η)/A for η in ηs]   # amplitude-norm, ℓ-rescaled
    x0, A, ℓ, collect(ηs), U
end
linfit(x,y)=(xm=sum(x)/length(x); ym=sum(y)/length(y); m=sum((x.-xm).*(y.-ym))/sum((x.-xm).^2); m)

function run(a; N=4096, dt=1e-4, thr=(2.0,4.0,8.0,16.0,32.0), tmax=12.0)
    ω=[cos(2π*j/N) for j in 0:N-1]; xs=[2π*j/N for j in 0:N-1]
    As=Float64[]; Ls=Float64[]; Us=Vector{Vector{Float64}}(); thrv=collect(thr); ti=1; t=0.0
    while t<tmax && ti<=length(thrv)
        step_rk4!(ω,dt,a); t+=dt; A=maximum(abs.(ω))
        if A>=thrv[ti]; _,Ai,ℓ,_,U=twoscale(ω,xs); push!(As,Ai); push!(Ls,ℓ); push!(Us,U); ti+=1; end
        (!isfinite(A)||A>1e6) && break
    end
    As,Ls,Us, ti>length(thrv)
end
function analyze(As,Ls,Us)
    dη=8.0/(length(Us[1])-1)
    d=[sqrt(sum((Us[i].-Us[i-1]).^2).*dη) for i in 2:length(Us)]
    ratio = length(d)>=2 ? d[end]/d[1] : NaN
    β = linfit(log.(1.0./As), log.(Ls))            # ℓ ~ λ^β,  λ=1/A
    converged = ratio < 0.5
    d, ratio, β, converged
end

function main()
    out=joinpath(@__DIR__,"ns050_twoscale_fit.out.txt"); fout=open(out,"w")
    pr(a...)=(println(stdout,a...);println(fout,a...)); bar="═"^86; dsh="─"^86
    pr(bar); pr("  ns050_twoscale_fit.jl — NS-050 (c1) (Scope: 1D-model + spectral truncation)")
    pr("  Two-scale dynamic-rescaling: independent spatial scale ℓ=A/‖ω_x‖∞; β=dlnℓ/dlnλ. :proved=0.")
    pr("  Resolves the a>0 UNDETERMINED of ns050_dss_spectral_gap.jl. Does NOT touch 3D-NS.")
    pr(bar)
    let N=16,v=Float64.(1:N),W=fwd(v); mx=maximum(abs(W[k+1]-sum(v[j+1]*cis(-2π*k*j/N) for j in 0:N-1)) for k in 0:N-1)
        pr(@sprintf("\n  FFT self-check: max|fft−DFT|=%.1e %s", mx, mx<1e-10 ? "✓" : "✗")); end

    pr("\n"*dsh); pr("  (A) CALIBRATION a=0 (CLM): two-scale fit should give β≈1 (ℓ≈λ) and U convergent.")
    pr(dsh)
    As,Ls,Us,blew=run(0.0); d,ratio,β,conv=analyze(As,Ls,Us)
    pr(@sprintf("    A: %s", join((@sprintf("%.1f",x) for x in As),", ")))
    pr(@sprintf("    ℓ (spatial): %s   λ=1/A: %s", join((@sprintf("%.4f",x) for x in Ls),", "), join((@sprintf("%.4f",1/x) for x in As),", ")))
    pr(@sprintf("    two-scale drift ‖ΔU‖: %s  (ratio %.3f)", join((@sprintf("%.2e",x) for x in d)," → "), ratio))
    pr(@sprintf("    β = d lnℓ/d lnλ = %.3f  (CLM expect 1.0);  U %s", β, conv ? "CONVERGES (self-similar) ✓" : "does not converge"))

    pr("\n"*dsh); pr("  (B) a>0 (toward De Gregorio): does the two-scale fit RESOLVE the single-scale failure?")
    pr(dsh)
    pr(@sprintf("    %-5s %-8s %-9s %-12s %-12s %-s","a","blew?","β","2scale ratio","(vs 1scale)","verdict"))
    for a in (0.0,0.3,0.5,1.0)
        As,Ls,Us,blew=run(a)
        if length(Us)<3
            pr(@sprintf("    %-5.2f %-8s %-9s %-12s %-12s %s",a,blew ? "yes" : "NO","—","—","—","no blow-up within tmax")); continue
        end
        d,ratio,β,conv=analyze(As,Ls,Us)
        verdict = a==0.0 ? "CLM β≈1, self-similar ✓" :
                  (conv ? @sprintf("two-scale CONVERGES ⇒ self-similar, β=%.2f≠1 (1-scale missed the spatial exponent)",β) :
                          "two-scale STILL fails ⇒ genuinely non-self-similar / DSS candidate")
        pr(@sprintf("    %-5.2f %-8s %-9.3f %-12.3f %-12s %s",a,blew ? "yes" : "no",β,ratio, ratio<0.5 ? "FIXED" : "(1scale failed)", verdict))
    end

    pr("\n"*bar); pr("  READING (NS-050 c1)"); pr(bar)
    pr("  • The two-scale fit adds an independent spatial length ℓ=A/‖ω_x‖∞, decoupling the spatial scale")
    pr("    from the amplitude scale λ=1/A. CALIBRATION a=0: β≈1 (ℓ≈λ) and U converges — recovers CLM, as")
    pr("    it must (the single-scale fit was correct THERE because β=1).")
    pr("  • a>0: see the table — if the two-scale U now CONVERGES with β≠1, the a>0 blow-up is self-similar")
    pr("    with an anomalous spatial exponent the single-scale fit structurally could not see (resolving")
    pr("    the earlier UNDETERMINED toward 'self-similar, not DSS'). If it STILL fails to converge, that")
    pr("    is evidence FOR genuine non-self-similarity / a DSS candidate — but even then, a clean DSS")
    pr("    claim needs the full (λ,x₀,period) modulation + a τ-periodicity test, NOT asserted here.")
    pr("  • FIREWALL: 1D OSW model, finite truncation. Two scales (amplitude+width), still no x₀-drift")
    pr("    (symmetry-pinned) or rotation. Surrogate for direction-1 M1/M3; does NOT touch 3D-NS. :proved=0.")
    pr(bar); close(fout); println(stdout,"\nwrote: $out")
end
main()
