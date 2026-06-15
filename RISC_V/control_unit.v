module control_unit(
    input [6:0] op,
    input zero,

    output reg pc_src, 
    output reg mem_write, 
    output reg alu_src, 
    output reg reg_write, 
    output reg [1:0] result_src,
    output reg [1:0] imm_src,
    output reg [1:0] alu_op
);

always @(*) begin

    pc_src     = 0;
    mem_write  = 0;
    alu_src    = 0;
    reg_write  = 0;
    result_src = 2'b00;
    imm_src    = 2'b00;
    alu_op     = 2'b00;

    case (op)

        7'b0000011: begin
            // lw
            reg_write  = 1;
            alu_src    = 1;
            result_src = 2'b01;
            imm_src    = 2'b00;
            alu_op     = 2'b00;
        end

        7'b0100011: begin
            // sw
            mem_write  = 1;
            alu_src    = 1;
            imm_src    = 2'b01;
            alu_op     = 2'b00;
        end

        7'b0110011: begin
            // R-type
            reg_write  = 1;
            alu_src    = 0;
            result_src = 2'b00;
            alu_op     = 2'b10;
        end

        7'b0010011: begin
            // I-type addi
            reg_write  = 1;
            alu_src    = 1;
            result_src = 2'b00;
            imm_src    = 2'b00;
            alu_op     = 2'b10;
        end

        7'b1100011: begin
            // beq
            pc_src     = zero;
            alu_src    = 0;
            imm_src    = 2'b10;
            alu_op     = 2'b01;
        end

        7'b1101111: begin
            // jal
            pc_src     = 1;
            reg_write  = 1;
            result_src = 2'b10;
            imm_src    = 2'b11;
            alu_op     = 2'b00;
        end

        default: begin
            pc_src     = 0;
            mem_write  = 0;
            alu_src    = 0;
            reg_write  = 0;
            result_src = 2'b00;
            imm_src    = 2'b00;
            alu_op     = 2'b00;
        end

    endcase
end

endmodule