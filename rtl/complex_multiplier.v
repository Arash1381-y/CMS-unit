module complex_multiplier #(
    parameter WIDTH=32
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [2*WIDTH-1:0] result
);
    // Sign extend everything
    wire signed [WIDTH-1:0] a_real = { {(WIDTH/2+1){a[WIDTH/2-1]}}, a[WIDTH/2-1:0] };
    wire signed [WIDTH-1:0] b_real = { {(WIDTH/2+1){b[WIDTH/2-1]}}, b[WIDTH/2-1:0] };

    wire signed [WIDTH-1:0] a_img = { {(WIDTH/2+1){a[WIDTH-1]}}, a[WIDTH-1:WIDTH/2] };
    wire signed [WIDTH-1:0] b_img = { {(WIDTH/2+1){b[WIDTH-1]}}, b[WIDTH-1:WIDTH/2] };

    // Actual calculation
    wire signed [WIDTH-1:0] result_real = a_real * b_real - a_img * b_img;
    wire signed [WIDTH-1:0] result_img = a_real * b_img + a_img * b_real;

    assign result[WIDTH-1:0] = result_real;
    assign result[2*WIDTH-1:WIDTH] = result_img;
endmodule