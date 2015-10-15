`include "ALU.v"

module testALU;

	wire[31:0]    result;
	wire          carryout;
	wire          zero;
	wire          overflow;
	reg[31:0]     a;
	reg[31:0]     b;
	reg[2:0]      command;

	ALU alu(result, carryout, overflow, zero, command, a, b);

	initial begin
		//ADDITION
		$write("%c[1;34m",27); $display("\n1/ ADDITION (4 Most Significant Bits)"); $write("%c[0m",27);
		$display("   INPUTS   |       GENERATED RESULTS    |       EXPECTED RESULTS");
		$display("---------------------------------------------------------------------");
		$display("  A     B   |   Sum     C_out     OFlow  |   Sum     C_out     OFlow");
		command=3'd0; 
		a[27:0]=28'b0; b[27:0]=28'b0;

		a[31:28]=4'b1001; b[31:28]=4'b1010; #3000
		$display(" %b  %b |   %b      %b         %b    |   0011      1         1  |", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a[31:28]=4'b1101; b[31:28]=4'b1010; #3000
		$display(" %b  %b |   %b      %b         %b    |   0111      1         1  |", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a[31:28]=4'b0101; b[31:28]=4'b0110; #3000
		$display(" %b  %b |   %b      %b         %b    |   1011      0         1  |", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a[31:28]=4'b0110; b[31:28]=4'b0100; #3000
		$display(" %b  %b |   %b      %b         %b    |   1010      0         1  |", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a[31:28]=4'b1110; b[31:28]=4'b1100; #3000
		$display(" %b  %b |   %b      %b         %b    |   1010      1         0  |", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a[31:28]=4'b1100; b[31:28]=4'b1101; #3000
		$display(" %b  %b |   %b      %b         %b    |   1001      1         0  |", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a[31:28]=4'b0001; b[31:28]=4'b0100; #3000
		$display(" %b  %b |   %b      %b         %b    |   0101      0         0  |", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a[31:28]=4'b1001; b[31:28]=4'b0101; #3000
		$display(" %b  %b |   %b      %b         %b    |   1110      0         0  |", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a[31:28]=4'b0101; b[31:28]=4'b1100; #3000
		$display(" %b  %b |   %b      %b         %b    |   0001      1         0  | Positive + Negative w/ C_out", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a[31:28]=4'b1110; b[31:28]=4'b0101; #3000
		$display(" %b  %b |   %b      %b         %b    |   0011      0         0  | Positive + Negative w/o C_out", a[31:28], b[31:28], result[31:28], carryout, overflow);

		// SUBTRACTION
		$write("%c[1;34m",27); $display("\n2/ SUBTRACTION (4 Most Significant Bits)"); $write("%c[0m",27);
		$display("  A     B   |   Sum     C_out     OFlow  |   Sum     C_out     OFlow");
		command=3'd1; 
		a[27:0]=28'b0; b[27:0]=28'b0;

		a[31:28]=4'b1001; b[31:28]=4'b0110; #3000
		$display(" %b  %b |   %b      %b         %b    |   0011      1         1  |", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a[31:28]=4'b1101; b[31:28]=4'b0110; #3000
		$display(" %b  %b |   %b      %b         %b    |   0111      1         1  |", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a[31:28]=4'b0101; b[31:28]=4'b1010; #3000
		$display(" %b  %b |   %b      %b         %b    |   1011      0         1  |", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a[31:28]=4'b0110; b[31:28]=4'b1100; #3000
		$display(" %b  %b |   %b      %b         %b    |   1010      0         1  |", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a[31:28]=4'b1110; b[31:28]=4'b0100; #3000
		$display(" %b  %b |   %b      %b         %b    |   1010      1         0  |", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a[31:28]=4'b1100; b[31:28]=4'b0011; #3000
		$display(" %b  %b |   %b      %b         %b    |   1001      1         0  |", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a[31:28]=4'b0100; b[31:28]=4'b1111; #3000
		$display(" %b  %b |   %b      %b         %b    |   0101      0         0  |", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a[31:28]=4'b0101; b[31:28]=4'b0111; #3000
		$display(" %b  %b |   %b      %b         %b    |   1110      0         0  |", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a[31:28]=4'b0101; b[31:28]=4'b0110; #3000
		$display(" %b  %b |   %b      %b         %b    |   1111      1         0  | Positive - Positive w/ C_out", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a[31:28]=4'b1110; b[31:28]=4'b1011; #3000
		$display(" %b  %b |   %b      %b         %b    |   0011      0         0  | Negative - Negative w/o C_out", a[31:28], b[31:28], result[31:28], carryout, overflow);

		$write("%c[1;34m",27); $display("\n2.5/ TESTING CARRIED BITS OF ADDER (4 Most Significant Bits)"); $write("%c[0m",27);
		$display("  A     B   |   Sum     C_out     OFlow  |   Sum     C_out     OFlow");
		command=3'd0;
		a=32'd2**31-1; b=32'd1; #3000
		$display(" %b  %b |   %b      %b         %b    |   1000      0         1  | A = 2**31-1, B = 1", a[31:28], b[31:28], result[31:28], carryout, overflow);
		a=32'd2**32-1; b=32'd1; #3000
		$display(" %b  %b |   %b      %b         %b    |   0000      1         0  | A = 2**32-1, B = 1", a[31:28], b[31:28], result[31:28], carryout, overflow);

		// XOR
		$write("%c[1;34m",27); $display("\n3/ XOR (4 Most Significant Bits)"); $write("%c[0m",27);
		$display("   INPUTS   |    GENERATED     |     EXPECTED");
		$display("--------------------------------------------------");	
		$display("  A     B   |      A ^ B       |      A ^ B       ");
		command=3'd2;

		a=32'd0; b=32'd0; #3000
		$display(" %b  %b |       %b       |       0000      ", a[31:28], b[31:28], result[31:28]);
		a=32'd0; b=32'd2**32-1; #3000
		$display(" %b  %b |       %b       |       1111      ", a[31:28], b[31:28], result[31:28]);
		a=32'd2**32-1; b=32'd0; #3000
		$display(" %b  %b |       %b       |       1111      ", a[31:28], b[31:28], result[31:28]);
		a=32'd2**32-1; b=32'd2**32-1; #3000
		$display(" %b  %b |       %b       |       0000      ", a[31:28], b[31:28], result[31:28]);

		// SLT
		$write("%c[1;34m",27); $display("\n4/ SLT"); $write("%c[0m",27);
		$display("  INPUTS    |          GENERATED          |           EXPECTED");
		$display("-----------------------------------------------------------------------");
		$display("  A     B   |   Sum[31]    OFlow     SLT  |   Sum[31]     OFlow     SLT");
		command=3'd3; 
		a[27:0]=28'b0; b[27:0]=28'b0;

		a[31:28]=4'b0010; b[31:28]=4'b1111; #3000
		$display(" %b  %b |      %b         %b        %b   |       0         0        0", a[31:28], b[31:28], alu.resSum[31], alu.overflow, result[31]);
		a[31:28]=4'b1010; b[31:28]=4'b0111; #3000
		$display(" %b  %b |      %b         %b        %b   |       0         1        1", a[31:28], b[31:28], alu.resSum[31], alu.overflow, result[31]);
		a[31:28]=4'b1100; b[31:28]=4'b0011; #3000
		$display(" %b  %b |      %b         %b        %b   |       1         0        1", a[31:28], b[31:28], alu.resSum[31], alu.overflow, result[31]);
		a[31:28]=4'b0101; b[31:28]=4'b1010; #3000
		$display(" %b  %b |      %b         %b        %b   |       1         1        0", a[31:28], b[31:28], alu.resSum[31], alu.overflow, result[31]);

		// AND
		$write("%c[1;34m",27); $display("\n5/ AND (4 Most Significant Bits)"); $write("%c[0m",27);
		$display("   INPUTS   |    GENERATED     |     EXPECTED");
		$display("--------------------------------------------------");	
		$display("  A     B   |      A && B      |      A && B      ");
		command=3'd4;

		a=32'd0; b=32'd0; #3000
		$display(" %b  %b |       %b       |       0000      ", a[31:28], b[31:28], result[31:28]);
		a=32'd0; b=32'd2**32-1; #3000
		$display(" %b  %b |       %b       |       0000      ", a[31:28], b[31:28], result[31:28]);
		a=32'd2**32-1; b=32'd0; #3000
		$display(" %b  %b |       %b       |       0000      ", a[31:28], b[31:28], result[31:28]);
		a=32'd2**32-1; b=32'd2**32-1; #3000
		$display(" %b  %b |       %b       |       1111      ", a[31:28], b[31:28], result[31:28]);

		// NAND
		$write("%c[1;34m",27); $display("\n6/ NAND (4 Most Significant Bits)"); $write("%c[0m",27);
		$display("  A     B   |    ~(A && B)     |    ~(A && B)     ");
		command=3'd5;

		a=32'd0; b=32'd0; #3000
		$display(" %b  %b |       %b       |       1111      ", a[31:28], b[31:28], result[31:28]);
		a=32'd0; b=32'd2**32-1; #3000
		$display(" %b  %b |       %b       |       1111      ", a[31:28], b[31:28], result[31:28]);
		a=32'd2**32-1; b=32'd0; #3000
		$display(" %b  %b |       %b       |       1111      ", a[31:28], b[31:28], result[31:28]);
		a=32'd2**32-1; b=32'd2**32-1; #3000
		$display(" %b  %b |       %b       |       0000      ", a[31:28], b[31:28], result[31:28]);

		// OR
		$write("%c[1;34m",27); $display("\n7/ OR (4 Most Significant Bits)"); $write("%c[0m",27);
		$display("  A     B   |      A || B      |      A || B      ");
		command=3'd6;

		a=32'd0; b=32'd0; #3000
		$display(" %b  %b |       %b       |       0000      ", a[31:28], b[31:28], result[31:28]);
		a=32'd0; b=32'd2**32-1; #3000
		$display(" %b  %b |       %b       |       1111      ", a[31:28], b[31:28], result[31:28]);
		a=32'd2**32-1; b=32'd0; #3000
		$display(" %b  %b |       %b       |       1111      ", a[31:28], b[31:28], result[31:28]);
		a=32'd2**32-1; b=32'd2**32-1; #3000
		$display(" %b  %b |       %b       |       1111      ", a[31:28], b[31:28], result[31:28]);

		// NOR
		$write("%c[1;34m",27); $display("\n8/ NOR (4 Most Significant Bits)"); $write("%c[0m",27);
		$display("  A     B   |    ~(A || B)     |    ~(A || B)     ");
		command=3'd7;

		a=32'd0; b=32'd0; #3000
		$display(" %b  %b |       %b       |       1111      ", a[31:28], b[31:28], result[31:28]);
		a=32'd0; b=32'd2**32-1; #3000
		$display(" %b  %b |       %b       |       0000      ", a[31:28], b[31:28], result[31:28]);
		a=32'd2**32-1; b=32'd0; #3000
		$display(" %b  %b |       %b       |       0000      ", a[31:28], b[31:28], result[31:28]);
		a=32'd2**32-1; b=32'd2**32-1; #3000
		$display(" %b  %b |       %b       |       0000      \n", a[31:28], b[31:28], result[31:28]);

		
		

	end
endmodule