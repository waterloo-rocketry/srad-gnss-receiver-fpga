module mcu_subsys_sram (
    input logic         clk,
    input logic         rst_n,
    input logic         mem_valid,
    output logic        mem_ready,
    input logic [31:0]  mem_addr,
    input logic [31:0]  mem_wdata,
    input logic [3:0]   mem_wstrb,
    output logic [31:0] mem_rdata);

endmodule // mcu_subsys_sram
