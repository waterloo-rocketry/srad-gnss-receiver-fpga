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
    input logic [31:0]  gpio_in,
    output logic [31:0] gpio_out
);

    gpio_ctrl_csr_pkg::gpio_ctrl_csr__in_t csr_in;
    gpio_ctrl_csr_pkg::gpio_ctrl_csr__out_t csr_out;

    gpio_ctrl_csr u_gpio_ctrl_csr (
        .clk(sys_clk),
        .rst(~rst_n),
        .s_apb_psel(psel),
        .s_apb_penable(penable),
        .s_apb_pwrite(pwrite),
        .s_apb_pprot('0),
        .s_apb_paddr(paddr[3:0]),
        .s_apb_pwdata(pwdata),
        .s_apb_pstrb(pstrb),
        .s_apb_pready(pready),
        .s_apb_prdata(prdata),
        .s_apb_pslverr(pslverr),
        .hwif_in(csr_in),
        .hwif_out(csr_out)
    );

    logic [1:0] [31:0] sync_flops;

    always_ff @(posedge sys_clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            sync_flops <= 'h0;
        end else begin
            sync_flops[0] <= gpio_in;
            sync_flops[1] <= sync_flops[0];
        end
    end

    assign gpio_out = csr_out.OUTPUT_CTRL_VALUE.OVALUE;
    assign csr_in.INPUT_STATUS.IVALUE = sync_flops[1];

endmodule // gpio_ctrl_top
