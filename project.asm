.data segment

         ;   0    1    2    3    4    5    6    7    8    9    a    b    c    d    e    f
    sboxArray  db 063h, 07Ch, 077h, 07Bh, 0F2h, 06Bh, 06Fh, 0C5h, 030h, 001h, 067h, 02Bh, 0FEh, 0D7h, 0ABh, 076h  ;0
               db 0CAh, 082h, 0C9h, 07Dh, 0FAh, 059h, 047h, 0F0h, 0ADh, 0D4h, 0A2h, 0AFh, 09Ch, 0A4h, 072h, 0C0h  ;1
               db 0B7h, 0FDh, 093h, 026h, 036h, 03Fh, 0F7h, 0CCh, 034h, 0A5h, 0E5h, 0F1h, 071h, 0D8h, 031h, 015h  ;2
               db 004h, 0C7h, 023h, 0C3h, 018h, 096h, 005h, 09Ah, 007h, 012h, 080h, 0E2h, 0EBh, 027h, 0B2h, 075h  ;3
               db 009h, 083h, 02Ch, 01Ah, 01Bh, 06Eh, 05Ah, 0A0h, 052h, 03Bh, 0D6h, 0B3h, 029h, 0E3h, 02Fh, 084h  ;4
               db 053h, 0D1h, 000h, 0EDh, 020h, 0FCh, 0B1h, 05Bh, 06Ah, 0CBh, 0Beh, 039h, 04Ah, 04Ch, 058h, 0CFh  ;5
               db 0D0h, 0EFh, 0AAh, 0FBh, 043h, 04Dh, 033h, 085h, 045h, 0F9h, 002h, 07Fh, 050h, 03Ch, 09Fh, 0A8h  ;6
               db 051h, 0A3h, 040h, 08Fh, 092h, 09Dh, 038h, 0F5h, 0BCh, 0B6h, 0DAh, 021h, 010h, 0FFh, 0F3h, 0D2h  ;7
               db 0CDh, 00Ch, 013h, 0ECh, 05Fh, 097h, 044h, 017h, 0C4h, 0A7h, 07Eh, 03Dh, 064h, 05Dh, 019h, 073h  ;8
               db 060h, 081h, 04Fh, 0DCh, 022h, 02Ah, 090h, 088h, 046h, 0EEh, 0B8h, 014h, 0DEh, 05Eh, 00Bh, 0DBh  ;9
               db 0E0h, 032h, 03Ah, 00Ah, 049h, 006h, 024h, 05Ch, 0C2h, 0D3h, 0ACh, 062h, 091h, 095h, 0E4h, 079h  ;a
               db 0E7h, 0C8h, 037h, 06Dh, 08Dh, 0D5h, 04Eh, 0A9h, 06Ch, 056h, 0F4h, 0EAh, 065h, 07Ah, 0AEh, 008h  ;b
               db 0BAh, 078h, 025h, 02Eh, 01Ch, 0A6h, 0B4h, 0C6h, 0E8h, 0DDh, 074h, 01Fh, 04Bh, 0BDh, 08Bh, 08Ah  ;c
               db 070h, 03Eh, 0B5h, 066h, 048h, 003h, 0F6h, 00Eh, 061h, 035h, 057h, 0B9h, 086h, 0C1h, 01Dh, 09Eh  ;d
               db 0E1h, 0F8h, 098h, 011h, 069h, 0D9h, 08Eh, 094h, 09Bh, 01Eh, 087h, 0E9h, 0CEh, 055h, 028h, 0DFh  ;e
               db 08Ch, 0A1h, 089h, 00Dh, 0BFh, 0E6h, 042h, 068h, 041h, 099h, 02Dh, 00Fh, 0B0h, 054h, 0BBh, 016h  ;f



x db 0
y db 0
z db 0
shifts dw 0
rows dw 0
a db 1,2,3,4,100,2,3,4,1,2,3,4,1,2,3,4

.code segment

 subBytes macro
        mov si, ax               ; Puts the position in the array in SI register to use it to address the array
        mov al, sboxArray[si]    ; Retrieves the value from the "2d" array
endm

call ShiftRows 
ret

ShiftRows PROC
mov di,1  
AllRowsShifts:
    mov ax,di
    mov si,4
    mul si;  
    inc ax
    mov shifts,0
    RowShifts:
        OneShift:
            mov si,ax
            mov bl,a[si-1]
            mov cx,3
            l:
            mov bh,a[si]
            mov a[si-1],bh
            inc si
            loop l
            mov a[si-1],bl
        inc shifts
        cmp shifts,di
        jnz RowShifts
    inc di 
    cmp di,4
    jnz AllRowsShifts
    ret
     endp

mixColumns PROC 
mov si,0
    sloop:
        ;fist eq
        mov al,a[si]
        call MulTwo
        push ax
        mov al,a[4+si]
        call MulThree
        pop bx
        xor al,bh
        xor al,a[8+si]
        xor al,a[12+si]
        mov b[si],al

        ;2nd eq
        mov al,a[si+4]
        call MulTwo
        push ax
        mov al,a[8+si]
        call MulThree
        pop bx
        xor al,bh
        xor al,a[si]
        xor al,a[12+si]
        mov b[si+4],al


        ;3rd eq
        mov al,a[si+8]
         call MulTwo
        push ax
        mov al,a[12+si]
        call MulThree
        pop bx
        xor al,bh
        xor al,a[si]
        xor al,a[4+si]
        mov b[si+8],al


        ;4th eq
        mov al,a[si+12]
         call MulTwo
        push ax
        mov al,a[si]
        call MulThree
        pop bx
        xor al,bh
        xor al,a[4+si]
        xor al,a[8+si]
        mov b[si+12],al
    inc si
    cmp si,4
    jnz sloop
    ret
    endp
MulThree PROC ; input id in ax
    push ax
    call MulTwo
    pop dx
    xor ax,dx
    ret
    endp

MulTwo PROC ; the input should be stored in ax
    mov bx,2
    mul bx  ; shift part is just *2 now if there is a carry it should be in ah 
    cmp ah,1
    jnz End1
    xor al,1Bh ; if ah is 1 then we should xor the al with is number of some reason
    ret 
    End1:endp; out is in al


