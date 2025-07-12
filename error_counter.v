// Módulo de Contador de Erros
module error_counter (
    input senha_ok, B, clk,
    input [1:0] state,
    output reg [1:0] error_count
);
    // Definir estado AB
    localparam AB = 2'b00; // Aberto
	 localparam FE = 2'b01; // Fechado normal

    always @(posedge clk) begin
        if (state == AB) // Zera contador em AB ou reset
            error_count <= 2'b00;
        else if (B && !senha_ok && error_count != 2'b11 && state == FE)
            error_count <= error_count + 1; // Incrementa em erro
    end
endmodule