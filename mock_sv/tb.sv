module top;
    TB_blk TB_inst ();
endmodule

module TB_blk;
    logic clk = 0, rst_n = 0;
    logic tready, ps2_clk, ps2_data;
    int counter = 0;

    ps2_master inst (clk, rst_n, 8'hFF, 1, tready, ps2_clk, ps2_data);

    always @(negedge clk, posedge clk) begin
        display();
        counter++;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
        clk = 1;
        rst_n = 1;
        for i in 0 to 15 loop
            wait_clk;
        end loop;
    end

    function display;
        $display("[%0h]: tready:%0h, clk:%0h, data:%0h",
            counter, tready, ps2_clk, ps2_data);
    endfunction

    task wait_clk;
        clk = 1;
        #1;
        clk = 0;
        #1;
    endtask
endmodule
