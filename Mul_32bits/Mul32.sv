module mul64_sv(
	input logic [31:0] x, 
	input logic [31:0] y, 
	output logic [64:0] z 
	);

logic [63:0] h_32[31:0]; 
logic [63:0] h_16[15:0]; 
logic [63:0] h_8[7:0]; 
logic [63:0] h_4[3:0]; 
logic [63:0] h_2[1:0]; 
logic [31:0] temp[31:0];

// temp = X & Y
genvar i, j;
generate
	for (i = 0; i < 32; i++) begin : scan_X
		for (j = 0; j < 32; j++) begin : scan_Y
			assign temp[i][j] = x[i] & y[j]; 
		end
	end
endgenerate


// h_32[i] = temp shift left [i] times 
assign h_32[0][63:0] = {32'b0, temp[0][31:0]};
assign h_32[1][63:0] = {31'b0, temp[1][31:0],1'b0}; 
assign h_32[2][63:0] = {30'b0, temp[2][31:0],2'b0}; 
assign h_32[3][63:0] = {29'b0, temp[3][31:0],3'b0};
assign h_32[4][63:0] = {28'b0, temp[4] [31:0],4'b0}; 
assign h_32[5][63:0] = {27'b0, temp[5] [31:0],5'b0}; 
assign h_32[6][63:0] = {26'b0, temp[6][31:0],6'b0};
assign h_32[7][63:0] = {25'b0, temp[7] [31:0],7'b0};
assign h_32[8][63:0] = {24'b0, temp[8][31:0],8'b0}; 
assign h_32[9][63:0] = {23'b0, temp[9][31:0],9'b0};
assign h_32[10][63:0] = {22'b0, temp[10][31:0],10'b0}; 
assign h_32[11][63:0] = {21'b0, temp[11][31:0],11'b0}; 
assign h_32[12][63:0] = {20'b0, temp[12][31:0],12'b0}; 
assign h_32[13][63:0] = {19'b0, temp[13] [31:0],13'b0}; 
assign h_32[14][63:0] = {18'b0, temp[14][31:0],14'b0};
assign h_32[15][63:0] = {17'b0, temp[15][31:0],15'b0};
assign h_32[16][63:0] = {16'b0, temp[16][31:0],16'b0}; 
assign h_32[17][63:0] = {15'b0, temp[17][31:0],17'b0}; 
assign h_32[18][63:0] = {14'b0, temp[18] [31:0],18'b0};
assign h_32[19][63:0] = {13'b0, temp[19] [31:0],19'b0};
assign h_32[20][63:0] = {12'b0, temp[20] [31:0],20'b00};
assign h_32[21][63:0] = {11'b0, temp[21] [31:0],21'b00};
assign h_32[22][63:0] = {10'b0, temp[22][31:0],22'b00};
assign h_32[23][63:0] = {9'b0, temp[23][31:0],23'b00}; 
assign h_32[24][63:0] = {8'b0, temp[24] [31:0],24'b00}; 
assign h_32[25][63:0] = {7'b0, temp[25][31:0],25'b00};  
assign h_32[26][63:0] = {6'b0, temp[26][31:0],26'b00}; 
assign h_32[27][63:0] = {5'b0, temp[27][31:0],27'b00}; 
assign h_32[28][63:0] = {4'b0, temp[28] [31:0],28'b00}; 
assign h_32[29][63:0] = {3'b0, temp[29] [31:0],29'b00};
assign h_32[30][63:0] = {2'b0, temp[30] [31:0],30'b00}; 
assign h_32[31][63:0] = {1'b0, temp[31] [31:0],31'b00};


//Sum of 2 row use full adder 64 bit, cin = 0
 add64 t2_0(.a(h_32[0]),.b(h_32[1]),.cin(0),.sum(h_16[0]));
 add64 t2_1(.a(h_32[2]),.b(h_32[3]),.cin(0),.sum(h_16[1]));
 add64 t2_2(.a(h_32[4]),.b(h_32[5]),.cin(0),.sum(h_16[2]));
 add64 t2_3(.a(h_32[6]),.b(h_32[7]),.cin(0),.sum(h_16[3]));
 add64 t2_4(.a(h_32[8]),.b(h_32[9]), .cin(0),.sum(h_16[4]));
 add64 t2_5(.a(h_32[10]),.b(h_32[11]),.cin(0),.sum(h_16[5]));
 add64 t2_6(.a(h_32[12]),.b(h_32[13]),.cin(0),.sum(h_16[6]));
 add64 t2_7(.a(h_32[14]),.b(h_32[15]),.cin(0),.sum(h_16[7])); 
 add64 t2_8(.a(h_32[16]),.b(h_32[17]),.cin(0),.sum(h_16[8])); 
 add64 t2_9(.a(h_32[18]),.b(h_32[19]),.cin (0),.sum(h_16[9]));
 add64 t2_10(.a(h_32[20]),.b(h_32[21]),.cin(0),.sum(h_16[10])); 
 add64 t2_11(.a(h_32[22]),.b(h_32[23]),.cin(0),.sum(h_16 [11]));
 add64 t2_12(.a(h_32[24]),.b(h_32[25]),.cin(0),.sum(h_16 [12])); 
 add64 t2_13(.a(h_32[26]),.b(h_32[27]),.cin(0),.sum(h_16[13]));
 add64 t2_14(.a(h_32[28]),.b(h_32[29]),.cin(0),.sum(h_16 [14]));
 add64 t2_15(.a(h_32[30]),.b(h_32[31]),.cin(0),.sum(h_16[15]));
 
 //Sum of 4 row use full adder 64 bit, cin = 0
 add64 t4_0(.a(h_16[0]),.b(h_16[1]),.cin(0),.sum (h_8[0]));
 add64 t4_1(.a(h_16[2]),.b(h_16[3]),.cin(0),.sum (h_8[1])); 
 add64 t4_2(.a(h_16[4]), .b(h_16[5]),.cin (0),.sum (h_8[2]));
 add64 t4_3(.a(h_16[6]),.b(h_16[7]), .cin (0),.sum (h_8[3]));
 add64 t4_4(.a(h_16[8]),.b (h_16[9]), .cin (0),.sum (h_8[4])); 
 add64 t4_5(.a(h_16 [10]),.b(h_16[11]),.cin (0),.sum (h_8[5]));
 add64 t4_6(.a(h_16 [12]), .b (h_16[12]), .cin (0),.sum (h_8[6]));
 add64 t4_7(.a(h_16[14]), .b(h_16[15]), .cin(0),.sum (h_8[7]));
 
 //Sum of 8 row use full adder 64 bit, cin = 0
	add64 t8_0(.a(h_8[0]),.b(h_8[1]),.cin (0),.sum (h_4 [0]));
	add64 t8_1(.a(h_8[2]),.b(h_8[3]),.cin (0),.sum (h_4[1]));
	add64 t8_2(.a(h_8[4]),.b(h_8[5]), .cin (0),.sum (h_4[2]));
	add64 t8_3(.a(h_8[6]),.b(h_8[7]),.cin (0),.sum (h_4[3]));
	
//Sum of 16 row
	add64 t16_1(.a(h_4[0]),.b(h_4[1]),.cin (0),.sum(h_2[0]));
	add64 t16_2(.a(h_4[2]),.b(h_4[3]),.cin (0),.sum(h_2[1]));
//Sum of 32 row use full adder and carry out
	add64_c t32(.a(h_2[0]), .b(h_2[1]), .cin(0), .sum_c(z));
endmodule
module add1(
    input logic a, b, cin,
    output logic carry, sum
);
    assign sum = (a ^ b) ^ cin;
    assign carry = (a & b) | ((a ^ b) & cin); 
endmodule

module add64_c(
    input logic [63:0] a,
    input logic [63:0] b,
    output logic [64:0] sum_c,
    input logic cin
);

logic [63:0] carry;
logic [63:0] sum;
logic carry_out;

// Instantiate the first adder
add1 ad0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .carry(carry[0]));

genvar i;
generate
    for (i = 1; i < 64; i = i + 1) begin : make_adder_64
        add1 ad (.a(a[i]), .b(b[i]), .cin(carry[i-1]), .sum(sum[i]), .carry(carry[i])); 
    end
endgenerate

assign carry_out = carry[63];
assign sum_c = {carry_out, sum};

endmodule

module add64(
    input logic [63:0] a,
    input logic [63:0] b,
    output logic [63:0] sum,
    input logic cin
);

logic [63:0] carry;
logic carry_out;
logic [64:0] sum_c;

// Instantiate the first adder
add1 ad0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .carry(carry[0]));

genvar i;
generate
    for (i = 1; i < 64; i = i + 1) begin : make_add64
        add1 ad (.a(a[i]), .b(b[i]), .cin(carry[i-1]), .sum(sum[i]), .carry(carry[i]));
    end
endgenerate

assign carry_out = carry[63];
assign sum_c = {carry_out, sum};

endmodule



