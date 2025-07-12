
// Módulo de Display (7 Segmentos)
module display_decoder (
    input [1:0] state,
    input [1:0] error_count,
    input AL, AF, EM,
    output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
    // Definir estados usando localparam
    localparam AB = 2'b00; // Aberto
    localparam FE = 2'b01; // Fechado Normal
    localparam PF = 2'b10; // Fechado Remotamente

    // Decodificação para 7 segmentos
    always @(*) begin
        // HEX0-HEX1: AB, PF, FE
        case (state)
            AB: begin HEX1 = 7'b0001000; HEX0 = 7'b0000011; end // AB (A, b)
            FE: begin HEX1 = 7'b0001110; HEX0 = 7'b0000110; end // FE (F, E)
            PF: begin HEX1 = 7'b0001100; HEX0 = 7'b0001110; end // PF (P, F)
            default: begin HEX0 = 7'b1111111; HEX1 = 7'b1111111; end // Desligado
        endcase

        // HEX2-HEX3: AF, AL, EM
        if (AF) begin HEX3 = 7'b0001000; HEX2 = 7'b0001110; end // AF (A, F)
        else if (AL) begin HEX3 = 7'b0001000; HEX2 = 7'b1000111; end // AL (A, L)
        else if (EM) begin HEX3 = 7'b0000110; HEX2 = 7'b1001000; end // EM (E, M)
        else begin HEX2 = 7'b1111111; HEX3 = 7'b1111111; end // Desligado

        // HEX4-HEX5: E1, E2, BL
        case (error_count)
            2'b01: begin HEX5 = 7'b0000110; HEX4 = 7'b1111001; end // E1 (E, 1)
            2'b10: begin HEX5 = 7'b0000110; HEX4 = 7'b0100100; end // E2 (E, 2)
            2'b11: begin HEX5 = 7'b0000011; HEX4 = 7'b1000111; end // BL (B, L)
            default: begin HEX5 = 7'b1111111; HEX4 = 7'b1111111; end // Desligado
        endcase
    end
endmodule