.syntax     unified
.cpu        cortex-m4
.text

/* Address Alignment */

/* FullWordAccess */
.global     FullWordAccess
.thumb_func
.align
FullWordAccess:
.rept       100
LDR         R1,[R0]
.endr
BX          LR

/* HalfWordAccess */
.global     HalfWordAccess
.thumb_func
.align
HalfWordAccess:
.rept       100
LDRH        R1,[R0]
.endr
BX          LR

/* Address Dependency */

/* AddressDependency */
.global     AddressDependency
.thumb_func
.align
AddressDependency:
.rept       100
LDR         R1,[R0]
LDR         R0,[R1]
.endr
BX          LR

/* NoAddressDependency */
.global     NoAddressDependency
.thumb_func
.align
NoAddressDependency:
.rept       100
LDR         R1,[R0]
LDR         R2,[R0]
.endr
BX          LR

/* Data Dependency */

/* DataDependency */
.global     DataDependency
.thumb_func
.align
DataDependency:
.rept       100
VADD.F32    S1,S0,S0
VADD.F32    S0,S1,S1
.endr
VMOV        S1,S0
BX LR

/* NoDataDependency */
.global     NoDataDependency
.thumb_func
.align
NoDataDependency:
.rept       100
VADD.F32    S1,S0,S0
VADD.F32    S2,S0,S0
.endr
VMOV        S1,S0
BX LR

/* Concurrent Execution */

/* VDIVOverlap */
.global     VDIVOverlap
.thumb_func
.align
VDIVOverlap:
VDIV.F32    S2,S1,S0
.rept       15
NOP
.endr
VMOV        S3,S2
BX          LR

/* End of file */
.end
