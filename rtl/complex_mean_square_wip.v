module complex_mean_square (
    input wire i_clk,
    input wire i_arst,
    input wire i_en,

    input wire [2:0] i_log2_samples,

    input wire        i_valid,
    input wire [31:0] i_y,
    input wire [31:0] i_y_hat,
	
    output reg        o_valid,
    output reg [63:0] o_data
);
	
    // Internal wires
    wire [31:0] y_diff_w;
    wire [79:0] sq_diff_data_w;
    wire [63:0] sq_diff_complex_w;
    wire        sq_diff_valid_w;
    wire [63:0] sum_res_w;
    wire [8:0]  num_samples_w = 1 << i_log2_samples;
    
    // Internal registers
    reg [8:0]  sample_rx_cnt_r;
    reg [8:0]  sample_proc_cnt_r;
    reg [1:0]  state_r, next_state_r;

    // State machine parameters
    localparam S_IDLE      = 2'b00;
    localparam S_INIT      = 2'b01;
    localparam S_COMPUTING = 2'b10;
    localparam S_FINALIZE  = 2'b11;


    //--- Sub-module Instantiations ---//

    // Calculate difference: y - y_hat
    complex_adder_subtractor #(.WIDTH(32)) y_difference_module (
        .a(i_y),
        .b(i_y_hat),
        .addNotSub(1'b0),
        .result(y_diff_w)
    );

    // Calculate squared difference: (y - y_hat)^2
    assign sq_diff_complex_w = {sq_diff_data_w[71:40], sq_diff_data_w[31:0]};

    complex_multiplier_ip cpow_calculator (
        .aclk(i_clk),
        .aresetn(~i_arst),
        .s_axis_a_tvalid(i_valid),
        .s_axis_a_tdata(y_diff_w),
        .s_axis_b_tvalid(i_valid),
        .s_axis_b_tdata(y_diff_w),
        .m_axis_dout_tvalid(sq_diff_valid_w),
        .m_axis_dout_tdata(sq_diff_data_w)
    );

    // Accumulate the sum of squares
    complex_adder_subtractor #(.WIDTH(64)) square_sum (
        .a(o_data), // Accumulator
        .b(sq_diff_complex_w),
        .addNotSub(1'b1),
        .result(sum_res_w)
    );



    // State register
    always @(posedge i_clk or posedge i_arst) begin
        if (i_arst)
            state_r <= S_IDLE;
        else
            state_r <= next_state_r;
    end

    // Next-state logic
    always @(*) begin
        next_state_r = state_r;
        case (state_r)
            S_IDLE:      if (i_en) next_state_r = S_INIT;
            S_INIT:      next_state_r = S_COMPUTING;
            S_COMPUTING: if (sample_rx_cnt_r == num_samples_w && sample_proc_cnt_r == num_samples_w)
                             next_state_r = S_FINALIZE;
            S_FINALIZE:  next_state_r = S_IDLE;
            default:     next_state_r = S_IDLE;
        endcase
    end


    // Datapath Logic
    always @(posedge i_clk or posedge i_arst) begin
        if (i_arst) begin
            o_valid           <= 1'b0;
            o_data            <= 64'b0;

            sample_rx_cnt_r   <= 9'b0;
            sample_proc_cnt_r <= 9'b0;
        end else begin
            o_valid <= 1'b0; // Default de-assertion

            case (state_r)
                S_INIT: begin
                    o_data            <= 64'b0;
                    sample_rx_cnt_r   <= 9'b0;
                    sample_proc_cnt_r <= 9'b0;
                end

                S_COMPUTING: begin
                    sample_rx_cnt_r <= sample_rx_cnt_r;
                    sample_proc_cnt_r <= sample_proc_cnt_r;

                    if (i_valid && sample_rx_cnt_r < num_samples_w) begin
                        sample_rx_cnt_r <= sample_rx_cnt_r + 1;
                    end


                    if (sq_diff_valid_w && !(sample_proc_cnt_r == num_samples_w)) begin
                        sample_proc_cnt_r <= sample_proc_cnt_r + 1;
                        o_data <= sum_res_w;
                    end
                end

                S_FINALIZE: begin
							  o_valid        <= 1'b1; // Assert valid for one cycle
							  // Perform signed division via arithmetic shift
							  o_data[31:0]   <= $signed(o_data[31:0]) >>> i_log2_samples;
							  o_data[63:32]  <= $signed(o_data[63:32]) >>> i_log2_samples;
                end
            endcase
        end
    end

endmodule