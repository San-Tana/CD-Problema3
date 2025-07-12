
// Módulo de Validação de Senha
module senha_validator (
    input [3:0] SENHA,
    input B, clk, reset, SPA,
    input [1:0] error_count, state,
    output reg senha_ok
);
    reg [3:0] senha_armazenada;

	 // Definir estado AB
    localparam AB = 2'b00; // Aberto
	 
    // Armazenar senha
    always @(posedge clk) begin
        if (reset && state == 2'b00)
            senha_armazenada <= 4'b0000; // Zera senha
        else if (B && error_count != 2'b11 && state == AB && !SPA)
            senha_armazenada <= SENHA; // Armazena nova senha
    end

    // Comparar senha
    always @(*) begin
        if (error_count == 2'b11)
            senha_ok = 0; // Bloqueado
        else
            senha_ok = (SENHA == senha_armazenada && B) ? 1 : 0;
    end
endmodule
