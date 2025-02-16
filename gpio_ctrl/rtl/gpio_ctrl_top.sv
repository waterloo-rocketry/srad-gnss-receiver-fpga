/* verilator lint_off UNUSEDSIGNAL */

module gpio_ctrl_top (
    // Clock and resets
    input logic         sys_clk,
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
    // GPIO interface
    output logic [31:0] gpio_out
);

    assign prdata = 32'h0;
    assign pready = 1'b0;
    assign pslverr = 1'b0;

    assign gpio_out = 32'h0;

endmodule // gpio_ctrl_top
