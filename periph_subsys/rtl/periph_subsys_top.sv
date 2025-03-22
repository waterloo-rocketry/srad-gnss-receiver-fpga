/* verilator lint_off PINMISSING */

module periph_subsys_top (
    // Clock and resets
    input logic       sys_clk,          // System clock
    input logic       rst_n,            // Active-low reset

    // Host Memory Interface (from MCU)
    input logic        host_valid,
    output logic       host_ready,
    input logic [31:0] host_addr,
    input logic [31:0] host_wdata,
    input logic [3:0]  host_wstrb,
    output logic [31:0] host_rdata
);

	logic [15:0] gpio_paddr;
	logic		 gpio_pwrite;
	logic		 gpio_psel;
	logic		 gpio_penable;
	logic [3:0]  gpio_pstrb;
	logic [31:0] gpio_pwdata;
	logic [31:0] gpio_prdata;
	logic		 gpio_pready;
	logic		 gpio_pslverr;

    apb_bridge_top u_apb_bridge_top (
        .sys_clk(sys_clk),
        .rst_n(rst_n),

        .host_valid(host_valid),
        .host_ready(host_ready),
        .host_addr(host_addr),
        .host_wdata(host_wdata),
        .host_wstrb(host_wstrb),
        .host_rdata(host_rdata),

        .apb_paddr0(gpio_paddr),
        .apb_pwrite0(gpio_pwrite),
        .apb_psel0(gpio_psel),
        .apb_penable0(gpio_penable),
        .apb_pstrb0(gpio_pstrb),
        .apb_pwdata0(gpio_pwdata),
        .apb_prdata0(gpio_prdata),
        .apb_pready0(gpio_pready),
        .apb_pslverr0(gpio_pslverr)
    );

    gpio_ctrl_top u_gpio_ctrl_top (
        .sys_clk(sys_clk),
        .rst_n(rst_n),

        .paddr(gpio_paddr),
        .pwrite(gpio_pwrite),
        .psel(gpio_psel),
        .penable(gpio_penable),
        .pstrb(gpio_pstrb),
        .pwdata(gpio_pwdata),
        .prdata(gpio_prdata),
        .pready(gpio_pready),
        .pslverr(gpio_pslverr) 
    );

endmodule // periph_subsys_top
