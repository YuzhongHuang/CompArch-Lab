//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------

module regfile
(
output[31:0]    ReadData1,  // Contents of first register read
output[31:0]    ReadData2,  // Contents of second register read
input[31:0] WriteData,  // Contents to write to register
input[4:0]  ReadRegister1,  // Address of first register to read
input[4:0]  ReadRegister2,  // Address of second register to read
input[4:0]  WriteRegister,  // Address of register to write
input       RegWrite,   // Enable writing of register when High
input       Clk     // Clock (Positive Edge Triggered)
);

    wire [31:0] data [31:0]; // data initially stored in the register file

    // Selects which register of the register file is being written to
    wire[31:0] RegisterToWrite;
    decoder1to32 decoder1 (RegisterToWrite, RegWrite, WriteRegister);

    // The first register is alwats zero
    register32zero register0 (data[0], WriteData, RegisterToWrite[0], Clk);

    // Writes the data into the rest of the register file
    genvar index;
    generate
        for (index = 1; index < 32; index = index + 1) begin: registerGen
            register32 register (data[index], WriteData, RegisterToWrite[index], Clk);
            if (index != 29) begin
                initial register.q = 0;
            end else begin
                initial register.q = 2**15-1;
            end
        end
    endgenerate

    // Read first and second register data from first and second register addresses
    mux32to1by32 mux1 (ReadData1, ReadRegister1, data[0], data[1], data[2], data[3], data[4], data[5], data[6],
            data[7], data[8], data[9], data[10], data[11], data[12], data[13], data[14], data[15],
            data[16], data[17], data[18], data[19], data[20], data[21], data[22], data[23],
            data[24], data[25], data[26], data[27], data[28], data[29], data[30], data[31]);
    mux32to1by32 mux2 (ReadData2, ReadRegister2, data[0], data[1], data[2], data[3], data[4], data[5], data[6],
            data[7], data[8], data[9], data[10], data[11], data[12], data[13], data[14], data[15],
            data[16], data[17], data[18], data[19], data[20], data[21], data[22], data[23],
            data[24], data[25], data[26], data[27], data[28], data[29], data[30], data[31]);
endmodule

// 32 bit decoder with enable signal
//   enable=0: all output bits are 0
//   enable=1: out[address] is 1, all other outputs are 0
module decoder1to32 (
  output[31:0] out,
  input enable,
  input[4:0] address
);

    assign out = enable<<address; 

endmodule

// 32-bit D Flip-Flop with enable
//   Positive edge triggered
module register32 (
  output reg [31:0] q,
  input [31:0] d,
  input wrenable,
  input clk
);

  always @(posedge clk) begin
      if(wrenable) begin
          q = d;
      end
  end

endmodule

// Always output zero
module register32zero (
  output wire[31:0] q,
  input[31:0] d,
  input wrenable,
  input clk
);
    assign q = 32'b0;
endmodule

// multiplexer that is 32 bits wide and 32 inputs deep
module mux32to1by32 (
  output[31:0] out,
  input[4:0] address,
  input[31:0] input0, input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, 
  input[31:0] input11, input12, input13, input14, input15, input16, input17, input18, input19, input20, 
  input[31:0] input21, input22, input23, input24, input25, input26, input27, input28, input29, input30, input31
);

  wire[31:0] mux[31:0];         // Create a 2D array of wires
  assign mux[0] = input0;       // Connect the sources of the array
  assign mux[1] = input1;
  assign mux[2] = input2;
  assign mux[3] = input3;
  assign mux[4] = input4;
  assign mux[5] = input5;
  assign mux[6] = input6;
  assign mux[7] = input7;
  assign mux[8] = input8;
  assign mux[9] = input9;
  assign mux[10] = input10;
  assign mux[11] = input11;
  assign mux[12] = input12;
  assign mux[13] = input13;
  assign mux[14] = input14;
  assign mux[15] = input15;
  assign mux[16] = input16;
  assign mux[17] = input17;
  assign mux[18] = input18;
  assign mux[19] = input19;
  assign mux[20] = input20;
  assign mux[21] = input21;
  assign mux[22] = input22;
  assign mux[23] = input23;
  assign mux[24] = input24;
  assign mux[25] = input25;
  assign mux[26] = input26;
  assign mux[27] = input27;
  assign mux[28] = input28;
  assign mux[29] = input29;
  assign mux[30] = input30;
  assign mux[31] = input31;
  assign out = mux[address];    // Connect the output of the array
endmodule

// module test();

//   wire [31:0] read1, read2;
//   reg [31:0] writedata;
//   reg [4:0] writeport, readport1, readport2;
//   reg we, clk;

//   regfile RF(read1, read2, writedata, readport1, readport2, writeport, we, clk);

//   always begin
//       #5; clk = !clk;
//   end

//   initial begin
//     clk = 0; 
//     we = 1; writedata = 2**15-1; writeport = 29; #10;
//   end
// endmodule
