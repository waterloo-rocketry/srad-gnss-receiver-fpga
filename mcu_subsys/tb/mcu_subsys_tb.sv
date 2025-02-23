module mcu_subsys_tb;

    logic sys_clk;
    logic rst_n;

    mcu_subsys_top u_mcu_subsys_top (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .periph_mem_valid(),
        .periph_mem_ready(1'b0),
        .periph_mem_addr(),
        .periph_mem_wdata(),
        .periph_mem_wstrb(),
        .periph_mem_rdata(32'h0)
    );

    initial begin
        rst_n = 1'b0;
        #100;
        rst_n = 1'b1;
        #1000;
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
        $dumpfile("mcu_subsys_tb.vcd");
        $dumpvars();
    end

endmodule // mcu_subsys_tb
