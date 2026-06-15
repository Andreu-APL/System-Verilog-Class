module top_module(
    input clk, 
    input rst
);

wire [31:0] pc; 
wire [31:0] pc_next; 
wire [31:0] pc4; 
wire [31:0] pc_target; 

wire [31:0] instruction; 

wire [31:0] rd1;
wire [31:0] rd2;

wire [31:0] imm_ext; 

wire [31:0] src_b; 
wire [31:0] alu_result; 
wire zero; 

wire [31:0] read_data; 
wire [31:0] result; 

wire pc_src;
wire mem_write;
wire alu_src;
wire reg_write;

wire [1:0] result_src;
wire [1:0] imm_src;
wire [1:0] alu_op;
wire [2:0] alu_control;


// PROGRAM COUNTER
program_counter DUT_PC(
    .clk(clk), 
    .rst(rst), 
    .pc_next(pc_next), 
    .pc_out(pc)
);


// INSTRUCTION MEMORY
instruction_memory DUT_IMEM(
    .clk(clk),
    .A(pc),
    .RD(instruction)
);


// PC + 4
adder DUT_PC4( 
    .a(pc), 
    .b(32'd4), 
    .result(pc4)
);


// PC + INMEDIATO
adder DUT_PCTARGET( 
    .a(pc), 
    .b(imm_ext), 
    .result(pc_target)
);


// MUX PARA SIGUIENTE PC
multiplexor DUT_MUX_PC(
    .A(pc4),
    .B(pc_target),
    .C(32'b0),
    .D(32'b0),
    .Sel({1'b0, pc_src}),
    .Y(pc_next)
);


// REGISTER FILE
reg_file DUT_REGFILE( 
    .clk(clk), 
    .WE3(reg_write), 

    .A1(instruction[19:15]),
    .A2(instruction[24:20]),
    .A3(instruction[11:7]),

    .WD3(result),

    .RD1(rd1), 
    .RD2(rd2)
);


// EXTEND / IMM GEN
imm_gen DUT_IMMGEN( 
    .instruction(instruction),
    .imm_src(imm_src),
    .imm_ext(imm_ext)
);


// CONTROL UNIT
control_unit DUT_CONTROL( 
    .op(instruction[6:0]),
    .zero(zero),

    .pc_src(pc_src),
    .mem_write(mem_write), 
    .alu_src(alu_src), 
    .reg_write(reg_write), 
    .result_src(result_src), 
    .imm_src(imm_src), 
    .alu_op(alu_op)
);


// ALU CONTROL
alu_control DUT_ALUCONTROL( 
    .alu_op(alu_op), 
    .funct3(instruction[14:12]), 
    .funct7(instruction[30]), 
    .alu_control(alu_control)
);


// MUX PARA ENTRADA B DE ALU
multiplexor DUT_MUX_ALU_B(
    .A(rd2),
    .B(imm_ext),
    .C(32'b0),
    .D(32'b0),
    .Sel({1'b0, alu_src}),
    .Y(src_b)
);


// ALU
alu DUT_ALU( 
    .a(rd1), 
    .b(src_b), 
    .alu_control(alu_control), 
    .result(alu_result), 
    .zero(zero)
);


// DATA MEMORY
data_memory DUT_DATAMEM(
    .clk(clk),
    .WE(mem_write),
    .A(alu_result),
    .WD(rd2),
    .RD(read_data)
);


// MUX RESULT
multiplexor DUT_MUX_RESULT(
    .A(alu_result),
    .B(read_data),
    .C(pc4),
    .D(32'b0),
    .Sel(result_src),
    .Y(result)
);

endmodule