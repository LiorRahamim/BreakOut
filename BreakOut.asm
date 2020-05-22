                                        data segment    
    a db '___$'   
    b db '   $' 
      c db '                                             '
db 10, 13, '               |                            |'
db 10, 13, '               |                            |' 
db 10, 13, '               |                            |'
db 10, 13, '               |                            |'
db 10, 13, '               |                            |'
db 10, 13, '               |                            |'
db 10, 13, '               |                            |'
db 10, 13, '               |                            |'
db 10, 13, '               |                            |'
db 10, 13, '               |                            |'
db 10, 13, '               |                            |'
db 10, 13, '               |                            |'
db 10, 13, '               |                            |'
db 10, 13, '               |                            |'
db 10, 13, '               |                            |'
db 10, 13, '               |                            |'
db 10, 13, '               |????????????????????????????|'
db 10, 13, '               |????????????????????????????|'
db 10, 13, '               |????????????????????????????|'
db 10, 13, '               |????????????????????????????|'
db 10, 13, '               |????????????????????????????|'
db 10, 13, '               |????????????????????????????|'
db 10, 13, '               |----------------------------|$'
    
    x db 30
    y db 1 
    
    xb db 31
    yb db 10 
    
    lose db 'TRY AGAIN!$'
    
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov es, ax 
    
    mov ah, 9
    mov dl, offset c
    int 21h   
    

      call Pos1 
      call Draw 
      call BallPos                    
      call DrawBall  
again:call UpdateBall
      call Update 
      jmp again 
   
    
end: mov ax, 4c00h 
    int 21h   
    
    Pos1 proc near 
        mov ah, 2
        mov dh, y
        mov dl, x
        mov bh, 0
        int 10h 
        ret
    
    Draw proc near
        mov ah, 9
        mov dx, offset a
        int 21h
        ret 
        
    Update proc near 
        z:call UpdateBall        
        mov ah, 01h
        int 16h  
        cmp al, '4' 
        je s       
        cmp al, '6'
        jne z
        s:mov ah, 0h
        int 16h 
        cmp al, '6'
        je Right
        cmp al, '4'
        je Left  
        ret 
        
    Right proc near        
        call Pos1
        mov ah, 9
        mov dx, offset b
        int 21h 
        inc x  
        cmp x, 42
        jne f
        sub x, 1
     f: call Pos1
        call Draw  
        call Update
        ret
        
    Left proc near  
        call Pos1
        mov ah, 9
        mov dx, offset b
        int 21h 
        dec x  
        cmp x, 15
        jne ff
        inc x
   ff:  call Pos1
        call Draw
        call Update
        ret 
        
    BallPos proc near
        mov ah, 2
        mov dh, yb
        mov dl, xb 
        mov bh, 0
        int 10h
        ret
        
    DrawBall proc near
        mov ah, 2
        mov dl, 'o'
        int 21h  
        ret
        
    UpdateBall proc near 
        call col
        cmp yb, 2
        je aa              6
        jne MoveBall
        aa:
        mov al, x
        mov ah, xb
        cmp al, ah
        je MoveBallLeftDown 
        inc al
        cmp al, ah
        je MoveBallDown
        inc al
        cmp al ,ah
        je MoveBallRightDown  
        jne MoveBallUp
        ret
        
        
    MoveBall proc near 
        mov ah, 2
        mov dl, ' '
        int 21h 
        cmp bl, 0
        je MoveBallUp
        cmp bl, 1
        je MoveBallDown  
        cmp bl, 2
        je MoveBallRightDown
        cmp bl, 3
        je MoveBallLeftDown
        cmp bl, 4
        je MoveBallRightUp
        cmp bl, 5
        je MoveBallLeftUp
        ret
        
    MoveBallLeftDown proc near 
        mov bl, 3
        call BallPos
        mov ah, 2
        mov dl, ' '
        int 21h 
        dec xb
        inc yb 
        call BallPos
        call DrawBall
        ret   
        
    MoveBallLeftUp proc near 
        mov bl, 5
        call BallPos
        mov ah, 2
        mov dl, ' '
        int 21h 
        dec xb
        dec yb 
        call BallPos
        call DrawBall
        ret 
        
    MoveBallDown proc near  
        mov bl, 1
        call BallPos
        mov ah, 2
        mov dl, ' '
        int 21h
        inc yb 
        call BallPos
        call DrawBall
        ret  
        
    MoveBallRightDown proc near  
        mov bl, 2
        call BallPos
        mov ah, 2
        mov dl, ' '
        int 21h 
        inc xb
        inc yb 
        call BallPos
        call DrawBall
        ret    
        
    MoveBallRightUp proc near  
        mov bl, 4
        call BallPos
        mov ah, 2
        mov dl, ' '
        int 21h 
        inc xb
        dec yb 
        call BallPos
        call DrawBall
        ret 
        
     MoveBallUp proc near 
        mov bl, 0
        call BallPos
        mov ah, 2
        mov dl, ' '
        int 21h
        dec yb 
        call BallPos
        call DrawBall
        ret 
    
     col proc near
        call BallPos
        cmp xb, 43
        jne at
        cmp bl, 2
        je MoveBallLeftDown
        jne MoveBallLeftUp
    at: cmp yb, 22
        jne af
        cmp bl, 3
        je MoveBallLeftUp
        cmp bl, 1
        je MoveBallUp
        jne MoveBallRightUp
    af: cmp xb, 16
        jne att
        cmp bl, 5
        je MoveBallRightUp
        jne MoveBallRightDown
   att: cmp  yb, 1 
        jne aff
        mov ah, 2
        mov dh, 10
        mov dl, 50
        mov bh, 0
        int 10h  
        mov ah, 9
        mov dx, offset lose
        int 21h
        jmp end
   aff: ret
        
         
        
         
ends

end start 
