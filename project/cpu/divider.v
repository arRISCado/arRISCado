module divider(
    input           clk,
    input           reset,
    input           start,
    input [31:0]    dividend,
    input [31:0]    divisor,
    output [31:0]   result,
    output [31:0]   reminder,
    output          done, // 1 quando a divisão estiver completa será usado como stall
);

    reg active;    // Verdadeiro se o divisor estiver em execução
    reg [4:0] cycle;    // Número de ciclos restantes
    reg [31:0] _result;    // Dividendo com resultado, termina com o resultado
    reg [31:0] _divider;    // Divisor
    reg [31:0] work;     // Resto em execução

    // Calcula o dígito atual
    wire [32:0] sub = {work[30:0], _result[31]} - _divider;

    // Envia os resultados para nosso mestre
    assign result = _result;
    assign reminder = work;
    assign done = ~active;

    always @(posedge clk or posedge reset) begin
        if (reset || ~start) begin // Se não recebermos o sinal de start, mantemos tudo zerado
            active <= 0;
            cycle <= 0;
            _result <= 0;
            _divider <= 0;
            work <= 0;
        end
        else if (start) begin
            if (~active) begin // Se ainda não está ativo, inicializa a divisão
                cycle <= 5'd31;
                _result <= dividend;
                _divider <= divisor;
                work <= 32'b0;
                active <= 1; // Como active é 1, done passa a ser 0, ativando o stall
            end
            else begin // Executa todas as interações de divisão
                if (sub[32] == 0) begin
                    work <= sub[31:0];
                    _result <= {_result[30:0], 1'b1};
                end
                else begin
                    work <= {work[30:0], _result[31]};
                    _result <= {_result[30:0], 1'b0};
                end
                if (cycle == 0) begin
                    active <= 0; // Ao final de execução de todos os ciclos, active = 0, logo done = 1 e o stall é desativado
                end
                cycle <= cycle - 5'd1;
            end
        end
    end
endmodule
