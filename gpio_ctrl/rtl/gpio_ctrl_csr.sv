// Generated by PeakRDL-regblock - A free and open-source SystemVerilog generator
//  https://github.com/SystemRDL/PeakRDL-regblock

/* verilator lint_off MULTIDRIVEN */

module gpio_ctrl_csr (
        input wire clk,
        input wire rst,

        input wire s_apb_psel,
        input wire s_apb_penable,
        input wire s_apb_pwrite,
        input wire [2:0] s_apb_pprot,
        input wire [3:0] s_apb_paddr,
        input wire [31:0] s_apb_pwdata,
        input wire [3:0] s_apb_pstrb,
        output logic s_apb_pready,
        output logic [31:0] s_apb_prdata,
        output logic s_apb_pslverr,

        input gpio_ctrl_csr_pkg::gpio_ctrl_csr__in_t hwif_in,
        output gpio_ctrl_csr_pkg::gpio_ctrl_csr__out_t hwif_out
    );

    //--------------------------------------------------------------------------
    // CPU Bus interface logic
    //--------------------------------------------------------------------------
    logic cpuif_req;
    logic cpuif_req_is_wr;
    logic [3:0] cpuif_addr;
    logic [31:0] cpuif_wr_data;
    logic [31:0] cpuif_wr_biten;
    logic cpuif_req_stall_wr;
    logic cpuif_req_stall_rd;

    logic cpuif_rd_ack;
    logic cpuif_rd_err;
    logic [31:0] cpuif_rd_data;

    logic cpuif_wr_ack;
    logic cpuif_wr_err;

    // Request
    logic is_active;
    always_ff @(posedge clk) begin
        if(rst) begin
            is_active <= '0;
            cpuif_req <= '0;
            cpuif_req_is_wr <= '0;
            cpuif_addr <= '0;
            cpuif_wr_data <= '0;
            cpuif_wr_biten <= '0;
        end else begin
            if(~is_active) begin
                if(s_apb_psel) begin
                    is_active <= '1;
                    cpuif_req <= '1;
                    cpuif_req_is_wr <= s_apb_pwrite;
                    cpuif_addr <= {s_apb_paddr[3:2], 2'b0};
                    cpuif_wr_data <= s_apb_pwdata;
                    for(int i=0; i<4; i++) begin
                        cpuif_wr_biten[i*8 +: 8] <= {8{s_apb_pstrb[i]}};
                    end
                end
            end else begin
                cpuif_req <= '0;
                if(cpuif_rd_ack || cpuif_wr_ack) begin
                    is_active <= '0;
                end
            end
        end
    end

    // Response
    assign s_apb_pready = cpuif_rd_ack | cpuif_wr_ack;
    assign s_apb_prdata = cpuif_rd_data;
    assign s_apb_pslverr = cpuif_rd_err | cpuif_wr_err;

    logic cpuif_req_masked;

    // Read & write latencies are balanced. Stalls not required
    assign cpuif_req_stall_rd = '0;
    assign cpuif_req_stall_wr = '0;
    assign cpuif_req_masked = cpuif_req
                            & !(!cpuif_req_is_wr & cpuif_req_stall_rd)
                            & !(cpuif_req_is_wr & cpuif_req_stall_wr);

    //--------------------------------------------------------------------------
    // Address Decode
    //--------------------------------------------------------------------------
    typedef struct {
        logic OUTPUT_CTRL_VALUE;
        logic OUTPUT_CTRL_ENABLE;
        logic INPUT_STATUS;
    } decoded_reg_strb_t;
    decoded_reg_strb_t decoded_reg_strb;
    logic decoded_req;
    logic decoded_req_is_wr;
    logic [31:0] decoded_wr_data;
    logic [31:0] decoded_wr_biten;

    always_comb begin
        decoded_reg_strb.OUTPUT_CTRL_VALUE = cpuif_req_masked & (cpuif_addr == 4'h0);
        decoded_reg_strb.OUTPUT_CTRL_ENABLE = cpuif_req_masked & (cpuif_addr == 4'h4);
        decoded_reg_strb.INPUT_STATUS = cpuif_req_masked & (cpuif_addr == 4'h8);
    end

    // Pass down signals to next stage
    assign decoded_req = cpuif_req_masked;
    assign decoded_req_is_wr = cpuif_req_is_wr;
    assign decoded_wr_data = cpuif_wr_data;
    assign decoded_wr_biten = cpuif_wr_biten;

    //--------------------------------------------------------------------------
    // Field logic
    //--------------------------------------------------------------------------
    typedef struct {
        struct {
            struct {
                logic [31:0] next;
                logic load_next;
            } OVALUE;
        } OUTPUT_CTRL_VALUE;
        struct {
            struct {
                logic [31:0] next;
                logic load_next;
            } OENABLE;
        } OUTPUT_CTRL_ENABLE;
    } field_combo_t;
    field_combo_t field_combo;

    typedef struct {
        struct {
            struct {
                logic [31:0] value;
            } OVALUE;
        } OUTPUT_CTRL_VALUE;
        struct {
            struct {
                logic [31:0] value;
            } OENABLE;
        } OUTPUT_CTRL_ENABLE;
    } field_storage_t;
    field_storage_t field_storage;

    // Field: gpio_ctrl_csr.OUTPUT_CTRL_VALUE.OVALUE
    always_comb begin
        automatic logic [31:0] next_c;
        automatic logic load_next_c;
        next_c = field_storage.OUTPUT_CTRL_VALUE.OVALUE.value;
        load_next_c = '0;
        if(decoded_reg_strb.OUTPUT_CTRL_VALUE && decoded_req_is_wr) begin // SW write
            next_c = (field_storage.OUTPUT_CTRL_VALUE.OVALUE.value & ~decoded_wr_biten[31:0]) | (decoded_wr_data[31:0] & decoded_wr_biten[31:0]);
            load_next_c = '1;
        end
        field_combo.OUTPUT_CTRL_VALUE.OVALUE.next = next_c;
        field_combo.OUTPUT_CTRL_VALUE.OVALUE.load_next = load_next_c;
    end
    always_ff @(posedge clk) begin
        if(rst) begin
            field_storage.OUTPUT_CTRL_VALUE.OVALUE.value <= 32'h0;
        end else begin
            if(field_combo.OUTPUT_CTRL_VALUE.OVALUE.load_next) begin
                field_storage.OUTPUT_CTRL_VALUE.OVALUE.value <= field_combo.OUTPUT_CTRL_VALUE.OVALUE.next;
            end
        end
    end
    assign hwif_out.OUTPUT_CTRL_VALUE.OVALUE.value = field_storage.OUTPUT_CTRL_VALUE.OVALUE.value;
    // Field: gpio_ctrl_csr.OUTPUT_CTRL_ENABLE.OENABLE
    always_comb begin
        automatic logic [31:0] next_c;
        automatic logic load_next_c;
        next_c = field_storage.OUTPUT_CTRL_ENABLE.OENABLE.value;
        load_next_c = '0;
        if(decoded_reg_strb.OUTPUT_CTRL_ENABLE && decoded_req_is_wr) begin // SW write
            next_c = (field_storage.OUTPUT_CTRL_ENABLE.OENABLE.value & ~decoded_wr_biten[31:0]) | (decoded_wr_data[31:0] & decoded_wr_biten[31:0]);
            load_next_c = '1;
        end
        field_combo.OUTPUT_CTRL_ENABLE.OENABLE.next = next_c;
        field_combo.OUTPUT_CTRL_ENABLE.OENABLE.load_next = load_next_c;
    end
    always_ff @(posedge clk) begin
        if(rst) begin
            field_storage.OUTPUT_CTRL_ENABLE.OENABLE.value <= 32'h0;
        end else begin
            if(field_combo.OUTPUT_CTRL_ENABLE.OENABLE.load_next) begin
                field_storage.OUTPUT_CTRL_ENABLE.OENABLE.value <= field_combo.OUTPUT_CTRL_ENABLE.OENABLE.next;
            end
        end
    end
    assign hwif_out.OUTPUT_CTRL_ENABLE.OENABLE.value = field_storage.OUTPUT_CTRL_ENABLE.OENABLE.value;

    //--------------------------------------------------------------------------
    // Write response
    //--------------------------------------------------------------------------
    assign cpuif_wr_ack = decoded_req & decoded_req_is_wr;
    // Writes are always granted with no error response
    assign cpuif_wr_err = '0;

    //--------------------------------------------------------------------------
    // Readback
    //--------------------------------------------------------------------------

    logic readback_err;
    logic readback_done;
    logic [31:0] readback_data;

    // Assign readback values to a flattened array
    logic [31:0] readback_array[3];
    assign readback_array[0][31:0] = (decoded_reg_strb.OUTPUT_CTRL_VALUE && !decoded_req_is_wr) ? field_storage.OUTPUT_CTRL_VALUE.OVALUE.value : '0;
    assign readback_array[1][31:0] = (decoded_reg_strb.OUTPUT_CTRL_ENABLE && !decoded_req_is_wr) ? field_storage.OUTPUT_CTRL_ENABLE.OENABLE.value : '0;
    assign readback_array[2][31:0] = (decoded_reg_strb.INPUT_STATUS && !decoded_req_is_wr) ? hwif_in.INPUT_STATUS.IVALUE.next : '0;

    // Reduce the array
    always_comb begin
        automatic logic [31:0] readback_data_var;
        readback_done = decoded_req & ~decoded_req_is_wr;
        readback_err = '0;
        readback_data_var = '0;
        for(int i=0; i<3; i++) readback_data_var |= readback_array[i];
        readback_data = readback_data_var;
    end

    assign cpuif_rd_ack = readback_done;
    assign cpuif_rd_data = readback_data;
    assign cpuif_rd_err = readback_err;
endmodule

/* verilator lint_on MULTIDRIVEN */
