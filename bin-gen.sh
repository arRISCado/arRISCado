#!/bin/bash

# Diretório de origem do repositório
source_dir=$(pwd)

# Diretório de origem para os assemblies
asm_dir="$source_dir/tests"

# Diretório de destino para os binários
binary_dir="$asm_dir/bin"

# Certifique-se de que o diretório de destino existe
mkdir -p "$binary_dir"

# Loop para compilar os assemblies
for asm_file in "$asm_dir"/*.s; do
    if [ -f "$asm_file" ]; then
        asm_filename=$(basename "$asm_file")
        binary_filename="${asm_filename%.s}"
        
        # Converte o código de montagem em binário
        riscv64-unknown-elf-as "$asm_dir/$asm_filename" -o "$binary_dir/$binary_filename"

        if [ -f $binary_dir/$binary_filename ]; then
            echo "Assembly $asm_filename compilado para $binary_filename"
        else
            echo "Não foi possível compilar Assembly $asm_filename"
        fi
    fi
done

echo "Compilação concluída!"
