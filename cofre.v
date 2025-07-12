// Módulo Principal: Cofre
module cofre (
    input clk, reset, A, B, H, SAF, SPA, // Entradas
    input [3:0] SENHA,                  // Senha de 4 bits
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, // Displays de 7 segmentos
    output reg CLOSE                    // LED para pino de travamento
);
    // Definir estados da MEF usando localparam
    localparam AB = 2'b00; // Aberto
    localparam FE = 2'b01; // Fechado Normal
    localparam PF = 2'b10; // Fechado Remotamente

    reg [1:0] state, next_state;
    wire senha_ok;          // Sinal da senha (1 = correta, 0 = errada)
    wire SPN;               // Sinal do sensor de pino
    wire [1:0] error_count; // Contador de erros (00, 01, 10, 11)
    wire AL, AF, EM;        // Sinais de transição
    reg sinAL, sinAF, sinEM; // Sinais de contagem (agora reg, pois são incrementados)

    // Instanciar submódulos
    wire slow_clk;
    divisor_clk_17x divclk (.clk_in(clk), .clk_OUT(slow_clk));
    wire dB;
    debounce db1 (.pb_1(B), .slow_clk(slow_clk), .pb_out(dB));
    wire drst;
    debounce db0 (.pb_1(reset), .slow_clk(slow_clk), .pb_out(drst));
    
    senha_validator senha_mod (
        .SENHA(SENHA),
        .B(dB),
        .error_count(error_count),
        .reset(drst),
        .SPA(SPA),
        .clk(slow_clk),
        .state(state),
        .senha_ok(senha_ok)
    );

    spn_logic spn_mod (
        .B(dB),
        .SPA(SPA),
        .SPN(SPN)
    );

    error_counter err_mod (
        .senha_ok(senha_ok),
        .B(dB),
        .state(state),
        .clk(slow_clk),
        .error_count(error_count)
    );

    display_decoder disp_mod (
        .state(state),
        .error_count(error_count),
        .AL(sinAL),
        .AF(sinAF),
        .EM(sinEM),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

    // Lógica de transição para AL, AF, EM
    assign AL = (state == FE && senha_ok && SPN); // Transição de FE para AB
    assign AF = (state == PF && SAF);             // Condição para AF
    assign EM = (H); // Chave mestra

    // Bloco para atualização de sinAL, sinAF, sinEM
    always @(posedge slow_clk or posedge drst) begin
        if (drst) begin
            sinAL <= 0;
            sinAF <= 0;
            sinEM <= 0;
        end else begin
            // Lógica para sinAL
            if (AL) begin
                sinAL <= 1;
            end else if (EM || AF) begin
                sinAL <= 0;
            end

            // Lógica para sinAF
            if (AF) begin
                sinAF <= 1;
            end else if (EM || AL) begin
                sinAF <= 0;
            end

            // Lógica para sinEM
            if (EM) begin
                sinEM <= 1;
            end else if (AF || AL) begin
                sinEM <= 0;
            end
        end
    end

    // Bloco 1: Registro de estado
    always @(posedge slow_clk or posedge H) begin
        if (H)
            state <= AB; // Estado inicial ou emergência
        else
            state <= next_state;
    end

    // Bloco 2: Lógica de próximo estado
    always @(*) begin
        case (state)
            AB: begin
                if (A == 0 && SPN)
                    next_state = FE; // Fechado Normal
                else if (A == 1 && SPN)
                    next_state = PF; // Fechado Remotamente
                else
                    next_state = AB; // Mantém Aberto
            end
            FE: begin
                if (senha_ok && SPN)
                    next_state = AB; // Abre
                else
                    next_state = FE; // Mantém Fechado Normal
            end
            PF: begin
                if (SAF)
                    next_state = AB; // Abre remotamente
                else
                    next_state = PF; // Mantém Fechado Remotamente
            end
            default: next_state = AB;
        endcase
    end

    // Bloco 3: Lógica de saída
    always @(*) begin
        CLOSE = (state == FE || state == PF); // Ativa pino em FE ou PF
    end

endmodule