module ComplexAdderSubtractor #(
    parameter WIDTH=32
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input addNotSub,
    output reg [WIDTH-1:0] result
);
    always @(*) begin
        if (addNotSub) begin
            // Add
            result[WIDTH-1:WIDTH/2] = a[WIDTH-1:WIDTH/2] + b[WIDTH-1:WIDTH/2];
            result[WIDTH/2-1:0] = a[WIDTH/2-1:0] + b[WIDTH/2-1:0];
        end else begin
            // Sub
            result[WIDTH-1:WIDTH/2] = a[WIDTH-1:WIDTH/2] - b[WIDTH-1:WIDTH/2];
            result[WIDTH/2-1:0] = a[WIDTH/2-1:0] - b[WIDTH/2-1:0];
        end
    end
endmodule