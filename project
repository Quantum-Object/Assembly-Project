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
     endp
