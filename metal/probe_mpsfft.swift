// metal/probe_mpsfft.swift — MPSGraph 3D FFT probe (the foundation of the Metal N=512 track).
// Answers: does Metal 4 (M5 Max) give a CORRECT + FAST GPU 3D FFT, so the spectral solver
// can move to GPU without hand-writing FFT kernels? RESULT (2026-06-02, M5 Max, macOS 26.5):
//   8³ complex roundtrip (fft∘ifft): max err 2.4e-7  PASS
//   N=256 forward 3D FFT: 0.0051 s/fft  (vs FFTW-18 CPU 0.0132 → 2.6×; vs hand-rolled-6 ~30×)
//   N=512 forward 3D FFT: 0.102 s/fft   ⇒ ~2 h for a T=10·2000-step run if FFT-bound
// ⇒ MPSGraph FFT is the engine; N=512 is in budget on this GPU. No custom FFT kernels needed.
//
// Build: swiftc -O probe_mpsfft.swift -o probe_mpsfft \
//          -framework Metal -framework MetalPerformanceShadersGraph -framework Foundation
// Run:   ./probe_mpsfft
import Foundation
import Metal
import MetalPerformanceShadersGraph

let device = MTLCreateSystemDefaultDevice()!
print("GPU: \(device.name)   unified-mem: \(device.recommendedMaxWorkingSetSize/1_000_000) MB")
func dims(_ n: Int) -> [NSNumber] { [NSNumber(value:n), NSNumber(value:n), NSNumber(value:n)] }

// ---- correctness: 8³ complex roundtrip (forward .none then inverse .size = identity) ----
do {
    let n = 8, cnt = n*n*n
    let g = MPSGraph()
    let x = g.placeholder(shape: dims(n), dataType: .complexFloat32, name: "x")
    let fd = MPSGraphFFTDescriptor(); fd.inverse = false; fd.scalingMode = .none
    let fwd = g.fastFourierTransform(x, axes: [0,1,2], descriptor: fd, name: "fwd")
    let id = MPSGraphFFTDescriptor(); id.inverse = true; id.scalingMode = .size
    let rt = g.fastFourierTransform(fwd, axes: [0,1,2], descriptor: id, name: "rt")
    let reals = (0..<cnt).map { _ in Float.random(in: -1...1) }
    var inter = [Float](); inter.reserveCapacity(cnt*2)
    for r in reals { inter.append(r); inter.append(0) }
    let buf = device.makeBuffer(bytes: inter, length: inter.count*MemoryLayout<Float>.stride, options: .storageModeShared)!
    let td = MPSGraphTensorData(buf, shape: dims(n), dataType: .complexFloat32)
    let res = g.run(feeds: [x: td], targetTensors: [rt], targetOperations: nil)
    var out = [Float](repeating: 0, count: cnt*2)
    res[rt]!.mpsndarray().readBytes(&out, strideBytes: nil)
    var maxerr: Float = 0
    for i in 0..<cnt { maxerr = max(maxerr, abs(out[2*i]-reals[i])); maxerr = max(maxerr, abs(out[2*i+1])) }
    print("8³ complex roundtrip (fft∘ifft): max err = \(maxerr)  \(maxerr < 1e-4 ? "PASS" : "FAIL")")
}

// ---- timing: forward 3D FFT at 256³ and 512³ ----
for N in [256, 512] {
    let g = MPSGraph()
    let x = g.placeholder(shape: dims(N), dataType: .complexFloat32, name: "x")
    let fd = MPSGraphFFTDescriptor(); fd.inverse = false; fd.scalingMode = .none
    let f = g.fastFourierTransform(x, axes: [0,1,2], descriptor: fd, name: "f")
    let bytes = N*N*N*2*MemoryLayout<Float>.stride
    guard let buf = device.makeBuffer(length: bytes, options: .storageModeShared) else {
        print("N=\(N): buffer alloc FAILED (\(bytes/1_000_000) MB)"); continue
    }
    let td = MPSGraphTensorData(buf, shape: dims(N), dataType: .complexFloat32)
    _ = g.run(feeds: [x: td], targetTensors: [f], targetOperations: nil)   // warmup (compile)
    let reps = N == 256 ? 10 : 3
    let t0 = DispatchTime.now()
    for _ in 0..<reps { _ = g.run(feeds: [x: td], targetTensors: [f], targetOperations: nil) }
    let dt = Double(DispatchTime.now().uptimeNanoseconds - t0.uptimeNanoseconds)/1e9/Double(reps)
    print("N=\(N) forward 3D FFT: \(String(format:"%.4f", dt)) s/fft   (\(bytes/1_000_000) MB/buf; ~36 ffts/step ⇒ \(String(format:"%.2f", dt*36*2000/3600)) h for T=10)")
}
