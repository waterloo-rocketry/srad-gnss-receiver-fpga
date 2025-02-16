module mcu_subsys_host_bridge (
    // Clock and reset
    input logic         sys_clk,
    input logic         rst_n,
    // CPU Memory Interface
    input logic         cpu_mem_valid,
    output logic        cpu_mem_ready,
    input logic [31:0]  cpu_mem_addr,
    input logic [31:0]  cpu_mem_wdata,
    input logic [3:0]   cpu_mem_wstrb,
    output logic [31:0] cpu_mem_rdata,
    // ROM Memory Interface
    output logic        rom_mem_valid,
    input logic         rom_mem_ready,
    output logic [31:0] rom_mem_addr,
    output logic [31:0] rom_mem_wdata,
    output logic [3:0]  rom_mem_wstrb,
    input logic [31:0]  rom_mem_rdata,
    // SRAM Memory Interface
    output logic        sram_mem_valid,
    input logic         sram_mem_ready,
    output logic [31:0] sram_mem_addr,
    output logic [31:0] sram_mem_wdata,
    output logic [3:0]  sram_mem_wstrb,
    input logic [31:0]  sram_mem_rdata,
    // Peripheral Memory Interface
    output logic        periph_mem_valid,
    input logic         periph_mem_ready,
    output logic [31:0] periph_mem_addr,
    output logic [31:0] periph_mem_wdata,
    output logic [3:0]  periph_mem_wstrb,
    input logic [31:0]  periph_mem_rdata
);

    // Pass-through signals
    assign rom_mem_addr = cpu_mem_addr;
    assign sram_mem_addr = cpu_mem_addr;
    assign periph_mem_addr = cpu_mem_addr;
    
    assign rom_mem_wdata = cpu_mem_wdata;
    assign sram_mem_wdata = cpu_mem_wdata;
    assign periph_mem_wdata = cpu_mem_wdata;

    assign rom_mem_wstrb = cpu_mem_wstrb;
    assign sram_mem_wstrb = cpu_mem_wstrb;
    assign periph_mem_wstrb = cpu_mem_wstrb;


endmodule // mcu_subsys_host_bridge
