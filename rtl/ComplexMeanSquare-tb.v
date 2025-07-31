module ComplexMultiplierTB;
    reg clk, reset, start;
    reg [2:0] log2n;
    reg [31:0] y, y_hat;
    wire next_number, done;
    wire [63:0] result;

    ComplexMeanSquare cms(
        .clk(clk),
        .reset(reset),
        .start(start),
        .log2n(log2n),
        .y(y),
        .y_hat(y_hat),
        .next_number(next_number),
        .done(done),
        .result(result)
    );

    initial begin
        //$dumpfile("mean-square.vcd");
        //$dumpvars(0, ComplexMultiplierTB);
        clk = 0;
        start = 0;
        reset = 0;
        #10;
        reset = 1;
        #10;
        reset = 0;
        #10;
        start = 1;
        log2n = 3;
        while (1) begin
            while ((next_number | done) == 0) begin
                // Wait for next number
                #10;
            end
            if (done == 1) begin
                $display("%d", result);
                $finish;
            end
            y = $random;
            y_hat = y + ($random % 100);
            $display("%d %d", y, y_hat);
            #10;
        end
    end

    always #5 clk = ~clk;
endmodule