module ComplexMeanSquare (
    input clk,
    input reset,
    input start,
    // log_2 of number of number. Number of numbers must be power of two
    input [2:0] log2n,
    input [31:0] y,
    input [31:0] y_hat,
    // When next_number is 1, the user must place the next numebr in y and y_hat
    output reg next_number,
    output reg done,
    output reg [63:0] result
);
    // We calculate y - y_hat here
    wire [31:0] y_difference_wire;
    reg [31:0] y_difference;
    ComplexAdderSubtractor #(.WIDTH(32)) y_difference_module(
        .a(y),
        .b(y_hat),
        .addNotSub(1'b0),
        .result(y_difference_wire)
    );

    // Calculate y_difference^2
    reg cpow_calculator_start;
    wire cpow_calculator_done;
    wire [63:0] cpow_calculator_result;
    ComplexMultiplier #(.WIDTH(32)) cpow_calculator(
        .clk (clk),
        .start (cpow_calculator_start),
        .a (y_difference),
        .b (y_difference),
        .done (cpow_calculator_done),
        .result (cpow_calculator_result)
    );

    // This module sums the 
    wire [63:0] square_sum_result;
    ComplexAdderSubtractor #(.WIDTH(64)) square_sum(
        .a(result),
        .b(cpow_calculator_result),
        .addNotSub(1'b1),
        .result(square_sum_result)
    );

    // How many numbers we have seen?
    reg [8:0] count;

    // State management
    reg [2:0] state, next_state;
    localparam IDLE = 3'b000;
    localparam INIT = 3'b001;
    localparam READING = 3'b010;
    localparam COMPUTE_SQUARE = 3'b011;
    localparam FINALIZE = 3'b100;
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (start)
                    next_state = INIT;
                else
                    next_state = IDLE;
            end
            
            INIT: begin
                next_state = READING;
            end
            
            READING: begin
                next_state = COMPUTE_SQUARE;
            end

            COMPUTE_SQUARE: begin
                if (cpow_calculator_done) begin
                    if (count == 8'b1 << log2n)
                        next_state = FINALIZE;
                    else
                        next_state = READING;
                end else begin
                    next_state = COMPUTE_SQUARE;
                end
            end
            
            FINALIZE: begin
                next_state = IDLE;
            end

            default: begin
                // ERROR?
                next_state = IDLE;
            end
        endcase
    end

    // Datapath logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            next_number <= 0;
            done <= 0;
            result <= 0;

            count <= 0;
            y_difference <= 0;
            cpow_calculator_start <= 0;
        end else begin
            case (state)
                IDLE: begin
                    // NOP!
                end
                
                INIT: begin
                    next_number <= 1;
                    done <= 0;
                    result <= 0;

                    count <= 0;
                    y_difference <= 0;
                    cpow_calculator_start <= 0;
                end
                
                READING: begin
                    next_number <= 0;
                    y_difference <= y_difference_wire;
                    count <= count + 1;
                    cpow_calculator_start <= 1;
                end

                COMPUTE_SQUARE: begin
                    if (cpow_calculator_done) begin
                        cpow_calculator_start <= 0;
                        next_number <= count != (8'b1 << log2n);
                        result <= square_sum_result;
                    end
                end
                
                FINALIZE: begin
                    done <= 1;
                    result[31:0] <= $signed(result[31:0]) >>> log2n;
                    result[63:32] <= $signed(result[63:32]) >>> log2n;
                end

                default: begin
                    // Error?
                end
            endcase
        end
    end
endmodule