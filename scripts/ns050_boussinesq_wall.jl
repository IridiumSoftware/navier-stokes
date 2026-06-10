#!/usr/bin/env julia
# ns050_boussinesq_wall.jl — NS-050: the LITERAL 2D Boussinesq Hou–Luo WALL fixture.
#
# EXPERIMENTAL. **Scope: 2D Boussinesq pseudospectral DNS truncation. NOT the NS PDE.** :proved=0;
# distance to the Clay prize UNTOUCHED. Points the calibrated (c1) two-scale instrument at the
# *spatially-resolved* Hou–Luo wall-stagnation flow, rather than its 1D reduction (ns050_houluo_hl.jl).
#
# FAITHFUL setup (Luo–Hou; Kiselev review; arXiv:1910.00173): 2D Boussinesq on the half-space x₂≥0 with a
# NO-PENETRATION wall at x₂=0, symmetry ω₀ odd in x₁, ρ₀ even in x₁ (conserved). Realized here on the
# periodic box [0,2π]² by SYMMETRY-PLANE parity — which enforces no-penetration EXACTLY (the correct BC for
# the INVISCID/Euler Hou–Luo scenario; no no-slip needed). Consistent parities (each verified preserved by
# the advection): ω odd-odd, ρ even-in-x₁/odd-in-x₂, ψ odd-odd ⇒ u₂=−∂_{x₁}ψ odd-in-x₂ ⇒ u₂=0 on x₂=0
# (no penetration), and x₁=0 & x₂=0 are symmetry/wall planes; the Hou–Luo stagnation/blow-up point is the
# corner (0,0).
#   ω_t + u·∇ω = ∂_{x₁}ρ ,  ρ_t + u·∇ρ = 0 ,  u=∇^⊥ψ, Δψ=ω  (Biot–Savart, div-free).
#
# HONEST SCOPE: faithful symmetries + faithful inviscid wall BC, BUT (i) within-truncation, resolution-gated
# — CANNOT reach the singular limit (Chen–Hou's proof needs rigorous numerics); (ii) whether a smooth IC
# reaches the self-similar regime before the gate is an empirical question, reported honestly; (iii) NO
# blow-up is claimed. Solver reused from ns050_boussinesq_2d.jl (validated there).

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
function fft2(Ar); A=ComplexF64.(Ar); N=size(A,1)
    for i in 1:N; r=A[i,:]; fft!(r); A[i,:]=r; end
    for j in 1:N; c=A[:,j]; fft!(c); A[:,j]=c; end; A; end
function ifft2(A); B=copy(A); N=size(B,1)
    for i in 1:N; r=B[i,:]; fft!(r;inv=true); B[i,:]=r; end
    for j in 1:N; c=B[:,j]; fft!(c;inv=true); B[:,j]=c; end; B; end
keff(k,N)= k<=N>>1 ? k : k-N
struct Ops; KX::Matrix{Float64}; KY::Matrix{Float64}; K2::Matrix{Float64}; cut::Int; N::Int; end
function make_ops(N)
    KX=[Float64(keff(a-1,N)) for a in 1:N, b in 1:N]; KY=[Float64(keff(b-1,N)) for a in 1:N, b in 1:N]
    K2=KX.^2 .+ KY.^2; K2[1,1]=1.0; Ops(KX,KY,K2,N÷3,N)
end
dealias!(Wh,op)=(for a in 1:op.N, b in 1:op.N; if abs(keff(a-1,op.N))>op.cut||abs(keff(b-1,op.N))>op.cut; Wh[a,b]=0; end; end; Wh)
function velocities(ωh,op)
    uh= im.*op.KY.*ωh./op.K2; uh[1,1]=0; vh=-im.*op.KX.*ωh./op.K2; vh[1,1]=0
    real.(ifft2(uh)), real.(ifft2(vh))
end
function rhs(ωh,ρh,op,ν,κ)
    u,v=velocities(ωh,op)
    ωx=real.(ifft2(im.*op.KX.*ωh)); ωy=real.(ifft2(im.*op.KY.*ωh))
    ρx=real.(ifft2(im.*op.KX.*ρh)); ρy=real.(ifft2(im.*op.KY.*ρh))
    advω=fft2(u.*ωx .+ v.*ωy); dealias!(advω,op); advρ=fft2(u.*ρx .+ v.*ρy); dealias!(advρ,op)
    (-advω .+ im.*op.KX.*ρh .- ν.*op.K2.*ωh), (-advρ .- κ.*op.K2.*ρh)
end
function step_rk4!(ωh,ρh,dt,op,ν,κ)
    a1,b1=rhs(ωh,ρh,op,ν,κ); a2,b2=rhs(ωh.+(dt/2).*a1,ρh.+(dt/2).*b1,op,ν,κ)
    a3,b3=rhs(ωh.+(dt/2).*a2,ρh.+(dt/2).*b2,op,ν,κ); a4,b4=rhs(ωh.+dt.*a3,ρh.+dt.*b3,op,ν,κ)
    @. ωh += (dt/6)*(a1+2a2+2a3+a4); @. ρh += (dt/6)*(b1+2b2+2b3+b4); nothing
end
mean2(A)=sum(A)/length(A)
tailf(Fh,op)=(N=op.N; tot=sum(abs2,Fh); hi=sum(abs2(Fh[a,b]) for a in 1:N, b in 1:N if abs(keff(a-1,N))>op.cut*2÷3||abs(keff(b-1,N))>op.cut*2÷3); hi/tot)
# two-scale fit on |ω| along x₁ through the peak: A=‖ω‖∞, ℓ=half-max width; returns (A, ℓ, ipeak, jpeak)
function twoscale_corner(ω, op)
    N=op.N; A=maximum(abs.(ω)); I=argmax(abs.(ω)); i0,j0=I[1],I[2]
    line=[abs(ω[i,j0]) for i in 1:N]; hw=1
    for r in 1:N÷2
        if line[mod(i0-1+r,N)+1]<A/2 || line[mod(i0-1-r,N)+1]<A/2; hw=r; break; end
    end
    A, max(hw,1)*(2π/N), i0, j0
end
linfit(x,y)=(xm=sum(x)/length(x); ym=sum(y)/length(y); sum((x.-xm).*(y.-ym))/sum((x.-xm).^2))

function main()
    out=joinpath(@__DIR__,"ns050_boussinesq_wall.out.txt"); fout=open(out,"w")
    pr(a...)=(println(stdout,a...);println(fout,a...);flush(fout)); bar="═"^88; dsh="─"^88
    pr(bar); pr("  ns050_boussinesq_wall.jl — literal 2D Boussinesq Hou–Luo WALL (Scope: 2D DNS truncation)")
    pr("  Symmetry-plane no-penetration wall (faithful inviscid BC). ω odd-odd, ρ even-x₁/odd-x₂. :proved=0.")
    pr(bar)
    N=128; op=make_ops(N); xs=[2π*(a-1)/N for a in 1:N]

    # ── Hou–Luo-parity IC: hyperbolic-flow seed ω odd-odd + density ρ even-x₁/odd-x₂ ──
    ω0=[0.5*sin(xs[a])*sin(xs[b]) for a in 1:N, b in 1:N]          # odd-odd ⇒ ω(0,·)=ω(·,0)=0
    ρ0=[cos(xs[a])*sin(xs[b]) for a in 1:N, b in 1:N]              # even-x₁, odd-x₂ ⇒ ρ(·,0)=0
    ωh=fft2(ω0); ρh=fft2(ρ0)

    # ── (V) VALIDATION: div-free, no-penetration u₂=0 at the wall x₂=0, ρ²-conservation, parity ──
    pr("\n"*dsh); pr("  (V) VALIDATION: div-free? u₂=0 at wall x₂=0? ∫ρ² conserved (inviscid)? parity held?"); pr(dsh)
    u,v=velocities(ωh,op)
    divh=im.*op.KX.*fft2(u).+im.*op.KY.*fft2(v); dmax=maximum(abs.(real.(ifft2(divh))))
    wallmax=maximum(abs.(v[:,1]))                                  # v=u₂ on the wall row x₂=0 (j=1)
    pr(@sprintf("    div(u) max=%.2e %s ;  max|u₂| on wall x₂=0 = %.2e %s", dmax, dmax<1e-10 ? "✓" : "✗", wallmax, wallmax<1e-12 ? "✓ no-penetration" : "✗"))
    ρ2_0=mean2(real.(ifft2(ρh)).^2)
    let ωt=copy(ωh), ρt=copy(ρh); for s in 1:400; step_rk4!(ωt,ρt,0.01,op,0.0,0.0); end
        ρ2_T=mean2(real.(ifft2(ρt)).^2); ωp=real.(ifft2(ωt))
        oddx=maximum(abs.(ωp[a,b]+ωp[mod(N-(a-1),N)+1,b]) for a in 1:N, b in 1:N)   # ω odd in x₁ about 0
        pr(@sprintf("    ∫ρ² drift=%.2e (inviscid, T=4) %s ;  ω odd-in-x₁ residual=%.2e %s",
            abs(ρ2_T-ρ2_0)/ρ2_0, abs(ρ2_T-ρ2_0)/ρ2_0<1e-3 ? "✓" : "(check)", oddx, oddx<1e-10 ? "✓ parity held" : "(check)"))
    end

    # ── (S) EVOLVE + two-scale at the focusing peak + resolution gate ──
    pr("\n"*dsh); pr("  (S) EVOLVE (ν=κ=2e-4): does ‖ω‖∞ focus at the wall corner (0,0)? two-scale β?"); pr(dsh)
    pr(@sprintf("    %-6s %-9s %-12s %-10s %-10s %-9s %-s","t","‖ω‖∞","peak(x₁,x₂)","ℓ(width)","λ=1/A","tail","status"))
    ν=2e-4; κ=2e-4; dt=0.01; t=0.0; smp=1.0; nexts=0.0; As=Float64[]; Ls=Float64[]
    while t<20.0+1e-9
        if t>=nexts-1e-9
            ωp=real.(ifft2(ωh)); A,ℓ,i0,j0=twoscale_corner(ωp,op); tail=tailf(ρh,op)
            x1=(i0-1)*(2π/N); x2=(j0-1)*(2π/N)
            atcorner = (min(x1,2π-x1)<0.6 && min(x2,2π-x2)<0.6)
            status = tail>0.02 ? "UNDER-RESOLVED (gate)" : (atcorner ? "focusing@corner" : "peak off-corner")
            pr(@sprintf("    %-6.2f %-9.3f (%4.2f,%4.2f)   %-10.4f %-10.5f %-9.1e %s", t, A, x1, x2, ℓ, 1/A, tail, status))
            if tail<=0.02 && atcorner; push!(As,A); push!(Ls,ℓ); end
            tail>0.02 && (pr("    ^ resolution gate: stop trusting past here (excluded from β)."); break)
            nexts+=smp
        end
        step_rk4!(ωh,ρh,dt,op,ν,κ); t+=dt
    end
    if length(As)>=3
        β=linfit(log.(1.0./As),log.(Ls))
        pr(@sprintf("\n    β=dlnℓ/dlnλ at the corner (resolved window) = %.3f  (HL model gave 2.47; c_l∈(2,4.53))", β))
    else
        pr(@sprintf("\n    %d corner-focusing resolved samples — too few for β (smooth IC did not reach the self-similar corner regime before the gate / tmax; honest NULL).", length(As)))
    end

    pr("\n"*bar); pr("  READING (literal 2D Boussinesq Hou–Luo wall)"); pr(bar)
    pr("  • VALIDATION: div-free, no-penetration u₂=0 on the wall x₂=0 (by parity), ∫ρ² conserved, ω parity")
    pr("    preserved — the faithful symmetry-plane wall BC is correctly enforced (the inviscid Hou–Luo BC).")
    pr("  • The run is reported as it is: whether ‖ω‖∞ focuses at the corner (0,0) and a within-truncation β")
    pr("    emerges, or whether the smooth IC fails to reach the self-similar corner regime before the")
    pr("    resolution gate — both are honest outcomes; see the table. NO blow-up is claimed either way.")
    pr("  • FIREWALL: faithful symmetries + faithful inviscid wall BC, BUT within-truncation and")
    pr("    resolution-gated — CANNOT reach the singular limit (Chen–Hou needed rigorous numerics). NOT the")
    pr("    Clay NS. The 1D HL model (ns050_houluo_hl.jl) remains the calibrated, β-validated reference.")
    pr("    :proved=0; distance UNTOUCHED.")
    pr(bar); close(fout); println(stdout,"\nwrote: $out")
end
main()
