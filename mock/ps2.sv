// Design
// D flip-flop
module ps2_master (
    input        clk,
    input        rst_n,
    input        [7:0] tdata,
    input        tvalid,
    output logic tready   = 0,
    output logic ps2_clk  = 1,
    output logic ps2_data = 0
);
    int counter = 0;
    bit [7:0] tdata_latched = 8'h00;
    bit transmitting = 0;
    bit transmitting_done = 1;

    // finds odd parity by XORing all data bits
    function bit calc_parity (input byte data);
        return ^data;
    endfunction

    // basics
    always @(posedge clk)
    begin
        if (!rst_n) begin
            transmitting  <= 0;
            tdata_latched <= 8'h00;
            counter       <= 0;
            ps2_data      <= 0;
        end
        else begin
            // wait for tvalid
            if (tvalid && tready && !transmitting) begin
                tdata_latched <= tdata;
                transmitting  <= 1;
            end

            // serdes
            if (transmitting) begin
                counter <= counter + 1;

                if (counter <= 7) begin
                    // data
                    ps2_data      <= tdata_latched[7];
                    tdata_latched <= {tdata_latched[6:0], tdata_latched[7]};
                end
                else if (counter == 8) begin
                    // parity
                    ps2_data      <= calc_parity(tdata_latched);
                end
                else begin
                    transmitting  <= 0;
                end
            end

        end
    end

    // clock
  always @(posedge clk, negedge clk)
    begin
        if (transmitting)
            ps2_clk <= !ps2_clk;
        else
            ps2_clk <= 1;
    end

    // tready
    always @(posedge clk)
    begin
        tready <= !transmitting;
    end

endmodule

