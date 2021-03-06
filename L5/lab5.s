    .syntax     unified
    .cpu        cortex-m4
    .text

/* void Log2Phys(uint32_t lba, uint32_t heads, uint32_t sectors, CHS *phy); */
    .global     Log2Phys
    .thumb_func
    .align
//R0 = lba, R1 = heads, R2 = sectors, R3 = phy
Log2Phys:
    PUSH        {R4}
//๐๐ฆ๐๐๐๐๐๐ = ๐๐๐ รท (โ๐๐๐๐  ร ๐ ๐๐๐ก๐๐๐ )
    MUL         R12, R1, R2         //R12 <- heads x sectors
    UDIV        R12, R0, R12        // R12 <- lba / (heads x sectors)
    STRH        R12, [R3]           // R12 -> cylinder
//โ๐๐๐ = (๐๐๐ รท ๐ ๐๐๐ก๐๐๐ ) % โ๐๐ds
    UDIV        R12, R0, R2         // R12 <- lba / sectors
    MOV         R4, R12             // (dividend) R4 is copy of lba/sectors
    UDIV        R12, R12, R1        // (quotient) R12 <- (lba/sectors) / heads(divisor)
    MLS         R12, R1, R12, R4    // R12 <- dividend - divisor x quotient
    STRB        R12, [R3, 2]        // R12 -> head
//๐ ๐๐๐ก๐๐ = (dividend ๐๐๐ % divisor ๐ ๐๐๐ก๐๐๐ )+ 1
    UDIV        R12, R0, R2         // (quotient) R12 <- lba / sectors
    MLS         R12, R2, R12, R0    // R12 <- lba - sectors x (lba/sectors)
    ADDS        R12, R12, 1         // R12 <- R12 + 1
    STRB        R12, [R3, 3]        // R12 -> sector
    POP         {R4}
    BX          LR

    /* End of file */
.end
