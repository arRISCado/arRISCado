import sys

if len(sys.argv) != 2:
    print("Uso: python3 fix-asm.py <arquivo>")
    sys.exit(1)

# Nome do arquivo a ser processado
nome_arquivo = "codes/assembly/" + sys.argv[1]

# String a ser procurada e removida
string_a_remover = ".attribute"

# Abra o arquivo em modo de leitura
try:
    with open(nome_arquivo, 'r') as arquivo:
        linhas = arquivo.readlines()

    # Abra o arquivo em modo de escrita, substituindo o original
    with open(nome_arquivo, 'w') as arquivo:
        for linha in linhas:
            if string_a_remover not in linha:
                arquivo.write(linha)

    print(f"Tag '{string_a_remover}'" + 
        " removido com sucesso de " + sys.argv[1] + ".")
except FileNotFoundError:
    print(f"O arquivo '{nome_arquivo}' não foi encontrado.")
except Exception as e:
    print(f"Ocorreu um erro: {str(e)}")
