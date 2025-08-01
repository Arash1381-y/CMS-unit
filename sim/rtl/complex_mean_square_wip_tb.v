`timescale 1ns / 1ps

module complex_mean_square_wip_tb;

	// Inputs
	reg i_clk;
	reg i_arst;
	reg i_en;
	reg [2:0] i_log2_samples;
	reg i_valid;
	reg [31:0] i_y;
	reg [31:0] i_y_hat;

	// Outputs
	wire o_valid;
	wire [63:0] o_data;

	// Instantiate the Unit Under Test (UUT)
	complex_mean_square uut (
		.i_clk(i_clk), 
		.i_arst(i_arst), 
		.i_en(i_en), 
		.i_log2_samples(i_log2_samples), 
		.i_valid(i_valid), 
		.i_y(i_y), 
		.i_y_hat(i_y_hat), 
		.o_valid(o_valid), 
		.o_data(o_data)
	);


    localparam CLK_PERIOD = 10; // 10 ns clock period (100 MHz)
    // 1. Clock Generation
    always begin
        i_clk = 1'b1;
        #(CLK_PERIOD / 2);
        i_clk = 1'b0;
        #(CLK_PERIOD / 2);
    end

	integer i = 0;
	initial begin
		 // Initialize Inputs
		 i_clk = 0;
		 i_arst = 1;
		 i_en = 0;
		 i_log2_samples = 3;  // for example, 8 samples
		 i_valid = 0;
		 i_y = 0;
		 i_y_hat = 0;
		 #20;
		 i_arst = 0;
		 #100;	 		 
		 i_en = 1;
		 #10;
		 i_valid = 1; 
		 while (1) begin
         if (o_valid == 1) begin
                $display("%d", o_data);
                $finish;
         end
			
			if (i < 1 << i_log2_samples) begin
				i_y = $random;
				i_y_hat = i_y + (($random % 5) << 16) + ($random % 3) + i;
				$display("%d %d", i_y, i_y_hat);
				i = i + 1;
			end else begin
				i_y = 0;
				i_y_hat = 0;
			end
			
			#10;
       end
	end
      
endmodule
