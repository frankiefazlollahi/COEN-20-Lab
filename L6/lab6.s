    .syntax     unified
    .cpu        cortex-m4
    .text

/* void CopyCell(uint32_t *dst, uint32_t *src) ; */
    .global     CopyCell
    .thumb_func
    .align
// R0 = dst, R1 = src
CopyCell:
    PUSH        {R4}
    LDR         R2,=0                       //R2 = row
OuterLoopC:
    LDR         R3,=0                       //R3 = col
    CMP         R2, 60                      //Compare R2 (row) & 60
    BHS         EndLoopC                    //If R2 >= 60 goto EndLoopC
InnerLoopC:
    CMP         R3, 60                      //Compare R3 (col) & 60
    BHS         InnerDoneC                  //If R3 >= 60 goto InnerDoneC
    LDR         R4, [R1, R3, LSL 2]         //R4 <- src[col]
    STR         R4, [R0, R3, LSL 2]         //R4 -> dst[col]
    ADD         R3, R3, 1                   //R3 <- R3 + 1
    B           InnerLoopC
InnerDoneC:
    ADD         R2, R2, 1                   //R2 <- R2 + 1
    ADD         R0, R0, 960                 //R0 <- R0 + 960 (240 * 4 = 960 bytes)
    ADD         R1, R1, 960                 //R1 <- R1 + 960 (240 * 4 = 960 bytes)
    B           OuterLoopC
EndLoopC:
    POP         {R4}
    BX          LR


/* void FillCell(uint32_t *dst, uint32_t pixel) ; */
    .global     FillCell
    .thumb_func
    .align
//R0 = dst, R1 = pixel
FillCell:
    LDR         R2,=0                       //R2 = row
OuterLoopF:
	LDR         R3,=0                       //R3 = col
    CMP         R2, 60                      //Compare R2 (row) & 60
    BHS         EndLoopF                    //If R2 >= 60 goto EndLoopF
InnerLoopF:
    CMP         R3, 60                      //Compare R3 (col) & 60
    BHS         InnerDoneF                  //If R3 >= 60 goto InnerDoneF
    STR         R1, [R0, R3, LSL 2]         //pixel -> dst[col]
    ADD         R3, R3, 1                   //R3 <- R3 + 1
    B           InnerLoopF
InnerDoneF:
    ADD         R2, R2, 1                   //R2 <- R2 + 1
	ADD         R0, R0, 960                 //R0 <- R0 + 960 (240 * 4 = 960 bytes)
    B           OuterLoopF
EndLoopF:
    BX          LR


/* End of file */
    .end
