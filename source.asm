                                             
; Restaurant Billing System

; Restaurant Billing system is a program that allows people to choose 
; from a list of menu items until they
; have everything they've wanted to order and then calculate the total
; bill when they are finished selecting from a list.

Include Irvine32.inc

.386
.stack 4096
ExitProcess proto,dwExitCode:dword


.data

	siz = 50000

	orientalf BYTE "orientalfile.txt",0
	chinesef byte "chinesefile.txt",0
	fastfoodf byte "fastfoodfile.txt",0
	drinkf byte "drinksfile.txt",0
	dessertf byte "dessertfile.txt",0

	fileHandler dword ?
	msg1 byte siz dup(?)

     bill DWORD 0
	 string BYTE '           WELCOME TO RESTAURANT',0dh,0ah,0
     string1 BYTE ' Menu:',0dh,0ah
             BYTE '      Enter 1 - Oriental food ',0dh,0ah
             BYTE '      Enter 2 - Chinese food ',0dh,0ah
             BYTE '      Enter 3 - Fast food ',0dh,0ah
             BYTE '      Enter 4 - Drinks ',0dh,0ah
             BYTE '      Enter 5 - Dessert ',0dh,0ah
             BYTE '      Enter 6 - Exit ',0dh,0ah,0

    string2  BYTE '      Enter 1- To continue',0dh,0ah
             BYTE '      Enter 2 - Exit ',0dh,0ah,0

    string3  BYTE '      Enter 1 - Naan   = Rs 10',0dh,0ah
             BYTE '      Enter 2 - Roti   = Rs 05',0dh,0ah
             BYTE '      Enter 3 - Exit ',0dh,0ah,0

    buffer3 DWORD 10,05

    buffer4 DWORD 100,90,70,85

    buffer5 DWORD 150,165,95,80

    buffer6 DWORD 100,150,50,95

    buffer7 DWORD 90,90,65,70

    buffer8 DWORD 155,145,75,60
    
    spaces BYTE '              ',0

    errorMsg BYTE '      Please follow instructions correctly ',0dh,0ah,0

    Quantity BYTE '      Quantity:     ',0

    billing BYTE  '      Total Bill:   Rs ',0    

.code
main proc
     call Crlf
     call Crlf
	mov edx,OFFSET string
     call WriteString
     L1:                         
       mov edx,OFFSET string1
       call WriteString
       mov edx,OFFSET spaces
       call WriteString
       call ReadDec
       call Checkerror    ; check whether user enter the number in given range

       cmp eax,1      ; comparison b/w what user enter with each item of list
       je L2
       cmp eax,2
       je L3
       cmp eax,3
       je L4
       cmp eax,4
       je L5
       cmp eax,5
       je L6
       jmp last

     L2: call Oriental       ; calling procedures depends on what user enters
         jmp L7
     L3: call Chinese
         jmp L7
     L4: call FastFood
         jmp L7
     L5: call Drinks
         jmp L7
     L6: call Dessert
     L7: mov edx,OFFSET string2
         call WriteString
         mov edx,OFFSET spaces
         call WriteString
         call ReadDec
         call Checkerror1
         cmp eax,1           ; if user want to continue then jump to L1
         je L1
     last:                    
         call Crlf
         call Crlf
         mov edx,OFFSET billing
         call WriteString
         mov eax,bill        
         call WriteDec       ; prints the bill
         call Crlf   ; next line
         call Crlf
         call WaitMsg
	invoke ExitProcess,0
main endp


Oriental PROC

; print the oriental menu and add prices into bill according to which item of what quantity user selects 
; and call another func(NaanRoti) according to requirment
; Receives: string4, buffer4
; Returns: return updated bill
;-----------------------------------------------

		mov edx, offset orientalf
		call OpenInputFile
	
		mov edx, offset msg1
		mov ecx, sizeof msg1

		Call ReadFromFile
	
	; Printing String from Msg1
	
		mov edx, offset msg1
		call WriteString


         ;mov edx,OFFSET string4
        ; call WriteString
		 call crlf
         mov edx,OFFSET spaces
	          call ReadDec
         call Crlf
         call Checkerror3
         cmp eax,1
         je L1
         cmp eax,2
         je L2
         cmp eax,3
         je L3
         cmp eax,4
         je L4
         cmp eax,5
         jmp last
 L1: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer4]      ; buffer4 is array contains price of oriental foods
     L11:                   ; quantity times a loop L11 runs           
        add bill,ebx            ; add price into bill
        loop L11
     jmp last
 L2: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer4 + 4]
     L22:
         add bill,ebx
         loop L22
     call NaanRoti
     jmp last
 L3: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer4 + 8]
     L33:
         add bill,ebx
         loop L33
     call NaanRoti
     jmp last
 L4: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer4 + 12]
     L44:
         add bill,ebx
         loop L44
     call NaanRoti
last:
ret
Oriental ENDP

NaanRoti PROC


; print the menu(naan,roti) and add prices into bill according to which item of what quantity user selects 
; Receives: string3, buffer3
; Returns: return updated bill
;-----------------------------------------------
 
        mov edx,OFFSET string3
        call WriteString
        mov edx,OFFSET spaces
        call WriteString
        call ReadDec
        call Checkerror2
        cmp eax,1
        je L1
        cmp eax,2
        je L2
        jmp last
     L1:
             mov ebx,[buffer3]    ; buuffer3 is array contains price of Naan and roti
        mov edx,OFFSET Quantity
        call WriteString
        call ReadDec
        call Crlf
        mov ecx,eax
        L11:
          add bill,ebx
          loop L11
       jmp last
     L2:
        mov ebx,[buffer3 + 4]
        mov edx,OFFSET Quantity
        call WriteString
        call ReadDec
        call Crlf
        mov ecx,eax
        L22:
          add bill,ebx
          loop L22
last:
ret
NaanRoti ENDP


Chinese PROC


; print the chinese menu and add prices into bill according to which item of what quantity user selects 
; Receives: string5, buffer5
; Returns: return updated bill
;-----------------------------------------------
	
		mov edx, offset chinesef
		call OpenInputFile
	;
		mov edx, offset msg1
		mov ecx, sizeof msg1
		
		Call ReadFromFile
	
	; Printing String from Msg1
	

		mov edx, offset msg1
		call WriteString
		call crlf

;         mov edx,OFFSET string5
;         call WriteString
         mov edx,OFFSET spaces
         call WriteString
         call ReadDec
         call Crlf
         call Checkerror3       ; check for error
         cmp eax,1
         je L1
         cmp eax,2
         je L2
         cmp eax,3
         je L3
         cmp eax,4
         je L4
         cmp eax,5
         jmp last

 ; price of 1st,2nd,.. item of Chinese menu is on 1st,2nd.. index of buffer5 respectively
 ; same for all other menus

 L1: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     mov ecx,eax
     mov ebx,[buffer5]   
     L11:
        add bill,ebx
        loop L11
     jmp last
 L2: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     mov ecx,eax
     mov ebx,[buffer5 + 4]
     L22:
         add bill,ebx
         loop L22
     jmp last
 L3: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer5 + 8]
     L33:
         add bill,ebx
         loop L33
     jmp last
 L4: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer5 + 12]
     L44:
         add bill,ebx
         loop L44
last:

ret
Chinese ENDP
         
FastFood PROC


; print the fastfood menu and add prices into bill according to which item of what quantity user selects 
; Receives: string6, buffer6
; Returns: return updated bill
;-----------------------------------------------


		mov edx, offset fastfoodf
		call OpenInputFile
	;
		mov edx, offset msg1
		mov ecx, sizeof msg1

		Call ReadFromFile
	
	; Printing String from Msg1
	

		mov edx, offset msg1
		call WriteString
		call crlf


;         mov edx,OFFSET string6
;         call WriteString
         mov edx,OFFSET spaces
         call WriteString
         call ReadDec
         call Crlf
         call Checkerror3
         cmp eax,1
         je L1
         cmp eax,2
         je L2
         cmp eax,3
         je L3
         cmp eax,4
         je L4
         cmp eax,5
         jmp last
 L1: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer6]
     L11:
        add bill,ebx
        loop L11
     jmp last
 L2: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer6 + 4]
     L22:
     jmp last
 L3: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer6 + 8]
     L33:
         add bill,ebx
         loop L33
     jmp last
 L4: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer6 + 12]
     L44:
         add bill,ebx
         loop L44
last:
ret
FastFood ENDP
         
Drinks PROC


; print the drinks menu and add prices into bill according to which item of what quantity user selects 
; Receives: string7, buffer7
; Returns: return updated bill
;-----------------------------------------------

		mov edx, offset drinkf
		call OpenInputFile
	;
		mov edx, offset msg1
		mov ecx, sizeof msg1

		Call ReadFromFile
	
	; Printing String from Msg1
	

		mov edx, offset msg1
		call WriteString
		call crlf

;         mov edx,OFFSET string7
;         call WriteString
         mov edx,OFFSET spaces
         call WriteString
         call ReadDec
         call Crlf
         call Checkerror3
         cmp eax,1
         je L1
         cmp eax,2
         je L2
         cmp eax,3
         je L3
         cmp eax,4
         je L4
         cmp eax,5
         jmp last
 L1: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer7]
     L11:
        add bill,ebx
        loop L11
     jmp last
 L2: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
          mov ecx,eax
     mov ebx,[buffer6 + 4]
     L22:
         add bill,ebx
         loop L22
     jmp last
 L3: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer6 + 8]
     L33:
         add bill,ebx
         loop L33
     jmp last
 L4: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer6 + 12]
     L44:
         add bill,ebx
         loop L44
last:
ret
FastFood ENDP
         
Drinks PROC


; print the drinks menu and add prices into bill according to which item of what quantity user selects 
; Receives: string7, buffer7
; Returns: return updated bill
;-----------------------------------------------

		mov edx, offset drinkf
		call OpenInputFile
	;
		mov edx, offset msg1
		mov ecx, sizeof msg1

		Call ReadFromFile
	
	; Printing String from Msg1
	

		mov edx, offset msg1
		call WriteString
		call crlf

;         mov edx,OFFSET string7
;         call WriteString
         mov edx,OFFSET spaces
         call WriteString
         call ReadDec
         call Crlf
         call Checkerror3
         cmp eax,1
         je L1
         cmp eax,2
         je L2
         cmp eax,3
         je L3
         cmp eax,4
         je L4
         cmp eax,5
         jmp last
 L1: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer7]
     L11:
        add bill,ebx
        loop L11
     jmp last
 L2: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer7 + 4]
     L22:
         add bill,ebx
         loop L22
     jmp last
 L3: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer7 + 8]
     L33:
         add bill,ebx
         loop L33
     jmp last
 L4: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf

     mov ecx,eax
     mov ebx,[buffer7 + 12]
     L44:
         add bill,ebx
         loop L44
last:
ret
Drinks ENDP
         
Dessert PROC


; print the dessert menu and add prices into bill according to which item of what quantity user selects 
; Receives: string8, buffer8
; Returns: return updated bill
;-----------------------------------------------

		mov edx, offset dessertf
		call OpenInputFile
	
		mov edx, offset msg1
		mov ecx, sizeof msg1

		Call ReadFromFile
	
	; Printing String from Msg1
	

		mov edx, offset msg1
		call WriteString
		call crlf

;         mov edx,OFFSET string8
;         call WriteString
         mov edx,OFFSET spaces
         call WriteString
         call ReadDec
         call Crlf
         call Checkerror3
         cmp eax,1
         je L1
         cmp eax,2
         je L2
         cmp eax,3
         je L3
         cmp eax,4
         je L4
         cmp eax,5
         jmp last
 L1: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer8]
     L11:
        add bill,ebx
        loop L11
     jmp last
 L2: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer8 + 4]
     L22:
         add bill,ebx
         loop L22
     jmp last
 L3: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     mov ecx,eax
     call Crlf
     mov ebx,[buffer8 + 8]
     L33:
         add bill,ebx
         loop L33
     jmp last
 L4: mov edx,OFFSET Quantity
     call WriteString
     call ReadDec
     call Crlf
     mov ecx,eax
     mov ebx,[buffer8 + 12]
     L44:
         add bill,ebx
         loop L44

last:
ret
Dessert ENDP

Checkerror PROC

; check whether eax contains value in range 1-6
; Receives: eax
; Returns: eax contains value in range 1-6 according to user's choice
;-----------------------------------------------
L1:



