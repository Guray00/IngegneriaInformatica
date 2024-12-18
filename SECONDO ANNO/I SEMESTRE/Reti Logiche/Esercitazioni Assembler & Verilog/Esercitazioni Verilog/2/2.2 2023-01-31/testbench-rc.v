module testbench();
    reg [7:0] x;
    reg [7:0] y;
    wire [15:0] m;

    MUL8 dut (
        .x(x), .y(y), .m(m)
    );

    reg [5:0] i_t;
    reg [7:0] x_t;
    reg [7:0] y_t;
    reg [15:0] m_t;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;

        for (i_t = 0; i_t < 60; i_t++) begin
            {x_t, y_t, m_t} = get_testcase(i_t);

            x = x_t; y = y_t;
            #10;
            if(m !== m_t) begin
                $display("Wrong result: expected %d, got %d", m_t, m);
                error = 1;
            end
        end
    end

    // linea di errore, utile per il debug
    reg error;
    initial error = 0;
    always @(posedge error) #1
        error = 0;

    function automatic [37:0] get_testcase;
        input [5:0] i;

        reg [7:0] x;
        reg [7:0] y;
        reg [15:0] m;

        begin
            x = (i[5:2] + 1) * 5;
            y = (i[1:0] + 4) * 7;
            m = x * y;
            
            get_testcase = {x, y, m};
        end
    endfunction

endmodule
