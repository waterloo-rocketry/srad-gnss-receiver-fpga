/* verilator lint_off UNUSEDSIGNAL */

module uart_ctrl_top (
    // Clock and resets
    input logic         sys_clk,
    input logic         uart_clk,
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
    // UART interface
    output logic        tx,
    input logic         rx
);

    assign prdata = 32'h0;
    assign pready = 1'b0;
    assign pslverr = 1'b0;

    assign tx = 1'b0;

endmodule // uart_ctrl_top
