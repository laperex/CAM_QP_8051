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
