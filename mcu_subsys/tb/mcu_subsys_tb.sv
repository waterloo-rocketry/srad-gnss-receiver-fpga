module mcu_subsys_tb;

    logic i_sys_clk;
    logic i_rst_n;

    mcu_subsys_tb u_mcu_subsys_tb (
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
        $dumpfile("mcu_subsys_tb.vcd");
        $dumpvars(0);
    end

endmodule // mcu_subsys_tb
