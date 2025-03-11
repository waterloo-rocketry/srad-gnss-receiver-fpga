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
    logic         cpu_mem_we;
    logic [3:0]   cpu_mem_be;
    logic [31:0]  cpu_mem_rdata;

    logic         instr_rom_mem_valid;
    logic         instr_rom_mem_ready;
    logic [31:0]  instr_rom_mem_addr;
    logic [31:0]  instr_rom_mem_wdata;
    logic [3:0]   instr_rom_mem_wstrb;
    logic [31:0]  instr_rom_mem_rdata;

    logic         data_rom_mem_valid;
    logic         data_rom_mem_ready;
    logic [31:0]  data_rom_mem_addr;
    logic [31:0]  data_rom_mem_wdata;
    logic [3:0]   data_rom_mem_wstrb;
    logic [31:0]  data_rom_mem_rdata;

    logic         sram_mem_valid;
    logic         sram_mem_ready;
    logic [31:0]  sram_mem_addr;
    logic [31:0]  sram_mem_wdata;
    logic [3:0]   sram_mem_wstrb;
    logic [31:0]  sram_mem_rdata;

    ibex_top u_ibex_cpu_top (
        // Clock and reset
        .clk_i(sys_clk),
        .rst_ni(rst_n),
        .test_en_i(1'b0),
        .ram_cfg_i('0),

         // Configuration
        .hart_id_i(32'h00000001),
        .boot_addr_i(32'h00000000),

        // Instruction memory interface
        .instr_req_o(instr_rom_mem_valid),
        .instr_gnt_i(instr_rom_mem_valid),
        .instr_rvalid_i(instr_rom_mem_ready),
        .instr_addr_o(instr_rom_mem_addr),
        .instr_rdata_i(instr_rom_mem_rdata),
        .instr_rdata_intg_i(7'b0000000),
        .instr_err_i(1'b0),

        // Data memory interface
        .data_req_o(cpu_mem_valid),
        .data_gnt_i(cpu_mem_valid),
        .data_rvalid_i(cpu_mem_ready),
        .data_we_o(cpu_mem_we),
        .data_be_o(cpu_mem_be),
        .data_addr_o(cpu_mem_addr),
        .data_wdata_o(cpu_mem_wdata),
        .data_wdata_intg_o(),
        .data_rdata_i(cpu_mem_rdata),
        .data_rdata_intg_i(7'h0),
        .data_err_i(1'b0),

        // Interrupt inputs
        .irq_software_i(1'b0),
        .irq_timer_i(1'b0),
        .irq_external_i(1'b0),
        .irq_fast_i(15'b000000000000000),
        .irq_nm_i(1'b0),

        // Scrambling Interface
        .scramble_key_valid_i(),
        .scramble_key_i(),
        .scramble_nonce_i(),
        .scramble_req_o(),
                     
        // Debug interface
        .debug_req_i            (1'b0),
        .crash_dump_o           (),
        .double_fault_seen_o    (),

        // Special control signals
        .fetch_enable_i         (ibex_pkg::IbexMuBiOn),
        .alert_minor_o          (),
        .alert_major_internal_o (),
        .alert_major_bus_o      (),
        .core_sleep_o           (),

        // DFT bypass controls
        .scan_rst_ni()
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
        .cpu_mem_we(cpu_mem_we),
        .cpu_mem_be(cpu_mem_be),
        .cpu_mem_rdata(cpu_mem_rdata),
        // ROM Memory Interface
        .rom_mem_valid(data_rom_mem_valid),
        .rom_mem_ready(data_rom_mem_ready),
        .rom_mem_addr(data_rom_mem_addr),
        .rom_mem_wdata(data_rom_mem_wdata),
        .rom_mem_wstrb(data_rom_mem_wstrb),
        .rom_mem_rdata(data_rom_mem_rdata),
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

    mcu_subsys_rom u_instr_rom (
        .clk(sys_clk),
        .rst_n(rst_n),
        .mem_valid(instr_rom_mem_valid),
        .mem_ready(instr_rom_mem_ready),
        .mem_addr(instr_rom_mem_addr),
        .mem_wdata(instr_rom_mem_wdata),
        .mem_wstrb(instr_rom_mem_wstrb),
        .mem_rdata(instr_rom_mem_rdata)
    );

    mcu_subsys_rom u_data_rom (
        .clk(sys_clk),
        .rst_n(rst_n),
        .mem_valid(data_rom_mem_valid),
        .mem_ready(data_rom_mem_ready),
        .mem_addr(data_rom_mem_addr),
        .mem_wdata(data_rom_mem_wdata),
        .mem_wstrb(data_rom_mem_wstrb),
        .mem_rdata(data_rom_mem_rdata)
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
