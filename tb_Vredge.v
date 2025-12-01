`timescale 1ns/1ps

module tb_Vredge;

    reg  clk;
    reg  rstb;
    reg  X;
    wire EDGE;

    // DUT
    Vredge dut (
        .clk  (clk),
        .rstb (rstb),
        .X    (X),
        .EDGE (EDGE)
    );

    // 1 ns clock period (like your other labs)
    initial begin
        clk = 1'b0;
        forever #500 clk = ~clk;   // 500 ps high, 500 ps low
    end

    // Reference model
    reg lastX;
    reg expected_EDGE;

    // Drive reset and X stimulus
    integer i;

    initial begin
        rstb = 1'b0;
        X    = 1'b0;
        lastX = 1'b0;
        expected_EDGE = 1'b0;

        // hold reset for a few cycles
        #(3*1000);
        rstb = 1'b1;

        // Change X every cycle with a pattern that has both
        // rising and falling transitions, plus some holds
        for (i = 0; i < 20; i = i + 1) begin
            @(negedge clk);
            case (i)
                0:  X = 0;   // no edge
                1:  X = 1;   // 0->1 edge
                2:  X = 1;   // hold 1
                3:  X = 0;   // 1->0 edge
                4:  X = 0;   // hold 0
                5:  X = 1;   // 0->1 edge
                default: X = ~X;  // toggle afterwards
            endcase
        end

        // let it run a bit, then finish
        #3000;
        $finish;
    end

    // Reference EDGE calculation and checker
    always @(posedge clk or negedge rstb) begin
        if (!rstb) begin
            lastX         <= 1'b0;
            expected_EDGE <= 1'b0;
        end else begin
            expected_EDGE <= (X != lastX);  // 1 if X changed
            lastX         <= X;

            if (EDGE !== expected_EDGE) begin
                $display("Mismatch at time %0t: X=%0b EDGE=%0b expected=%0b",
                         $time, X, EDGE, expected_EDGE);
                $stop;
            end
        end
    end

endmodule
