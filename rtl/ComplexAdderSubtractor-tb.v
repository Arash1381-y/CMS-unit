module ComplexAdderSubtractorTB;
    reg [31:0] a, b;
    reg addNotSub;
    wire [31:0] result;
    integer i;

    ComplexAdderSubtractor #(.WIDTH(32)) caddsub(
        .a(a),
        .b(b),
        .addNotSub(addNotSub),
        .result(result)
    );

    initial begin
        a = 0;
        b = 0;
        #20;
        for (i = 0; i < 1000; i++) begin
            a = $random;
            b = $random;
            addNotSub = 1;
            #10;
            $display("%d + %d = %d", a, b, result);
            addNotSub = 0;
            #10;
            $display("%d - %d = %d", a, b, result);
        end
        $finish;
    end
endmodule