`timescale 1ns/100ps

module cordic_test;

    localparam integer SZ = 16;
    localparam integer CLK_PERIOD_NS = 10;  // 100 MHz clock
    localparam integer LATENCY_CYCLES = 16; // Set to your DUT's latency

    reg                    clock;
    reg         [31:0]     angle;
    reg signed [SZ-1:0]    Xin, Yin;
    wire signed [SZ:0]     Xout, Yout;

    integer i;

    // The input amplitude is scaled down to compensate for the
    // approximate CORDIC gain of 1.647.
    localparam integer VALUE = 19429; // Approximately 32000 / 1.647

    // DUT instance
    CORDIC dut (
        .clock      (clock),
        .angle      (angle),
        .Xin        (Xin),
        .Yin        (Yin),
        .Xout       (Xout),
        .Yout       (Yout)
    );

    // 100 MHz clock: 10 ns period
    initial begin
        clock = 1'b0;
        forever #(CLK_PERIOD_NS / 2) clock = ~clock;
    end

    initial begin
        $display("Starting CORDIC testbench");

        angle = 32'd0;
        Xin   = VALUE;
        Yin   = 0;

        // Allow time for initialization
        #1000;

        $display("Angle(deg)  angle[31:0]  Xout        Yout");

        // Sweep from 0 through 359 degrees
        for (i = 0; i < 360; i = i + 1) begin
            // Drive the angle away from the active clock edge.
            @(negedge clock);

            // Convert degrees to a 32-bit fractional-turn value:
            // 0 degrees   = 0x00000000
            // 90 degrees  = 0x40000000
            // 180 degrees = 0x80000000
            // 270 degrees = 0xC0000000
            angle = (64'd4294967296 * i) / 360;

            // Wait for the DUT to produce its result.
            repeat (LATENCY_CYCLES) @(posedge clock);
            #1;

            $display("%3d         %h   %d   %d",
                     i, angle, $signed(Xout), $signed(Yout));
        end

        $display("Simulation has finished");
        $finish;
    end

endmodule