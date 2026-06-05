#!/usr/bin/env julia
# active_turbulence_agents.jl — NS-043 (Phase 2): discrete active-dipole AGENTS.
#
# SCOPE: phenomenology / 2D active-turbulence truncation. **NOT the NS PDE.**
#
# The active-matter coupling: discrete self-propelled agents ("creatures") swim in
# the FAITHFUL fluid (NS-041), sense it, steer by the ported fluoddity Fourier brain,
# and force it back as NET-ZERO force DIPOLES — the physically-correct active-swimmer
# forcing, and the fix for fluoddity's momentum-MONOPOLE splat. Each agent per step:
#   (1) SENSE: bilinear-interpolate the velocity at two sensors (±sensorAngle, in the
#       agent's own frame), project to (forward,left) — rotation-invariant input to a
#       mirror-symmetric 10-center sum-of-sines brain (ported from fluoddity
#       Shaders.swift:195–249) → (axial thrust, turn).
#   (2) FORCE the fluid as a DIPOLE: +f·p̂ at the head (x+ℓ/2 p̂), −f·p̂ at the tail
#       (x−ℓ/2 p̂), each spread by a NORMALIZED Gaussian immersed-boundary kernel
#       (Σ weights = 1) ⇒ the dipole injects EXACTLY ZERO net momentum (pusher).
#       The fluid feels (∇×f)_z (NS-041's curl hook — no extra projection).
#   (3) ADVECT + reorient: ẋ = u(x) + v_swim·p̂; heading turns by the brain command +
#       the local vorticity ω(x)/2 (the physical leading-order co-rotation).
#
# AT-03 (→ TEST_SPEC T-18): the dipole forcing injects net grid momentum ≈ 0 to
# MACHINE PRECISION — *the* check that the forcing is a faithful active swimmer, the
# property fluoddity's monopole splat violates (shown by the monopole contrast).
# Plus a stable coupled run (creatures swim, fluid responds, invariants bounded).

using Printf
using Random

# ── fluid primitives (the NS-041/042 core) ──
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
function fft2(Ar); A=ComplexF64.(Ar); N=size(A,1)
    for i in 1:N; r=A[i,:]; fft!(r); A[i,:]=r; end
    for jc in 1:N; c=A[:,jc]; fft!(c); A[:,jc]=c; end; A; end
function ifft2(A); B=copy(A); N=size(B,1)
    for i in 1:N; r=B[i,:]; fft!(r;inv=true); B[i,:]=r; end
    for jc in 1:N; c=B[:,jc]; fft!(c;inv=true); B[:,jc]=c; end; B; end
keff(k,N)= k<=N>>1 ? k : k-N
function make_ops(N)
    kx=[Float64(keff(a-1,N)) for a in 1:N, b in 1:N]
    ky=[Float64(keff(b-1,N)) for a in 1:N, b in 1:N]
    k2=kx.^2 .+ ky.^2; k2p=copy(k2); k2p[1,1]=1.0
    cut=N÷3; deal=[abs(keff(a-1,N))<=cut && abs(keff(b-1,N))<=cut for a in 1:N, b in 1:N]
    (kx=kx,ky=ky,k2=k2,k2p=k2p,deal=deal)
end
function nonlin(W, op)
    ψ = W ./ op.k2p; ψ[1,1] = 0
    u  = real.(ifft2(-im .* op.ky .* ψ)); v  = real.(ifft2( im .* op.kx .* ψ))
    ωx = real.(ifft2( im .* op.kx .* W)); ωy = real.(ifft2( im .* op.ky .* W))
    Aadv = fft2(u .* ωx .+ v .* ωy); Aadv[.!op.deal] .= 0; -Aadv
end
function step!(W, dt, op, S, E, E2)   # IF-RK4, G(W)=nonlin(W)+S (S = active forcing this step)
    k1 = dt .* (nonlin(W, op) .+ S)
    k2 = dt .* (nonlin(E2 .* (W .+ k1 ./ 2), op) .+ S)
    k3 = dt .* (nonlin(E2 .* W .+ k2 ./ 2, op) .+ S)
    k4 = dt .* (nonlin(E .* W .+ E2 .* k3, op) .+ S)
    @. W = E*W + (E*k1 + 2*E2*(k2+k3) + k4)/6; W
end
energy(W,op) = 0.5*sum(abs2.(W)./op.k2p)/length(W)^2
enstrophy(W) = 0.5*sum(abs2.(W))/length(W)^2

# velocity (U,V) and vorticity (Wr) in real space from ω̂
function fields(W, op)
    ψ = W ./ op.k2p; ψ[1,1]=0
    real.(ifft2(-im .* op.ky .* ψ)), real.(ifft2(im .* op.kx .* ψ)), real.(ifft2(W))
end

# ── agents: bilinear interp, ported Fourier brain, normalized Gaussian spread ──
@inline function bilin(F, gx, gy, N)         # F[i,j], grid coords gx,gy ∈ [0,N)
    i0=floor(Int,gx); j0=floor(Int,gy); fx=gx-i0; fy=gy-j0
    i1=mod(i0,N)+1; i2=mod(i0+1,N)+1; j1=mod(j0,N)+1; j2=mod(j0+1,N)+1
    (1-fx)*(1-fy)*F[i1,j1] + fx*(1-fy)*F[i2,j1] + (1-fx)*fy*F[i1,j2] + fx*fy*F[i2,j2]
end
# 10-center sum-of-sines 4D→4D (fluoddity brain): rule = [10×freq4 ; 10×amp4]
@inline function brain(rule, x1,x2,x3,x4)
    o1=0.0;o2=0.0;o3=0.0;o4=0.0
    @inbounds for i in 0:9
        s = sin(rule[4i+1]*x1 + rule[4i+2]*x2 + rule[4i+3]*x3 + rule[4i+4]*x4)
        o1+=rule[40+4i+1]*s; o2+=rule[40+4i+2]*s; o3+=rule[40+4i+3]*s; o4+=rule[40+4i+4]*s
    end
    (o1,o2,o3,o4)
end
# normalized Gaussian spread of a point force (Fx,Fy) at grid pos (gx,gy): Σweights=1
@inline function spread!(fxg, fyg, gx, gy, Fx, Fy, N, invσ2, half)
    i0=floor(Int,gx); j0=floor(Int,gy); sw=0.0
    @inbounds for di in -half:half, dj in -half:half
        sw += exp(-(((i0+di)-gx)^2+((j0+dj)-gy)^2)*invσ2)
    end
    inv=1.0/sw
    @inbounds for di in -half:half, dj in -half:half
        w = exp(-(((i0+di)-gx)^2+((j0+dj)-gy)^2)*invσ2)*inv
        ii=mod(i0+di,N)+1; jj=mod(j0+dj,N)+1
        fxg[ii,jj]+=Fx*w; fyg[ii,jj]+=Fy*w
    end
end

# build the dipole force field from the agents (returns fxg,fyg + the net momentum)
function agent_forces!(fxg, fyg, px, py, th, U, V, rule, par, N)
    fill!(fxg,0.0); fill!(fyg,0.0)
    dxg = N/(2π)                                   # physical→grid scale
    for a in 1:length(px)
        gx=px[a]*dxg; gy=py[a]*dxg
        hx=cos(th[a]); hy=sin(th[a]); lx=-hy; ly=hx   # forward, left
        # two sensors (±sensorAngle, sensorDist) in the agent frame
        sa=par.sensorAngle; sd=par.sensorDist*dxg
        cR=cos(sa); sR=sin(sa)
        fLx=hx*cR-hy*sR; fLy=hx*sR+hy*cR             # rotate(fwd,+sa)
        fRx=hx*cR+hy*sR; fRy=-hx*sR+hy*cR            # rotate(fwd,-sa)
        uL=bilin(U,gx+fLx*sd,gy+fLy*sd,N); vL=bilin(V,gx+fLx*sd,gy+fLy*sd,N)
        uR=bilin(U,gx+fRx*sd,gy+fRy*sd,N); vR=bilin(V,gx+fRx*sd,gy+fRy*sd,N)
        L1=(uL*hx+vL*hy)*par.senseScale; L2=(uL*lx+vL*ly)*par.senseScale
        R1=(uR*hx+vR*hy)*par.senseScale; R2=(uR*lx+vR*ly)*par.senseScale
        b1,b2,_,_ = brain(rule, L1,L2,R1,R2)         # mirror-symmetric:
        m1,m2,_,_ = brain(rule, R1,-R2,L1,-L2)
        axial=b1+m1                                  # reflection-even (thrust)
        # swim speed + dipole thrust magnitude from the brain
        vsw = clamp(par.swim*(1+axial*par.speedGain), 0.2*par.swim, 2.0*par.swim)
        fmag = par.forceGain*vsw
        hl = par.dipL*dxg/2                           # half dipole length (grid)
        spread!(fxg,fyg, gx+hx*hl, gy+hy*hl,  fmag*hx,  fmag*hy, N, par.invσ2, par.half) # head +f
        spread!(fxg,fyg, gx-hx*hl, gy-hy*hl, -fmag*hx, -fmag*hy, N, par.invσ2, par.half) # tail −f
    end
    sum(fxg), sum(fyg)
end

function main()
    out=joinpath(@__DIR__,"active_turbulence_agents.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...);flush(fout))
    bar="═"^78
    pr(bar); pr("  active_turbulence_agents.jl — NS-043 Phase 2: discrete active-dipole AGENTS")
    pr("  Scope: phenomenology (2D active-turbulence). NOT the NS PDE.")
    pr(bar)

    N=128; op=make_ops(N)
    ν=1.5e-4; μ=0.5; kdrag=3.0; dt=0.005
    nag=1500
    par=(swim=0.35, sensorDist=0.10, sensorAngle=0.40, senseScale=2.0, speedGain=0.5,
         turn=0.4, forceGain=2.5, dipL=0.12, invσ2=1.0, half=3)
    pr(@sprintf("\n  N=%d, agents=%d, ν=%.1e, drag μ=%.2f(k<%.0f), dt=%.3f", N, nag, ν, μ, kdrag, dt))
    pr(@sprintf("  agent: swim=%.2f sensorDist=%.2f forceGain=%.1f dipoleL=%.2f (pusher, net-zero dipole)",
        par.swim, par.sensorDist, par.forceGain, par.dipL))

    drag=[ sqrt(op.k2[a,b])<kdrag ? μ : 0.0 for a in 1:N, b in 1:N ]
    L=-(ν.*op.k2 .+ drag); E=exp.(L.*dt); E2=exp.(L.*(dt/2))

    rng=MersenneTwister(20260605)
    rule=zeros(80)
    for i in 1:40; rule[i]=2*(2rand(rng)-1); end       # freqs ∈ (−2,2)
    for i in 41:80; rule[i]=(2rand(rng)-1); end         # amps  ∈ (−1,1)
    px=2π.*rand(rng,nag); py=2π.*rand(rng,nag); th=2π.*rand(rng,nag)
    W=fft2(1e-3 .* randn(rng,N,N))
    fxg=zeros(N,N); fyg=zeros(N,N)
    U,V,Wr = fields(W,op)

    # ── AT-03: dipole momentum-neutrality vs the monopole contrast ──
    mx,my = agent_forces!(fxg,fyg, px,py,th, U,V, rule, par, N)
    scale = sum(abs.(fxg))+sum(abs.(fyg))                # total |force| for relative measure
    # monopole reference: same heads, NO tails → net = Σ f·p̂ ≠ 0
    fmx=copy(fxg); fmy=copy(fyg)                         # (dipole field; recompute monopole)
    fill!(fmx,0.0); fill!(fmy,0.0); dxg=N/(2π)
    for a in 1:nag
        hx=cos(th[a]); hy=sin(th[a]); vsw=par.swim; fmag=par.forceGain*vsw
        spread!(fmx,fmy, px[a]*dxg, py[a]*dxg, fmag*hx, fmag*hy, N, par.invσ2, par.half)
    end
    pr("\n  (AT-03) NET MOMENTUM injected by the agent forcing (must be ≈0 for a faithful swimmer):")
    pr(@sprintf("    DIPOLE   (faithful):  |Σf| = (%.2e, %.2e)   relative = %.2e", mx, my, (abs(mx)+abs(my))/scale))
    pr(@sprintf("    MONOPOLE (fluoddity): |Σf| = (%.2e, %.2e)   relative = %.2e",
        sum(fmx), sum(fmy), (abs(sum(fmx))+abs(sum(fmy)))/(sum(abs.(fmx))+sum(abs.(fmy)))))
    at03 = (abs(mx)+abs(my))/scale < 1e-12
    pr(@sprintf("  ⇒ dipole net momentum is machine-zero (%s); the monopole is O(1) ⇒ unphysical. AT-03: %s",
        at03 ? "✓" : "✗", at03 ? "PASS" : "CHECK"))

    # ── coupled run: creatures swim, fluid responds, invariants bounded ──
    pr("\n  COUPLED RUN (agents ⟷ faithful fluid):")
    pr(@sprintf("    %-8s %-12s %-12s %-12s", "step","E","Z","mean|vel|agents"))
    steps=1500; finite=true; disp=0.0
    for s in 1:steps
        U,V,Wr = fields(W,op)
        mx,my = agent_forces!(fxg,fyg, px,py,th, U,V, rule, par, N)
        S = im .* (op.kx .* fft2(fyg) .- op.ky .* fft2(fxg)); S[.!op.deal] .= 0   # (∇×f)_z
        step!(W, dt, op, S, E, E2)
        # advance agents: sense u + ω at position, swim + co-rotate
        dxg=N/(2π); sp=0.0
        for a in 1:nag
            gx=px[a]*dxg; gy=py[a]*dxg
            u=bilin(U,gx,gy,N); v=bilin(V,gx,gy,N); ω=bilin(Wr,gx,gy,N)
            hx=cos(th[a]); hy=sin(th[a]); lx=-hy; ly=hx
            sd=par.sensorDist*dxg; sa=par.sensorAngle; cR=cos(sa); sR=sin(sa)
            fLx=hx*cR-hy*sR; fLy=hx*sR+hy*cR; fRx=hx*cR+hy*sR; fRy=-hx*sR+hy*cR
            uL=bilin(U,gx+fLx*sd,gy+fLy*sd,N); vL=bilin(V,gx+fLx*sd,gy+fLy*sd,N)
            uR=bilin(U,gx+fRx*sd,gy+fRy*sd,N); vR=bilin(V,gx+fRx*sd,gy+fRy*sd,N)
            L1=(uL*hx+vL*hy)*par.senseScale; L2=(uL*lx+vL*ly)*par.senseScale
            R1=(uR*hx+vR*hy)*par.senseScale; R2=(uR*lx+vR*ly)*par.senseScale
            b1,b2,_,_=brain(rule,L1,L2,R1,R2); m1,m2,_,_=brain(rule,R1,-R2,L1,-L2)
            axial=b1+m1; turnT=b2-m2
            th[a] += (turnT*par.turn + 0.5*ω)*dt          # brain turn + co-rotation ω/2
            vsw=clamp(par.swim*(1+axial*par.speedGain),0.2*par.swim,2.0*par.swim)
            px[a]=mod(px[a]+(u+vsw*hx)*dt, 2π); py[a]=mod(py[a]+(v+vsw*hy)*dt, 2π)
            sp += vsw
        end
        if !isfinite(energy(W,op)); finite=false; break; end
        if s % (steps÷6)==0
            pr(@sprintf("    %-8d %-12.5f %-12.3f %-12.4f", s, energy(W,op), enstrophy(W), sp/nag))
        end
    end
    stable = finite && isfinite(energy(W,op))
    pr(@sprintf("\n  coupled run %s (E=%.4f, Z=%.3f, finite=%s).",
        stable ? "STABLE" : "UNSTABLE", energy(W,op), enstrophy(W), string(finite)))

    pr("\n"*bar); pr("  READING (NS-043 Phase 2)")
    pr(bar)
    pr("  • Discrete active agents swim in the faithful fluid, sense it, steer by the ported")
    pr("    fluoddity brain, and force it as NET-ZERO dipoles (AT-03 machine-zero) — the physical")
    pr("    active-swimmer forcing, fixing fluoddity's momentum-monopole splat (O(1) net, shown).")
    pr("  • Phase 3 asks: does lifelike organization emerge (vortex/agent census, E(k) shift)?")
    pr("  • FIREWALL: Scope phenomenology, NOT the PDE. Distance to prize: UNTOUCHED.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
    return at03 && stable
end

ok = main()
exit(ok ? 0 : 1)
