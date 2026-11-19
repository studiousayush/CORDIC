// 4-point radix-2 DIT FFT, combinational, signed integer samples.
// The 18-bit outputs preserve growth from summing 16-bit inputs.
module fft4_radix2 (
    input  wire signed [15:0] x0_re, x0_im,
    input  wire signed [15:0] x1_re, x1_im,
    input  wire signed [15:0] x2_re, x2_im,
    input  wire signed [15:0] x3_re, x3_im,
    output wire signed [17:0] X0_re, X0_im,
    output wire signed [17:0] X1_re, X1_im,
    output wire signed [17:0] X2_re, X2_im,
    output wire signed [17:0] X3_re, X3_im
);
    // First butterfly stage: even and odd indexed input pairs.
    wire signed [16:0] e0_re = x0_re + x2_re;
    wire signed [16:0] e0_im = x0_im + x2_im;
    wire signed [16:0] e1_re = x0_re - x2_re;
    wire signed [16:0] e1_im = x0_im - x2_im;
    wire signed [16:0] o0_re = x1_re + x3_re;
    wire signed [16:0] o0_im = x1_im + x3_im;
    wire signed [16:0] o1_re = x1_re - x3_re;
    wire signed [16:0] o1_im = x1_im - x3_im;

    // W4^0 = 1 and W4^1 = -j. Multiplication by -j is (im, -re).
    assign X0_re = e0_re + o0_re;
    assign X0_im = e0_im + o0_im;
    assign X2_re = e0_re - o0_re;
    assign X2_im = e0_im - o0_im;
    assign X1_re = e1_re + o1_im;
    assign X1_im = e1_im - o1_re;
    assign X3_re = e1_re - o1_im;
    assign X3_im = e1_im + o1_re;
endmodule
