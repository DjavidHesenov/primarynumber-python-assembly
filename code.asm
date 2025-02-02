/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program cribleEras64.s   */

/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeConstantesARM64.inc"

.equ MAXI,      100

/*********************************/
/* Initialized data              */
/*********************************/
.data
sMessResult:        .asciz "Prime  : @ \n"
szCarriageReturn:   .asciz "\n"

/*********************************/
/* UnInitialized data            */
/*********************************/
.bss  
sZoneConv:                  .skip 24
TablePrime:                 .skip   8 * MAXI 
/*********************************/
/*  code section                 */
/*********************************/
.text
.global main 
main:                               // entry of program 
    ldr x4,qAdrTablePrime           // address prime table
    mov x0,#2                       // prime 2
    bl displayPrime
    mov x1,#2
    mov x2,#1
1:                                  // loop for multiple of 2
    str x2,[x4,x1,lsl #3]           // mark  multiple of 2
    add x1,x1,#2
    cmp x1,#MAXI                    // end ?
    ble 1b                          // no loop
    mov x1,#3                       // begin indice
    mov x3,#1
2:
    ldr x2,[x4,x1,lsl #3]           // load table élément
    cmp x2,#1                       // is prime ?
    beq 4f
    mov x0,x1                       // yes -> display
    bl displayPrime
    mov x2,x1
3:                                  // and loop to mark multiples of this prime
    str x3,[x4,x2,lsl #3]
    add x2,x2,x1                    // add the prime
    cmp x2,#MAXI                    // end ?
    ble 3b                          // no -> loop
4:
    add x1,x1,2                     // other prime in table
    cmp x1,MAXI                     // end table ?
    ble 2b                          // no -> loop

100:                                // standard end of the program 
    mov x0,0                        // return code
    mov x8,EXIT                     // request to exit program
    svc 0                           // perform the system call
qAdrszCarriageReturn:    .quad szCarriageReturn
qAdrsMessResult:         .quad sMessResult
qAdrTablePrime:          .quad TablePrime

/******************************************************************/
/*      Display prime table elements                                */ 
/******************************************************************/
/* x0 contains the prime */
displayPrime:
    stp x1,lr,[sp,-16]!             // save  registers
    ldr x1,qAdrsZoneConv
    bl conversion10                 // call décimal conversion
    ldr x0,qAdrsMessResult
    ldr x1,qAdrsZoneConv            // insert conversion in message
    bl strInsertAtCharInc
    bl affichageMess                // display message
100:
    ldp x1,lr,[sp],16               // restaur  2 registers
    ret                             // return to address lr x30
qAdrsZoneConv:                   .quad sZoneConv  

/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"