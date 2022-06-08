data segment 
   poruka1 db "Unesite string S: $"  
   strS db "            "
   poruka2 db "Jeste.$" 
   poruka3 db "Nije.$"
ends

stack segment
    dw   128  dup(0)
ends

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

inttostr proc
   mov bp, sp
   mov ax, [bp+4] 
   mov dl, '$'
   push dx
   mov si, 10
petlja2:
   mov dx, 0
   div si
   add dx, 48
   push dx
   cmp ax, 0
   jne petlja2
   mov bx, [bp+2]
petlja2a:      
   pop dx
   mov [bx], dl
   inc bx
   cmp dl, '$'
   jne petlja2a
   ret 4
inttostr endp


keyPress macro
    push ax
    mov ah, 08
    int 21h
    pop ax
endm


krajPrograma macro
    mov ax, 4c02h
    int 21h
endm  

Palindrom proc  
    push ax
    push bx 
    push cx
    push dx
    push si
    push di
    push bp
    mov bp, sp
    mov dx, [bp+18] 
  
    cmp dx, 1
    je trivijalno
    cmp dx, 0
   je trivijalno 
  
  mov si, [bp+16]
  mov di, [bp+16]
  add si, [bp+20] 
  add di, [bp+20]
  add di, [bp+18]
  dec di
  mov al, [di]
  mov bl, [si] 
  cmp al, bl
  
   
                 
   je nastavi2
   jmp nije
   

trivijalno:
    mov cx, 1  
   jmp kraj
   
    
nije:  
   mov cx, 0
  jmp kraj
   
nastavi2: 
    mov ax, [bp+16]
    mov bx, [bp+18]
    sub bx, 2
    mov dx, [bp+20]
    inc dx
    push dx
    push bx
    push ax
    call Palindrom 
  pop cx
    
   

    
kraj: 
    mov [bp+20], cx
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret 4  
    
Palindrom endp
      

start:
assume cs: code, ss: stek
    mov ax, data
    mov ds, ax  
    xor si, si
    xor di, di

 
    call novired 
    writeString poruka1
    push 10
    push offset strS
    call readString 
    call novired


duzinaS:    
    push offset strS
    mov al, StrS[di]
    cmp al, '$'
    je nastavi 
    inc di
    jmp duzinaS    

    
   
nastavi: 
    push si
    push di
    push offset strS
    call Palindrom
    pop si
    cmp si, 1
    je jeste
    writeString poruka3 
    jmp kraj2   
    
    
jeste: 
   writeString poruka2
    
kraj2:
    keypress
    krajPrograma
    
            
ends

end start
