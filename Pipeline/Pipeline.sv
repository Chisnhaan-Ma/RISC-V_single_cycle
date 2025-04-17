module Pipeline(
    input logic clk,
    input logic reset,
    output logic [31:0]Write_scoreboard,
    output logic [4:0]rsw_scoreboard
);
    // Wires for interstage connections
    logic [31:0] PC_ID, inst_ID;
    logic [31:0] WBSel_out;
    logic [4:0] rsW;
    logic reg_file_wb_enable;

    logic [31:0] PC_EX, inst_EX;
    logic [31:0] data_1_EX, data_2_EX, Imm_EX;
    logic [3:0] ALU_sel_EX;
    logic BrUn_EX;
    logic MemRW_EX;
    logic [2:0] load_type_EX;
    logic [1:0] WBSel_EX;
    logic regWEn_EX;
    logic Asel_EX, Bsel_EX;

    logic [1:0] forwardA_EX, forwardB_EX;
    logic [31:0] ALU_out_MEM, WBSel_out_WB_fwd;

    logic BrEq_MEM, BrLt_MEM;
    logic [31:0] PC_MEM, data_2_MEM, inst_MEM;
    logic MemRW_MEM;
    logic [2:0] load_type_MEM;
    logic [1:0] WBSel_MEM;
    logic regWEn_MEM;

    logic [31:0] PC_add4_WB, ALU_out_WB, mem_WB, inst_WB;
    logic [1:0] WBSel_WB;
    logic regWEn_WB;

    logic PCSel;
    logic [31:0] PC_Branch_EX;
	logic [4:0] rd_WB, rd_MEM;
	 
	logic Stall, flush;
	logic [4:0] rs1_ID, rs2_ID;
    logic [1:0] Branch_fwd_A_EX,Branch_fwd_B_EX;
    // Instantiate Fetch
    Fetch_cycle fetch_inst (
        .clk(clk),
        .reset(reset),
        .PCSel(PCSel),
        .ALU_out_MEM(ALU_out_MEM),
        .PC_ID(PC_ID),
        .inst_ID(inst_ID),
		.Stall(Stall),
        .flush(flush)
    );

    // Instantiate Decode
    Decode_cycle decode_inst (
        .clk(clk),
        .reset(reset),
        .PC_ID(PC_ID),
        .inst_ID(inst_ID),
        .WBSel_out_WB(WBSel_out),
        .rsW(rsW),
        .reg_file_wb_enable(reg_file_wb_enable),
        .PC_EX(PC_EX),
        .inst_EX(inst_EX),
        .data_1_EX(data_1_EX),
        .data_2_EX(data_2_EX),
        .Imm_EX(Imm_EX),
        .ALU_sel_EX(ALU_sel_EX),
        .BrUn_EX(BrUn_EX),
        .MemRW_EX(MemRW_EX),
        .load_type_EX(load_type_EX),
        .WBSel_EX(WBSel_EX),
        .regWEn_EX(regWEn_EX),
		.rs1_ID(rs1_ID),
		.rs2_ID(rs2_ID),
        .flush(flush),
        .Stall(Stall),
        .Asel_EX(Asel_EX),
        .Bsel_EX(Bsel_EX)
    );

    // Instantiate Execute
    Execute_cycle execute_inst (
        .clk(clk),
        .reset(reset),
        .PC_EX(PC_EX),
        .inst_EX(inst_EX),
        .MemRW_EX(MemRW_EX),
        .load_type_EX(load_type_EX),
        .WBSel_EX(WBSel_EX),
        .regWEn_EX(regWEn_EX),
        .data_1_EX(data_1_EX),
        .data_2_EX(data_2_EX),
        .Imm_EX(Imm_EX),
        .ALU_sel_EX(ALU_sel_EX),
        .BrUn_EX(BrUn_EX),
        .forwardA_EX(forwardA_EX),
        .forwardB_EX(forwardB_EX),
        .ALU_out_MEM_fwd(ALU_out_MEM),
        .WBSel_out_WB_fwd(WBSel_out),
        .BrEq_MEM(BrEq_MEM),
        .BrLt_MEM(BrLt_MEM),
        .ALU_out_MEM(ALU_out_MEM),
        .PC_MEM(PC_MEM),
        .data_2_MEM(data_2_MEM),
        .inst_MEM(inst_MEM),
        .MemRW_MEM(MemRW_MEM),
        .load_type_MEM(load_type_MEM),
        .WBSel_MEM(WBSel_MEM),
        .regWEn_MEM(regWEn_MEM),
        .flush(flush),
        .Asel_EX(Asel_EX),
        .Bsel_EX(Bsel_EX),
        .Branch_fwd_A_EX(Branch_fwd_A_EX),
        .Branch_fwd_B_EX(Branch_fwd_B_EX)
    );

    // Instantiate Memory
    Memory_cycle memory_inst (
        .clk(clk),
        .reset(reset),
        .inst_MEM(inst_MEM),
        .PC_MEM(PC_MEM),
        .data_2_MEM(data_2_MEM),
        .BrEq_MEM(BrEq_MEM),
        .BrLt_MEM(BrLt_MEM),
        .ALU_out_MEM(ALU_out_MEM),
        .MemRW_MEM(MemRW_MEM),
        .load_type_MEM(load_type_MEM),
        .WBSel_MEM(WBSel_MEM),
        .regWEn_MEM(regWEn_MEM),
        .PC_add4_WB(PC_add4_WB),
        .ALU_out_WB(ALU_out_WB),
        .mem_WB(mem_WB),
        .inst_WB(inst_WB),
        .WBSel_WB(WBSel_WB),
        .regWEn_WB(regWEn_WB),
		.rd_MEM(rd_MEM)
    );

    // Instantiate Writeback
    Writeback_cycle writeback_inst (
        .PC_add4_WB(PC_add4_WB),
        .ALU_out_WB(ALU_out_WB),
        .mem_WB(mem_WB),
        .inst_WB(inst_WB),
        .WBSel_WB(WBSel_WB),
        .regWEn_WB(regWEn_WB),
        .WBSel_out(WBSel_out),
        .rsW(rsW),
        .reg_file_wb_enable(reg_file_wb_enable),
		.rd_WB(rd_WB)
    );
	forward_control fwd(
        .inst_EX_fwd(inst_EX),
        .rd_MEM(rd_MEM),
        .rd_WB(rd_WB),
        .regWEn_MEM(regWEn_MEM),
        .regWEn_WB(regWEn_WB),
        .forwardA_EX(forwardA_EX),
        .forwardB_EX(forwardB_EX),
        .Branch_fwd_A_EX(Branch_fwd_A_EX),
        .Branch_fwd_B_EX(Branch_fwd_B_EX)
	);
	
	hazard_detection_load fix_load (
        .inst_EX(inst_EX),
        .rs1_ID(rs1_ID),
        .rs2_ID(rs2_ID),
        .WBSel_EX(WBSel_EX),
        .regWEn_EX(regWEn_EX),
        .Stall(Stall)
	);

    branch_taken branch_taken (
    .BrLt_MEM(BrLt_MEM),
    .BrEq_MEM(BrEq_MEM),
    .inst_MEM(inst_MEM),
    .PCSel(PCSel),
    .flush(flush)
    );
    assign Write_scoreboard = WBSel_out;
    assign rsw_scoreboard = rsW;
endmodule

module branch_taken (
	input logic BrLt_MEM,
	input logic BrEq_MEM,
	input logic [31:0] inst_MEM,
	output logic PCSel,
	output logic flush);
	
	always @ (*) begin
        // B Type
        if (inst_MEM[6:0] == 7'b1100011) begin
            case (inst_MEM[14:12])
                3'b000: PCSel = BrEq_MEM;        // BEQ
                3'b001: PCSel = ~BrEq_MEM;       // BNE
                3'b100: PCSel = BrLt_MEM;        // BLT
                3'b101: PCSel = ~BrLt_MEM;       // BGE
                3'b110: PCSel = BrLt_MEM;        // BLTU
                3'b111: PCSel = ~BrLt_MEM;       // BGEU
                default: PCSel= 0;
            endcase
        end
        // JAL & JALR
        else if(inst_MEM[6:0] == 7'b1101111) PCSel = 1;
        else if(inst_MEM[6:0] == 7'b1100111) PCSel = 1;
        else PCSel = 0;
    end
	assign flush = PCSel;
endmodule

module hazard_detection_load(
    input  logic [31:0] inst_EX,
    input  logic [4:0]  rs1_ID,
    input  logic [4:0]  rs2_ID,
    input  logic [1:0]  WBSel_EX,        // Xác định nếu lệnh trước là load
    input  logic        regWEn_EX,       // Có ghi thanh ghi không
    output logic        Stall
);
    logic [4:0] rd_EX;

    // Tách rd từ instruction ở EX stage
    assign rd_EX = inst_EX[11:7];

    always_comb begin
        // Nếu lệnh ở EX là load (WBSel = 2'b01) và ghi vào thanh ghi (regWEn_EX)
        // và rd_EX khớp với rs1_ID hoặc rs2_ID của lệnh hiện tại ở Decode
			if (WBSel_EX == 2'b00 && regWEn_EX == 1'b1 && (rd_EX != 5'd0) && (rd_EX == rs1_ID || rd_EX == rs2_ID)) begin
				 Stall = 1'b1;
			end
			else Stall = 1'b0;
    end
endmodule

module forward_control(
    input logic [31:0]inst_EX_fwd,
    input logic [4:0]rd_MEM,
    input logic [4:0]rd_WB,
    input logic regWEn_MEM,
    input logic regWEn_WB,
    output logic [1:0]forwardA_EX,
    output logic [1:0]forwardB_EX,
    output logic [1:0]Branch_fwd_A_EX, 
    output logic [1:0]Branch_fwd_B_EX
   // output logic forward_store_EX
);
    logic [6:0] opcode_EX;
    logic [4:0] rs1_EX, rs2_EX;

    // Tách rs1 và rs2 từ instruction 
    assign rs1_EX = inst_EX_fwd[19:15];
    assign rs2_EX = inst_EX_fwd[24:20];

    always @ (*) begin

        if(inst_EX_fwd[6:0] == 7'b0100011 ) begin
            forwardB_EX = 2'b00;
            forwardA_EX = 2'b00;
        end
        else begin

        // Forward A ALU
        if ((rd_MEM != 5'd0) && (rd_MEM == rs1_EX)&&(regWEn_MEM))
            forwardA_EX = 2'b01;  // Forward từ MEM
        else if ((rd_WB != 5'd0) && (rd_WB == rs1_EX)&&(regWEn_WB))
            forwardA_EX = 2'b10;  // Forward từ WB
		else forwardA_EX = 2'b00;
        
        // Forward B ALU
        if ((rd_MEM != 5'd0) && (rd_MEM == rs2_EX)&&(regWEn_MEM))
            forwardB_EX = 2'b01;  // Forward từ MEM
        else if ((rd_WB != 5'd0) && (rd_WB == rs2_EX)&&(regWEn_WB))
            forwardB_EX = 2'b10;  // Forward từ WB
		else forwardB_EX = 2'b00;
        end

        if(inst_EX_fwd[6:0] == 7'b1100011 ) begin
            forwardB_EX = 2'b00;
            forwardA_EX = 2'b00;
            // Forward A Branch
            if ((rd_MEM != 5'd0) && (rd_MEM == rs1_EX)&&(regWEn_MEM))
                Branch_fwd_A_EX = 2'b01;  // Forward từ MEM
            else if ((rd_WB != 5'd0) && (rd_WB == rs1_EX)&&(regWEn_WB))
                Branch_fwd_A_EX = 2'b10;  // Forward từ WB
            else Branch_fwd_A_EX = 2'b00;

            // Forward B Branch
            if ((rd_MEM != 5'd0) && (rd_MEM == rs2_EX)&&(regWEn_MEM))
                Branch_fwd_B_EX = 2'b01;  // Forward từ MEM
            else if ((rd_WB != 5'd0) && (rd_WB == rs2_EX)&&(regWEn_WB))
                Branch_fwd_B_EX = 2'b10;  // Forward từ WB
            else  Branch_fwd_B_EX = 2'b00;

        end

    end
endmodule
module Writeback_cycle(
    input logic [31:0] PC_add4_WB,
    input logic [31:0] ALU_out_WB,
    input logic [31:0] mem_WB,
    input logic [31:0] inst_WB,
    input logic [1:0] WBSel_WB,
    input logic regWEn_WB,
    output logic [31:0] WBSel_out,
    output logic [4:0] rsW,
    output logic reg_file_wb_enable,
    output logic [4:0] rd_WB // thêm rd_WB để forward
);
    MUX4to1 Writeback_mux(
    .in0(mem_WB),
    .in1(ALU_out_WB),
    .in2(PC_add4_WB),
    .in3(32'b0),
    .sel(WBSel_WB),
    .out(WBSel_out)
    );
    assign rsW = inst_WB[11:7];
    assign reg_file_wb_enable = regWEn_WB;
    assign rd_WB = inst_WB[11:7];
endmodule

module Memory_cycle(
    input logic clk,
    input logic reset,

    // Inputs từ Execute giữ hộ inst
    input logic [31:0] inst_MEM,

    // Input từ Execute giá trị được sử dụng trong MEM
    input logic [31:0] PC_MEM,
    input logic [31:0] data_2_MEM,
    input logic BrEq_MEM,
    input logic BrLt_MEM,
    input logic [31:0] ALU_out_MEM,

    // input từ Execute MEM control
    input logic MemRW_MEM,
    input logic [2:0] load_type_MEM,

    // input từ Execute giữ hộ Writeback control
    input logic [1:0] WBSel_MEM,
    input logic regWEn_MEM,

    // Outputs từ Memory tới Writeback
    output logic [31:0] PC_add4_WB, 
    output logic [31:0] ALU_out_WB,
    output logic [31:0] mem_WB,
    output logic [31:0] inst_WB,

    // Output tới Writeback Control
    output logic [1:0] WBSel_WB,
    output logic regWEn_WB,

    // Output thêm rd ở tầng Memory để forward  
    output logic [4:0] rd_MEM 
);
    
    // Internal signals
    logic [31:0] PC_add4_internal;
    logic [31:0] dataR_DMEM;
    logic [31:0] load_result;

    // Pipeline registers
    logic [31:0] PC_reg_WB;
    logic [31:0] ALU_reg_WB;
    logic [31:0] load_result_reg_WB;
    logic [31:0] inst_reg_WB;
    logic [1:0] WBSel_reg_WB;
    logic regWEn_reg_WB;
    // PC + 4
    Add_Sub_32bit PC_add4_inst (
        .A(PC_MEM),
        .B(32'd4),
        .Sel(1'b0),
        .Result(PC_add4_internal)
    );

    DMEM DMEM_instance (
        .addr(ALU_out_MEM),
        .clk(clk),
        .MemRW(MemRW_MEM),
        .dataW(data_2_MEM),
        .dataR(dataR_DMEM)
    );

    Load_encode Load_encode_instance (
        .load_data(dataR_DMEM),
        .load_type(load_type_MEM),
        .load_result(load_result)
    );

    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            PC_reg_WB <= 32'd0;
            ALU_reg_WB <= 32'd0;
            load_result_reg_WB <= 32'd0;
            inst_reg_WB <= 32'd0;
            WBSel_reg_WB <= 0;
            regWEn_reg_WB <= 0;

        end else begin
            PC_reg_WB <= PC_add4_internal;
            ALU_reg_WB <= ALU_out_MEM;
            load_result_reg_WB <= load_result;
            inst_reg_WB <= inst_MEM;
            WBSel_reg_WB <= WBSel_MEM;
            regWEn_reg_WB <= regWEn_MEM;
        end
    end

    assign PC_add4_WB = PC_reg_WB;
    assign ALU_out_WB = ALU_reg_WB;
    assign mem_WB = load_result_reg_WB;
    assign inst_WB = inst_reg_WB;
    assign WBSel_WB = WBSel_reg_WB;
    assign regWEn_WB = regWEn_reg_WB;

    assign rd_MEM = inst_MEM[11:7]; // rd_MEM cho forward
endmodule

module Execute_cycle(
    input logic clk,
    input logic reset,

    // Input từ Decode PC, inst giữ nguyên
    input logic [31:0] PC_EX,
    input logic [31:0] inst_EX,

    // Input từ Decode, giữ hộ MEM control
    input logic MemRW_EX,
    input logic [2:0] load_type_EX,

    // Input từ Decode, giữ hộ Writeback control
    input logic [1:0] WBSel_EX,
    input logic regWEn_EX,

    // Input từ Decode được sử dụng trong Execute
    input logic Asel_EX,
    input logic Bsel_EX,
    input logic [31:0] data_1_EX,
    input logic [31:0] data_2_EX,
    input logic [31:0] Imm_EX,
    input logic [3:0] ALU_sel_EX,
    input logic BrUn_EX,

    // Input từ MEM cho flush
    input logic flush,

    // Input từ Forwarding control
    input logic [1:0] forwardA_EX,
    input logic [1:0] forwardB_EX,
    input logic [1:0] Branch_fwd_A_EX, 
    input logic [1:0] Branch_fwd_B_EX,

    // Data forwarding từ MEM và WriteBack
    input logic [31:0] ALU_out_MEM_fwd,
    input logic [31:0] WBSel_out_WB_fwd,

    // Outputs tới MEM giá trị tính được từ Execute
    output logic BrEq_MEM,
    output logic BrLt_MEM,
    output logic [31:0] ALU_out_MEM,

    // Output tới MEM các giá trị giữ hộ
    output logic [31:0] PC_MEM,
    output logic [31:0] data_2_MEM,
    output logic [31:0] inst_MEM,

    // Output to Execute MEM control
    output logic MemRW_MEM,
    output logic [2:0] load_type_MEM,

    // Output to Execute Writeback control
    output logic [1:0] WBSel_MEM,
    output logic regWEn_MEM,

    // Output rs1 và rs2 để forward
    output logic [31:0] inst_EX_fwd
);

    logic [31:0] ALU_result;
    logic [31:0] forwardA_data, forwardB_data;

    logic [31:0] PC_reg, inst_reg, data_2_reg, ALU_reg;
    logic BrEq_reg, BrEq;
    logic BrLt_reg, BrLt;
    logic MemRW_reg;
    logic [2:0] load_type_reg;
    logic [1:0] WBSel_reg;
    logic regWEn_reg;
    logic [31:0] Asel_out, Bsel_out;
    logic [31:0]Branch1_out, Branch2_out;
    assign inst_EX_fwd = inst_EX;

    // Forwarding multiplexers
    MUX4to1 mux_forwardA (
        .sel(forwardA_EX),
        .in0(Asel_out),
        .in1(ALU_out_MEM_fwd),
        .in2(WBSel_out_WB_fwd),
        .in3(32'b0),
        .out(forwardA_data)
    );

    MUX4to1 mux_forwardB (
        .sel(forwardB_EX),
        .in0(Bsel_out),
        .in1(ALU_out_MEM_fwd),
        .in2(WBSel_out_WB_fwd),
        .in3(32'b0),
        .out(forwardB_data)
    );

    MUX4to1 Branch1 (
        .sel(Branch_fwd_A_EX),
        .in0(data_1_EX),
        .in1(ALU_out_MEM_fwd),
        .in2(WBSel_out_WB_fwd),
        .in3(32'b0),
        .out(Branch1_out)
    );

    MUX4to1 Branch2 (
        .sel(Branch_fwd_B_EX),
        .in0(data_2_EX),
        .in1(ALU_out_MEM_fwd),
        .in2(WBSel_out_WB_fwd),
        .in3(32'b0),
        .out(Branch2_out)
    );

    Mux2to1 Op_A(
        .in0(data_1_EX),
        .in1(PC_EX),
        .sel(Asel_EX),
        .out(Asel_out)
    );
    Mux2to1 Op_B(
        .in0(data_2_EX),
        .in1(Imm_EX),
        .sel(Bsel_EX),
        .out(Bsel_out)
    );
    // Branch comparator
    brc brc_unit (
        .BrUn(BrUn_EX),
        .data_1(Branch1_out),
        .data_2(Branch2_out),
        .BrEq(BrEq),
        .BrLt(BrLt)
    );

    // ALU
    ALU alu_unit(
        .A(forwardA_data),
        .B(forwardB_data), // hoặc Imm_EX nếu có mux chọn Bsel
        .ALU_out(ALU_result),
        .ALU_sel(ALU_sel_EX)
    );

    // Pipeline registers
    always_ff @ (posedge clk or negedge reset) begin
        if (!reset) begin
            PC_reg <= 32'd0;
            inst_reg <= 32'd0;
            data_2_reg <= 32'd0;
            ALU_reg <= 32'd0;
            MemRW_reg <= 0;
            load_type_reg <= 0;
            WBSel_reg <= 0;
            regWEn_reg <= 0;
            BrEq_reg <= 0;
            BrLt_reg <= 0;    
        end 
		else if (flush) begin
			PC_reg <= 32'd0;
            inst_reg <= 32'd0;
            data_2_reg <= 32'd0;
            ALU_reg <= 32'd0;
            MemRW_reg <= 0;
            load_type_reg <= 0;
            WBSel_reg <= 0;
            regWEn_reg <= 0;
            BrEq_reg <= 0;
            BrLt_reg <= 0;    
          end	

		else begin
            PC_reg <= PC_EX;
            inst_reg <= inst_EX;
            data_2_reg <= data_2_EX;
            ALU_reg <= ALU_result;
            MemRW_reg <= MemRW_EX;
            load_type_reg <= load_type_EX;
            WBSel_reg <= WBSel_EX;
            regWEn_reg <= regWEn_EX;
            BrEq_reg <= BrEq;
            BrLt_reg <= BrLt;
        end
    end

    assign ALU_out_MEM = ALU_reg;
    assign PC_MEM = PC_reg;
    assign data_2_MEM = data_2_reg;
    assign inst_MEM = inst_reg;
    assign MemRW_MEM = MemRW_reg;
    assign load_type_MEM = load_type_reg;
    assign WBSel_MEM = WBSel_reg;
    assign regWEn_MEM = regWEn_reg;
    assign BrEq_MEM = BrEq_reg;
    assign BrLt_MEM = BrLt_reg;
endmodule

module Decode_cycle(
    input logic clk,
    input logic reset,

    // Input từ Fetch
    input logic [31:0] PC_ID,
    input logic [31:0] inst_ID,

    // Input từ Writeback
    input logic [31:0] WBSel_out_WB,
    input logic [4:0] rsW,
    input logic reg_file_wb_enable,
	 
	// flush
    input logic flush,
    input logic Stall,

    // Output tới Ex giá trị PC và inst
    output logic [31:0] PC_EX,
    output logic [31:0] inst_EX,

    // Output to Execute EX_control
    output logic  Asel_EX,
    output logic  Bsel_EX,
    output logic [31:0] data_1_EX,
    output logic [31:0] data_2_EX,
    output logic [31:0] Imm_EX,
    output logic [3:0] ALU_sel_EX,
    output logic BrUn_EX,

    // Output to Execute MEM control
    output logic MemRW_EX,
    output logic [2:0] load_type_EX,

    // Output to Execute Writeback control
    output logic [1:0] WBSel_EX,
    output logic regWEn_EX,
	 
	 // Output để fix load hazard
	 output logic [4:0]rs1_ID,
	 output logic [4:0]rs2_ID
);
    // Signal Imm_Gen
    logic [31:0] Imm_out, Imm_out_reg;
    logic [2:0] Imm_Sel;

    // Signal Regfile
    logic [31:0] data_1, data_2;
    logic [31:0] data_1_reg, data_2_reg;

    //Signal Control Unit
    logic [3:0] ALU_sel;
    logic BrUn; 
    logic MemRW;
    logic [2:0] load_type;
    logic [1:0] WBSel;
    logic regWEn;

    logic [31:0] PC_reg, inst_reg;


    // pipeline register
    logic [3:0] ALU_sel_reg;
    logic BrUn_reg;
    logic MemRW_reg;
    logic [2:0] load_type_reg;
    logic [1:0] WBSel_reg;
    logic regWEn_reg;
    logic Asel, Asel_reg, Bsel, Bsel_reg;
    regfile regfile_instance (
        .clk(clk),
        .reset(reset),
        .rs1(inst_ID[19:15]),
        .rs2(inst_ID[24:20]),
        .rsW(rsW),
        .data_W(WBSel_out_WB),
        .regWEn(reg_file_wb_enable),
        .data_1(data_1),
        .data_2(data_2)
    );

    Control_unit control_instance (
        .inst(inst_ID),
        .Imm_Sel(Imm_Sel),
        .regWEn(regWEn),
        .BrUn(BrUn),
        .Bsel(Bsel),
        .Asel(Asel),
        .ALU_sel(ALU_sel),
        .MemRW(MemRW),
        .load_type(load_type),
        .WBSel(WBSel)
    );

    Imm_Gen Imm_Gen_instance (
        .inst(inst_ID),
        .Imm_Sel(Imm_Sel),
        .Imm_out(Imm_out)
    );

    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            Imm_out_reg   <= 32'b0;
            data_1_reg    <= 32'b0;
            data_2_reg    <= 32'b0;
            PC_reg        <= 32'b0;
            inst_reg      <= 32'h00000013; // NOP
            ALU_sel_reg   <= 4'b0;
            BrUn_reg      <= 1'b0;
            MemRW_reg     <= 1'b0;
            load_type_reg <= 3'b0;
            WBSel_reg     <= 2'b0;
            regWEn_reg    <= 1'b0;
            Asel_reg      <= 1'b0;
            Bsel_reg      <= 1'b0;
        end 
		  else if (Stall) begin
            // Khi stall: Giữ lại toàn bộ dữ liệu cũ, nhưng chèn NOP
            inst_reg <= 32'h00000013; // chỉ thay đổi instruction
        end 
		  else if (flush) begin
			   Imm_out_reg   <= 32'b0;
            data_1_reg    <= 32'b0;
            data_2_reg    <= 32'b0;
            PC_reg        <= 32'b0;
            inst_reg      <= 32'h00000013; // NOP
            ALU_sel_reg   <= 4'b0;
            BrUn_reg      <= 1'b0;
            MemRW_reg     <= 1'b0;
            load_type_reg <= 3'b0;
            WBSel_reg     <= 2'b0;
            regWEn_reg    <= 1'b0;
            Asel_reg      <= 1'b0;
		  end
		  else begin
            Imm_out_reg   <= Imm_out;
            data_1_reg    <= data_1;
            data_2_reg    <= data_2;
            PC_reg        <= PC_ID;
            inst_reg      <= inst_ID;
            ALU_sel_reg   <= ALU_sel;
            BrUn_reg      <= BrUn;
            MemRW_reg     <= MemRW;
            load_type_reg <= load_type;
            WBSel_reg     <= WBSel;
            regWEn_reg    <= regWEn;
            Asel_reg      <= Asel;
            Bsel_reg      <= Bsel;
        end
    end

    assign PC_EX = PC_reg;
    assign data_1_EX = data_1_reg;
    assign data_2_EX = data_2_reg;
    assign Imm_EX = Imm_out_reg;
    assign inst_EX = inst_reg;
    assign ALU_sel_EX = ALU_sel_reg;
    assign BrUn_EX = BrUn_reg;
    assign MemRW_EX = MemRW_reg;
    assign load_type_EX = load_type_reg;
    assign WBSel_EX = WBSel_reg;
    assign regWEn_EX = regWEn_reg;
    assign Asel_EX = Asel_reg;
    assign Bsel_EX = Bsel_reg;
	 
	 // fix load hazard
	 assign rs1_ID = inst_ID[19:15];
	 assign rs2_ID = inst_ID[24:20];
endmodule

module Fetch_cycle (
    input logic clk,
    input logic reset,

    // PCsel chọn nhảy từ control unit
    input logic PCSel,                      
    input logic [31:0] ALU_out_MEM,  // địa chỉ nhảy từ Execute
	
	 // Stall, flush
	input logic Stall,
	input logic flush,
	 
    // Output to Decode
    output logic [31:0] PC_ID,
    output logic [31:0] inst_ID
);
    logic [31:0] PC_in, PC_out, PC_add4_out, PC_reg;
    logic [31:0] inst, inst_reg;

    // PC
    PC PC_instance (
        .clk(clk),
        .reset(reset),
        .enable(~Stall), // Thêm enable để dừng PC khi Stall
        .data_in(PC_in),
        .data_out(PC_out)
    );


    // Tính PC + 4
    Add_Sub_32bit PC_add4 (
        .A(PC_out),
        .B(32'd4),
        .Sel(1'b0),
        .Result(PC_add4_out)
    );

    // Chọn địa chỉ tiếp theo: nhảy hoặc +4
    Mux2to1 PC_taken (
        .in0(PC_add4_out),
        .in1(ALU_out_MEM),
        .sel(PCSel),
        .out(PC_in)
    );

    IMEM IMEM_instance (
        .addr(PC_out),
        .inst(inst)
    );
    // Pipeline register IF/ID
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            inst_reg <= 32'b0;
            PC_reg <= 32'b0;
        end else begin
            if (flush) begin
                inst_reg <= 32'h00000013; // NOP khi flush
            end 
            else begin
                inst_reg <= inst;
            end

            if (!Stall) begin
                PC_reg <= PC_out; // Chỉ cập nhật PC nếu không stall
            end
            else inst_reg <= inst_reg;
        end
    end

    assign inst_ID = inst_reg;
    assign PC_ID = PC_reg;
endmodule

module Mux2to1(
    input logic [31:0]in0,
    input logic [31:0]in1,
    input logic sel,
    output logic [31:0]out
);
    assign out = sel?in1:in0;
endmodule

///Control Unit//////
module Control_unit(
	input logic [31:0]inst,
	//input logic BrEq,
	//input logic BrLt,
	//output logic PCSel,
	output logic [2:0]Imm_Sel,
	output logic regWEn,
	output logic BrUn,
	output logic Bsel,
	output logic Asel,
	output logic [3:0]ALU_sel,
	output logic MemRW,
	output logic [2:0]load_type,
	output logic [1:0]WBSel);
	
	logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

   assign opcode = inst[6:0];
   assign funct3 = inst[14:12];
	
    always @(*) begin
        // Giá trị mặc định
        //PCSel   = 1'b0;
        Imm_Sel = 3'b000;
		regWEn  = 1'b0;
        BrUn    = 1'b0;
        Bsel    = 1'b0;
        Asel    = 1'b0;
        ALU_sel = 4'b0000;
        MemRW   = 1'b0;
        WBSel   = 2'b00;
		load_type = 3'b0;
        //BrUn = 1'b0;
		case (opcode)

			7'b0110011: begin  // R-type 
            regWEn  = 1'b1;//cho phép ghi reg file
            WBSel   = 2'b1;// chọn write back từ ngõ ra ALU
            Asel    = 1'b0;// chọn A từ rs1
            Bsel    = 1'b0;//chọn B từ rs2
			load_type = 3'b0; //không load
				case(funct3)
					3'b000: ALU_sel = (inst[30]) ? 4'b1000 : 4'b0000; // SUB nếu inst[30] = 1, ADD nếu inst[30] = 0
					3'b001: ALU_sel = 4'b0001; // SLL
					3'b010: ALU_sel = 4'b0010; // SLT
					3'b011: ALU_sel = 4'b0011; // SLTU
					3'b100: ALU_sel = 4'b0100; // XOR
					3'b101: ALU_sel = (inst[30]) ? 4'b1101 : 4'b0101; // SRA nếu inst[30] = 1, SRL nếu inst[30] = 0
					3'b110: ALU_sel = 4'b0110; // OR
					3'b111: ALU_sel = 4'b0111; // AND
					default: ALU_sel = 4'b0000; // Mặc định là ADD
				endcase
			end
			

			7'b0010011: begin  // I-type 
			regWEn  = 1'b1;//cho phép ghi reg file
            WBSel   = 2'b1;// chọn write back từ ngõ ra ALU
            Asel    = 1'b0;// chọn A từ rs1
            Bsel    = 1'b1;//chọn B từ rs2
				Imm_Sel = 3'b000;// Imm_Gen theo I type
				MemRW   = 1'b0;	// Cho phép đọc đọc DMEM
				load_type = 3'b0; // không load
				case(funct3)
					3'b000: ALU_sel = 4'b0000; // ADDI
					3'b001: ALU_sel = 4'b0001; // SLLI
					3'b010: ALU_sel = 4'b0010; // SLTI
					3'b011: ALU_sel = 4'b0011; // SLTUI
					3'b100: ALU_sel = 4'b0100; // XORI
					3'b101: ALU_sel = (inst[30]) ? 4'b1101 : 4'b0101; // SRAI nếu inst[30] = 1, SRLI nếu inst[30] = 0
					3'b110: ALU_sel = 4'b0110; // ORI
					3'b111: ALU_sel = 4'b0111; // ANDI
					default: ALU_sel = 4'b0000; // Mặc định là ADD
				endcase
				end
				
			7'b0000011: begin  // Load
			    regWEn  = 1'b1; // Cho phép ghi lại vào regfile
                WBSel   = 2'b0; // Lấy dữ liệu từ DMEM
                Asel    = 1'b0; // Chọn Rs1 + Imm_Gen
                Bsel    = 1'b1; // Chọn Imm_Gen
				Imm_Sel = 3'b000;	// Imm_Gen theo I type
				ALU_sel = 4'b0000;	// Thực hiện phép cộng
				MemRW   = 1'b0;	// Cho phép đọc đọc DMEM
				case(funct3)
					3'b000: load_type = 3'b000; //LB
					3'b001: load_type = 3'b001; //LH
					3'b010: load_type = 3'b010; //LW
					3'b100: load_type = 3'b100; //LBU					
					3'b101: load_type = 3'b101; //LHU			
					default: load_type = 3'b111; 
				endcase
			end
			
			7'b0100011: begin //	S-type
				Imm_Sel = 3'b001;	// Imm_Gen theo S type
				regWEn = 1'b0; //không cho ghi lại vào reg file
				Asel = 1'b0; //chọn A là rs1 
				Bsel = 1'b1; //chọn B là Imm_Gen theo S type
				MemRW = 1'b1; //cho phép đọc và ghi DMEM
				ALU_sel = 4'b0000;	// Thực hiện phép cộng
				WBSel = 2'b11; //write back là tùy định vì không ghi ngược lại vào regfile
			end
			
			7'b1100011: begin	// B-type
				Imm_Sel = 3'b010;	//Imm_Gen theo B type
				regWEn = 1'b0;	//Không ghi lại vào reg file
				Asel = 1'b1;	// A chọn PC hiện hành
				Bsel = 1'b1;	// B chọn imm_Gen theo B type
				ALU_sel = 4'b0000;	//ALU thực hiện phép cộng
				MemRW = 1'b0;	// Cho phép đọc DMEM
				WBSel = 2'b11; // write back là tùy định vì không ghi ngược lại vào regfile
				case(funct3)
					3'b000: begin BrUn = 1'b1; end//BEQ
					3'b001: begin BrUn = 1'b1; end//BNE
					3'b100: begin BrUn = 1'b0; end//BLT
					3'b101: begin BrUn = 1'b0; end//BGE
					3'b110: begin BrUn = 1'b1; end//BLTU
					3'b111: begin BrUn = 1'b1; end//BGEU
					default: BrUn = 1'b0;
				endcase
			end
			
			7'b1101111: begin // J-type JAL
				//PCSel = 1'b1;	//PCSel chọn luôn nhảy
				Imm_Sel = 3'b011; // Imm_Gen theo J Type
				regWEn = 1'b1;	// cho phép ghi ngược vào regfile
				Bsel = 1'b1;	// B chọn Imm_Gen theo J type
				Asel  =1'b1;	// A chọn PC hiện hành
				ALU_sel = 4'b0000;	// ALU thực hiện phép cộng
				MemRW = 1'b0;	// Cho phép đọc DMEM
				WBSel = 2'b10;	// Write back chọn PC+4 để return
			end
			
			7'b1100111: begin // I-type JALR
				//PCSel = 1'b1;	//PCSel chọn luôn nhảy
				Imm_Sel = 3'b000; // Imm_Gen theo I Type
				regWEn = 1'b1;	// cho phép ghi ngược vào regfile
				Bsel = 1'b1;	// B chọn Imm_Gen theo I type
				Asel = 1'b0;	// A chọn rs1
				ALU_sel = 4'b0000;	// ALU thực hiện phép cộng
				MemRW = 1'b0;	// Cho phép đọc DMEM
				WBSel = 2'b10; // Write back chọn PC+4 để return
			end
			7'b0110111: begin // U-type LUI
				//PCSel = 1'b0;	// PCSel chọn không nhảy
				Imm_Sel = 3'b100; //Imm_Gen theo U type LUI
				regWEn = 1'b1; //cho phép ghi vào reg file
				Bsel = 1'b1;	// B chọn Imm_Gen theo U type LUI
				Asel = 1'b0;	// A tùy định
				ALU_sel = 4'b1111; //ALU dẫn B ra ALU_out
				MemRW = 1'b0; // Cho phép đọc DMEM
				WBSel = 2'b01; // chọn write back từ ALU_out
			end
			7'b0010111: begin // U-type AUIPC
				//PCSel = 1'b0;	// PCSel chọn không nhảy
				Imm_Sel = 3'b101; //Imm_Gen theo U type AUIPC
				regWEn = 1'b1; //cho phép ghi vào reg file
				Bsel = 1'b1;	// B chọn Imm_Gen theo U type LUI
				Asel = 1'b1;	// A tùy lấy PC hiện hành
				ALU_sel = 4'b0000; //ALU thực hiện phép cộng
				MemRW = 1'b0; // Cho phép đọc DMEM
				WBSel = 2'b01; // chọn write back từ ALU_out
			end
			default begin
				//PCSel   = 1'b0;
				Imm_Sel = 3'b000;
				regWEn  = 1'b0;
				BrUn    = 1'b0;
				Bsel    = 1'b0;
				Asel    = 1'b0;
				ALU_sel = 4'b0000;
				MemRW   = 1'b0;
				WBSel   = 2'b00;
			end
		endcase
	end
endmodule
/////////Program Counter//////////////////////
module PC (
    input logic clk,
    input logic reset,
    input logic enable,
    input logic [31:0] data_in,
    output logic [31:0] data_out
);
    always_ff @(posedge clk or negedge reset) begin
        if (!reset)
            data_out <= 32'b0;
        else if (enable)
            data_out <= data_in;
       // else data_out <= 32'h00000013;
    end
endmodule


//////////Register File ///////////////////////
module regfile(
	input logic clk, regWEn, reset,
	input logic [31:0]data_W,
	input logic [4:0]rsW,
	input logic [4:0]rs1,
	input logic [4:0]rs2,
	output logic [31:0]data_1,
	output logic [31:0]data_2);
	
	logic [31:0]reg_mem[31:0];
	
	always_ff @(posedge clk or negedge reset) begin
      if (!reset) begin
            for (int i = 1; i < 32; i++) begin
                reg_mem[i] <= 32'b0;  //reset regfile = 0
            end
		end
		else if(regWEn) reg_mem[rsW] <= data_W;
		else reg_mem[rsW] <= reg_mem[rsW];
	end
	assign data_1 = (rs1 == 5'd0) ? 32'b0 : reg_mem[rs1];
	assign data_2 = (rs2 == 5'd0) ? 32'b0 : reg_mem[rs2];
	
	
endmodule

///////Instruction Memory ////////////////////////	
module IMEM (
	input logic [31:0]addr,
	output logic [31:0]inst
    );
	
    initial begin
        $display("Loading program into IMEM...");
        $readmemh("D:/RTL project/RISCV/mem.dump", memory); // dùng `/` thay vì `\`
    end

	logic [31:0] memory [0:256];
	assign inst = memory[addr[31:2]];
endmodule

///////Data Memory ////////////////////////
module DMEM(
	input logic [31:0]addr,
	input logic [31:0]dataW,
	output logic [31:0]dataR,
	input logic clk, MemRW);
	
	logic [31:0]memory[0:255];

	always_ff @ (posedge clk) begin
		if(MemRW) memory[addr] <= dataW;	// MemRW = 1 để write
	end
	assign dataR = memory[addr];	//luôn ở trạng thái READ
endmodule	

////////Load Encoding/////
module Load_encode(
    input  logic [31:0] load_data, // Data từ DMEM
    input  logic [2:0]  load_type,  // Chọn kiểu load
    output logic [31:0] load_result); 
	 
    always @(*) begin
        case (load_type)
            3'b000: load_result = {{24{load_data[7]}}, load_data[7:0]};  // Load byte mở rộng dấu
            3'b001: load_result = {{16{load_data[15]}}, load_data[15:0]}; // Load haftword mở rộng dấu
            3'b010: load_result = load_data;  // LW 
            3'b100: load_result = {24'b0, load_data[7:0]};  // LBU 
            3'b101: load_result = {16'b0, load_data[15:0]}; // LHU 
            default: load_result = 32'b0;  
        endcase
    end

endmodule
/////////Immediate generator///////////////
module Imm_Gen(	
	input logic [2:0] Imm_Sel, // Chọn kiểu generate
	input logic [31:0] inst,	// Instruction
	output logic [31:0] Imm_out); // Kết quả
	// I type = 000	7'b0010011
	// S type = 001	7'b0100011
	// B type = 010	7'b1100011
	// J type = 011	7'b1101111	JAL
	// U type = 100	7'b0110111 	LUI
	// U type = 101	7'b0010111	AUIPC
always @(*) begin
	case(Imm_Sel) 
		3'b000: begin //I typte
          Imm_out = {{20{inst[31]}}, inst[31:20]};
		end
		3'b001: begin // S type
          Imm_out = {{20{inst[31]}}, inst[31:25], inst[11:7]};
		end
		3'b010: begin //B type
          Imm_out = {{20{inst[31]}}, inst[7],inst[30:25], inst[11:8],1'b0};
		end
		3'b011: begin // J type JAL
          Imm_out = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
		end
		3'b100: begin // U type LUI
			Imm_out = {inst[31:12], 12'b0};
		end
		3'b101: begin // U type AUIPC
			Imm_out = {inst[31:12], 12'b0};
		end
		default: Imm_out = 32'b0;
	endcase
end
endmodule
	

module Shift_Left_Logical (
    input  logic [31:0] data_in,   // Data
    input  logic [4:0]  shift_amt, // Số bit cần dịch
    output logic [31:0] data_out);   // Kết quả


    always @(*) begin
        case (shift_amt)
            5'd0:  data_out = data_in;
            5'd1:  data_out = {data_in[30:0], 1'b0};
            5'd2:  data_out = {data_in[29:0], 2'b0};
            5'd3:  data_out = {data_in[28:0], 3'b0};
            5'd4:  data_out = {data_in[27:0], 4'b0};
            5'd5:  data_out = {data_in[26:0], 5'b0};
            5'd6:  data_out = {data_in[25:0], 6'b0};
            5'd7:  data_out = {data_in[24:0], 7'b0};
            5'd8:  data_out = {data_in[23:0], 8'b0};
            5'd9:  data_out = {data_in[22:0], 9'b0};
            5'd10: data_out = {data_in[21:0], 10'b0};
            5'd11: data_out = {data_in[20:0], 11'b0};
            5'd12: data_out = {data_in[19:0], 12'b0};
            5'd13: data_out = {data_in[18:0], 13'b0};
            5'd14: data_out = {data_in[17:0], 14'b0};
            5'd15: data_out = {data_in[16:0], 15'b0};
            5'd16: data_out = {data_in[15:0], 16'b0};
            5'd17: data_out = {data_in[14:0], 17'b0};
            5'd18: data_out = {data_in[13:0], 18'b0};
            5'd19: data_out = {data_in[12:0], 19'b0};
            5'd20: data_out = {data_in[11:0], 20'b0};
            5'd21: data_out = {data_in[10:0], 21'b0};
            5'd22: data_out = {data_in[9:0], 22'b0};
            5'd23: data_out = {data_in[8:0], 23'b0};
            5'd24: data_out = {data_in[7:0], 24'b0};
            5'd25: data_out = {data_in[6:0], 25'b0};
            5'd26: data_out = {data_in[5:0], 26'b0};
            5'd27: data_out = {data_in[4:0], 27'b0};
            5'd28: data_out = {data_in[3:0], 28'b0};
            5'd29: data_out = {data_in[2:0], 29'b0};
            5'd30: data_out = {data_in[1:0], 30'b0};
            5'd31: data_out = {data_in[0], 31'b0};
            default: data_out = 32'b0;
        endcase
    end

endmodule

module Shift_Right_Logical (
    input  logic [31:0] data_in,   // Data
    input  logic [4:0]  shift_amt, // Số bit cần dịch
    output logic [31:0] data_out);   // Kết quả 


    always @(*) begin
        case (shift_amt)
            5'd0:  data_out = data_in;
            5'd1:  data_out = {1'b0, data_in[31:1]};
            5'd2:  data_out = {2'b0, data_in[31:2]};
            5'd3:  data_out = {3'b0, data_in[31:3]};
            5'd4:  data_out = {4'b0, data_in[31:4]};
            5'd5:  data_out = {5'b0, data_in[31:5]};
            5'd6:  data_out = {6'b0, data_in[31:6]};
            5'd7:  data_out = {7'b0, data_in[31:7]};
            5'd8:  data_out = {8'b0, data_in[31:8]};
            5'd9:  data_out = {9'b0, data_in[31:9]};
            5'd10: data_out = {10'b0, data_in[31:10]};
            5'd11: data_out = {11'b0, data_in[31:11]};
            5'd12: data_out = {12'b0, data_in[31:12]};
            5'd13: data_out = {13'b0, data_in[31:13]};
            5'd14: data_out = {14'b0, data_in[31:14]};
            5'd15: data_out = {15'b0, data_in[31:15]};
            5'd16: data_out = {16'b0, data_in[31:16]};
            5'd17: data_out = {17'b0, data_in[31:17]};
            5'd18: data_out = {18'b0, data_in[31:18]};
            5'd19: data_out = {19'b0, data_in[31:19]};
            5'd20: data_out = {20'b0, data_in[31:20]};
            5'd21: data_out = {21'b0, data_in[31:21]};
            5'd22: data_out = {22'b0, data_in[31:22]};
            5'd23: data_out = {23'b0, data_in[31:23]};
            5'd24: data_out = {24'b0, data_in[31:24]};
            5'd25: data_out = {25'b0, data_in[31:25]};
            5'd26: data_out = {26'b0, data_in[31:26]};
            5'd27: data_out = {27'b0, data_in[31:27]};
            5'd28: data_out = {28'b0, data_in[31:28]};
            5'd29: data_out = {29'b0, data_in[31:29]};
            5'd30: data_out = {30'b0, data_in[31:30]};
            5'd31: data_out = {31'b0, data_in[31]};
            default: data_out = 32'b0;
        endcase
    end

endmodule

module Shift_Right_Arithmetic (
    input  logic [31:0] data_in, // Data
    input  logic [4:0] shift_amt, // Số bit cần dịch
    output logic [31:0] data_out); //Kết quả

    always @(*) begin
        case (shift_amt)
            5'd0:  data_out = data_in;
            5'd1:  data_out = {data_in[31], data_in[31:1]};
            5'd2:  data_out = {{2{data_in[31]}}, data_in[31:2]};
            5'd3:  data_out = {{3{data_in[31]}}, data_in[31:3]};
            5'd4:  data_out = {{4{data_in[31]}}, data_in[31:4]};
            5'd5:  data_out = {{5{data_in[31]}}, data_in[31:5]};
            5'd6:  data_out = {{6{data_in[31]}}, data_in[31:6]};
            5'd7:  data_out = {{7{data_in[31]}}, data_in[31:7]};
            5'd8:  data_out = {{8{data_in[31]}}, data_in[31:8]};
            5'd9:  data_out = {{9{data_in[31]}}, data_in[31:9]};
            5'd10: data_out = {{10{data_in[31]}}, data_in[31:10]};
            5'd11: data_out = {{11{data_in[31]}}, data_in[31:11]};
            5'd12: data_out = {{12{data_in[31]}}, data_in[31:12]};
            5'd13: data_out = {{13{data_in[31]}}, data_in[31:13]};
            5'd14: data_out = {{14{data_in[31]}}, data_in[31:14]};
            5'd15: data_out = {{15{data_in[31]}}, data_in[31:15]};
            5'd16: data_out = {{16{data_in[31]}}, data_in[31:16]};
            5'd17: data_out = {{17{data_in[31]}}, data_in[31:17]};
            5'd18: data_out = {{18{data_in[31]}}, data_in[31:18]};
            5'd19: data_out = {{19{data_in[31]}}, data_in[31:19]};
            5'd20: data_out = {{20{data_in[31]}}, data_in[31:20]};
            5'd21: data_out = {{21{data_in[31]}}, data_in[31:21]};
            5'd22: data_out = {{22{data_in[31]}}, data_in[31:22]};
            5'd23: data_out = {{23{data_in[31]}}, data_in[31:23]};
            5'd24: data_out = {{24{data_in[31]}}, data_in[31:24]};
            5'd25: data_out = {{25{data_in[31]}}, data_in[31:25]};
            5'd26: data_out = {{26{data_in[31]}}, data_in[31:26]};
            5'd27: data_out = {{27{data_in[31]}}, data_in[31:27]};
            5'd28: data_out = {{28{data_in[31]}}, data_in[31:28]};
            5'd29: data_out = {{29{data_in[31]}}, data_in[31:29]};
            5'd30: data_out = {{30{data_in[31]}}, data_in[31:30]};
            5'd31: data_out = {{31{data_in[31]}}, data_in[31]};
            default: data_out = 32'b0;
        endcase
    end
endmodule

module Add_Sub_32bit (
    input  logic [31:0] A, B,  // Input A, B
    input  logic Sel,          // 0 = ADD, 1 = SUB
    output logic [31:0] Result,// Kết quả phép cộng 
    output logic Cout);          // Carry-out

    logic [31:0] B_mod;        // 
    logic Cin;                 // Carry-in
    logic [31:0] carry;  // Carry signals
    assign B_mod = (Sel) ? ~B : B;  // Bù 2 của B

    Full_Adder FA0(
	 A[0],
	 B_mod[0],
	 Sel,
	 Result[0],
	 carry[0]);

    // Generate 31 more full adders
    genvar i;
    generate
        for (i = 1; i < 32; i = i + 1) begin :adder_32
            Full_Adder FA (A[i], B_mod[i], carry[i-1], Result[i], carry[i]);
        end
    endgenerate

    assign Cout = carry[31];

endmodule

	
module Full_Adder (
    input  logic A,
	 input logic B,
	 input logic Cin,
    output logic Sum,
	 output logic Cout);
	 
    assign Sum  = A ^ B ^ Cin;
    assign Cout = (A & B) | (Cin & (A ^ B));

endmodule
	
module SLT_SLTU (
    input  logic [31:0] A, B,  // Input A, B
    input  logic Sel,          // 0 = SLT (có dấu), 1 = SLTU (không dấu)
    output logic [31:0] Result); // Kết quả

    logic [31:0] diff_out;  // Kết quả phép trừ A - B
    logic carry_out;        // Carry/Borrow từ phép trừ

    Add_Sub_32bit SUB(
	 .A(A),
	 .B(B), 
	 .Sel(1'b1), 
	 .Result(diff_out),
	 .Cout(carry_out));

    always @(*) begin
        case (Sel)
            1'b0: Result = {31'b0, (A[31] & ~B[31]) | (~(A[31] ^ B[31]) & diff_out[31])}; // SLT (có dấu)
            1'b1: Result = {31'b0, ~carry_out};  // SLTU (không dấu)
            default: Result = 32'b0; 
        endcase
    end
endmodule
	
module ALU(
    input  logic [3:0]  ALU_sel, // Chọn phép tính
    input  logic [31:0] A,	// Toán hạng 1
    input  logic [31:0] B, // Toán hạng 2
    output logic [31:0] ALU_out); // Kết quả
	 
    logic [31:0] add_sub_out, sll_out, srl_out, sra_out;
    logic [31:0] slt_out, sltu_out;

    // Instance các module cần dùng
	 
	 // ADD, SUB
    Add_Sub_32bit ADD_SUB( 
	 .A(A),
	 .B(B),
	 .Sel(ALU_sel[3]),
	 .Result(add_sub_out)); 
	 
	 // SLL
    Shift_Left_Logical SLL(
	 .data_in(A),
	 .shift_amt(B[4:0]),
	 .data_out(sll_out)); // SLL

	 // SRL
    Shift_Right_Logical SRL(
	 .data_in(A), 
	 .shift_amt(B[4:0]),
	 .data_out(srl_out)); 
	 
	 // SRA
    Shift_Right_Arithmetic SRA(
	 .data_in(A), 
	 .shift_amt(B[4:0]),
	 .data_out(sra_out)); 
	 
	 // SLT
    SLT_SLTU SLT_MODULE(
	 .A(A), 
	 .B(B), 
	 .Sel(1'b0),
	 .Result(slt_out));  
	 
	 // SLT
    SLT_SLTU SLTU_MODULE(
	 .A(A),
	 .B(B), 
	 .Sel(1'b1), 
	 .Result(sltu_out));  

    always @(*) begin
        case (ALU_sel)
            4'b0000: ALU_out = add_sub_out;  // ADD
            4'b1000: ALU_out = add_sub_out;  // SUB
            4'b0001: ALU_out = sll_out;      // SLL
            4'b0010: ALU_out = slt_out;  // SLT (1 bit)
            4'b0011: ALU_out = sltu_out; // SLTU (1 bit)
            4'b0100: ALU_out = A ^ B;  // XOR
            4'b0101: ALU_out = srl_out; // SRL
            4'b1101: ALU_out = sra_out; // SRA
            4'b0110: ALU_out = A | B;  // OR
            4'b0111: ALU_out = A & B;  // AND
			4'b1111: ALU_out = B; //Cho lệnh LUI
            default: ALU_out = 32'b0;  
        endcase
    end
endmodule	
	
module MUX4to1 (
    input logic [1:0] sel, // Chọn nguồn writeback
    input logic [31:0] in0, // Writeback từ DMEM qua Load
	 input logic [31:0] in1, // Writeback từ ALU
	 input logic [31:0] in2, // Writeback PC + 4 cho lệnh JALR
	 input logic [31:0]	in3, // Trống
    output logic [31:0] out); // Ngõ ra writeback
	 
    always @(*) begin
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
            default: out = 32'd0; 
        endcase
    end
endmodule
	
module brc (
    input logic BrUn, // 1: so sánh unsigned, 0: so sánh signed
    input logic [31:0] data_1,  // Toán hạng 1
	 input logic [31:0] data_2,  // Toán hạng 2
    output logic BrEq,	// 1: Bằng, 0: Không bằng 
	 output logic BrLt); // 1: (1)<(2) , 0: (1) >= 2;

    logic [31:0] Diff;  // Kết quả phép trừ rs1 - rs2
    logic Cout;         // Carry-out từ Add_Sub_32bit

    // Gọi module Add_Sub_32bit để thực hiện rs1 - rs2
    Add_Sub_32bit subtractor (
        .A(data_1),
        .B(data_2),
        .Sel(1'b1),   // SUB
        .Result(Diff),
        .Cout(Cout)
    );

    // So sánh bằng nhau (BrEq = 1 nếu Diff == 0)
    always @(*) begin
        if (Diff == 32'b0)
            BrEq = 1'b1;
        else
            BrEq = 1'b0;
    end

    // So sánh nhỏ hơn (BrLt)
    always @(*) begin
        if (BrUn)  // Unsigned
            BrLt = ~Cout;
        else       // Signed
            BrLt = Diff[31];
    end

endmodule

	
	
	
	
	
	
	
	
	
	