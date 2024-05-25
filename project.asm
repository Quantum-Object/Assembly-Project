.data segment

x db 0
y db 0
z db 0
shifts dw 0
rows dw 0
a db 1,2,3,4,100,2,3,4,1,2,3,4,1,2,3,4

.code segment
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
