module apb_bridge_top (
    // Clock and resets
    input logic       sys_clk,
    input logic       rst_n,

    // Host Memory Interface (from MCU)
    input logic        host_valid,  // Transaction request valid
    output logic       host_ready,  // Transaction request ready
    input logic [31:0] host_addr,   // Transaction address
    input logic [31:0] host_wdata,  // Transaction write data
    input logic [3:0]  host_wstrb,  // Transaction write strobe
    output logic [31:0] host_rdata, // Transaction read data

    // APB Master Interface (to Peripherals)
    output logic [15:0] apb_paddr,      // APB address
    output logic        apb_pwrite,     // APB write enable
    output logic        apb_psel,       // APB select
    output logic        apb_penable,    // APB enable
    output logic [3:0]  apb_pstrb,      // APB write strobes
    output logic [31:0] apb_pwdata,     // APB write data
    input  logic [31:0] apb_prdata,     // APB read data
    input  logic        apb_pready,     // APB ready
    input  logic        apb_pslverr     // APB error
);

    // APB transaction state machine
    typedef enum logic[1:0] {
        IDLE,
        SETUP,
        ACCESS,
        COMPLETE
    } apb_state_t; 

    apb_state_t curr_state, next_state;

    // Register host signals for stability
    logic [31:0] host_addr_r;
    logic [31:0] host_wdata_r;
    logic [3:0]  host_wstrb_r;
    logic        host_write_r;

    // State machine sequential logic
    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            curr_state <= IDLE;
            host_addr_r <= 32'h0;
            host_wdata_r <= 32'h0;
            host_wstrb_r <= 4'h0;
            host_write_r <= 1'b0;
        end else begin
            curr_state <= next_state;
            
            // Capture host signals on valid transaction
            if (curr_state == IDLE && host_valid) begin
                host_addr_r <= host_addr;
                host_wdata_r <= host_wdata;
                host_wstrb_r <= host_wstrb;
                host_write_r <= |host_wstrb; // Write if any write strobe is active
            end
        end
    end

    // State machine combinational logic
    always_comb begin
        // Default next state
        next_state = curr_state;
        
        case (curr_state)
            IDLE: begin
                if (host_valid) begin
                    next_state = SETUP;
                end
            end
            
            SETUP: begin
                next_state = ACCESS;
            end
            
            ACCESS: begin
                if (apb_pready) begin
                    next_state = COMPLETE;
                end
            end
            
            COMPLETE: begin
                next_state = IDLE;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end
    
    // APB control signals
    always_comb begin
        // Default values
        apb_psel = 1'b0;
        apb_penable = 1'b0;
        host_ready = 1'b0;
        
        case (curr_state)
            IDLE: begin
                // No APB transaction
                apb_psel = 1'b0;
                apb_penable = 1'b0;
                host_ready = 1'b0;
            end
            
            SETUP: begin
                // APB setup phase
                apb_psel = 1'b1;
                apb_penable = 1'b0;
                host_ready = 1'b0;
            end
            
            ACCESS: begin
                // APB access phase
                apb_psel = 1'b1;
                apb_penable = 1'b1;
                host_ready = 1'b0;
            end
            
            COMPLETE: begin
                // Transaction complete
                apb_psel = 1'b0;
                apb_penable = 1'b0;
                host_ready = 1'b1;
            end
            
            default: begin
                apb_psel = 1'b0;
                apb_penable = 1'b0;
                host_ready = 1'b0;
            end
        endcase
    end

    // APB data path
    assign apb_paddr = host_addr_r[15:0];
    assign apb_pwrite = host_write_r;
    assign apb_pwdata = host_wdata_r;
    assign apb_pstrb = host_wstrb_r;
    
    // Host read data
    assign host_rdata = apb_prdata;

endmodule // apb_bridge_top