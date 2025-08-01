module ComplexMultiplierTB;
    // Our design for complex multiplier is combinational. Thus, we dont need clk, start and done
    reg [31:0] a, b;
    wire [63:0] result;
    integer i;

    ComplexMultiplier #(.WIDTH(32)) cmult(
        .a(a),
        .b(b),
        .result(result)
    );

    initial begin
        a = 0;
        b = 0;
        #20;
        for (i = 0; i < 1000; i++) begin
            a = $random;
            b = $random;
            #10;
            $display("%d * %d = %d", a, b, result);
        end
        $finish;
    end
endmodule