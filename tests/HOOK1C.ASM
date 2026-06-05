.model tiny
.386
.code
org 100h
; HOOK1C - test fixture TSR
;
; Hooks INT 1Ch in front of whatever is installed (e.g. COLTSR) and
; chains through. Once resident, COLTSR's vector check must fail and
; its removal attempt must print "Unable 2 Remove".

start:
  jmp    @install

OldVec dd ?

Handler proc far
  jmp    dword ptr cs:[OldVec]      ; chain to previous handler
Handler endp

Transient label word

@install:
  mov    ax,351ch
  int    21h
  mov    word ptr [OldVec],bx
  mov    word ptr [OldVec+2],es

  mov    ax,251ch
  lea    dx,Handler
  int    21h

  lea    dx,Msg
  mov    ah,9
  int    21h

  lea    dx,Transient
  shr    dx,4
  inc    dx
  mov    ax,3100h
  int    21h

Msg db "1C hooked",0dh,0ah,'$'
end start
