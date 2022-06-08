data segment
     poruka1 db "Unesite broj n (osnova 5): $"  
     poruka2 db "Fibonacci($"
     poruka3 db ") (rezultat u osnovi 15): $"
     n dw 0
     strN db "        "
     strNrez db "        "
data ends

stek segment stack
    dw 512 dup(0)
stek ends     

code segment
    
    novired proc
        push ax
        push bx
        push cx
        push dx
        mov ah,03
        mov bh,0
        int 10h
        inc dh
        mov dl,0
        mov ah,02
        int 10h
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    novired endp   
    
    writeString macro s
        push ax
        push dx  
        mov dx, offset s
        mov ah, 09
        int 21h
        pop dx
        pop ax
    endm 
    
    readString proc
            push ax
            push bx
            push cx
            push dx
            push si
            mov bp, sp
            mov dx, [bp+12]
            mov bx, dx
            mov ax, [bp+14]
            mov byte [bx] ,al
            mov ah, 0Ah
            int 21h
            mov si, dx     
            mov cl, [si+1] 
            mov ch, 0
        kopiraj:
            mov al, [si+2]
            mov [si], al
            inc si
            loop kopiraj     
            mov [si], '$'
            pop si  
            pop dx
            pop cx
            pop bx
            pop ax
            ret
    readString endp 
    
    krajPrograma macro
        mov ax, 4c02h
        int 21h
    endm

    strtoint5 proc 
            push ax
            push bx
            push cx
            push si
            mov bp, sp
            mov bx, [bp+12]
            mov ax, 0
            mov cx, 0
            mov si, 5
        petlja:
            mov cl, [bx]
            cmp cl, '$'
            je kraj1
            mul si
            sub cx, 48
            add ax, cx
            inc bx  
            jmp petlja
        kraj1:
            mov bx, [bp+10] 
            mov [bx], ax 
            pop si  
            pop cx
            pop bx
            pop ax
            ret 4
    strtoint5 endp
    
    inttostr15 proc 
            push ax
            push bx
            push cx
            push dx
            push si
            mov bp, sp
            mov ax, [bp+14] 
            mov dl, '$'
            push dx
            mov si, 15
        petlja2:
            mov dx, 0
            div si
            add dx, 48
            cmp dx, 57
            jg veceoddevet
        nastavi:    
            push dx
            cmp ax, 0
            jne petlja2
            mov bx, [bp+12]
        petlja2a:      
            pop dx
            mov [bx], dl
            inc bx
            cmp dl, '$'
            jne petlja2a
            pop si  
            pop dx
            pop cx
            pop bx
            pop ax
            ret 4
        veceoddevet:
            add dx, 7
            jmp nastavi
    inttostr15 endp

    fib proc
            push ax
            push bx
            push cx
            push dx
            push bp
            mov bp, sp
            mov ax, [bp+12]
            cmp ax, 1
            je prvi
            cmp ax, 2
            je drugi
            mov bx, ax
            dec bx
            push bx
            push bx
            call fib
            pop cx
            mov dx, cx
            dec bx
            push bx
            push bx
            call fib
            pop cx
            add dx, cx
        kraj:          
            mov [bp+14], dx
            pop bp
            pop dx
            pop cx
            pop bx
            pop ax
            ret 2
        prvi:
            mov dx, 0
            jmp kraj
        drugi:
            mov dx, 1
            jmp kraj  
    fib endp 
     
    start: 
        assume cs:code, ss:stek
        mov ax, data
        mov ds, ax
        
        call novired
        writeString poruka1
        push 9
        push offset strN
        call readString 
        push offset strN
        push offset n
        call strtoint5
        call novired
        
        mov ax, n
        push ax
        push ax
        call fib
        pop ax
        mov n, ax
        
        writeString poruka2 
        push n
        push offset strNrez
        call inttostr15
        writeString strN
        writeString poruka3
        writeString strNrez
        call novired
        krajprograma
code ends 
end start