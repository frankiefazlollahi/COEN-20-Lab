    .syntax     unified
    .cpu        cortex-m4
    .text


/* uint32_t GetNibble(void *nibbles, uint32_t which) ; */
    .global     GetNibble
    .thumb_func
    .align
// R0 = nibbles, R1 = which
GetNibble:
    LSRS        R1,R1,1         //R1(which) <- which/2, track remainder in carry flag
    LDRB        R3,[R0,R1]      //R3 <- byte with desired nibble
    ITE         CS
    LSRCS       R3, 4           //if carry == 1 want most significant nibble, shift right 4, moving nibble value to least significant nibble
    ANDCC       R3,R3,0x0F      //if carry == 0 want least significant nibble, R3 <- 0x0F(0b00001111) clear most significant nibble if flag == 0
    MOV         R0,R3           //R0 <- R3
    BX          LR

/* void PutNibble(void *nibbles, uint32_t which, uint32_t value) ; */
    .global     PutNibble
    .thumb_func
    .align
// R0 = nibbles, R1 = which, R2 = value
PutNibble:
    LSRS        R1,R1,1         //R1(which) <- which/2, track remainder in carry flag
    LDRB        R3,[R0,R1]      //R3(pbyte) <- sbyte with desired nibble
    ITTE        CS
    ANDCS       R3,R3,0x0F      //if carry == 1, Clear most significant nibble using (R3 & 0x0F(0b00001111))
    LSLCS       R2,R2,4         //shift left 4, moving nibble value to most significant nibble
    ANDCC       R3,R3,0xF0      //if flag == 0, Clear least significant nibble using (R3 & 0xF0(0b11110000))
    ORR         R2, R2, R3      // R2 <- pbyte | value
    STRB        R2,[R0,R1]      // R2 -> byte with desired nibble
    BX          LR

/* End of file */
    .end
