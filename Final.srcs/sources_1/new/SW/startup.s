/* ================================================
 * startup.s — RV32I Startup Code
 * Sets stack pointer and jumps to main()
 * ================================================ */

.section .text
.global _start

_start:
    /* Set stack pointer to top of memory (1KB) */
    lui  sp, 0x00001       /* sp = 0x1000 (4KB stack) */
    
    /* Clear all registers */
    li   x1,  0
    li   x2,  0
    li   x3,  0
    li   x4,  0
    li   x5,  0
    li   x6,  0
    li   x7,  0
    li   x8,  0
    li   x9,  0
    li   x10, 0
    
    /* Jump to main */
    jal  ra, main
    
    /* Infinite loop if main returns */
_end:
    j _end