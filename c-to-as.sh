#!/bin/bash

# Diretório de origem do repositório
source_dir=$(pwd)

# Diretório de origem para os códigos
codes_dir="$source_dir/codes"

# Diretório de origem para os assemblies
asm_dir="$codes_dir/assembly"

# Diretório de destino para os binários
binary_dir="$codes_dir/bin"

# Diretório de destino para os binários
hex_dir="$codes_dir/hex"

# Certifique-se de que o diretório de destino existe
mkdir -p "$binary_dir"

# Loop para compilar os assemblies
for asm_file in "$codes_dir"/*.c; do
    if [ -f "$asm_file" ]; then
        asm_filename=$(basename "$asm_file")
        binary_filename="${asm_filename%.s}"

        # Compila o código
        riscv64-unknown-elf-gcc -S -march=rv32imac -mabi=ilp32 "$codes_dir/$asm_filename" -o "$asm_dir/$binary_filename.s"
        
        # Converte o código de montagem em binário
        # riscv64-unknown-elf-as -o $binary_filename.o "$asm_dir/$binary_filename.s"
        # riscv64-unknown-elf-ld -T linker.ld -o $binary_filename.elf $binary_filename.o
        # riscv64-unknown-elf-objcopy -O binary $binary_filename.elf "$binary_dir/$binary_filename"
        # xxd -p "$binary_dir/$binary_filename" > "$hex_dir/$binary_filename.hex"

        # Removendo arquivos temporários
        # rm $binary_filename.o $binary_filename.elf 

        if [ -f $binary_dir/$binary_filename ]; then
            echo "Assembly $asm_filename compilado para $binary_filename"
        else
            echo "Não foi possível compilar Assembly $asm_filename"
        fi
    fi
done

echo "Compilação concluída!"