module mcu_subsys_rom (
    input logic         clk,
    input logic         rst_n,
    input logic         mem_valid,
    output logic        mem_ready,
    input logic [31:0]  mem_addr,
    input logic [31:0]  mem_wdata,
    input logic [3:0]   mem_wstrb,
    output logic [31:0] mem_rdata);

    logic [31:0] rdata_next;

    always_comb begin
		unique case (mem_addr[15:2])
			14'h020: rdata_next = 32'h40010137;
			14'h021: rdata_next = 32'h0040006f;
			14'h022: rdata_next = 32'h80000737;
			14'h023: rdata_next = 32'h00100793;
			14'h024: rdata_next = 32'h00f72223;
			14'h025: rdata_next = 32'h06400793;
			14'h026: rdata_next = 32'hfff78793;
			14'h027: rdata_next = 32'hfe079ee3;
			14'h028: rdata_next = 32'h00072783;
			14'h029: rdata_next = 32'h0017c793;
			14'h02a: rdata_next = 32'h00f72023;
			14'h02b: rdata_next = 32'hfe9ff06f;
			14'h02c: rdata_next = 32'h80000000;
			14'h02d: rdata_next = 32'h80000000;
			default: rdata_next = 32'h00000000;
		endcase // case (instr_addr_i)
    end // always_comb

    always_ff @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            mem_rdata <= 32'h0;
            mem_ready <= 1'b0;
        end else begin
            mem_rdata <= rdata_next;
            mem_ready <= mem_valid;
        end
    end

endmodule // mcu_subsys_rom
