module tb_Imm_Gen;
    // Khai báo tín hiệu test
    logic [2:0] Imm_Sel;
    logic [31:0] inst;
    logic [31:0] Imm_out;

    // Khởi tạo module Imm_Gen
    Imm_Gen uut (
        .Imm_Sel(Imm_Sel),
        .inst(inst),
        .Imm_out(Imm_out)
    );

    // Testbench chính
    initial begin
      $dumpfile("tb_Imm_Gen.vcd");
      $dumpvars(0,tb_Imm_Gen);
        $display("Starting Imm_Gen Testbench...");
        $monitor("Time=%0t | Imm_Sel=%b | inst=%h | Imm_out=%h", $time, Imm_Sel, inst, Imm_out);

        // Kiểm thử I-type (Load/ALU Immediate) (ADDI)
        Imm_Sel = 3'b000; inst = 32'hFFF08093; #10; // ADDI x1, x1, -1
        Imm_Sel = 3'b000; inst = 32'h3e810093; #10; // ADDI x1, x2, 1000

        // Kiểm thử S-type (Store) (SW)
        Imm_Sel = 3'b001; inst = 32'hFE010E23; #10; // SW x1, -4(x2)
        Imm_Sel = 3'b001; inst = 32'h00B12223; #10; // SW x11, 4(x2)

        // Kiểm thử B-type (Branch) (BEQ, BNE)
        Imm_Sel = 3'b010; inst = 32'hFE108CE3; #10; // BEQ x1, x2, -8
        Imm_Sel = 3'b010; inst = 32'h04c51063; #10; // BNE x10, x12, 64

        // Kiểm thử J-type (JAL)
        Imm_Sel = 3'b011; inst = 32'h00c000ef; #10; // JAL x1, 12
        Imm_Sel = 3'b011; inst = 32'hfe5ff0ef; #10; // JAL x1, -28

        // Kiểm thử U-type (LUI)
        Imm_Sel = 3'b100; inst = 32'h00064437; #10; // LUI x0, 0x100
        Imm_Sel = 3'b100; inst = 32'h01388637; #10; // LUI x0, 0x5000

        // Kiểm thử U-type (AUIPC)
        Imm_Sel = 3'b101; inst = 32'habcd1017; #10; // AUIPC x2, 0xABCD1
        Imm_Sel = 3'b101; inst = 32'h02000017; #10; // AUIPC x0, 0x2000

        // Kết thúc simulation
        $display("Testbench completed!");
        $finish;
    end
endmodule
