; blinky.asm - SDCC style

            .area   RESET (ABS)
            .org    0x0000
            ljmp    start

            .area   CODE (REL)

start:      
            mov     SP, #0x7F   ; Initialize stack pointer

loop:       
            setb    P1.0        ; Turn ON LED on P1.0
            acall   delay

            clr     P1.0        ; Turn OFF LED on P1.0
            acall   delay

            sjmp    loop

delay:      
            mov     R7, #0xFF
d1:         
            mov     R6, #0xFF
d2:         
            djnz    R6, d2
            djnz    R7, d1
            ret

            .end
