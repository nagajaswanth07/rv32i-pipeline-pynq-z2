/* ================================================
 * RV32I Pipeline Test Program
 * Target : PYNQ-Z2 (XC7Z020CLG400-1)
 * Toolchain: RISC-V GCC (riscv32-unknown-elf)
 * Output : program.hex (loaded via $readmemh)
 * ================================================ */

/* Memory-mapped base address */
#define MEM_BASE 0x00000000

/* Simple delay function */
void delay(int count) {
    volatile int i;
    for (i = 0; i < count; i++);
}

/* Write a value to memory address */
void mem_write(int addr, int val) {
    volatile int *ptr = (volatile int *)addr;
    *ptr = val;
}

/* Read a value from memory address */
int mem_read(int addr) {
    volatile int *ptr = (volatile int *)addr;
    return *ptr;
}

/* Main program */
int main() {

    /* ---- Basic Arithmetic ---- */
    int a = 5;           /* ADDI x1, x0, 5   → x1 = 5  */
    int b = 3;           /* ADDI x2, x0, 3   → x2 = 3  */
    int sum = a + b;     /* ADD  x3, x1, x2  → x3 = 8  */
    int diff = a - b;    /* SUB  x4, x1, x2  → x4 = 2  */
    int prod = a * b;    /* MUL  (via shifts) → x5 = 15 */

    /* ---- Logical Operations ---- */
    int and_val = a & b; /* ANDI x6, x1, 3   → x6 = 1  */
    int or_val  = a | b; /* ORI  x7, x1, 3   → x7 = 7  */
    int xor_val = a ^ b; /* XORI x8, x1, 3   → x8 = 6  */

    /* ---- Shift Operations ---- */
    int sll_val = a << 1; /* SLLI x9, x1, 1  → x9 = 10 */
    int srl_val = a >> 1; /* SRLI x10,x1, 1  → x10 = 2 */

    /* ---- Memory Operations ---- */
    mem_write(0x00, sum);          /* SW x3, 0(x0)  → Mem[0] = 8  */
    mem_write(0x04, diff);         /* SW x4, 4(x0)  → Mem[4] = 2  */
    mem_write(0x08, and_val);      /* SW x6, 8(x0)  → Mem[8] = 1  */

    int load1 = mem_read(0x00);    /* LW x11, 0(x0) → x11 = 8     */
    int load2 = mem_read(0x04);    /* LW x12, 4(x0) → x12 = 2     */

    /* ---- Comparison ---- */
    int cmp = (sum > diff) ? 1 : 0; /* SLT → 1 if sum > diff */

    /* ---- LED Output ---- */
    /* lower 4 bits of sum = 8 = 1000 → LD3 ON */
    int led_val = sum & 0xF;

    /* Infinite loop — keeps LED stable on hardware */
    while (1) {
        delay(1000);
    }

    return 0;
}