module mcu_subsys_sram (
    input logic         clk,
    input logic         rst_n,
    input logic         mem_valid,
    output logic        mem_ready,
    input logic [31:0]  mem_addr,
    input logic [31:0]  mem_wdata,
    input logic [3:0]   mem_wstrb,
    output logic [31:0] mem_rdata);

    logic [255:0] [31:0] mem;

    always_ff @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            mem_ready <= 1'b0;
            mem_rdata <= 32'h0;
        end else begin
            mem_rdata <= mem[mem_addr[7:0]];

            if(mem_valid) begin
                mem_ready <= 1'b1;
                if(mem_wstrb[0]) mem[mem_addr[7:0]][7:0] <= mem_wdata[7:0];
                if(mem_wstrb[1]) mem[mem_addr[7:0]][15:8] <= mem_wdata[15:8];
                if(mem_wstrb[2]) mem[mem_addr[7:0]][23:16] <= mem_wdata[23:16];
                if(mem_wstrb[3]) mem[mem_addr[7:0]][31:24] <= mem_wdata[31:24];
            end else begin
                mem_ready <= 1'b0;
            end
        end
    end

endmodule // mcu_subsys_sram
