module apb_bridge_tb;

    // Clock and reset
    logic        sys_clk;
    logic        rst_n;
    
    // Host Memory Interface (from MCU)
    logic        host_valid;
    logic        host_ready;
    logic [31:0] host_addr;
    logic [31:0] host_wdata;
    logic [3:0]  host_wstrb;
    logic [31:0] host_rdata;
    
    // APB Master Interface (to Peripherals)
    logic [15:0] apb_paddr;
    logic        apb_pwrite;
    logic        apb_psel;
    logic        apb_penable;
    logic [3:0]  apb_pstrb;
    logic [31:0] apb_pwdata;
    logic [31:0] apb_prdata;
    logic        apb_pready;
    logic        apb_pslverr;
    
    // Instantiate the APB bridge with all connections properly made
    apb_bridge_top u_apb_bridge_top (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        
        // Host Memory Interface
        .host_valid(host_valid),
        .host_ready(host_ready),
        .host_addr(host_addr),
        .host_wdata(host_wdata),
        .host_wstrb(host_wstrb),
        .host_rdata(host_rdata),
        
        // APB Master Interface
        .apb_paddr(apb_paddr),
        .apb_pwrite(apb_pwrite),
        .apb_psel(apb_psel),
        .apb_penable(apb_penable),
        .apb_pstrb(apb_pstrb),
        .apb_pwdata(apb_pwdata),
        .apb_prdata(apb_prdata),
        .apb_pready(apb_pready),
        .apb_pslverr(apb_pslverr)
    );
    
    // Simple APB peripheral emulator
    // Returns address value as read data and asserts ready after one cycle
    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            apb_prdata <= 32'h0;
            apb_pready <= 1'b0;
            apb_pslverr <= 1'b0;
        end else begin
            // Default response after one cycle
            apb_pready <= apb_psel && apb_penable;
            
            // For read transactions, return the address as data
            if (apb_psel && !apb_pwrite) begin
                apb_prdata <= {16'h0, apb_paddr}; // Pad with zeros to make 32 bits
            end
            
            // No errors in this test
            apb_pslverr <= 1'b0;
        end
    end
    
    // Test scenario variables
    logic [31:0] expected_rdata;
    
    // Clock generation
    initial begin
        sys_clk = 1'b0;
        forever #5 sys_clk = ~sys_clk; // 100MHz clock
    end
    
    // Task for write transactions
    task write_transaction;
        input [31:0] addr;
        input [31:0] data;
        begin
            @(posedge sys_clk);
            host_valid = 1'b1;
            host_addr = addr;
            host_wdata = data;
            host_wstrb = 4'hF; // Write all bytes
            
            // Wait for transaction to complete
            wait(host_ready);
            @(posedge sys_clk);
            host_valid = 1'b0;
            host_wstrb = 4'h0;
            
            $display("Write completed: ADDR=0x%h, DATA=0x%h", addr, data);
        end
    endtask
    
    // Task for read transactions
    task read_transaction;
        input [31:0] addr;
        output [31:0] data;
        begin
            @(posedge sys_clk);
            host_valid = 1'b1;
            host_addr = addr;
            host_wstrb = 4'h0; // No write strobes for read
            
            // Wait for transaction to complete
            wait(host_ready);
            data = host_rdata;
            @(posedge sys_clk);
            host_valid = 1'b0;
            
            $display("Read completed: ADDR=0x%h, DATA=0x%h", addr, data);
        end
    endtask
    
    // Test sequence
    initial begin
        // Initialize signals
        rst_n = 1'b0;
        host_valid = 1'b0;
        host_addr = 32'h0;
        host_wdata = 32'h0;
        host_wstrb = 4'h0;
        
        // Release reset
        #20;
        rst_n = 1'b1;
        #10;
        
        // Test 1: Basic write transaction
        $display("\n--- Test 1: Basic write transaction ---");
        write_transaction(32'h10004000, 32'hAABBCCDD);
        #20;
        
        // Test 2: Basic read transaction
        $display("\n--- Test 2: Basic read transaction ---");
        read_transaction(32'h10004000, expected_rdata);
        
        // Fixed the width mismatch by comparing against 32-bit constant
        if (expected_rdata == 32'h00004000) begin
            $display("✓ TEST PASSED: Read data 0x%h matches expected value 0x00004000", expected_rdata);
        end else begin
            $display("✗ TEST FAILED: Read data 0x%h does not match expected value 0x00004000", expected_rdata);
        end
        
        // Test 3: Multiple back-to-back transactions
        $display("\n--- Test 3: Multiple back-to-back transactions ---");
        for (int i = 0; i < 5; i++) begin
            logic [31:0] addr = 32'h10005000 + (i*4);
            logic [31:0] expected = 32'h00005000 + (i*4); // 32-bit expected value
            
            write_transaction(addr, 32'hA0000000 + i);
            read_transaction(addr, expected_rdata);
            
            if (expected_rdata == expected) begin
                $display("✓ Transaction %0d: Read data 0x%h matches expected value 0x%h", i, expected_rdata, expected);
            end else begin
                $display("✗ Transaction %0d: Read data 0x%h does not match expected value 0x%h", i, expected_rdata, expected);
            end
        end
        
        // Finish simulation
        #50;
        $display("\n--- APB Bridge testing completed ---");
        $finish;
    end
    
    // Generate waveform file
    initial begin
        $dumpfile("apb_bridge_tb.vcd");
        $dumpvars(0, apb_bridge_tb);
    end

endmodule