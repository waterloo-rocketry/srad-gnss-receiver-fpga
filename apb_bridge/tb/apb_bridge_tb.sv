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
    
    // APB Master Interface signals for 16 peripherals 
    logic [23:0] apb_paddr   [15:0];
    logic        apb_pwrite  [15:0];
    logic        apb_psel    [15:0];
    logic        apb_penable [15:0];
    logic [3:0]  apb_pstrb   [15:0];
    logic [31:0] apb_pwdata  [15:0];
    logic [31:0] apb_prdata  [15:0];
    logic        apb_pready  [15:0];
    logic        apb_pslverr [15:0];
    
    // Instantiate the APB bridge with all connections
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
        
        // APB Master Interfaces (to 16 Peripherals)
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
    
    // Initialize all peripheral signals that aren't explicitly modeled
    initial begin
        // Default values for peripherals 2-14
        // Each peripheral returns its index as read data
        for (int i = 2; i <= 14; i++) begin
            assign apb_prdata[i] = i;
            assign apb_pready[i] = 1'b1; // Always ready
            assign apb_pslverr[i] = 1'b0; // No errors
        end
    end
    
    // Simple APB peripheral emulator for Peripheral 0
    // Returns address value as read data and asserts ready after one cycle
    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            apb_prdata[0] <= 32'h0;
            apb_pready[0] <= 1'b0;
            apb_pslverr[0] <= 1'b0;
        end else begin
            // Default response after one cycle
            apb_pready[0] <= apb_psel[0] && apb_penable[0];
            
            // For read transactions, return the address + 0xA0000000 as data
            if (apb_psel[0] && !apb_pwrite[0]) begin
                apb_prdata[0] <= {8'hA0, apb_paddr[0]}; // Mark with A0 prefix
            end
            
            // No errors in this test
            apb_pslverr[0] <= 1'b0;
        end
    end
    
    // Simple APB peripheral emulator for Peripheral 1
    // Returns address value + 0xB0000000 as read data
    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            apb_prdata[1] <= 32'h0;
            apb_pready[1] <= 1'b0;
            apb_pslverr[1] <= 1'b0;
        end else begin
            // Default response after one cycle
            apb_pready[1] <= apb_psel[1] && apb_penable[1];
            
            // For read transactions, return the address + 0xB0000000 as data
            if (apb_psel[1] && !apb_pwrite[1]) begin
                apb_prdata[1] <= {8'hB0, apb_paddr[1]}; // Mark with B0 prefix
            end
            
            // No errors in this test
            apb_pslverr[1] <= 1'b0;
        end
    end
    
    // Simple APB peripheral emulator for Peripheral 15
    // Returns address value + 0xF0000000 as read data
    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            apb_prdata[15] <= 32'h0;
            apb_pready[15] <= 1'b0;
            apb_pslverr[15] <= 1'b0;
        end else begin
            // Default response after one cycle
            apb_pready[15] <= apb_psel[15] && apb_penable[15];
            
            // For read transactions, return the address + 0xF0000000 as data
            if (apb_psel[15] && !apb_pwrite[15]) begin
                apb_prdata[15] <= {8'hF0, apb_paddr[15]}; // Mark with F0 prefix
            end
            
            // No errors in this test
            apb_pslverr[15] <= 1'b0;
        end
    end
    
    // Test scenario variables
    logic [31:0] expected_rdata;
    logic [31:0] read_data;
    
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
        
        $display("\n=== APB Bridge Testbench ===");
        $display("Testing address mapping with 16 peripherals");
        $display("- Bits [23:0]  - Passed to selected peripheral");
        $display("- Bits [27:24] - Used for peripheral selection (0-15)");
        $display("- Bits [29:28] - Ignored");
        $display("- Bits [31:30] - Available for other uses");
        
        // Test 1: Access Peripheral 0
        $display("\n--- Test 1: Access Peripheral 0 ---");
        // Write to peripheral 0 (address bits [27:24] = 0)
        write_transaction(32'h00123456, 32'hAABBCCDD);
        #20;
        
        // Read from peripheral 0
        read_transaction(32'h00123456, read_data);
        expected_rdata = {8'hA0, 24'h123456}; // Peripheral 0 returns A0 prefix + address
        
        if (read_data == expected_rdata) begin
            $display("✓ TEST PASSED: Read data 0x%h matches expected value 0x%h", read_data, expected_rdata);
        end else begin
            $display("✗ TEST FAILED: Read data 0x%h does not match expected value 0x%h", read_data, expected_rdata);
        end
        
        // Test 2: Access Peripheral 1
        $display("\n--- Test 2: Access Peripheral 1 ---");
        // Write to peripheral 1 (address bits [27:24] = 1)
        write_transaction(32'h01ABCDEF, 32'h11223344);
        #20;
        
        // Read from peripheral 1
        read_transaction(32'h01ABCDEF, read_data);
        expected_rdata = {8'hB0, 24'hABCDEF}; // Peripheral 1 returns B0 prefix + address
        
        if (read_data == expected_rdata) begin
            $display("✓ TEST PASSED: Read data 0x%h matches expected value 0x%h", read_data, expected_rdata);
        end else begin
            $display("✗ TEST FAILED: Read data 0x%h does not match expected value 0x%h", read_data, expected_rdata);
        end
        
        // Test 3: Access Peripheral 15 (highest index)
        $display("\n--- Test 3: Access Peripheral 15 ---");
        // Write to peripheral 15 (address bits [27:24] = 15)
        write_transaction(32'h0F876543, 32'h99887766);
        #20;
        
        // Read from peripheral 15
        read_transaction(32'h0F876543, read_data);
        expected_rdata = {8'hF0, 24'h876543}; // Peripheral 15 returns F0 prefix + address
        
        if (read_data == expected_rdata) begin
            $display("✓ TEST PASSED: Read data 0x%h matches expected value 0x%h", read_data, expected_rdata);
        end else begin
            $display("✗ TEST FAILED: Read data 0x%h does not match expected value 0x%h", read_data, expected_rdata);
        end
        
        // Test 4: Test address bits [29:28] are ignored
        $display("\n--- Test 4: Test ignored address bits [29:28] ---");
        // These addresses should all map to the same peripheral 1 location
        // despite having different values in bits [29:28]
        for (int i = 0; i < 4; i++) begin
            logic [31:0] addr = 32'h01234567 | (i << 28);
            
            $display("Testing address 0x%h (bits [29:28] = %d)", addr, i);
            write_transaction(addr, 32'hA5A5A5A5);
            read_transaction(addr, read_data);
            
            expected_rdata = {8'hB0, 24'h234567}; // Should always be the same
            
            if (read_data == expected_rdata) begin
                $display("✓ TEST PASSED: Bits [29:28]=%d - Read data 0x%h matches expected value 0x%h", 
                          i, read_data, expected_rdata);
            end else begin
                $display("✗ TEST FAILED: Bits [29:28]=%d - Read data 0x%h does not match expected value 0x%h", 
                          i, read_data, expected_rdata);
            end
        end
        
        // Test 5: Multiple sequential accesses to different peripherals
        $display("\n--- Test 5: Sequential accesses to different peripherals ---");
        
        // Access peripherals 0, 1, and 15 in sequence
        // First peripheral 0
        write_transaction(32'h00111111, 32'hAAAAAAAA);
        read_transaction(32'h00111111, read_data);
        expected_rdata = {8'hA0, 24'h111111};
        
        if (read_data == expected_rdata) begin
            $display("✓ Peripheral 0: Read data 0x%h matches expected value 0x%h", read_data, expected_rdata);
        end else begin
            $display("✗ Peripheral 0: Read data 0x%h does not match expected value 0x%h", read_data, expected_rdata);
        end
        
        // Next peripheral 1
        write_transaction(32'h01222222, 32'hBBBBBBBB);
        read_transaction(32'h01222222, read_data);
        expected_rdata = {8'hB0, 24'h222222};
        
        if (read_data == expected_rdata) begin
            $display("✓ Peripheral 1: Read data 0x%h matches expected value 0x%h", read_data, expected_rdata);
        end else begin
            $display("✗ Peripheral 1: Read data 0x%h does not match expected value 0x%h", read_data, expected_rdata);
        end
        
        // Finally peripheral 15
        write_transaction(32'h0F333333, 32'hCCCCCCCC);
        read_transaction(32'h0F333333, read_data);
        expected_rdata = {8'hF0, 24'h333333};
        
        if (read_data == expected_rdata) begin
            $display("✓ Peripheral 15: Read data 0x%h matches expected value 0x%h", read_data, expected_rdata);
        end else begin
            $display("✗ Peripheral 15: Read data 0x%h does not match expected value 0x%h", read_data, expected_rdata);
        end
        
        // Finish simulation
        #50;
        $display("\n=== APB Bridge testing completed ===");
        $finish;
    end
    
    // Generate waveform file
    initial begin
        $dumpfile("apb_bridge_tb.vcd");
        $dumpvars(0, apb_bridge_tb);
    end

endmodule