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

        @(posedge sys_clk);
        paddr = 16'h0;
        pwrite = 1'b1;
        psel = 1'b1;
        pwdata = 32'h12345678;
        @(posedge sys_clk);
        penable = 1'b1;
        @(posedge sys_clk);
        psel = 1'b0;
        penable = 1'b0;
        @(posedge sys_clk);

        #100;

        @(posedge sys_clk);
        paddr = 16'h8;
        pwrite = 1'b0;
        psel = 1'b1;
        @(posedge sys_clk);
        penable = 1'b1;
        @(posedge sys_clk);
        psel = 1'b0;
        penable = 1'b0;
        @(posedge sys_clk);

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
