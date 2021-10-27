    .syntax     unified
    .cpu        cortex-m4
    .text

/* int32_t Add(int32_t a, int32_t b) */
    .global     Add
    .thumb_func
    .align
Add:
    ADD         R0, R0, R1      // a + b
    BX          LR

/* int32_t Less1(int32_t a) */
    .global     Less1
    .thumb_func
    .align
Less1:
    SUB         R0, R0, 1       // a - 1
    BX          LR

/* int32_t Square2x(int32_t x) */
    .global     Square2x
    .thumb_func
    .align
Square2x:
    ADD         R0, R0, R0      // R0 <- x + x
    B           Square          // Square(x + x)

/* int32_t Last(int32_t x) */
    .global     Last
    .thumb_func
    .align
Last:
    PUSH        {R4, LR}
    MOV         R4, R0          // R4 is copy of x
    BL          SquareRoot      // R0 <- SquareRoot(x)
    ADD         R0, R0, R4      // R0 <- SquareRoot(x) + x
    POP         {R4, LR}
    BX          LR

    /* End of file */
    .end
