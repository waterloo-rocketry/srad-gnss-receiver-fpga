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

/* verilator lint_off EOFNEWLINE */
/* verilator lint_off UNUSEDSIGNAL */ // For host_addr[31:28] which are not used by this bridge
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
    output logic       host_slverr,     // Host slave error indication

    // APB Master Interfaces (to 16 Peripherals)
    output logic [23:0] apb_paddr   [15:0], // APB address bus
    output logic        apb_pwrite  [15:0], // Write enable (1=write, 0=read)
    output logic        apb_psel    [15:0], // Peripheral select
    output logic        apb_penable [15:0], // Enable signal
    output logic [3:0]  apb_pstrb   [15:0], // Write strobes
    output logic [31:0] apb_pwdata  [15:0], // Write data bus
    input  logic [31:0] apb_prdata  [15:0], // Read data bus
    input  logic        apb_pready  [15:0], // Ready signal from slave
    input  logic        apb_pslverr [15:0]  // Slave error response
);
/* verilator lint_on UNUSEDSIGNAL */

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
    logic [27:0] host_addr_r;   // Registered address from host (only up to bit 27 needed)
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
            host_addr_r <= 28'h0; // Adjusted for 28-bit width
            host_wdata_r <= 32'h0;
            host_wstrb_r <= 4'h0;
            host_write_r <= 1'b0;
        end else begin
            // Normal operation - update state
            curr_state <= next_state;
            
            // Capture host signals on valid transaction in IDLE state
            if (curr_state == IDLE && host_valid) begin
                host_addr_r <= host_addr[27:0]; // Capture only relevant bits
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
    // (These bits are from the original host_addr, now host_addr_r[27:24])
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
        for (int i = 0; i < 16; i++) begin
            apb_psel[i] = 1'b0;
        end
        
        // Only select a slave during SETUP or ACCESS states
        // and only if the slave selection is valid
        if ((curr_state == SETUP || curr_state == ACCESS) && valid_slave_sel) begin
            apb_psel[slave_sel] = 1'b1; // Select the target slave
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
    // This can be simplified if all peripherals share the same enable logic,
    // but individual assignment allows for future flexibility if needed.
    // For now, we will assign it to all.
    always_comb begin
        for (int i = 0; i < 16; i++) begin
            apb_penable[i] = apb_penable_common;
        end
    end
    
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
    always_comb begin
        for (int i = 0; i < 16; i++) begin
            apb_paddr[i] = apb_paddr_common;
        end
    end
    
    // Write signal - common to all slaves
    logic apb_pwrite_common;
    assign apb_pwrite_common = host_write_r;
    
    // Distribute common write signal to all slaves
    always_comb begin
        for (int i = 0; i < 16; i++) begin
            apb_pwrite[i] = apb_pwrite_common;
        end
    end
    
    // -----------------------------------------------------------------------
    // Write Data Distribution
    // -----------------------------------------------------------------------
    // Common write data signal derived from host write data
    // and distributed to all slaves
    // -----------------------------------------------------------------------
    logic [31:0] apb_pwdata_common;
    assign apb_pwdata_common = host_wdata_r;
    
    always_comb begin
        for (int i = 0; i < 16; i++) begin
            apb_pwdata[i] = apb_pwdata_common;
        end
    end
    
    // Write strobes
    logic [3:0] apb_pstrb_common;
    assign apb_pstrb_common = host_wstrb_r;
    
    always_comb begin
        for (int i = 0; i < 16; i++) begin
            apb_pstrb[i] = apb_pstrb_common;
        end
    end
    
    // Response multiplexer
    always_comb begin
        // Default response for unmapped regions
        selected_pready = 1'b1;  // Auto-complete unmapped accesses
        selected_prdata = 32'h0; // Return zeros for unmapped reads
        selected_pslverr = 1'b0; // No error by default
        
        if (valid_slave_sel) begin
            // Select appropriate slave responses based on the slave index
            selected_pready = apb_pready[slave_sel];
            selected_prdata = apb_prdata[slave_sel];
            selected_pslverr = apb_pslverr[slave_sel];
        end
    end
    
    // Final host interface response
    // Host Interface Response
    assign host_ready = (curr_state == COMPLETE);
    assign host_rdata = selected_prdata; // Pass through selected peripheral response
    assign host_slverr = (curr_state == COMPLETE) ? selected_pslverr : 1'b0; // Pass through slave error on completion

endmodule // apb_bridge_top
/* verilator lint_on EOFNEWLINE */
