.model small
.stack 100h
.data segment
        num db 05h
    state db 0d4h, 0e0h, 0b8h, 01eh
          db 0bfh, 0b4h, 041h, 027h
          db 05dh, 052h, 011h, 098h
          db 030h, 0aeh, 0f1h, 0e5h
    tmp db 16 dup(?)
 
    shifts dw 0
    rows dw 0
    a db 1,2,3,4,052h,2,3,4,1,2,3,4,1,2,3,4
                ;   0     1     2     3     4     5     6     7     8     9     a     b     c     d     e     f
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


    cipherKey db 02bh, 028h, 0abh, 009h
              db 07eh, 0aeh, 0f7h, 0cfh
              db 015h, 0d2h, 015h, 04fh
              db 016h, 0a6h, 088h, 03ch
              
    newKey db 16 dup(?)
    rcon db 01  
              

      
.code segment       
    
start:
    ; Initialize the state pointer
    mov ax, @data
    mov ds, ax

    mov si, offset state
    ;call ShiftRows
    ;call mix_columns     
    call keySchdule
    hlt
       
 
 keySchdule proc
                    
    mov al,cipherKey[3]
    mov newKey[11], al 
                
    mov al,cipherKey[7]
    mov newKey[0], al 
    
    mov al,cipherKey[11]
    mov newKey[3], al
    
    mov al,cipherKey[15]
    mov newKey[7], al    
    
    mov al,newKey[3]
    call subBytes  
    mov newKey[3],al
    
    mov al,newKey[7]
    call subBytes  
    mov newKey[7],al
    
    mov al,newKey[11]
    call subBytes  
    mov newKey[11],al
    
    mov al,newKey[0]
    call subBytes  
    mov newKey[0],al
    
    mov si, 0
    
    mov al,newKey[0]
    mov bl, cipherKey[0]   
    xor al, bl
    
       
    ret
 endp      
 
     subBytes proc ; after procedure call the value of the substituted byte will be in the al register       
        mov ah, 0       
        mov si,ax ; puts the position in the array in si register to use it to address the array
        mov al, sboxArray[si]    ; retrives the value from the "2d" array     
        ret
    subBytes endp

; Mix Columns Transformation
mix_columns proc
    ; Process each column
    mov cx, 4      ; Process 4 columns
    mov di, offset tmp    ; Temporary storage pointer
    
process_column:   ; Load one column into registers                                                                                                           
    ; Perform the Mix Columns transformation for the first byte
    ; tmp0 = 2 * a0 + 3 * a1 + 1 * a2 + 1 * a3
    mov al, [si]       ; Load a0
    call mult2         ; 2 * a0
    mov ah, al         ; Store 2 * a0 in ah
    mov al, [si + 4]   ; Load a1
    call mult3         ; 3 * a1
    xor ah, al         ; 2 * a0 + 3 * a1
    mov al, [si + 8]   ; Load a2
    xor ah, al         ; 2 * a0 + 3 * a1 + a2
    mov al, [si + 12]  ; Load a3
    xor ah, al         ; 2 * a0 + 3 * a1 + a2 + a3 
    mov al,0
    mov [di], ah       ; Store result in tmp[0, col]

    ; Perform the Mix Columns transformation for the second byte
    ; tmp1 = 1 * a0 + 2 * a1 + 3 * a2 + 1 * a3
    mov al, [si + 4]   ; Load a1
    call mult2         ; 2 * a1
    mov ah, al         ; Store 2 * a1 in ah
    mov al, [si + 8]   ; Load a2
    call mult3         ; 3 * a2
    xor ah, al         ; 2 * a1 + 3 * a2
    mov al, [si]       ; Load a0
    xor ah, al         ; a0 + 2 * a1 + 3 * a2
    mov al, [si + 12]  ; Load a3
    xor ah, al         ; a0 + 2 * a1 + 3 * a2 + a3
    mov al,0
    mov [di + 4], ah   ; Store result in tmp[1, col]

    ; Perform the Mix Columns transformation for the third byte
    ; tmp2 = 1 * a0 + 1 * a1 + 2 * a2 + 3 * a3
    mov al, [si + 8]   ; Load a2
    call mult2         ; 2 * a2
    mov ah, al         ; Store 2 * a2 in ah
    mov al, [si + 12]  ; Load a3
    call mult3         ; 3 * a3
    xor ah, al         ; 2 * a2 + 3 * a3
    mov al, [si]       ; Load a0
    xor ah, al         ; a0 + 2 * a2 + 3 * a3
    mov al, [si + 4]   ; Load a1
    xor ah, al         ; a0 + a1 + 2 * a2 + 3 * a3
    mov al,0
    mov [di + 8], ah   ; Store result in tmp[2, col]

    ; Perform the Mix Columns transformation for the fourth byte
    ; tmp3 = 3 * a0 + 1 * a1 + 1 * a2 + 2 * a3
    mov al, [si]       ; Load a0
    call mult3         ; 3 * a0
    mov ah, al         ; Store 3 * a0 in ah
    mov al, [si + 12]  ; Load a3
    call mult2         ; 2 * a3
    xor ah, al         ; 3 * a0 + 2 * a3
    mov al, [si + 4]   ; Load a1
    xor ah, al         ; 3 * a0 + a1 + 2 * a3
    mov al, [si + 8]   ; Load a2
    xor ah, al         ; 3 * a0 + a1 + a2 + 2 * a3
    mov al,0
    mov [di + 12], ah  ; Store result in tmp[3, col]

    ; Move to the next column
    add si, 1
    add di, 1
    loop process_column
    
    
    mov si, offset state 
    mov di, offset tmp
    ;add si, 15 
    mov cx, 16
    returnToOriginal:
        mov bh,[di]
        mov [si], bh
        inc si
        inc di
    loop returnToOriginal
    RET  
    
    mix_columns endp  
    
    mult2 proc
        ; AL already contains the byte to be multiplied by 2
        test al, 80h ; Check the most significant bit
        shl al, 1    ; Multiply by 2
        jnc skipXor  ; If no carry, skip the XOR
        xor al, 1bh  ; XOR with 1B if carry is set
    skipXor:
        ret
    mult2 endp
    
    ; Procedure to multiply by 3 (2*num + num)
    mult3 proc
        mov bl, al
        call mult2    ; Multiply by 2 (result is in AL)
        xor al, bl    ; Add the original value (equivalent to multiplying by 3)
        ret
    mult3 endp 



    
    
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
    
   AddRoundKey    MACRO  a1,a2  
    
    mov si,0
    theloop:  
            mov bl,[a1+si]
            xor bl ,[a2+si]
            mov [a1+si],bl
            inc si
            cmp si,16
            jnz theloop  
    
    ENDM


