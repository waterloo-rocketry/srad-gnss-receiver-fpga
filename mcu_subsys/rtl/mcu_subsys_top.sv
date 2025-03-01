/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off PINMISSING */

module mcu_subsys_top (
    // Clock and resets
    input logic         sys_clk,
    input logic         rst_n,
    // Peripheral memory bus
    output logic        periph_mem_valid,
    input logic         periph_mem_ready,
    output logic [31:0] periph_mem_addr,
    output logic [31:0] periph_mem_wdata,
    output logic [3:0]  periph_mem_wstrb,
    input logic [31:0]  periph_mem_rdata
);

    logic         cpu_mem_valid;
    logic         cpu_mem_ready;
    logic [31:0]  cpu_mem_addr;
    logic [31:0]  cpu_mem_wdata;
    logic [3:0]   cpu_mem_wstrb;
    logic [31:0]  cpu_mem_rdata;

    logic         rom_mem_valid;
    logic         rom_mem_ready;
    logic [31:0]  rom_mem_addr;
    logic [31:0]  rom_mem_wdata;
    logic [3:0]   rom_mem_wstrb;
    logic [31:0]  rom_mem_rdata;

    logic         sram_mem_valid;
    logic         sram_mem_ready;
    logic [31:0]  sram_mem_addr;
    logic [31:0]  sram_mem_wdata;
    logic [3:0]   sram_mem_wstrb;
    logic [31:0]  sram_mem_rdata;

    picorv32 #(
        .PROGADDR_RESET(32'h00000080)
    ) u_picorv32 (
        // Clock and reset
        .clk(sys_clk),
        .resetn(rst_n),
        // Memory bus
        .mem_valid(cpu_mem_valid),
        .mem_ready(cpu_mem_ready),
        .mem_addr(cpu_mem_addr),
        .mem_wdata(cpu_mem_wdata),
        .mem_wstrb(cpu_mem_wstrb),
        .mem_rdata(cpu_mem_rdata),
        // IRQ Interface
        .irq(32'h0)
    );

    mcu_subsys_host_bridge u_host_bridge (
        // Clock and reset
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        // CPU Memory Interface
        .cpu_mem_valid(cpu_mem_valid),
        .cpu_mem_ready(cpu_mem_ready),
        .cpu_mem_addr(cpu_mem_addr),
        .cpu_mem_wdata(cpu_mem_wdata),
        .cpu_mem_wstrb(cpu_mem_wstrb),
        .cpu_mem_rdata(cpu_mem_rdata),
        // ROM Memory Interface
        .rom_mem_valid(rom_mem_valid),
        .rom_mem_ready(rom_mem_ready),
        .rom_mem_addr(rom_mem_addr),
        .rom_mem_wdata(rom_mem_wdata),
        .rom_mem_wstrb(rom_mem_wstrb),
        .rom_mem_rdata(rom_mem_rdata),
        // SRAM Memory Interface
        .sram_mem_valid(sram_mem_valid),
        .sram_mem_ready(sram_mem_ready),
        .sram_mem_addr(sram_mem_addr),
        .sram_mem_wdata(sram_mem_wdata),
        .sram_mem_wstrb(sram_mem_wstrb),
        .sram_mem_rdata(sram_mem_rdata),
        // Peripheral Memory Interface
        .periph_mem_valid(periph_mem_valid),
        .periph_mem_ready(periph_mem_ready),
        .periph_mem_addr(periph_mem_addr),
        .periph_mem_wdata(periph_mem_wdata),
        .periph_mem_wstrb(periph_mem_wstrb),
        .periph_mem_rdata(periph_mem_rdata)
    );

    mcu_subsys_rom u_rom (
        .clk(sys_clk),
        .rst_n(rst_n),
        .mem_valid(rom_mem_valid),
        .mem_ready(rom_mem_ready),
        .mem_addr(rom_mem_addr),
        .mem_wdata(rom_mem_wdata),
        .mem_wstrb(rom_mem_wstrb),
        .mem_rdata(rom_mem_rdata)
    );

    mcu_subsys_sram u_sram (
        .clk(sys_clk),
        .mem_valid(sram_mem_valid),
        .mem_ready(sram_mem_ready),
        .mem_addr(sram_mem_addr),
        .mem_wdata(sram_mem_wdata),
        .mem_wstrb(sram_mem_wstrb),
        .mem_rdata(sram_mem_rdata)
    );

endmodule // mcu_subsys_top
