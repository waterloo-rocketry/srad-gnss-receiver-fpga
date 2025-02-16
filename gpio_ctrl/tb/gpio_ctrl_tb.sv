module gpio_ctrl_tb;

    logic i_sys_clk;
    logic i_rst_n;

    gpio_ctrl_tb u_gpio_ctrl_tb (
        .i_sys_clk(i_sys_clk),
        .i_rst_n(i_rst_n)
    );

    initial begin
        i_rst_n = 1'b0;
        #100;
        i_rst_n = 1'b1;
        #200;
        $finish;
    end

    initial begin
        i_sys_clk = 1'b0;
        forever begin
            #10;
            i_sys_clk = ~i_sys_clk;
        end
    end

    initial begin
        $dumpfile("gpio_ctrl_tb.vcd");
        $dumpvars(0);
    end

endmodule // gpio_ctrl_tb
