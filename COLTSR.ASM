.model tiny
codeseg
.386
org 100h
Int2FKennung equ 0f3h
; (c) 2001 by Hawkynt
;-----------------------------C-O-D-E-------------------------------------------

Dos macro Func
  mov	 ah,Func
  int	 21h
endm

start:
  jmp    @ColourInstall
;------------------------------------D-A-T-A------------------------------------
Go db 0
Active db 0
Tab db 33 dup (0) ;empty
db 1  dup (9) ;char
db 1  dup (4) ;"
db 5  dup (9) ;char
db 1  dup (8) ;(
db 1  dup (8) ;)
db 1  dup (2) ;*
db 1  dup (2) ;+
db 1  dup (9) ;char
db 1  dup (2) ;-
db 1  dup (9) ;char
db 1  dup (2) ;/
db 10 dup (11);numbers
db 3  dup (9) ;char
db 1  dup (14);=
db 3  dup (9) ;char
db 26 dup (0) ;empty Capitals
db 1  dup (8) ;[
db 1  dup (2) ;\
db 1  dup (8) ;]
db 3  dup (9) ;char
db 26 dup (0) ;empty Letters
db 4  dup (9) ;char
db 129 dup (0);empty
;***********************I*N*T*S*************************************************

Int2FHandler proc far
  cmp	 ah, Int2FKennung
  je	 @forme
  db	 0eah
  Old2F  dw ?,? 		; old int...
@forme:
  cmp	 al,1			; function: return codeseg
  je	 @GetSegm
  mov	 al,ah
  ror	 al,2			; inverse kennung...
  iret
@GetSegm:
  push	 cs
  pop	 es
  iret
Int2FHandler endp

Int16Handler proc far
  push   bx
  xor    bx,bx
  or     ah,ah
  setz   bl
  cmp    ah,10h
  sete   bh
  or     bl,bh                  ; combine...
i16@no:
  pushf
  db	 9Ah
  Old16  dw ?,?
  pushf                         ; saves result flags...
  or     bl,bl
  jz     i16@exit
  mov    cs:[Go],1
i16@exit:
  popf
  pop    bx
  retf   2
Int16Handler endp

Int1CHandler proc far
  cmp    cs:[active],1
  je     i1c@end

  pusha
  push   ds

  mov    ax,0b800h
  push	 040h
  pop    ds
  movzx  bx,byte ptr ds:[062h]  ; pagenum...
  mov    cx,ds:[04ch]
  mov    dx,ds:[04ch]           ; pagesize in byte

  shr	 dx,4			; convert to segment...
  cmp	 bx,0
  jz	 i@gotaddress
i@incloop:
  add	 ax,dx			; add pagesize
  dec	 bx
  jnz	 i@incloop
i@gotaddress:
  mov    ds,ax
  xor    si,si
  shr    cx,1

  cmp    ds:[1],byte ptr 8
  jne    i1c@go

  cmp    cs:[go],1
  jne    i1c@bye

i1c@go:
  mov    cs:[go],byte ptr 0
  mov    cs:[active],byte ptr 1

;Routine starts here
 ;PUSH SI
 ;PUSH AX
 ;PUSH BX
 ;PUSH CX
 ;PUSH DX
 XOR CL,CL
 XOR DX,DX
 XOR SI,SI
 XOR BH,BH
LOOP1:
 CMP DX,80      ;Check for End of Line
 JNE LOOP5
 XOR DX,DX
 XOR CL,CL
LOOP5:
 ;LODSW                   ;MOV AX,DS:[SI];INC SI;INC SI
 ;MOVZX BX,AL             ;MOV BL,AL;XOR BH,BH
 MOV BL,DS:[SI]           ;Character in BL
 MOV AL,CS:[offset Tab+bx];Color in AL
 CMP BX,34               ;Compare with quotes "
 JNE LOOP6
 XOR CL,1                ;Change flag on "
LOOP6:
 CMP CL,1                ;FLAG=1?
 JNE LOOP3
 OR AL,AL                ;all strings default to 5 or table value
 JNZ LOOP3
 MOV AL,5                ;Check for "; otherwise, STRING <-STRINGCOL
LOOP3:
 OR AL,AL
 JZ LOOP2
 MOV AH,DS:[SI+1]        ;Read Color
 AND AL,15
 SHR AH,4
 CMP AL,AH               ;COLOR=NEWCOL
 JE LOOP2
 SHL AH,4
 OR AH,AL
 MOV DS:[SI+1],AH        ;IF NOT SET NEWCOL
LOOP2:
 INC DX
 INC SI
 INC SI
 CMP SI,4002
 JNE LOOP1
 ;POP DX
 ;POP CX
 ;POP BX
 ;POP AX
 ;POP SI

i1c@bye:
  mov    ds:[1],byte ptr 8
  pop    ds
  popa
  mov    cs:[active],0
i1c@end:
  db     0eah
  Old1c  dw ?,?
Int1CHandler endp

Transient Label Word

@ColourInstall:
  mov	 ah,Int2fKennung
  xor	 al,al
  push	 ax
  int	 2fh			; already installed?
  pop	 bx
  ror	 bh,2
  or	 al,al
  jz	 @install
  cmp	 bh,al
  je	 @already
  mov	 ah,9
  lea	 dx,BelegtMsg
  jmp	 @@quit
@already:
  mov	 al,1
  int	 2fh
  mov	 si,es

  mov    al,2fh
  Dos	 35h
  mov	 bx,es
  cmp	 bx,si
  jne	 @noway

  mov    es,si

  mov    al,16h
  Dos	 35h
  mov	 bx,es
  cmp	 bx,si
  jne    @noway

  mov    es,si

  mov    al,1ch
  Dos	 35h
  mov	 bx,es
  cmp	 bx,si
  jne	 @noway

  mov    es,si

  mov    al,2fh
  mov	 dx,es:[Old2f]
  mov	 ds,es:[Old2f+2]
  Dos	 25h

  mov	 al,16h
  mov	 dx,es:[Old16]
  mov	 ds,es:[Old16+2]
  Dos	 25h

  mov    al,1ch
  mov    dx,es:[Old1c]
  mov    ds,es:[Old1c+2]
  Dos	 25h

  Dos    49h                    ; free mem...

  push   cs
  pop    ds

  lea    dx, FreeMsg
  Dos	 9
@@quit:
  xor	 al,al
  Dos	 4ch
@noway:
  lea	 dx,NoRemoveMsg
  Dos	 9
  jmp	 @@quit
@install:
  mov    al,2fh
  Dos	 35h
  mov	 [Old2f],bx
  mov	 [Old2f+2],es
  lea	 dx, Int2fHandler
  Dos	 25h

  mov	 al,16h
  Dos	 35h
  mov	 [Old16],bx
  mov	 [Old16+2],es
  lea	 dx, Int16Handler
  Dos	 25h

  mov    al,1ch
  Dos	 35h
  mov    [Old1c],bx
  mov    [Old1c+2],es
  lea    dx, Int1cHandler
  Dos	 25h

  mov	 es,cs:[2ch]
  Dos	 49h

  lea	 dx,InstallMsg
  Dos	 09h

  lea	 dx,Transient
  shr	 dx,4
  inc    dx
  Dos    31h

BelegtMsg db "Can't Hook",0dh,0ah,36
NoRemoveMsg db "Unable 2 Remove",0dh,0ah,36
InstallMsg db "Handler installed !",0dh,0ah,36
FreeMsg db "Freed Memory",0dh,0ah,36
end start
