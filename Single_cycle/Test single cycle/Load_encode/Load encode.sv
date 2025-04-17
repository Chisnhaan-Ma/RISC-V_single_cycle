`timescale 1ns/1ps

module Load_encode_tb();
    logic [31:0] load_data;
    logic [2:0] load_type;
    logic [31:0] load_result;

    Load_encode uut (
        .load_data(load_data),
        .load_type(load_type),
        .load_result(load_result)
    );

    initial begin
      $dumpfile("Load_encode_tb.vcd");
      $dumpvars(0,Load_encode_tb);
        load_data = 32'hFF0000A0; 
        load_type = 3'b000; //LB
        #10 load_data = 32'hFF00003C;
      	
        
        #10 load_type = 3'b001; //LH
      		load_data = 32'h0AB0004F;	
        #10 load_data = 32'h0000FF00; 

        
        #10 load_data = 32'h12345678;
        load_type = 3'b010; //LW

       
		#10 load_data = 32'hACBDEFAB;
        load_type = 3'b100;//LBU
 

        #10 load_data = 32'hF123BCDE;
        load_type = 3'b101; //LHU

        $finish;
    end
endmodule
