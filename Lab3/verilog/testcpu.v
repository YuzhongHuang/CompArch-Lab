`include "cpu.v"

module testCPU();
	reg clk;
	CPU ourCpu(clk);
	always begin
		#5 clk = !clk;
	end

	integer index;

	initial begin
		clk = 0;
		#10000;
		$display("HELLO THERE");

        for (index = 0; index < 32; index = index + 1) begin: registerGen
            $display("%d: %d", index, ourCpu.RegisterFile.data[index]);
        end
		$finish;
	end
endmodule