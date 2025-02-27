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

    logic [1:0] read_mux_select;

    // Decoder
    always_comb begin
        rom_mem_valid = 1'b0;
        sram_mem_valid = 1'b0;
        periph_mem_valid = 1'b0;

        unique case (cpu_mem_addr[31:30])
            2'b00: begin
                rom_mem_valid = cpu_mem_valid;
            end
            2'b01: begin
                sram_mem_valid = cpu_mem_valid;
            end
            default: begin
                periph_mem_valid = cpu_mem_valid;
            end
        endcase // unique case (cpu_mem_addr[31:31])
    end

    // Read Mux
    always_comb begin
        unique case (cpu_mem_addr[31:30])
            2'b00: begin
                cpu_mem_ready = rom_mem_ready;
                cpu_mem_rdata = rom_mem_rdata;
            end
            2'b01: begin
                cpu_mem_ready = sram_mem_ready;
                cpu_mem_rdata = sram_mem_rdata;
            end
            default: begin
                cpu_mem_ready = periph_mem_ready;
                cpu_mem_rdata = periph_mem_rdata;
            end
        endcase // unique case (cpu_mem_addr[31:30])
    end

endmodule // mcu_subsys_host_bridge
