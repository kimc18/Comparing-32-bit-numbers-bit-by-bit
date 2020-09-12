.global _start
_start:

.org 0

BOTTOM_OF_LIST: .word 0x4066F6E2
NUMBER_TWO: .word 0x7066F6FE
TOP_OF_LIST: .word 0x7be6fcfe
NUMBER_X: .word 0x5066f6fe

movia r1, BOTTOM_OF_LIST
movia r2, TOP_OF_LIST
movia r3, NUMBER_TWO
movia r4, NUMBER_X

movi r5, 0x0 #counter to see how many contiguous bits there are
movi r6, 0x0 #counter for other numbers
movi r17, 0x0 #counter for other number
movi r7, 0x1 #since rori does not exist this is used like an immediate value for ror

ldw r8, 0(r1) #bottom
ldw r9, 0(r2) #top
ldw r13, 0(r3) #num 2
ldw r14, 0(r4) #num x

movhi r10, 0x7fff
ori r10, r10, 0xffff
movhi r20,  0x7fff
ori r20, r20, 0xffff
movhi r21, 0x7fff
ori r21, r21, 0xffff

movhi r22, 0xffff
ori r22, r22, 0xfffe

#this is used to check each bit individually, then branches
CHECK_TOP_AND_X:   or r11, r10, r14
or r12, r10, r9
beq r10, r22, CHECK_BOTTOM_AND_X #if the ror shift is done go to next check
beq r11, r12, COUNTER1

CHECK_BOTTOM_AND_X: or r15, r20, r8
 or r16, r20, r14
 beq r20, r22, CHECK_NUM2_AND_X
 beq r15, r16, COUNTER2

CHECK_NUM2_AND_X: or r18, r21, r13
 or r19, r21, r14
 beq r18, r19, COUNTER3
 br CHECK_GREATER

COUNTER1: ror r10, r10, r7
addi r5, r5, 1
br CHECK_TOP_AND_X

COUNTER2: ror r20, r20, r7
addi r6, r6, 1
br CHECK_BOTTOM_AND_X

COUNTER3: ror r21, r21, r7
addi r17, r17, 1
br CHECK_NUM2_AND_X

CHECK_GREATER: cmpgeu r23, r5, r6
  beq r23, r0, R6_BIGGER
  bne r23, r0, R5_BIGGER

#these registers show which num is largest
R5_BIGGER: cmpgeu r24, r5, r17
  br END
R6_BIGGER: cmpgeu r25, r6, r17
  br END

END: .end
