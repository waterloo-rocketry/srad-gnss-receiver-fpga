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
    // Peripheral 0
    logic [23:0] apb_paddr0;
    logic        apb_pwrite0;
    logic        apb_psel0;
    logic        apb_penable0;
    logic [3:0]  apb_pstrb0;
    logic [31:0] apb_pwdata0;
    logic [31:0] apb_prdata0;
    logic        apb_pready0;
    logic        apb_pslverr0;
    
    // Peripheral 1
    logic [23:0] apb_paddr1;
    logic        apb_pwrite1;
    logic        apb_psel1;
    logic        apb_penable1;
    logic [3:0]  apb_pstrb1;
    logic [31:0] apb_pwdata1;
    logic [31:0] apb_prdata1;
    logic        apb_pready1;
    logic        apb_pslverr1;
    
    // Peripherals 2-14
    logic [23:0] apb_paddr2, apb_paddr3, apb_paddr4, apb_paddr5, apb_paddr6, apb_paddr7;
    logic [23:0] apb_paddr8, apb_paddr9, apb_paddr10, apb_paddr11, apb_paddr12, apb_paddr13, apb_paddr14;
    
    logic apb_pwrite2, apb_pwrite3, apb_pwrite4, apb_pwrite5, apb_pwrite6, apb_pwrite7;
    logic apb_pwrite8, apb_pwrite9, apb_pwrite10, apb_pwrite11, apb_pwrite12, apb_pwrite13, apb_pwrite14;
    
    logic apb_psel2, apb_psel3, apb_psel4, apb_psel5, apb_psel6, apb_psel7;
    logic apb_psel8, apb_psel9, apb_psel10, apb_psel11, apb_psel12, apb_psel13, apb_psel14;
    
    logic apb_penable2, apb_penable3, apb_penable4, apb_penable5, apb_penable6, apb_penable7;
    logic apb_penable8, apb_penable9, apb_penable10, apb_penable11, apb_penable12, apb_penable13, apb_penable14;
    
    logic [3:0] apb_pstrb2, apb_pstrb3, apb_pstrb4, apb_pstrb5, apb_pstrb6, apb_pstrb7;
    logic [3:0] apb_pstrb8, apb_pstrb9, apb_pstrb10, apb_pstrb11, apb_pstrb12, apb_pstrb13, apb_pstrb14;
    
    logic [31:0] apb_pwdata2, apb_pwdata3, apb_pwdata4, apb_pwdata5, apb_pwdata6, apb_pwdata7;
    logic [31:0] apb_pwdata8, apb_pwdata9, apb_pwdata10, apb_pwdata11, apb_pwdata12, apb_pwdata13, apb_pwdata14;
    
    logic [31:0] apb_prdata2, apb_prdata3, apb_prdata4, apb_prdata5, apb_prdata6, apb_prdata7;
    logic [31:0] apb_prdata8, apb_prdata9, apb_prdata10, apb_prdata11, apb_prdata12, apb_prdata13, apb_prdata14;
    
    logic apb_pready2, apb_pready3, apb_pready4, apb_pready5, apb_pready6, apb_pready7;
    logic apb_pready8, apb_pready9, apb_pready10, apb_pready11, apb_pready12, apb_pready13, apb_pready14;
    
    logic apb_pslverr2, apb_pslverr3, apb_pslverr4, apb_pslverr5, apb_pslverr6, apb_pslverr7;
    logic apb_pslverr8, apb_pslverr9, apb_pslverr10, apb_pslverr11, apb_pslverr12, apb_pslverr13, apb_pslverr14;
    
    // Peripheral 15
    logic [23:0] apb_paddr15;
    logic        apb_pwrite15;
    logic        apb_psel15;
    logic        apb_penable15;
    logic [3:0]  apb_pstrb15;
    logic [31:0] apb_pwdata15;
    logic [31:0] apb_prdata15;
    logic        apb_pready15;
    logic        apb_pslverr15;
    
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
        
        // APB Master Interface - Peripheral 0
        .apb_paddr0(apb_paddr0),
        .apb_pwrite0(apb_pwrite0),
        .apb_psel0(apb_psel0),
        .apb_penable0(apb_penable0),
        .apb_pstrb0(apb_pstrb0),
        .apb_pwdata0(apb_pwdata0),
        .apb_prdata0(apb_prdata0),
        .apb_pready0(apb_pready0),
        .apb_pslverr0(apb_pslverr0),
        
        // APB Master Interface - Peripheral 1
        .apb_paddr1(apb_paddr1),
        .apb_pwrite1(apb_pwrite1),
        .apb_psel1(apb_psel1),
        .apb_penable1(apb_penable1),
        .apb_pstrb1(apb_pstrb1),
        .apb_pwdata1(apb_pwdata1),
        .apb_prdata1(apb_prdata1),
        .apb_pready1(apb_pready1),
        .apb_pslverr1(apb_pslverr1),
        
        // APB Master Interface - Peripherals 2-14
        .apb_paddr2(apb_paddr2), .apb_paddr3(apb_paddr3), .apb_paddr4(apb_paddr4),
        .apb_paddr5(apb_paddr5), .apb_paddr6(apb_paddr6), .apb_paddr7(apb_paddr7),
        .apb_paddr8(apb_paddr8), .apb_paddr9(apb_paddr9), .apb_paddr10(apb_paddr10),
        .apb_paddr11(apb_paddr11), .apb_paddr12(apb_paddr12), .apb_paddr13(apb_paddr13),
        .apb_paddr14(apb_paddr14),
        
        .apb_pwrite2(apb_pwrite2), .apb_pwrite3(apb_pwrite3), .apb_pwrite4(apb_pwrite4),
        .apb_pwrite5(apb_pwrite5), .apb_pwrite6(apb_pwrite6), .apb_pwrite7(apb_pwrite7),
        .apb_pwrite8(apb_pwrite8), .apb_pwrite9(apb_pwrite9), .apb_pwrite10(apb_pwrite10),
        .apb_pwrite11(apb_pwrite11), .apb_pwrite12(apb_pwrite12), .apb_pwrite13(apb_pwrite13),
        .apb_pwrite14(apb_pwrite14),
        
        .apb_psel2(apb_psel2), .apb_psel3(apb_psel3), .apb_psel4(apb_psel4),
        .apb_psel5(apb_psel5), .apb_psel6(apb_psel6), .apb_psel7(apb_psel7),
        .apb_psel8(apb_psel8), .apb_psel9(apb_psel9), .apb_psel10(apb_psel10),
        .apb_psel11(apb_psel11), .apb_psel12(apb_psel12), .apb_psel13(apb_psel13),
        .apb_psel14(apb_psel14),
        
        .apb_penable2(apb_penable2), .apb_penable3(apb_penable3), .apb_penable4(apb_penable4),
        .apb_penable5(apb_penable5), .apb_penable6(apb_penable6), .apb_penable7(apb_penable7),
        .apb_penable8(apb_penable8), .apb_penable9(apb_penable9), .apb_penable10(apb_penable10),
        .apb_penable11(apb_penable11), .apb_penable12(apb_penable12), .apb_penable13(apb_penable13),
        .apb_penable14(apb_penable14),
        
        .apb_pstrb2(apb_pstrb2), .apb_pstrb3(apb_pstrb3), .apb_pstrb4(apb_pstrb4),
        .apb_pstrb5(apb_pstrb5), .apb_pstrb6(apb_pstrb6), .apb_pstrb7(apb_pstrb7),
        .apb_pstrb8(apb_pstrb8), .apb_pstrb9(apb_pstrb9), .apb_pstrb10(apb_pstrb10),
        .apb_pstrb11(apb_pstrb11), .apb_pstrb12(apb_pstrb12), .apb_pstrb13(apb_pstrb13),
        .apb_pstrb14(apb_pstrb14),
        
        .apb_pwdata2(apb_pwdata2), .apb_pwdata3(apb_pwdata3), .apb_pwdata4(apb_pwdata4),
        .apb_pwdata5(apb_pwdata5), .apb_pwdata6(apb_pwdata6), .apb_pwdata7(apb_pwdata7),
        .apb_pwdata8(apb_pwdata8), .apb_pwdata9(apb_pwdata9), .apb_pwdata10(apb_pwdata10),
        .apb_pwdata11(apb_pwdata11), .apb_pwdata12(apb_pwdata12), .apb_pwdata13(apb_pwdata13),
        .apb_pwdata14(apb_pwdata14),
        
        .apb_prdata2(apb_prdata2), .apb_prdata3(apb_prdata3), .apb_prdata4(apb_prdata4),
        .apb_prdata5(apb_prdata5), .apb_prdata6(apb_prdata6), .apb_prdata7(apb_prdata7),
        .apb_prdata8(apb_prdata8), .apb_prdata9(apb_prdata9), .apb_prdata10(apb_prdata10),
        .apb_prdata11(apb_prdata11), .apb_prdata12(apb_prdata12), .apb_prdata13(apb_prdata13),
        .apb_prdata14(apb_prdata14),
        
        .apb_pready2(apb_pready2), .apb_pready3(apb_pready3), .apb_pready4(apb_pready4),
        .apb_pready5(apb_pready5), .apb_pready6(apb_pready6), .apb_pready7(apb_pready7),
        .apb_pready8(apb_pready8), .apb_pready9(apb_pready9), .apb_pready10(apb_pready10),
        .apb_pready11(apb_pready11), .apb_pready12(apb_pready12), .apb_pready13(apb_pready13),
        .apb_pready14(apb_pready14),
        
        .apb_pslverr2(apb_pslverr2), .apb_pslverr3(apb_pslverr3), .apb_pslverr4(apb_pslverr4),
        .apb_pslverr5(apb_pslverr5), .apb_pslverr6(apb_pslverr6), .apb_pslverr7(apb_pslverr7),
        .apb_pslverr8(apb_pslverr8), .apb_pslverr9(apb_pslverr9), .apb_pslverr10(apb_pslverr10),
        .apb_pslverr11(apb_pslverr11), .apb_pslverr12(apb_pslverr12), .apb_pslverr13(apb_pslverr13),
        .apb_pslverr14(apb_pslverr14),
        
        // APB Master Interface - Peripheral 15
        .apb_paddr15(apb_paddr15),
        .apb_pwrite15(apb_pwrite15),
        .apb_psel15(apb_psel15),
        .apb_penable15(apb_penable15),
        .apb_pstrb15(apb_pstrb15),
        .apb_pwdata15(apb_pwdata15),
        .apb_prdata15(apb_prdata15),
        .apb_pready15(apb_pready15),
        .apb_pslverr15(apb_pslverr15)
    );
    
    // Initialize all peripheral signals that aren't explicitly modeled
    initial begin
        // Default values for peripherals 2-14
        // Each peripheral returns its index as read data
        assign apb_prdata2 = 32'h2;
        assign apb_prdata3 = 32'h3;
        assign apb_prdata4 = 32'h4;
        assign apb_prdata5 = 32'h5;
        assign apb_prdata6 = 32'h6;
        assign apb_prdata7 = 32'h7;
        assign apb_prdata8 = 32'h8;
        assign apb_prdata9 = 32'h9;
        assign apb_prdata10 = 32'hA;
        assign apb_prdata11 = 32'hB;
        assign apb_prdata12 = 32'hC;
        assign apb_prdata13 = 32'hD;
        assign apb_prdata14 = 32'hE;
        
        // Default ready signals (always ready)
        assign apb_pready2 = 1'b1;
        assign apb_pready3 = 1'b1;
        assign apb_pready4 = 1'b1;
        assign apb_pready5 = 1'b1;
        assign apb_pready6 = 1'b1;
        assign apb_pready7 = 1'b1;
        assign apb_pready8 = 1'b1;
        assign apb_pready9 = 1'b1;
        assign apb_pready10 = 1'b1;
        assign apb_pready11 = 1'b1;
        assign apb_pready12 = 1'b1;
        assign apb_pready13 = 1'b1;
        assign apb_pready14 = 1'b1;
        
        // Default error signals (never error)
        assign apb_pslverr2 = 1'b0;
        assign apb_pslverr3 = 1'b0;
        assign apb_pslverr4 = 1'b0;
        assign apb_pslverr5 = 1'b0;
        assign apb_pslverr6 = 1'b0;
        assign apb_pslverr7 = 1'b0;
        assign apb_pslverr8 = 1'b0;
        assign apb_pslverr9 = 1'b0;
        assign apb_pslverr10 = 1'b0;
        assign apb_pslverr11 = 1'b0;
        assign apb_pslverr12 = 1'b0;
        assign apb_pslverr13 = 1'b0;
        assign apb_pslverr14 = 1'b0;
    end
    
    // Simple APB peripheral emulator for Peripheral 0
    // Returns address value as read data and asserts ready after one cycle
    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            apb_prdata0 <= 32'h0;
            apb_pready0 <= 1'b0;
            apb_pslverr0 <= 1'b0;
        end else begin
            // Default response after one cycle
            apb_pready0 <= apb_psel0 && apb_penable0;
            
            // For read transactions, return the address + 0xA0000000 as data
            if (apb_psel0 && !apb_pwrite0) begin
                apb_prdata0 <= {8'hA0, apb_paddr0}; // Mark with A0 prefix
            end
            
            // No errors in this test
            apb_pslverr0 <= 1'b0;
        end
    end
    
    // Simple APB peripheral emulator for Peripheral 1
    // Returns address value + 0xB0000000 as read data
    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            apb_prdata1 <= 32'h0;
            apb_pready1 <= 1'b0;
            apb_pslverr1 <= 1'b0;
        end else begin
            // Default response after one cycle
            apb_pready1 <= apb_psel1 && apb_penable1;
            
            // For read transactions, return the address + 0xB0000000 as data
            if (apb_psel1 && !apb_pwrite1) begin
                apb_prdata1 <= {8'hB0, apb_paddr1}; // Mark with B0 prefix
            end
            
            // No errors in this test
            apb_pslverr1 <= 1'b0;
        end
    end
    
    // Simple APB peripheral emulator for Peripheral 15
    // Returns address value + 0xF0000000 as read data
    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            apb_prdata15 <= 32'h0;
            apb_pready15 <= 1'b0;
            apb_pslverr15 <= 1'b0;
        end else begin
            // Default response after one cycle
            apb_pready15 <= apb_psel15 && apb_penable15;
            
            // For read transactions, return the address + 0xF0000000 as data
            if (apb_psel15 && !apb_pwrite15) begin
                apb_prdata15 <= {8'hF0, apb_paddr15}; // Mark with F0 prefix
            end
            
            // No errors in this test
            apb_pslverr15 <= 1'b0;
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