module gpio_ctrl_tb;

    logic        sys_clk;
    logic        rst_n;
    logic [15:0] paddr;
    logic        pwrite;
    logic        psel;
    logic        penable;
    logic [3:0]  pstrb;
    logic [31:0] pwdata;
    logic [31:0] prdata;
    logic        pready;
    logic        pslverr;
    logic [31:0] gpio_in;
    logic [31:0] gpio_out;

    gpio_ctrl_top u_gpio_ctrl_top (.*);

    clocking apb_clk @(posedge sys_clk);

        output paddr;
        output pwrite;
        output psel;
        output penable;
        output pstrb;
        output pwdata;

        input  prdata;
        input  pready;
        input  pslverr;

    endclocking // apb_clk

    initial begin
        rst_n = 1'b0;

        paddr = 16'h0;
        pwrite = 1'b0;
        psel = 1'b0;
        penable = 1'b0;
        pstrb = 4'b1111;
        pwdata = 32'h0;

        gpio_in = 32'h90abcdef;

        #100;
        rst_n = 1'b1;
        #200;

        @apb_clk;
        apb_clk.paddr <= 16'h0;
        apb_clk.pwrite <= 1'b1;
        apb_clk.psel <= 1'b1;
        apb_clk.pwdata <= 32'h12345678;
        @apb_clk;
        apb_clk.penable <= 1'b1;
        @apb_clk;
        apb_clk.psel <= 1'b0;
        apb_clk.penable <= 1'b0;
        @apb_clk;

        #100;

        @apb_clk;
        apb_clk.paddr <= 16'h8;
        apb_clk.pwrite <= 1'b0;
        apb_clk.psel <= 1'b1;
        @apb_clk;
        apb_clk.penable <= 1'b1;
        @apb_clk;
        apb_clk.psel <= 1'b0;
        apb_clk.penable <= 1'b0;
        @apb_clk;

        #200;

        $finish;
    end

    initial begin
        sys_clk = 1'b0;
        forever begin
            #10;
            sys_clk = ~sys_clk;
        end
    end

    initial begin
        $dumpfile("gpio_ctrl_tb.vcd");
        $dumpvars;
    end

endmodule // gpio_ctrl_tb
