module gnss_receiver_tb;

    logic sys_clk;
    logic rst_n;

    gnss_receiver_top u_gnss_receiver_top (
        .sys_clk(sys_clk),
        .rst_n(rst_n)
    );

    initial begin
        rst_n = 1'b0;
        #100;
        rst_n = 1'b1;
        #5000000;
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
        $dumpfile("gnss_receiver_tb.vcd");
        $dumpvars();
    end

endmodule // gnss_receiver_tb
