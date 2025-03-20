/*
 * APB Bridge Top Module
 *
 * This module implements a bridge between a host memory interface (e.g., from an MCU)
 * and 16 APB slave interfaces. It handles address decoding, transaction control,
 * and multiplexing of responses from the selected slave.
 *
 * Address mapping:
 * - Bits [23:0]  - Passed directly to the selected peripheral
 * - Bits [27:24] - Used for slave selection (0-15)
 * - Bits [29:28] - Ignored
 * - Bits [31:30] - Available for other purposes
 *
 * Each slave gets a 16MB address region.
 */
module apb_bridge_top (
    // Clock and resets
    input logic       sys_clk,          // System clock
    input logic       rst_n,            // Active-low reset

    // Host Memory Interface (from MCU)
    input logic        host_valid,      // Transaction request valid
    output logic       host_ready,      // Transaction request ready
    input logic [31:0] host_addr,       // Transaction address
    input logic [31:0] host_wdata,      // Transaction write data
    input logic [3:0]  host_wstrb,      // Transaction write strobe (byte enables)
    output logic [31:0] host_rdata,     // Transaction read data

    // APB Master Interfaces (to 16 Peripherals)
    // Slave 0 - Address range when bits [27:24] = 4'h0
    output logic [23:0] apb_paddr0,     // APB address bus
    output logic        apb_pwrite0,    // Write enable (1=write, 0=read)
    output logic        apb_psel0,      // Peripheral select
    output logic        apb_penable0,   // Enable signal
    output logic [3:0]  apb_pstrb0,     // Write strobes
    output logic [31:0] apb_pwdata0,    // Write data bus
    input  logic [31:0] apb_prdata0,    // Read data bus
    input  logic        apb_pready0,    // Ready signal from slave
    input  logic        apb_pslverr0,   // Slave error response

    // Slave 1 - Address range when bits [27:24] = 4'h1
    output logic [23:0] apb_paddr1,     // APB address bus
    output logic        apb_pwrite1,    // Write enable
    output logic        apb_psel1,      // Peripheral select
    output logic        apb_penable1,   // Enable signal
    output logic [3:0]  apb_pstrb1,     // Write strobes
    output logic [31:0] apb_pwdata1,    // Write data bus
    input  logic [31:0] apb_prdata1,    // Read data bus
    input  logic        apb_pready1,    // Ready signal from slave
    input  logic        apb_pslverr1,   // Slave error response

    // Slave 2 - Address range when bits [27:24] = 4'h2
    output logic [23:0] apb_paddr2,     // APB address bus
    output logic        apb_pwrite2,    // Write enable
    output logic        apb_psel2,      // Peripheral select
    output logic        apb_penable2,   // Enable signal
    output logic [3:0]  apb_pstrb2,     // Write strobes
    output logic [31:0] apb_pwdata2,    // Write data bus
    input  logic [31:0] apb_prdata2,    // Read data bus
    input  logic        apb_pready2,    // Ready signal from slave
    input  logic        apb_pslverr2,   // Slave error response

    // Slave 3 - Address range when bits [27:24] = 4'h3
    output logic [23:0] apb_paddr3,     // APB address bus
    output logic        apb_pwrite3,    // Write enable
    output logic        apb_psel3,      // Peripheral select
    output logic        apb_penable3,   // Enable signal
    output logic [3:0]  apb_pstrb3,     // Write strobes
    output logic [31:0] apb_pwdata3,    // Write data bus
    input  logic [31:0] apb_prdata3,    // Read data bus
    input  logic        apb_pready3,    // Ready signal from slave
    input  logic        apb_pslverr3,   // Slave error response

    // Slave 4 - Address range when bits [27:24] = 4'h4
    output logic [23:0] apb_paddr4,     // APB address bus
    output logic        apb_pwrite4,    // Write enable
    output logic        apb_psel4,      // Peripheral select
    output logic        apb_penable4,   // Enable signal
    output logic [3:0]  apb_pstrb4,     // Write strobes
    output logic [31:0] apb_pwdata4,    // Write data bus
    input  logic [31:0] apb_prdata4,    // Read data bus
    input  logic        apb_pready4,    // Ready signal from slave
    input  logic        apb_pslverr4,   // Slave error response

    // Slave 5 - Address range when bits [27:24] = 4'h5
    output logic [23:0] apb_paddr5,     // APB address bus
    output logic        apb_pwrite5,    // Write enable
    output logic        apb_psel5,      // Peripheral select
    output logic        apb_penable5,   // Enable signal
    output logic [3:0]  apb_pstrb5,     // Write strobes
    output logic [31:0] apb_pwdata5,    // Write data bus
    input  logic [31:0] apb_prdata5,    // Read data bus
    input  logic        apb_pready5,    // Ready signal from slave
    input  logic        apb_pslverr5,   // Slave error response

    // Slave 6 - Address range when bits [27:24] = 4'h6
    output logic [23:0] apb_paddr6,     // APB address bus
    output logic        apb_pwrite6,    // Write enable
    output logic        apb_psel6,      // Peripheral select
    output logic        apb_penable6,   // Enable signal
    output logic [3:0]  apb_pstrb6,     // Write strobes
    output logic [31:0] apb_pwdata6,    // Write data bus
    input  logic [31:0] apb_prdata6,    // Read data bus
    input  logic        apb_pready6,    // Ready signal from slave
    input  logic        apb_pslverr6,   // Slave error response

    // Slave 7 - Address range when bits [27:24] = 4'h7
    output logic [23:0] apb_paddr7,     // APB address bus
    output logic        apb_pwrite7,    // Write enable
    output logic        apb_psel7,      // Peripheral select
    output logic        apb_penable7,   // Enable signal
    output logic [3:0]  apb_pstrb7,     // Write strobes
    output logic [31:0] apb_pwdata7,    // Write data bus
    input  logic [31:0] apb_prdata7,    // Read data bus
    input  logic        apb_pready7,    // Ready signal from slave
    input  logic        apb_pslverr7,   // Slave error response

    // Slave 8 - Address range when bits [27:24] = 4'h8
    output logic [23:0] apb_paddr8,     // APB address bus
    output logic        apb_pwrite8,    // Write enable
    output logic        apb_psel8,      // Peripheral select
    output logic        apb_penable8,   // Enable signal
    output logic [3:0]  apb_pstrb8,     // Write strobes
    output logic [31:0] apb_pwdata8,    // Write data bus
    input  logic [31:0] apb_prdata8,    // Read data bus
    input  logic        apb_pready8,    // Ready signal from slave
    input  logic        apb_pslverr8,   // Slave error response

    // Slave 9 - Address range when bits [27:24] = 4'h9
    output logic [23:0] apb_paddr9,     // APB address bus
    output logic        apb_pwrite9,    // Write enable
    output logic        apb_psel9,      // Peripheral select
    output logic        apb_penable9,   // Enable signal
    output logic [3:0]  apb_pstrb9,     // Write strobes
    output logic [31:0] apb_pwdata9,    // Write data bus
    input  logic [31:0] apb_prdata9,    // Read data bus
    input  logic        apb_pready9,    // Ready signal from slave
    input  logic        apb_pslverr9,   // Slave error response

    // Slave 10 - Address range when bits [27:24] = 4'hA
    output logic [23:0] apb_paddr10,    // APB address bus
    output logic        apb_pwrite10,    // Write enable
    output logic        apb_psel10,      // Peripheral select
    output logic        apb_penable10,    // Enable signal
    output logic [3:0]  apb_pstrb10,     // Write strobes
    output logic [31:0] apb_pwdata10,    // Write data bus
    input  logic [31:0] apb_prdata10,    // Read data bus
    input  logic        apb_pready10,    // Ready signal from slave
    input  logic        apb_pslverr10,    // Slave error response

    // Slave 11 - Address range when bits [27:24] = 4'hB
    output logic [23:0] apb_paddr11,     // APB address bus
    output logic        apb_pwrite11,     // Write enable
    output logic        apb_psel11,       // Peripheral select
    output logic        apb_penable11,     // Enable signal
    output logic [3:0]  apb_pstrb11,      // Write strobes
    output logic [31:0] apb_pwdata11,      // Write data bus
    input  logic [31:0] apb_prdata11,      // Read data bus
    input  logic        apb_pready11,      // Ready signal from slave
    input  logic        apb_pslverr11,      // Slave error response

    // Slave 12 - Address range when bits [27:24] = 4'hC
    output logic [23:0] apb_paddr12,      // APB address bus
    output logic        apb_pwrite12,      // Write enable
    output logic        apb_psel12,        // Peripheral select
    output logic        apb_penable12,      // Enable signal
    output logic [3:0]  apb_pstrb12,        // Write strobes
    output logic [31:0] apb_pwdata12,        // Write data bus
    input  logic [31:0] apb_prdata12,        // Read data bus
    input  logic        apb_pready12,        // Ready signal from slave
    input  logic        apb_pslverr12,        // Slave error response

    // Slave 13 - Address range when bits [27:24] = 4'hD
    output logic [23:0] apb_paddr13,      // APB address bus
    output logic        apb_pwrite13,      // Write enable
    output logic        apb_psel13,         // Peripheral select
    output logic        apb_penable13,       // Enable signal
    output logic [3:0]  apb_pstrb13,         // Write strobes
    output logic [31:0] apb_pwdata13,         // Write data bus
    input  logic [31:0] apb_prdata13,         // Read data bus
    input  logic        apb_pready13,         // Ready signal from slave
    input  logic        apb_pslverr13,         // Slave error response

    // Slave 14 - Address range when bits [27:24] = 4'hE
    output logic [23:0] apb_paddr14,      // APB address bus
    output logic        apb_pwrite14,      // Write enable
    output logic        apb_psel14,         // Peripheral select
    output logic        apb_penable14,       // Enable signal
    output logic [3:0]  apb_pstrb14,         // Write strobes
    output logic [31:0] apb_pwdata14,         // Write data bus
    input  logic [31:0] apb_prdata14,         // Read data bus
    input  logic        apb_pready14,         // Ready signal from slave
    input  logic        apb_pslverr14,         // Slave error response

    // Slave 15 - Address range when bits [27:24] = 4'hF
    output logic [23:0] apb_paddr15,      // APB address bus
    output logic        apb_pwrite15,      // Write enable
    output logic        apb_psel15,         // Peripheral select
    output logic        apb_penable15,       // Enable signal
    output logic [3:0]  apb_pstrb15,         // Write strobes
    output logic [31:0] apb_pwdata15,         // Write data bus
    input  logic [31:0] apb_prdata15,         // Read data bus
    input  logic        apb_pready15,         // Ready signal from slave
    input  logic        apb_pslverr15         // Slave error response
);

    // -----------------------------------------------------------------------
    // APB Transaction State Machine
    // -----------------------------------------------------------------------
    // The APB protocol uses a state machine to control transactions:
    // IDLE    -> Initial state, waiting for a valid transaction request
    // SETUP   -> Setting up the transaction (address, data, control signals)
    // ACCESS  -> Active transaction, waiting for slave response
    // COMPLETE -> Transaction completed, results returned to host
    // -----------------------------------------------------------------------
    typedef enum logic[1:0] {
        IDLE,       // Waiting for transaction
        SETUP,      // Address phase
        ACCESS,     // Data phase
        COMPLETE    // Completion phase
    } apb_state_t; 

    apb_state_t curr_state, next_state;  // Current and next state registers

    // -----------------------------------------------------------------------
    // Registered Host Interface Signals
    // -----------------------------------------------------------------------
    // These registers capture and hold the host interface signals
    // for stability during the APB transaction
    // -----------------------------------------------------------------------
    logic [31:0] host_addr_r;   // Registered address from host
    logic [31:0] host_wdata_r;  // Registered write data from host
    logic [3:0]  host_wstrb_r;  // Registered write strobes from host
    logic        host_write_r;  // Derived write/read indicator

    // -----------------------------------------------------------------------
    // Slave Select and Response Signals
    // -----------------------------------------------------------------------
    logic [3:0]  slave_sel;       // Selected slave index (0-15)
    logic        valid_slave_sel; // Indicates if selected slave is valid
    
    // Selected slave response signals - multiplexed from all slaves
    logic        selected_pready;   // Ready signal from selected slave
    logic [31:0] selected_prdata;   // Read data from selected slave
    logic        selected_pslverr;  // Error signal from selected slave

    // -----------------------------------------------------------------------
    // State Machine Sequential Logic
    // -----------------------------------------------------------------------
    // This always_ff block handles state transitions and signal registration
    // on the positive edge of the clock or negative edge of reset
    // -----------------------------------------------------------------------
    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset state
            curr_state <= IDLE;
            host_addr_r <= 32'h0;
            host_wdata_r <= 32'h0;
            host_wstrb_r <= 4'h0;
            host_write_r <= 1'b0;
        end else begin
            // Normal operation - update state
            curr_state <= next_state;
            
            // Capture host signals on valid transaction in IDLE state
            if (curr_state == IDLE && host_valid) begin
                host_addr_r <= host_addr;
                host_wdata_r <= host_wdata;
                host_wstrb_r <= host_wstrb;
                host_write_r <= |host_wstrb; // Write if any write strobe is active
            end
        end
    end

    // -----------------------------------------------------------------------
    // State Machine Combinational Logic
    // -----------------------------------------------------------------------
    // This always_comb block determines the next state based on
    // the current state and input signals
    // -----------------------------------------------------------------------
    always_comb begin
        // Default next state is current state
        next_state = curr_state;
        
        case (curr_state)
            IDLE: begin
                // Transition to SETUP if host requests a transaction
                if (host_valid) begin
                    next_state = SETUP;
                end
            end
            
            SETUP: begin
                // SETUP is always followed by ACCESS
                next_state = ACCESS;
            end
            
            ACCESS: begin
                // Wait in ACCESS until selected slave indicates ready
                if (selected_pready) begin
                    next_state = COMPLETE;
                end
            end
            
            COMPLETE: begin
                // COMPLETE always returns to IDLE
                next_state = IDLE;
            end
            
            default: begin
                // Safety - return to IDLE if in an undefined state
                next_state = IDLE;
            end
        endcase
    end
    
    // -----------------------------------------------------------------------
    // Address Decoder
    // -----------------------------------------------------------------------
    // Extracts the slave select bits from the address
    // Each slave gets a 16MB address region (24 bits)
    // Bits [27:24] determine which slave is selected
    // -----------------------------------------------------------------------
    always_comb begin
        // Extract the slave select bits from address
        slave_sel = host_addr_r[27:24];
        
        // For now, all slave selects are considered valid
        // This could be enhanced to filter out invalid slave indices
        valid_slave_sel = 1'b1;
    end
    
    // -----------------------------------------------------------------------
    // Slave Select Signal Generation
    // -----------------------------------------------------------------------
    // Generates the select signals for each slave based on the
    // decoded address and current state
    // -----------------------------------------------------------------------
    always_comb begin
        // Default - no slave selected
        apb_psel0 = 1'b0;
        apb_psel1 = 1'b0;
        apb_psel2 = 1'b0;
        apb_psel3 = 1'b0;
        apb_psel4 = 1'b0;
        apb_psel5 = 1'b0;
        apb_psel6 = 1'b0;
        apb_psel7 = 1'b0;
        apb_psel8 = 1'b0;
        apb_psel9 = 1'b0;
        apb_psel10 = 1'b0;
        apb_psel11 = 1'b0;
        apb_psel12 = 1'b0;
        apb_psel13 = 1'b0;
        apb_psel14 = 1'b0;
        apb_psel15 = 1'b0;
        
        // Only select a slave during SETUP or ACCESS states
        // and only if the slave selection is valid
        if ((curr_state == SETUP || curr_state == ACCESS) && valid_slave_sel) begin
            case (slave_sel)
                4'h0: apb_psel0 = 1'b1;   // Select slave 0
                4'h1: apb_psel1 = 1'b1;   // Select slave 1
                4'h2: apb_psel2 = 1'b1;   // Select slave 2
                4'h3: apb_psel3 = 1'b1;   // Select slave 3
                4'h4: apb_psel4 = 1'b1;   // Select slave 4
                4'h5: apb_psel5 = 1'b1;   // Select slave 5
                4'h6: apb_psel6 = 1'b1;   // Select slave 6
                4'h7: apb_psel7 = 1'b1;   // Select slave 7
                4'h8: apb_psel8 = 1'b1;   // Select slave 8
                4'h9: apb_psel9 = 1'b1;   // Select slave 9
                4'hA: apb_psel10 = 1'b1;  // Select slave 10
                4'hB: apb_psel11 = 1'b1;  // Select slave 11
                4'hC: apb_psel12 = 1'b1;  // Select slave 12
                4'hD: apb_psel13 = 1'b1;  // Select slave 13
                4'hE: apb_psel14 = 1'b1;  // Select slave 14
                4'hF: apb_psel15 = 1'b1;  // Select slave 15
            endcase
        end
    end
    
    // -----------------------------------------------------------------------
    // APB Enable Signal Generation
    // -----------------------------------------------------------------------
    // The APB enable signal is active during the ACCESS state
    // and is broadcast to all slaves
    // -----------------------------------------------------------------------
    logic apb_penable_common;
    // Enable is active during the ACCESS state
    assign apb_penable_common = (curr_state == ACCESS);
    
    // Assign the common enable signal to all slaves
    assign apb_penable0 = apb_penable_common;
    assign apb_penable1 = apb_penable_common;
    assign apb_penable2 = apb_penable_common;
    assign apb_penable3 = apb_penable_common;
    assign apb_penable4 = apb_penable_common;
    assign apb_penable5 = apb_penable_common;
    assign apb_penable6 = apb_penable_common;
    assign apb_penable7 = apb_penable_common;
    assign apb_penable8 = apb_penable_common;
    assign apb_penable9 = apb_penable_common;
    assign apb_penable10 = apb_penable_common;
    assign apb_penable11 = apb_penable_common;
    assign apb_penable12 = apb_penable_common;
    assign apb_penable13 = apb_penable_common;
    assign apb_penable14 = apb_penable_common;
    assign apb_penable15 = apb_penable_common;
    
    // -----------------------------------------------------------------------
    // Common Control Signal Distribution
    // -----------------------------------------------------------------------
    // These signals are common to all slaves and are derived
    // from the registered host signals
    // -----------------------------------------------------------------------
    
    // Address - lower 24 bits from host address
    logic [23:0] apb_paddr_common;
    assign apb_paddr_common = host_addr_r[23:0];
    
    // Distribute common address to all slaves
    assign apb_paddr0 = apb_paddr_common;
    assign apb_paddr1 = apb_paddr_common;
    assign apb_paddr2 = apb_paddr_common;
    assign apb_paddr3 = apb_paddr_common;
    assign apb_paddr4 = apb_paddr_common;
    assign apb_paddr5 = apb_paddr_common;
    assign apb_paddr6 = apb_paddr_common;
    assign apb_paddr7 = apb_paddr_common;
    assign apb_paddr8 = apb_paddr_common;
    assign apb_paddr9 = apb_paddr_common;
    assign apb_paddr10 = apb_paddr_common;
    assign apb_paddr11 = apb_paddr_common;
    assign apb_paddr12 = apb_paddr_common;
    assign apb_paddr13 = apb_paddr_common;
    assign apb_paddr14 = apb_paddr_common;
    assign apb_paddr15 = apb_paddr_common;
    
    // Write signal - common to all slaves
    logic apb_pwrite_common;
    assign apb_pwrite_common = host_write_r;
    
    // Distribute common write signal to all slaves
    assign apb_pwrite0 = apb_pwrite_common;
    assign apb_pwrite1 = apb_pwrite_common;
    assign apb_pwrite2 = apb_pwrite_common;
    assign apb_pwrite3 = apb_pwrite_common;
    assign apb_pwrite4 = apb_pwrite_common;
    assign apb_pwrite5 = apb_pwrite_common;
    assign apb_pwrite6 = apb_pwrite_common;
    assign apb_pwrite7 = apb_pwrite_common;
    assign apb_pwrite8 = apb_pwrite_common;
    assign apb_pwrite9 = apb_pwrite_common;
    assign apb_pwrite10 = apb_pwrite_common;
    assign apb_pwrite11 = apb_pwrite_common;
    assign apb_pwrite12 = apb_pwrite_common;
    assign apb_pwrite13 = apb_pwrite_common;
    assign apb_pwrite14 = apb_pwrite_common;
    assign apb_pwrite15 = apb_pwrite_common;
    
    // -----------------------------------------------------------------------
    // Write Data Distribution
    // -----------------------------------------------------------------------
    // Common write data signal derived from host write data
    // and distributed to all slaves
    // -----------------------------------------------------------------------
    logic [31:0] apb_pwdata_common;
    assign apb_pwdata_common = host_wdata_r;
    
    assign apb_pwdata0 = apb_pwdata_common;
    assign apb_pwdata1 = apb_pwdata_common;
    assign apb_pwdata2 = apb_pwdata_common;
    assign apb_pwdata3 = apb_pwdata_common;
    assign apb_pwdata4 = apb_pwdata_common;
    assign apb_pwdata5 = apb_pwdata_common;
    assign apb_pwdata6 = apb_pwdata_common;
    assign apb_pwdata7 = apb_pwdata_common;
    assign apb_pwdata8 = apb_pwdata_common;
    assign apb_pwdata9 = apb_pwdata_common;
    assign apb_pwdata10 = apb_pwdata_common;
    assign apb_pwdata11 = apb_pwdata_common;
    assign apb_pwdata12 = apb_pwdata_common;
    assign apb_pwdata13 = apb_pwdata_common;
    assign apb_pwdata14 = apb_pwdata_common;
    assign apb_pwdata15 = apb_pwdata_common;
    
    // Write strobes
    logic [3:0] apb_pstrb_common;
    assign apb_pstrb_common = host_wstrb_r;
    
    assign apb_pstrb0 = apb_pstrb_common;
    assign apb_pstrb1 = apb_pstrb_common;
    assign apb_pstrb2 = apb_pstrb_common;
    assign apb_pstrb3 = apb_pstrb_common;
    assign apb_pstrb4 = apb_pstrb_common;
    assign apb_pstrb5 = apb_pstrb_common;
    assign apb_pstrb6 = apb_pstrb_common;
    assign apb_pstrb7 = apb_pstrb_common;
    assign apb_pstrb8 = apb_pstrb_common;
    assign apb_pstrb9 = apb_pstrb_common;
    assign apb_pstrb10 = apb_pstrb_common;
    assign apb_pstrb11 = apb_pstrb_common;
    assign apb_pstrb12 = apb_pstrb_common;
    assign apb_pstrb13 = apb_pstrb_common;
    assign apb_pstrb14 = apb_pstrb_common;
    assign apb_pstrb15 = apb_pstrb_common;
    
    // Response multiplexer
    always_comb begin
        // Default response for unmapped regions
        selected_pready = 1'b1;  // Auto-complete unmapped accesses
        selected_prdata = 32'h0; // Return zeros for unmapped reads
        selected_pslverr = 1'b0; // No error by default
        
        if (valid_slave_sel) begin
            // Select appropriate slave responses based on the slave index
case (slave_sel)
                4'h0: begin
                    selected_pready = apb_pready0;
                    selected_prdata = apb_prdata0;
                    selected_pslverr = apb_pslverr0;
                end
                4'h1: begin
                    selected_pready = apb_pready1;
                    selected_prdata = apb_prdata1;
                    selected_pslverr = apb_pslverr1;
                end
                4'h2: begin
                    selected_pready = apb_pready2;
                    selected_prdata = apb_prdata2;
                    selected_pslverr = apb_pslverr2;
                end
                4'h3: begin
                    selected_pready = apb_pready3;
                    selected_prdata = apb_prdata3;
                    selected_pslverr = apb_pslverr3;
                end
                4'h4: begin
                    selected_pready = apb_pready4;
                    selected_prdata = apb_prdata4;
                    selected_pslverr = apb_pslverr4;
                end
                4'h5: begin
                    selected_pready = apb_pready5;
                    selected_prdata = apb_prdata5;
                    selected_pslverr = apb_pslverr5;
                end
                4'h6: begin
                    selected_pready = apb_pready6;
                    selected_prdata = apb_prdata6;
                    selected_pslverr = apb_pslverr6;
                end
                4'h7: begin
                    selected_pready = apb_pready7;
                    selected_prdata = apb_prdata7;
                    selected_pslverr = apb_pslverr7;
                end
                4'h8: begin
                    selected_pready = apb_pready8;
                    selected_prdata = apb_prdata8;
                    selected_pslverr = apb_pslverr8;
                end
                4'h9: begin
                    selected_pready = apb_pready9;
                    selected_prdata = apb_prdata9;
                    selected_pslverr = apb_pslverr9;
                end
                4'hA: begin
                    selected_pready = apb_pready10;
                    selected_prdata = apb_prdata10;
                    selected_pslverr = apb_pslverr10;
                end
                4'hB: begin
                    selected_pready = apb_pready11;
                    selected_prdata = apb_prdata11;
                    selected_pslverr = apb_pslverr11;
                end
                4'hC: begin
                    selected_pready = apb_pready12;
                    selected_prdata = apb_prdata12;
                    selected_pslverr = apb_pslverr12;
                end
                4'hD: begin
                    selected_pready = apb_pready13;
                    selected_prdata = apb_prdata13;
                    selected_pslverr = apb_pslverr13;
                end
                4'hE: begin
                    selected_pready = apb_pready14;
                    selected_prdata = apb_prdata14;
                    selected_pslverr = apb_pslverr14;
                end
                4'hF: begin
                    selected_pready = apb_pready15;
                    selected_prdata = apb_prdata15;
                    selected_pslverr = apb_pslverr15;
                end
            endcase
        end
    end
    
    // Final host interface response
    // Host Interface Response
    assign host_ready = (curr_state == COMPLETE);
    assign host_rdata = selected_prdata; // Pass through selected peripheral response

endmodule // apb_bridge_top