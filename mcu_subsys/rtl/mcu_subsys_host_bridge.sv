module mcu_subsys_host_bridge (
    // Clock and reset
    input logic         sys_clk,
    input logic         rst_n,
    // CPU Memory Interface
    input logic         cpu_mem_valid,
    output logic        cpu_mem_ready,
    input logic [31:0]  cpu_mem_addr,
    input logic [31:0]  cpu_mem_wdata,
    input logic         cpu_mem_we,
    input logic [3:0]   cpu_mem_be,
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

    // Write Strobe
    logic [3:0] cpu_mem_wstrb;
    assign cpu_mem_wstrb = cpu_mem_we ? cpu_mem_be : 4'h0;

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
            2'b10: begin
                periph_mem_valid = cpu_mem_valid;
            end
            default: begin
            end
        endcase // unique case (cpu_mem_addr[31:31])
    end

    logic muxed_ready;

    // Read Mux
    always_comb begin
        unique case (cpu_mem_addr[31:30])
            2'b00: begin
                muxed_ready = rom_mem_ready;
                cpu_mem_rdata = rom_mem_rdata;
            end
            2'b01: begin
                muxed_ready = sram_mem_ready;
                cpu_mem_rdata = sram_mem_rdata;
            end
            2'b10: begin
                muxed_ready = periph_mem_ready;
                cpu_mem_rdata = periph_mem_rdata;
            end
            default: begin
                muxed_ready = 1'b1;
                cpu_mem_rdata = 32'h00000000;
            end
        endcase // unique case (cpu_mem_addr[31:30])
    end // always_comb

    // Only assert ready when there's an outstanding transaction
    logic trans_active;
    always_ff @(posedge sys_clk or negedge rst_n) begin
        if(!rst_n) begin
            trans_active <= 1'b0;
        end else begin
            if(cpu_mem_valid) begin
                trans_active <= 1'b1;
            end else if(muxed_ready) begin
                trans_active <= 1'b0;
            end
        end
    end // always_ff @ (posedge sys_clk or negedge rst_n)

    assign cpu_mem_ready = muxed_ready & trans_active;

endmodule // mcu_subsys_host_bridge
