@echo off
echo Compiling startup.s...
riscv-none-elf-gcc -march=rv32i -mabi=ilp32 -c startup.s -o startup.o

echo Compiling program.c...
riscv-none-elf-gcc -march=rv32i -mabi=ilp32 -c program.c -o program.o

echo Linking...
riscv-none-elf-gcc -march=rv32i -mabi=ilp32 -nostartfiles -T link.ld startup.o program.o -o program.elf

echo Generating binary...
riscv-none-elf-objcopy -O binary program.elf program.bin

echo Generating hex...
"C:\Users\HAI\AppData\Local\Programs\Python\Python313\python.exe" bin_to_hex.py

echo Done! program.hex generated.
pause