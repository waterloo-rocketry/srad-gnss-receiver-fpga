/* verilator lint_off UNUSEDSIGNAL */

module spi_ctrl_top (
    // Clock and resets
    input logic         sys_clk,
    input logic         spi_clk,
    input logic         rst_n,
    // APB Interface
    input logic [15:0]  paddr,
    input logic         pwrite,
    input logic         psel,
    input logic         penable,
    input logic [3:0]   pstrb,
    input logic [31:0]  pwdata,
    output logic [31:0] prdata,
    output logic        pready,
    output logic        pslverr,
    // SPI interface
    output logic        sclk,
    output logic        mosi,
    input logic         miso,
    output logic        cs
);

    assign prdata = 32'h0;
    assign pready = 1'b0;
    assign pslverr = 1'b0;

    assign sclk = spi_clk;
    assign mosi = 1'b1;
    assign cs = 1'b1;

endmodule // spi_ctrl_top
