    .syntax     unified
    .cpu        cortex-m4
    .text

/* void Integrate(void) */
    .global     Integrate
    .thumb_func
    .align
//S4 = prev, S16 = dx, S17 = r, S18 = v, S19 = a, S20 = x, R4 = n
Integrate:
    PUSH        {R4, LR}
    VPUSH       {S16, S17, S18, S19, S20, S21}
    BL          DeltaX          //S0 <- DeltaX()
    VMOV        S16, S0         //S16 <- S0
    VMOV        S0, 1.0         //S0(r) <- 1.0
    VMOV        S17, S0         //S17 <- S0
    VSUB.F32    S1, S1, S1      //S1(v) <- 0.0
    VMOV        S18, S1         //S18 <- S1
    VSUB.F32    S2, S2, S2      //S1(a) <- 0.0
    VMOV        S19, S2         //S19 <- S2
    VMOV        S3, 1.0         //S3(x) <- 1.0
    VMOV        S20, S3         //S20 <- S3
    LDR         R0,= 0          //R0(n) <- 0
    MOV         R4, R0          //R4 <- R0
While:
    MOV         R0, R4
    VMOV        S0, S17
    VMOV        S1, S18
    VMOV        S2, S19
    BL          UpdateDisplay   //UpdateDisplay(n, r, v, a)
    VMOV        S4, S18         //S4(prev) <- v
    VMOV        S5, 1.0         //S5 <- 1.0
    VDIV.F32    S6, S5, S20     //S6 <- 1/x
    VADD.F32    S7, S20, S16    //S7 <- x + dx
    VDIV.F32    S8, S5, S7      //S8 <- 1/(x+dx)
    VADD.F32    S9, S6, S8      //S9 <- 1/x + 1/(x+dx)
    VMOV        S10, 2.0        //S10 <- 2.0
    VDIV.F32    S17, S9, S10    //S17(r) <- (1/x + 1/(x + dx))/2
    VMLA.F32    S18, S17, S17   //S18(v) <- v + r*r
    VADD.F32    S19, S19, S17   //S19(a) <- a + r
    ADD         R4, R4, 1       //R4(n) <- n + 1
    VADD.F32    S20, S20, S16   //S20(x) <- x + dx
    VCMP.F32    S18, S4         //Compare S18(v) & S4(prev)
    VMRS        APSR_nzcv, FPSCR
    BEQ         Done            //if v == prev, exit loop
    B           While           //else continue looping

Done:
    VPOP        {S16, S17, S18, S19, S20, S21}
    POP         {R4, LR}
    BX          LR

/* End of file */
    .end
