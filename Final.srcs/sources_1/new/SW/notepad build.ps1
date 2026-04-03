# ================================================
# RV32I Build Script for Windows PowerShell
# ================================================

$TOOLCHAIN = "riscv-none-elf"
$ARCH      = "rv32i"
$ABI       = "ilp32"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " RV32I Pipeline Build Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Step 1 - Compile startup
Write-Host "`n[1/5] Compiling startup.s..." -ForegroundColor Yellow
& "$TOOLCHAIN-gcc" -march=$ARCH -mabi=$ABI -nostdlib -c startup.s -o startup.o
if ($LASTEXITCODE -ne 0) { Write-Host "FAILED!" -ForegroundColor Red; exit 1 }
Write-Host "OK" -ForegroundColor Green

# Step 2 - Compile C
Write-Host "`n[2/5] Compiling program.c..." -ForegroundColor Yellow
& "$TOOLCHAIN-gcc" -march=$ARCH -mabi=$ABI -nostdlib -nostartfiles -O0 -c program.c -o program.o
if ($LASTEXITCODE -ne 0) { Write-Host "FAILED!" -ForegroundColor Red; exit 1 }
Write-Host "OK" -ForegroundColor Green

# Step 3 - Link
Write-Host "`n[3/5] Linking to ELF..." -ForegroundColor Yellow
& "$TOOLCHAIN-gcc" -march=$ARCH -mabi=$ABI -nostdlib -nostartfiles -T link.ld startup.o program.o -o program.elf
if ($LASTEXITCODE -ne 0) { Write-Host "FAILED!" -ForegroundColor Red; exit 1 }
Write-Host "OK" -ForegroundColor Green

# Step 4 - Binary
Write-Host "`n[4/5] Converting to binary..." -ForegroundColor Yellow
& "$TOOLCHAIN-objcopy" -O binary program.elf program.bin
if ($LASTEXITCODE -ne 0) { Write-Host "FAILED!" -ForegroundColor Red; exit 1 }
Write-Host "OK" -ForegroundColor Green

# Step 5 - HEX
Write-Host "`n[5/5] Generating program.hex..." -ForegroundColor Yellow
python bin_to_hex.py
if ($LASTEXITCODE -ne 0) { Write-Host "FAILED!" -ForegroundColor Red; exit 1 }

# Show disassembly
Write-Host "`n========= Disassembly =========" -ForegroundColor Cyan
& "$TOOLCHAIN-objdump" -d program.elf | Select-Object -First 40

# Copy to Vivado sim folder
$DEST = "D:\Xilink\SoC\GEMINI\project_1\project_1.sim\sim_1\behav\xsim\"
if (Test-Path $DEST) {
    Copy-Item program.hex $DEST
    Write-Host "`nCopied program.hex to Vivado sim folder!" -ForegroundColor Green
} else {
    Write-Host "`nVivado sim folder not found - copy manually" -ForegroundColor Yellow
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " BUILD COMPLETE - program.hex is ready!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
