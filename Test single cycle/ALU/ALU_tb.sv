module ALU_tb();

  logic [3:0]  ALU_sel;
  logic signed [31:0] A;
  logic signed [31:0] B;
  logic [31:0] ALU_out;

   ALU uut (
     .ALU_sel(ALU_sel),
     .ALU_out(ALU_out),
     .A(A),
     .B(B));
       
    // Initialize signals
    initial begin
			A = 10;
   		B = 5;
			ALU_sel = 4'b0000; //ADD
   		#10 ALU_sel = 4'b1000; //SUB
      	#10 ALU_sel = 4'b0001; // SLL
      	#10 ALU_sel = 4'b0010; // SLT
      	#10 ALU_sel = 4'b0011; // SLTU
      	#10 ALU_sel = 4'b0100; // XOR
      	#10 ALU_sel = 4'b0101; // SRL
      	#10 ALU_sel = 4'b1101; // SRA
      	#10 ALU_sel = 4'b0110; // OR
         #10 ALU_sel = 4'b0111; // AND
         #10 ALU_sel = 4'b1111; // LUI
      
      // when A,B are signed
      	#10 A = 32'hFFFFFFFE;
      		B = 32'hFFFFFFFF; 
      		ALU_sel = 4'b0000; //ADD
   		#10 ALU_sel = 4'b1000; //SUB
      	#10 ALU_sel = 4'b0010; //SLL
      	#10 ALU_sel = 4'b0011; //SLTU
      	#10 ALU_sel = 4'b0100; //XOR
      	#10 ALU_sel = 4'b0110; //OR
         #10 ALU_sel = 4'b0111; //AND
         #10 ALU_sel = 4'b1111; //LUI
    end
  
	initial begin
      #500 $finish;
    end
	initial begin
      $dumpfile ("ALU_tb.vcd");
      $dumpvars(0,ALU_tb);
    end
endmodule
