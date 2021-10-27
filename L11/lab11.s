    .syntax     unified
    .cpu        cortex-m4
    .text

/* Q16 Q16GoodRoot(Q16 radicand) */
    .global     Q16GoodRoot
    .thumb_func
    .align
//R0 = radicand, R1 = bit, R2 = residue, R3 = sqroot, R4 = temp
Q16GoodRoot:
    PUSH    {R4, R5}
    LDR     R1,=(1<<30)         //R1 <- 1<<30
    CLZ     R4, R0              //R4 <- __CLZ(radicand)
    MVN     R5, 1               //R5 <- ~1
    AND     R4, R4, R5          //R4 <- __CLZ(radicand) & ~1
    LSR     R1, R4              //R1 <- (1 << 30) >> (__CLZ(radicand) & ~1)
    MOV     R2, R0              //R2 <- R0
    LDR     R3,= 0              //R3 <- 0
While:
    CMP     R1, 0
    BEQ     Done                //if bit == 0, exit loop
    ADD     R4, R3, R1          //R4 <- sqroot + bit
    MOV     R5, R1              //R5 <- R1
    LSL     R5, 1               //(used in IT block) R5 <<= 1
    CMP     R2, R4
    ITT     HS                  //if residue >= temp
    SUBHS   R2, R2, R4          //R2 <- R2 - R4
    ADDHS   R3, R3, R5          //R3 <- R3 + (bit << 1)
    LSR     R3, R3, 1           //R3 >>= 1
    LSR     R1, R1, 2           //R1 >>= 2
    B       While               //repeat loop
Done:
    LSL     R3, 8               //R3 <<= 8
    MOV     R0, R3              //return sqroot
    POP     {R4, R5}
    BX      LR

/* End of file */
    .end
