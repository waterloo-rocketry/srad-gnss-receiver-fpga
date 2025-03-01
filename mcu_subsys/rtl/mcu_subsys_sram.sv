module mcu_subsys_sram (
    input logic         clk,
    input logic         mem_valid,
    output logic        mem_ready,
    input logic [31:0]  mem_addr,
    input logic [31:0]  mem_wdata,
    input logic [3:0]   mem_wstrb,
    output logic [31:0] mem_rdata);

    logic [31:0] mem [16384-1:0];

    assign mem_rdata = mem[mem_addr[15:2]];
    assign mem_ready = 1'b1;

    always_ff @(posedge clk) begin
        if(mem_valid) begin
            if(mem_wstrb[0]) mem[mem_addr[15:2]][7:0] <= mem_wdata[7:0];
            if(mem_wstrb[1]) mem[mem_addr[15:2]][15:8] <= mem_wdata[15:8];
            if(mem_wstrb[2]) mem[mem_addr[15:2]][23:16] <= mem_wdata[23:16];
            if(mem_wstrb[3]) mem[mem_addr[15:2]][31:24] <= mem_wdata[31:24];
        end
    end

endmodule // mcu_subsys_sram
