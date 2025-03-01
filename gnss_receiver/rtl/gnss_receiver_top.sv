module gnss_receiver_top (
    // Clock and resets
    input logic         sys_clk,
    input logic         rst_n
);

    logic        periph_mem_valid;
    logic        periph_mem_ready;
    logic [31:0] periph_mem_addr;
    logic [31:0] periph_mem_wdata;
    logic [3:0]  periph_mem_wstrb;
    logic [31:0] periph_mem_rdata;

    mcu_subsys_top u_mcu_subsys(
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .periph_mem_valid(periph_mem_valid),
        .periph_mem_ready(periph_mem_ready),
        .periph_mem_addr(periph_mem_addr),
        .periph_mem_wdata(periph_mem_wdata),
        .periph_mem_wstrb(periph_mem_wstrb),
        .periph_mem_rdata(periph_mem_rdata)
    );

    periph_subsys_top u_periph_subsys();

    mcu_subsys_sram u_fake_periph (
        .clk(sys_clk),
        .mem_valid(periph_mem_valid),
        .mem_ready(periph_mem_ready),
        .mem_addr(periph_mem_addr),
        .mem_wdata(periph_mem_wdata),
        .mem_wstrb(periph_mem_wstrb),
        .mem_rdata(periph_mem_rdata)
    );

endmodule // gnss_receiver_top
