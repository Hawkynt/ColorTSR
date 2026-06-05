.model tiny
.386
.code
org 100h
; CHKCOLOR - behavioral test probe for COLTSR
;
; Writes known characters with attribute 07h directly into text video
; memory (B800:0000), waits a few timer ticks so the resident INT 1Ch
; handler gets a chance to run, then reads the attribute bytes back.
;
; stdout (redirectable):
;   COLORIZED - every probe carries the colour COLTSR's table predicts
;   UNCHANGED - every probe still has its original attribute 07h
;   MISMATCH  - anything else (partial/incorrect colouring)
; exit code: 0 = COLORIZED, 1 = UNCHANGED, 2 = MISMATCH

ProbeRow    equ 10                  ; screen row used for the probes
ProbeOfs    equ ProbeRow*80*2       ; byte offset into B800:0000
BoundaryOfs equ (25*80-1)*2         ; last visible cell (row 24, col 79)

start:
  jmp    @main

; probe table: character, expected colour nibble (0 = must stay unchanged)
Probes      db 'A',0                ; letter        -> table empty, untouched
            db '0',0bh              ; digit, lower boundary of 0-9 range
            db '9',0bh              ; digit, upper boundary of 0-9 range
            db '=',0eh              ; assignment
            db '(',08h              ; bracket
            db '"',04h              ; opening quote
            db 'X',05h              ; letter inside string -> string colour
            db '"',04h              ; closing quote
ProbeCount  equ ($-Probes)/2

FlagsOk     db 1                    ; all probes match predicted colours
FlagsRaw    db 1                    ; all probes still carry 07h

MsgColorized db "COLORIZED",0dh,0ah,'$'
MsgUnchanged db "UNCHANGED",0dh,0ah,'$'
MsgMismatch  db "MISMATCH",0dh,0ah,'$'

; checks one cell: expected colour nibble in DL, attribute address ES:DI+1
; clears FlagsOk/FlagsRaw accordingly
CheckCell proc near
  mov    al,es:[di+1]
  mov    dh,dl
  or     dh,dh
  jnz    @@havecolour
  mov    dh,07h                     ; nibble 0 -> cell must stay 07h
@@havecolour:
  cmp    al,dh
  je     @@okdone
  mov    [FlagsOk],0
@@okdone:
  cmp    al,07h
  je     @@rawdone
  mov    [FlagsRaw],0
@@rawdone:
  ret
CheckCell endp

@main:
  mov    ax,0003h                   ; clean 80x25 text screen, page 0
  int    10h

  mov    ax,0b800h
  mov    es,ax

  ; place the probes in ProbeRow with a neutral attribute
  mov    di,ProbeOfs
  mov    si,offset Probes
  mov    cx,ProbeCount
@@place:
  lodsb
  mov    ah,07h
  stosw
  inc    si                         ; skip expected-colour byte
  loop   @@place

  ; boundary probe: very last visible cell must be processed too
  mov    word ptr es:[BoundaryOfs],0700h+'9'

  ; wait >= 4 BIOS timer ticks (~220ms) so INT 1Ch fires several times
  push   es
  push   40h
  pop    es
  mov    bx,es:[6ch]
@@tickwait:
  mov    ax,es:[6ch]
  sub    ax,bx
  cmp    ax,4
  jb     @@tickwait
  pop    es

  ; verify the probe cells
  mov    si,offset Probes
  mov    di,ProbeOfs
  mov    cx,ProbeCount
@@check:
  inc    si                         ; skip character byte
  lodsb
  mov    dl,al
  call   CheckCell
  add    di,2
  loop   @@check

  ; verify the boundary cell ('9' -> digit colour)
  mov    di,BoundaryOfs
  mov    dl,0bh
  call   CheckCell

  ; report
  cmp    [FlagsOk],1
  jne    @@notok
  lea    dx,MsgColorized
  xor    bl,bl
  jmp    @@print
@@notok:
  cmp    [FlagsRaw],1
  jne    @@broken
  lea    dx,MsgUnchanged
  mov    bl,1
  jmp    @@print
@@broken:
  lea    dx,MsgMismatch
  mov    bl,2
@@print:
  mov    ah,9
  int    21h
  mov    al,bl
  mov    ah,4ch
  int    21h
end start
