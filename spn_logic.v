// Módulo de Lógica de SPN
module spn_logic (
    input B, SPA,
    output SPN
);
    assign SPN = (B && SPA); // SPA = 1 (porta fechada), B = 1 (pressionado)
endmodule