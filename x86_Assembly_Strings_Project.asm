
; Summary:
; This is a simple x86 Assembly program 
; This program prompts the user for a string
; and allows the user to modify the string
; chosen from a list of functions.
; This program requires the Irvine32 library.

; Author: Estevan Ortega
; Strings Project



.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

WriteInt proto
ReadInt proto
WriteString proto
WriteChar proto
ReadChar proto
Crlf proto
ReadString proto

.data

; Create prompts as string variables

promptString DB "Please enter a string of at most 50 characters. Type <enter> to terminate your string.",0

menuPrompt DB "Please enter a function from the following menu:",0AH,0DH
		   DB "Function 0 outputs this menu again and will prompt for a new function",0AH,0DH
		   DB "Function 1 returns the first of occurance of a given letter",0AH,0DH
		   DB "Function 2 returns the number of occurances of a given letter",0AH,0DH
		   DB "Function 3 returns the length of the string",0AH,0DH
		   DB "Function 4 returns the number of alphanumeric characters",0AH,0DH
	  	   DB "Function 5 replaces every occurance of a char with another symbol",0AH,0DH
		   DB "Function 6 capitalizes the letters in a string",0AH,0DH
		   DB "Function 7 makes each letter lowercase",0AH,0DH
		   DB "Function 8 toggles the case of each letter",0AH,0DH
		   DB "Function 9 undoes the last modification to the string",0AH,0DH
		   DB "Function 10 allows input of a new string",0AH,0DH
		   DB "Function 999 halts the program",0

funcPrompt DB "Enter function #: ",0
errorPrompt DB "The function number entered is invalid. Enter a valid funtion number from the menu.",0
newStrPrompt DB "Enter new string",0

func1_PromptOne DB "Enter a character to determine the first occurance of: ",0
func1_PromptTwo DB "The first '",0
func1_PromptThree DB "' is at postion ",0
func1_PromptFour DB " in the string ",0

func2_PromptOne DB "Enter the character of which to find the number of occurances: ",0
func2_PromptTwo DB "The character '",0
func2_PromptThree DB "' occurs ",0
func2_PromptFour DB " times in the string.",0

func3_PromptOne DB "There are ",0
func3_PromptTwo DB " total character in the string ",0

func4_PromptOne DB "There are ",0
func4_PromptTwo DB " alphanumeric characters in the string ",0

func5_PromptOne DB "Enter a character to replace: ",0
func5_PromptTwo DB "Enter replacement character: ",0
func5_PromptThree DB "Replacing all of the ",0
func5_PromptFour DB "'s in the string ",0
func5_PromptFive DB " with ",0
func5_PromptSix DB " yields ",0

func6_PromptOne DB "Capitalizing each letter in the string ",0
func6_PromptTwo DB "yields ",0

func7_PromptOne DB "Making all alphabetic characters lower-case in the string ",0
func7_PromptTwo DB "yields ",0

func8_PromptOne DB "Toggling of letters in the string ",0
func8_PromptTwo DB "yields ",0

func9_Prompt DB "The string reverts back to: ",0


inputString DB 50 dup(0)

oldInputString DB 50 dup(0)

funcNumber DD ?

numberOfOccurances DD ?



.code
main proc

Begin:	mov edx,OFFSET promptString		; Displays prompt
		call WriteString

		call Crlf						; Newline

		mov edx,OFFSET inputString		; Points to inputString
		mov ecx, 50						; Specifies max number of chars
		call ReadString

		cld
		mov ecx, LENGTHOF inputString	; Sets rep counter
		mov esi, OFFSET inputString		; points esi to inputString
		mov edi, OFFSET oldInputString	; points sdi to oldInputString
		rep movsd						; Copies inputString to oldInputString

		call DisplayMenu				; lists functions

funcLoop:
		call Crlf
		mov edx,OFFSET funcPrompt
		call WriteString

		call ReadInt					; User inputs function number
		mov funcNumber, eax

		call Crlf


		; Searches for which method to call using the Binary Search Method
		; by cutting the list of 12 possible methods in half twice.
		; Func list: 0 1 2 3 4 5 6 7 8 9 10 999


		cmp funcNumber, 6
		jl firstHalf

		cmp funcNumber, 9
		jl thirdQuarter

			; Checks for 9, 10, and 999
		jne f10
		call function_9
		jmp funcLoop

f10:	cmp funcNumber, 10
		jne f999
		call function_10
		jmp funcLoop
		
f999:	cmp funcNumber, 999
		jne error
		jmp done

			; Checks for 8, 7, and 6

thirdQuarter:
		cmp funcNumber, 8
		jne f7
		call function_8
		jmp funcLoop

f7: 	cmp funcNumber, 7
		jne f6
		call function_7
		jmp funcLoop

f6:		cmp funcNumber, 6
		jne error
		call function_6
		jmp funcLoop

firstHalf:
		cmp funcNumber, 3
		jl	firstQuarter

			; Checks for 3, 4, and 5
		jne f4
		call function_3
		jmp funcLoop

f4: 	cmp funcNumber, 4
		jne f5
		call function_4
		jmp funcLoop

f5:		cmp funcNumber, 5
		jne error
		call function_5
		jmp funcLoop

			; Checks for 2, 1, and 0
firstQuarter:
		cmp funcNumber, 2
		jne f1
		call function_2
		jmp funcLoop

f1: 	cmp funcNumber, 1
		jne f0
		call function_1
		jmp funcLoop

f0:		cmp funcNumber, 0
		jne error
		call DisplayMenu
		jmp funcLoop


error: 
	  call Crlf
	  mov edx,OFFSET errorPrompt
	  call WriteString
	  jmp funcLoop


	done: invoke ExitProcess,0
main endp



DisplayMenu proc

		mov edx,OFFSET menuPrompt
		call WriteString
		call Crlf

		ret

DisplayMenu endp



function_1 proc

	mov edx,OFFSET func1_PromptOne
	call WriteString

	Call ReadChar		; Reads char into eax

	call Crlf

	cld
	mov ecx, LENGTHOF inputString
	mov edi, OFFSET inputString 
	
	repne scasb
	
	jnz quit
	neg ecx
	dec ecx
	add ecx, LENGTHOF inputString

	mov edx,OFFSET func1_PromptTwo
	call WriteString

	call WriteChar

	mov edx,OFFSET func1_PromptThree
	call WriteString

	mov eax, ecx
	call WriteInt

	mov edx,OFFSET func1_PromptFour
	call WriteString

	mov edx,OFFSET inputString
	call WriteString

	call Crlf


quit:
	ret
function_1 endp


function_2 proc

	mov edx,OFFSET func2_PromptOne
	call WriteString

	call ReadChar		; Reads char into eax
	call WriteChar
	call Crlf
	
	mov edx,OFFSET func2_PromptTwo
	call WriteString

	call WriteChar

	mov edx,OFFSET func2_PromptThree
	call WriteString


	cld
	mov ecx, LENGTHOF inputString
	mov edi, OFFSET inputString 
	xor ebx, ebx

strLoop:
	repne scasb
	jnz exitLoop
	inc ebx
	jmp strLoop

exitLoop:
	mov eax, ebx
	call WriteInt

	mov edx, OFFSET func2_PromptFour
	call WriteString

	ret
function_2 endp


function_3 proc

	mov edx,OFFSET func3_PromptOne
	call WriteString

	mov eax, 0
	cld
	mov ecx, LENGTHOF inputString
	mov edi, OFFSET inputString 
	
	repne scasb
	
	jnz quit
	neg ecx
	dec ecx
	add ecx, LENGTHOF inputString

	mov eax, ecx
	call WriteInt

	mov edx,OFFSET func3_PromptTwo
	call WriteString
	
quit:
	ret
function_3 endp


function_4 proc

	cld
	mov ecx, LENGTHOF inputString
	mov esi, OFFSET inputString
	xor ebx, ebx

startLoop:
	
	lodsb
	cmp eax, 0
	je done

	cmp eax, 65		; Check if uppercase alphanumerical
	jl	startLoop
	cmp eax, 90
	jg	lowcase
	inc ebx
	jmp startLoop

lowcase:
	cmp eax, 97		; Check if lowercase alphanumerical
	jl	startLoop
	cmp eax, 122
	jg	startLoop
	inc ebx
	jmp	startLoop

done:
	mov edx,OFFSET func4_PromptOne
	call WriteString

	mov eax, ebx
	call WriteInt

	mov edx,OFFSET func4_PromptTwo
	call WriteString

	mov edx,OFFSET inputString
	call WriteString

	ret
function_4 endp


function_5 proc

	cld
	mov ecx, LENGTHOF inputString	; Sets rep counter
	mov esi, OFFSET inputString		; points esi to inputString
	mov edi, OFFSET oldInputString	; points edi to oldInputString
	rep movsd

	mov edx, OFFSET func5_PromptOne
	call WriteString

	XOR	 ecx, ecx
	XOR	 ebx, ebx

	call ReadChar		; Reads first char into eax
	call WriteChar
	call Crlf
	mov cl, al		; moves first char to cl
	
	mov edx,OFFSET func5_PromptTwo
	call WriteString

	call ReadChar		; Reads second char into eax
	call WriteChar
	call Crlf
	mov bl, al		; moves second char to bl

	mov edx,OFFSET func5_PromptThree
	call WriteString

	mov eax, ecx
	call WriteChar

	mov edx,OFFSET func5_PromptFour
	call WriteString

	mov edx,OFFSET inputString
	call WriteString
	call Crlf

	mov edx,OFFSET func5_PromptFive
	call WriteString

	mov eax, ebx
	call WriteChar

	mov edx,OFFSET func5_PromptSix
	call WriteString


	mov esi, OFFSET inputString 
	mov edx, ecx

strLoop:
	XOR	eax, eax
	mov al, [esi]

	cmp eax, 0
	je	exitLoop	; Finish if we are at end of the string.
	cmp	eax, ecx

	je	charEqual
	inc	esi
	jmp strLoop

charEqual:
	mov	[esi], bl
	inc esi
	jmp strLoop

exitLoop:

	mov edx, OFFSET inputString
	call WriteString

	ret
function_5 endp


function_6 proc

	cld
	mov ecx, LENGTHOF inputString	; Sets rep counter
	mov esi, OFFSET inputString		; points esi to inputString
	mov edi, OFFSET oldInputString	; points sdi to oldInputString
	rep movsd						; Copies inputString to oldInputString

	mov ecx, LENGTHOF inputString
	mov esi, OFFSET inputString

startLoop:
	
	lodsb
	cmp eax, 0
	je done

	cmp eax, 97
	jl	startLoop
	cmp eax, 122
	jg	startLoop
	and eax, 223
	mov edi, esi
	dec edi
	stosb
	jmp	startLoop

done:

	mov edx,OFFSET func6_PromptOne
	call WriteString

	mov edx,OFFSET oldInputString
	call WriteString
	call Crlf

	mov edx,OFFSET func6_PromptTwo
	call WriteString

	mov edx,OFFSET inputString
	call WriteString
	
	ret
function_6 endp


function_7 proc

	cld
	mov ecx, LENGTHOF inputString	; Sets rep counter
	mov esi, OFFSET inputString		; points esi to inputString
	mov edi, OFFSET oldInputString	; points sdi to oldInputString
	rep movsd						; Copies inputString to oldInputString

	mov ecx, LENGTHOF inputString
	mov esi, OFFSET inputString

startLoop:
	
	lodsb
	cmp eax, 0
	je done

	cmp eax, 65
	jl	startLoop
	cmp eax, 90
	jg	startLoop
	or eax, 32
	mov edi, esi
	dec edi
	stosb
	jmp	startLoop

done:

	mov edx,OFFSET func7_PromptOne
	call WriteString

	mov edx,OFFSET oldInputString
	call WriteString
	call Crlf

	mov edx,OFFSET func7_PromptTwo
	call WriteString

	mov edx,OFFSET inputString
	call WriteString

	ret
function_7 endp


function_8 proc

	cld
	mov ecx, LENGTHOF inputString	; Sets rep counter
	mov esi, OFFSET inputString		; points esi to inputString
	mov edi, OFFSET oldInputString	; points sdi to oldInputString
	rep movsd						; Copies inputString to oldInputString

	mov ecx, LENGTHOF inputString
	mov esi, OFFSET inputString

startLoop:
	
	lodsb
	cmp eax, 0
	je done

	cmp eax, 65		; Check if uppercase alphanumerical
	jl	startLoop
	cmp eax, 90
	jg	lowcase
	or eax, 32	; Convert to lowercase
	mov edi, esi
	dec edi
	stosb
	jmp startLoop

lowcase:
	cmp eax, 97		; Check if lowercase alphanumerical
	jl	startLoop
	cmp eax, 122
	jg	startLoop
	and eax, 223	; Convert to uppercase
	mov edi, esi
	dec edi
	stosb
	jmp	startLoop

done:
	mov edx,OFFSET func8_PromptOne
	call WriteString

	mov edx,OFFSET oldInputString
	call WriteString
	call Crlf

	mov edx,OFFSET func8_PromptTwo
	call WriteString

	mov edx,OFFSET inputString
	call WriteString

	ret
function_8 endp


function_9 proc

		mov edx,OFFSET inputString
		call WriteString
		call Crlf

		mov edx,OFFSET func9_Prompt
		call WriteString
		call Crlf

		mov edx,OFFSET oldInputString
		call WriteString
		call Crlf

		cld
		mov ecx, LENGTHOF inputString	; Sets rep counter
		mov esi, OFFSET oldInputString	; points esi to inputString
		mov edi, OFFSET inputString		; points sdi to oldInputString
		rep movsd

ret
function_9 endp


function_10 proc

	mov edx,OFFSET promptString		; Displays prompt
	call WriteString

	call Crlf						; Newline

	mov edx,OFFSET inputString		; Points to inputString
	mov ecx, 50						; Specifies max number of chars
	call ReadString

ret
function_10 endp



end main