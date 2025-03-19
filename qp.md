1. **Write an 8051 C program to toggle the bits of Pl ports continuously with a 250ms time delay.**

   ```C
   #include <reg51.h>

   // Function to create a 250ms delay
   void delay_250ms() {
       unsigned int i, j;
       for (i = 0; i < 250; i++) {
           for (j = 0; j < 120; j++); // Roughly 1ms delay (depends on crystal)
       }
   }

   void main() {
       while (1) {
           P1 = ~P1;         // Toggle all bits of Port 1
           delay_250ms();    // Call 250ms delay function
       }
   }

   ```
2. **write an assembly language program in 8051 to add an array of ten g-bit numbers stored in the
   external memory. Draw the flowchart or write the algorithm also.**

3. **Write an assembly language program to find the sum of l0 numbers stored from location
   2000H and store the results in the consecutive locations.**
   ```
   MOV DPTR, #2000H    ; Point to external memory array base address
        MOV R0, #0AH        ; R0 = 10 (counter for 10 numbers)

        MOV R1, #00H        ; Store Result of Addition
        MOV R2, #00H        ; Store Carry of Addition
        CLR A               ; Clear Accumulator (result register)

    LOOP:
        MOV R1, A			; store result in R1 (initially A = 0)
        MOVX A, @DPTR		; Read a number from external memory into A

        CLR C				; clear carry (C = 0)
        ADD A, R1			; Add the number to the sum (initially A = 0)
        
        MOV A, #00H			; A = 0
        ADDC A, R2			; A = 0 + R2 + C
        MOV R2, A			

        INC DPTR        ; Point to next memory location
        DJNZ R0, LOOP   ; Decrement R0, loop until R0 = 0
        
        MOV A, R1			; A = Result (R1)
        MOVX A, @DPTR		; store A to external memory
        INC DPTR
        MOV A, R2			; A = Carry (R2)
        MOVX A, @DPTR		; store A to external memory

        HERE: SJMP HERE     ; Infinite loop
   ```

4. **Write an 8051-assembly language program to toggle all the bits of Port 0 every 1 ms using a
subroutine. The crystal frequency used is I 1MHz. Assume the machine cycle values as 1 or 2.**

```
        MOV P0, #0FFH      ; Set all bits of Port 0 initially
    MAIN_LOOP:
        CPL P0             ; Toggle all bits of Port 0
        ACALL DELAY_1MS    ; Call 1ms delay subroutine
        SJMP MAIN_LOOP     ; Repeat forever

    ; ----------- Delay Subroutine 1ms -----------
    ; Assuming machine cycle ≈ 1us, so 1ms ≈ 1000 us = 1000 machine cycles
    ; We'll make a nested loop to get around 1000 cycles.

    DELAY_1MS:
        MOV R1, #250       ; Outer loop
    DELAY_LOOP1:
        MOV R2, #4         ; Inner loop
    DELAY_LOOP2:
        DJNZ R2, DELAY_LOOP2
        DJNZ R1, DELAY_LOOP1
        RET
```

5. **Write 8051 C program to convert ASCII digits of '5' and '8' to packed BCD and 4 sent the
value to port2.**

```C
    #include <reg51.h>
        
    void main(void) {
        // '5' = 0x35
        // '8' = 0x35
        unsigned char bcd1 = '5' - 0x30;
        unsigned char bcd2 = '8' - 0x30;
        P2 = (bcd1 << 4) | bcd2;
    }
```

6. **Write an 8051 C program to get a byte of data form P0. If it is less than 100, send it to P1;
otherwise, send it to P2.**

```C
    #include <reg51.h>
        
    void main(void) {
        unsigned char data = P0;
        
        if (data < 100) {
            P1 = data;
        } else {
            P2 = data;
        }
    }
```

7. **Write an 8051 C program to get a byte of data form P1, wait 1/2 second, and then send it to P2.**

```C
    #include <reg51.h>
    
    // 1 second		= 1000ms
    // 1/2 second	= 500ms
    void delay_500ms() {
        for (unsigned int i = 0; i < 500; i++) {	// 500ms delay
            for (unsigned int j = 0; j < 120; j++);	// 1ms delay
            // j < 120 for 12Mhz clock
        }
    }
        
    void main(void) {
        unsigned char data = P1;
        
        delay_500ms();
        
        P2 = data;
    }
```

8. ![1742399587021](image/qp/1742399587021.png)

```
    MOV DPTR, #0050H    ; DPTR = 50H
    
    MOVX A, @DPTR       ; A = MEMORY[dptr] (value in memory at adress dptr (50)) [get first value]
    MOV R0, A           ; R0 = A
    
    INC DPTR            ; DPTR = 51H
    MOVX A, @DPTR       ; get 2nd value
    ADD A, R0           ; A = A + R0

    INC DPTR            ; DPTR = 52H
    MOVX @DPTR, A       ; MEMORY[DPTR] = A

    INC DPTR
    MOV A, #00H         ; A = 0
    ADDC A, #00H        ; A = A + C
    MOVX @DPTR, A       ; MEMORY[DPTR] = A [store carry]
    
WAIT:
    LJMP WAIT
```

9. ![1742399629565](image/qp/1742399629565.png)

```
    MOV DPTR, #0050H    ; DPTR = 50H
    MOV A, #FFH         ; A = FFH
    MOV R0, #08         ; R0 = 08H

LOOP:
    MOVX @DPTR, A       ; MEM[DPTR] = A
    DJNZ R0, LOOP       ; R0 = R0 - 1 and jump if R0 != 0

WAIT:
    LJMP WAIT
```

10. ![1742399642305](image/qp/1742399642305.png)

```
    MOV DPTR, #0051H    ; DPTR = 51H
    MOVX A, @DPTR       ; Load LSB of B
    MOV R0, A           ;
    MOV DPTR, #0055H    ; DPTR = 55H
    MOVX A, @DPTR       ; Load LSB of A

    CLR C               ; Clear carry before subtraction
    SUBB A, R0          ; Subtract LSB

    MOV DPTR, #0040H
    MOVX @DPTR, A       ; Store result LSB in 40H

    ; --- Subtract MSB with borrow ---
    MOV DPTR, #0052H    ; DPTR = 52H
    MOVX A, @DPTR       ; Load MSB of B
    MOV R0, A           ;
    MOV DPTR, #0056H    ; DPTR = 56H
    MOVX A, @DPTR       ; Load MSB of A

    SUBB A, R0          ; Subtract MSB

    MOV DPTR, #0041H    
    MOVX @DPTR, A       ; Store result MSB in 41H

    JNC POSITIVE        ; Jump if no carry (positive result)

    ; Negative case
    MOV DPTR, #0042H
    MOV @DPTR, #01H     ; Store 01H if result is negative
    LJMP WAIT

POSITIVE:
    MOV DPTR, #0042H
    MOV @DPTR, #00H     ; Store 00H if result is positive

WAIT:
    LJMP WAIT     ; Infinite loop

    
```

11. ![1742399650018](image/qp/1742399650018.png)

```
    MOV DPTR, #0051H    ; DPTR = 51H
    MOVX A, @DPTR       ; Load LSB of B
    MOV R0, A           ;
    MOV DPTR, #0055H    ; DPTR = 55H
    MOVX A, @DPTR       ; Load LSB of A

    CLR C               ; Clear carry before subtraction
    SUBB A, R0          ; Subtract LSB

    MOV DPTR, #0040H
    MOVX @DPTR, A       ; Store result LSB in 40H

    ; --- Subtract MSB with borrow ---
    MOV DPTR, #0052H    ; DPTR = 52H
    MOVX A, @DPTR       ; Load MSB of B
    MOV R0, A           ;
    MOV DPTR, #0056H    ; DPTR = 56H
    MOVX A, @DPTR       ; Load MSB of A

    SUBB A, R0          ; Subtract MSB

    MOV DPTR, #0041H    
    MOVX @DPTR, A       ; Store result MSB in 41H
    
    MOV DPTR, #0041H    ; to store borrow
    MOV A, #00H         ; A = 0
    ADDC A, #00H        ; A = A + 0 + Carry ( in this case Carry = Borrow for Subtraction )
    MOVX @DPTR, A       ; Store Borrow
    
    WAIT: LJMP WAIT   ; Infinite loop
```

12. ![1742399657760](image/qp/1742399657760.png)

```
    MOV A, #0FFH        ; Load FFH into accumulator
    MOV DPTR, #0050H    ; Set external address to 50H

LOOP:
    MOVX @DPTR, A   ; Write FFH to external memory
    INC DPTR        ; Increment address

    MOV A, DPL
    CJNE A, #59H, LOOP ; Repeat until address 58H is reached; jumps if A != 59H 

WAIT: LJMP WAIT

```

13. ![1742399664522](image/qp/1742399664522.png)

```
    ; --- Load first BCD LSB from external memory 60H ---
    MOV DPTR, #0060H
    MOVX A, @DPTR        ; A = [60H]
    MOV R0, A           ; R0 = A

    ; --- Load second BCD LSB from external memory 61H ---
    MOV DPTR, #0061H
    MOVX A, @DPTR       ; A = [61H] temporarily store in R0

    ; --- Add the BCD LSBs ---
    ADD A, R0            ; A = A + R0
    DA A                 ; Adjust to BCD

    ; --- Store result LSB to 52H ---
    MOV DPTR, #0052H
    MOVX @DPTR, A

    ; --- Add MSBs (carry only) ---
    MOV A, #00H          ; Clear A
    ADDC A, #00H         ; Add carry from LSB addition
    DA A                 ; Adjust to BCD

    ; --- Store result MSB to 53H ---
    MOV DPTR, #0053H
    MOVX @DPTR, A

WAIT:
    LJMP WAIT

```

14.  ![1742399675461](image/qp/1742399675461.png)

```
    MOV DPTR, #1000H    ; DPTR = 50H
    MOV A, #00H         ; A = 00H
    MOV R0, #0A         ; R0 = 0AH

LOOP:
    MOVX @DPTR, A       ; MEM[DPTR] = A
    DJNZ R0, LOOP       ; R0 = R0 - 1 and jump if R0 != 0

WAIT:
    LJMP WAIT
```

15. ![1742399683837](image/qp/1742399683837.png)

```
    MOV DPTR, #8100     ; memory location of N = #8100H
    MOVX A, @DPTR         ; A = N
    ADD A, #01            ; A = A + 1
    ADD A, #02            ; A = A + 2
    ADD A, #03            ; A = A + 3

    MOV DPTR, #0070     ; store result at 0070H
    MOVX @DPTR, A
```

16. ![1742399693148](image/qp/1742399693148.png)

```
    MOV DPTR, #0070H
    MOVX A, @DPTR       ; A = [70H]
    MOV A, B              ; B = A

    ; --- Load second number from 71H ---
    MOV DPTR, #0071H
    MOVX A, @DPTR      ; Store second number in A

    ; --- Multiply A * B ---
    MUL AB              ; A * B --> result in A (LSB) and B (MSB)

    ; --- Store LSB result at 52H ---
    MOV DPTR, #0052H
    MOVX @DPTR, A

    ; --- Store MSB result at 53H ---
    MOV DPTR, #0053H
    MOV A, B
    MOVX @DPTR, A

WAIT:
    LJMP WAIT
```

17. ![1742399718718](image/qp/1742399718718.png)

```
    MOV DPTR, #0050H    ; DPTR = 50H
    MOV R0, #0A         ; R0 = 0AH

LOOP:
    MOVX A, @DPTR       ; A = MEM[DPTR]
    INC A
    MOVX @DPTR, A       ; MEM[DPTR] = A
    DJNZ R0, LOOP       ; R0 = R0 - 1 and jump if R0 != 0

WAIT:
    LJMP WAIT
```

42. ![1742400109794](image/qp/1742400109794.png)

```C
    #include <reg51.h>

    // Define pins
    sbit DOOR_SENSOR = P1^1;  // P1.1
    sbit BUZZER = P1^7;       // P1.7

    void delay_ms(unsigned int ms) {
        unsigned int i, j;
        for(i = 0; i < ms; i++) {
            for(j = 0; j < 127; j++);  // Roughly 1 ms delay on 11.0592 MHz
        }
    }

    void main(void) {
        while(1) {
            if(DOOR_SENSOR == 1) { // Door opened (assuming active high)
                // Generate square wave for buzzer
                BUZZER = 1;
                delay_ms(1); // Adjust this for desired frequency (e.g., ~500Hz)
                BUZZER = 0;
                delay_ms(1);
            } else {
                BUZZER = 0; // Door closed, buzzer off
            }
        }
    }

```

45. ![1742405811658](image/qp/1742405811658.png)

```

```