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
