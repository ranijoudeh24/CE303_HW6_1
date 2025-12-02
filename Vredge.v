`timescale 1ns/1ps

module Vredge (
    input  wire clk,
    input  wire rstb,  
    input  wire X,
    output reg  EDGE   
);

    localparam [1:0]
        A = 2'b00,  
        B = 2'b01,
        C = 2'b10,   
        D = 2'b11;  

    reg [1:0] state, next_state;

    always @(posedge clk or negedge rstb) begin
        if (!rstb)
            state <= A;
        else
            state <= next_state;
    end

    always @* begin
        next_state = state;
        case (state)
            A: begin
                if (X)       next_state = B;  
            end

            B: begin
                if (X)       next_state = C;
                else        next_state = A;  
            end

            C: begin
                if (!X)      next_state = D; 
            end

            D: begin
                if (!X)      next_state = A;
                else        next_state = C;  
            end
        endcase
    end

    always @* begin
        case (state)
            B, D:   EDGE = 1'b1;
            default:EDGE = 1'b0;
        endcase
    end

endmodule
