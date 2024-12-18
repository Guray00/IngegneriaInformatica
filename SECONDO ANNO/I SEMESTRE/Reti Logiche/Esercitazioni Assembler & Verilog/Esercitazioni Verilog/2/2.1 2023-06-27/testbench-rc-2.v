module testbench();
    reg [7:0] x, y;
    wire [7:0] z;
    
    MAX m (
        .x(x), .y(y), .max(z)
    );

    reg [5:0] i;
    reg [7:0] t_x, t_y, t_z;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;

        for (i = 0; i < 32; i++) begin
            {t_x, t_y, t_z} = get_testcase(i[4:0]);

            x = t_x; y = t_y;
            #10;
            if(z != t_z)
                $display("Test #%g failed, expected %g, got %g", i, t_z, z);
        end
    end

    function automatic [23:0] get_testcase;
        input [4:0] i;

        reg [7:0] x, y, z;
        
        begin
            if( i[0] == 1) begin
                x = (i[4:2] + 4) * 3;
                y = (i[1:0] + 1) * 5;
            end
            else begin
                x = (i[1:0] + 1) * 5;
                y = (i[4:2] + 4) * 3;
            end

            z = {1'b0,x} > {1'b0, y} ? x : y;
            
            get_testcase = {x, y, z};
        end
    endfunction

endmodule