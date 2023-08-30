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
        binary_filename="${asm_filename%.asm}"
        
        # Compilação usando NASM e GCC
        nasm -f elf "$asm_file" -o "$binary_dir/$binary_filename.o"
        gcc "$binary_dir/$binary_filename.o" -o "$binary_dir/$binary_filename"
        
        echo "Assembly $asm_filename compilado para $binary_filename"
    fi
done

echo "Compilação concluída!"
