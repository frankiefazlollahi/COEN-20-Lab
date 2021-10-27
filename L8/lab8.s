    .syntax     unified
    .cpu        cortex-m4
    .text

/* uint32_t Zeller1(uint32_t k, uint32_t m, uint32_t D, uint32_t C) ; */
    .global     Zeller1
    .thumb_func
    .align
//R0 = k, R1 = m, R2 = D, R3 = C
Zeller1:
    PUSH        {R4, R5}
    LDR         R4,= 13             //R4 <- 13
    MUL         R4, R4, R1          //R4 <- 13*m
    SUB         R4, R4, 1           //R4 <- 13*m -1
    LDR         R5,= 5              //R5 <- 5
    UDIV        R4, R4, R5          //R4 <- (-1 + 13*m)/5
    ADD         R0, R0, R4          //R0 <- K + R4
    ADD         R0, R0, R2          //R0 <- R0 + D
    LDR         R4,= 4              //R4 <- 4
    UDIV        R2, R2, R4          //R2 <- D/4
    ADD         R0, R0, R2          //R0 <- R0 + D/4
    UDIV        R5, R3, R4          //R5 <- C/4
    ADD         R0, R0, R5          //R0 <- R0 + C/4
    LSL         R5, R3, 1           //R5 <- 2C
    SUB         R0, R0, R5          //R0 <- R0 - 2C
    LDR         R4,= 7              //R4 <- 7
    SDIV        R5, R0, R4          //R5 <- (K + (13m-1)/5 + (5D - 7C)/4) / 7
    MLS         R0, R4, R5, R0      //R0 <- (K + (13m-1)/5 + (5D - 7C)/4) % 7
    CMP         R0, 0
    IT          LT
    ADDLT       R0, R0, 7           //if remainder < 0, add 7
    POP         {R4, R5}
    BX          LR

// No Divide Instructions
/* uint32_t Zeller2(uint32_t k, uint32_t m, uint32_t D, uint32_t C) ; */
    .global     Zeller2
    .thumb_func
    .align
//R0 = k, R1 = m, R2 = D, R3 = C
Zeller2:
    PUSH        {R4, R5, R6}
    LDR         R4,= 13             //R4 <- 13
    MUL         R4, R4, R1          //R4 <- 13*m
    SUB         R4, R4, 1           //R4 <- 13*m -1
    LDR         R5,= 3435973837
    UMULL       R6, R5, R5, R4
    LSR         R4, R5, 2           //R4 <- (-1 + 13*m)/5
    ADD         R0, R0, R4          //R0 <- K + R4
    ADD         R0, R0, R2          //R0 <- R0 + D
    LSR         R2, R2, 2           //R2 <- D/4
    ADD         R0, R0, R2          //R0 <- R0 + D/4
    LSR         R5, R3, 2           //R5 <- C/4
    ADD         R0, R0, R5          //R0 <- R0 + C/4
    LSL         R3, R3, 1           //R3 <- 2C
    SUB         R0, R0, R3          //R0 <- R0 - 2C
    MOV         R6, R0              //R6 <- R0
    LDR         R4,= 2454267027
    SMMLA       R4, R4, R0, R0
    LSR         R0, R0, 31
    ADD         R0, R0, R4, ASR 2   //R0 <- (K + (13m-1)/5 + D + D/4 + C/4 - 2C)/7
    LDR         R4,= 7              //R4 <- 7
    MLS         R0, R0, R4, R6      //R0 <- (K + (13m-1)/5 + (5D - 7C)/4) % 7
    CMP         R0, 0
    IT          LT
    ADDLT       R0, R0, 7           //if remainder < 0, add 7
    POP         {R4, R5, R6}
    BX          LR

// No Multiply Instructions
/* uint32_t Zeller3(uint32_t k, uint32_t m, uint32_t D, uint32_t C) ; */
    .global     Zeller3
    .thumb_func
    .align
//R0 = k, R1 = m, R2 = D, R3 = C
Zeller3:
    PUSH        {R4, R5}
    LSL         R4, R1, 4           //R4 <- 16*m
    SUB         R4, R4, R1, LSL 2   //R4 <- 16*m -4m
    ADD         R4, R4, R1          //R4 <- 16m-4m+m
    SUB         R4, R4, 1           //R4 <- 13m - 1
    LDR         R5,= 5              //R5 <- 5
    UDIV        R4, R4, R5          //R4 <- (-1 + 13*m)/5
    ADD         R0, R0, R4          //R0 <- K + R4
    ADD         R0, R0, R2          //R0 <- R0 + D
    LDR         R4,= 4              //R4 <- 4
    UDIV        R2, R2, R4          //R2 <- D/4
    ADD         R0, R0, R2          //R0 <- R0 + D/4
    UDIV        R5, R3, R4          //R5 <- C/4
    ADD         R0, R0, R5          //R0 <- R0 + C/4
    LSL         R5, R3, 1           //R5 <- 2C
    SUB         R0, R0, R5          //R0 <- R0 - 2C
    LDR         R4,= 7              //R4 <- 7
    SDIV        R5, R0, R4          //quotient R5 <- (K + (13m-1)/5 + (5D - 7C)/4) / 7
    RSB         R4, R5, R5, LSL 3   //quotient * divisor R4 <- 8*R5 - R5
    SUB         R0, R0, R4          //dividend - quotient * divisor R0 <- R0 - R4
    CMP         R0, 0
    IT          LT
    ADDLT       R0, R0, 7           //if remainder < 0, add 7
    POP         {R4, R5}
    BX          LR

/* End of file */
.end
