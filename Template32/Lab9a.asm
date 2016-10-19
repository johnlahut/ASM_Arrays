;John Lahut
;Lab 9

;Demonstrates arrays, and various ways to manipulate and access them

title  Lab9a.asm

.386
.model flat, stdcall

;Named constants
 MAX_SIZE equ 100

;External procedure prototypes
 WriteHex proto
 ReadInt proto
 WriteInt proto
 Crlf proto
 WriteString proto
 ExitProcess proto, dwExitcode:dword

.stack 100h

.data
        prompt1  byte  "Enter integers to store in an array (0 to stop): ", 0
        msgPos   byte  "The sum of the positive values is ", 0
        msgNeg   byte  "The sum of the negative values is ", 0
        msgPos2  byte  "The # of positive values is ", 0
        msgNeg2  byte  "The # of negative values is ", 0
 
        numValues dword ?		;# of values stored in listA
        listA     sdword  MAX_SIZE dup (?)
        posSum    dword ?		;sum of positive values in listA
        posCount  dword ?		;# of positive values stored in listA	
        negSum    sdword ?		;sum of negative values stored in listA
        negCount  dword ?		;# of negative values stored in listA

.code
 main proc
	
     ;Print "Enter integers to store in an array (0 to stop): "
      mov edx, offset prompt1
      call WriteString
      call Crlf

     ;FILL IN CODE to do the following procedure call
     ; Fill(listA, numValues)
	 
	 push offset listA					;push on arugments
	 push numValues
	 call Fill
	 pop numValues						;return by value


     ;FILL IN CODE to do the following procedure call
     ; ComputeSums(listA, numValues, posSum, posCount, negSum, negCount)
	 push offset listA
	 push numValues
	 push posSum
	 push posCount
	 push negSum
	 push negCount
	 call ComputeSums
	 pop negCount
	 pop negSum
	 pop posCount
	 pop posSum

     ;Print "The sum of the positive values is " posSum
      mov edx, offset msgPos
      call WriteString
      mov eax, posSum
      call WriteInt
      call Crlf

     ;Print "The # of positive values is " posCount
      mov edx, offset msgPos2
      call WriteString
      mov eax, posCount
      call WriteInt
      call Crlf

     ;Print "The sum of the negative values is " negSum
      mov edx, offset msgNeg
      call WriteString
      mov eax, negSum
      call WriteInt
      call Crlf

     ;Print "The # of negative values is " negCount
      mov edx, offset msgNeg2
      call WriteString
      mov eax, negCount
      call WriteInt
      call Crlf

     ;Terminate the program
      push 0
      call ExitProcess
main endp

;FILL IN CODE for procedure Fill which fills an array with
; values which come from the user.  Fill should use a sentinel
; controlled loop to continue storing values until the user enters 0
; Fill should return the # of filled locations in the array (the
; sentinel should not be stored or counted)

OFFSET_LISTA			equ			[ebp+24]				;&listA located at ebp+20
NUM_VALUES				equ			[ebp+20]				;numValues located at ebp+24
Fill proc

;preserve regs

push esi									;array pointer
push eax									;readint 
push ecx									;counter reg
push ebp									;base stack ptr

mov ebp, esp								;align stack ptrs
mov esi, OFFSET_LISTA						;esi points to base of stack

DO1:

	call ReadInt

	;if input == 0, exit
	cmp eax, 0
	je END1

	;else
	mov [esi], eax
	add esi, type listA
	mov eax, NUM_VALUES
	inc eax
	mov NUM_VALUES, eax
	jmp DO1


END1:
;restore regs
pop ebp
pop ecx
pop eax
pop esi

ret
Fill endp



;FILL IN CODE for procedure ComputeSums which will compute and return
; the sum and count of the positive values stored in its
; array argument, and will compute and return the sum and count
; of the negative values stored in its array argument
;local constants for addressing
OFFSET_LISTA		equ			[ebp+44]
NUM_VALUES			equ			[ebp+40]
POS_SUM				equ			[ebp+36]
POS_COUNT			equ			[ebp+32]
NEG_SUM				equ			[ebp+28]
NEG_COUNT			equ			[ebp+24]

ComputeSums proc

;preserve registers
push esi					;array ptr
push eax					;used for math/storage
push ebx					;storage
push ecx					;loop counter
push ebp					;stack ptr

mov ebp, esp				;align stack ptr

mov esi, OFFSET_LISTA		;points to start of listA
mov ecx, NUM_VALUES

L1:

mov eax, [esi]
add esi, type listA
call WriteInt
call Crlf

;compare current index
cmp eax, 0
mov ebx, eax					;ebx will preserve current index

;jump if neg
jl negative

;greater than zero path

;modify posCount
mov eax, POS_COUNT				;eax = posCount
inc eax							;posCount++
mov POS_COUNT, eax				;posCount = eax

;modify posSum
mov eax, POS_SUM				;eax = posSum
add eax, ebx					;eax += ebx
mov POS_SUM, eax				;posSum = eax

;exit conditional
jmp endif1

negative:
;modify negCount
mov eax, NEG_COUNT				;eax = negCount
inc eax
mov NEG_COUNT, eax

;modify negSum
mov eax, NEG_SUM
add eax, ebx
mov NEG_SUM, eax

endif1:
loop L1

;restore registers
pop ebp
pop ecx
pop ebx
pop eax
pop esi

ret
ComputeSums endp




end main


