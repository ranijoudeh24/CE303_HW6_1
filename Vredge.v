`timescale 1ns/1ps

module Vredge (
    input  wire clk,
    input  wire rstb,   // active–low reset
    input  wire X,
    output reg  EDGE    // Moore-type output
);

    // State encoding
    localparam [1:0]
        A = 2'b00,   // X was 0, no edge
        B = 2'b01,   // 0->1 edge pulse
        C = 2'b10,   // X was 1, no edge
        D = 2'b11;   // 1->0 edge pulse

    reg [1:0] state, next_state;

    // Sequential state register (non-blocking!)
    always @(posedge clk or negedge rstb) begin
        if (!rstb)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic
    always @* begin
        next_state = state;
        case (state)
            A: begin
                if (X)       next_state = B;  // 0->1 edge
            end

            B: begin
                // After edge pulse, remember X=1
                if (X)       next_state = C;
                else        next_state = A;   // defensive
            end

            C: begin
                if (!X)      next_state = D;  // 1->0 edge
            end

            D: begin
                // After edge pulse, remember X=0
                if (!X)      next_state = A;
                else        next_state = C;   // defensive
            end
        endcase
    end

    // Moore output logic
    always @* begin
        case (state)
            B, D:   EDGE = 1'b1;
            default:EDGE = 1'b0;
        endcase
    end

endmodule
