

ink
inkey    HALT
         XOR  A
         LD   (aLAST_KEY+1),A
         EI
ahl0
         CALL KEYSCAN

         LD   A,E
         INC  A
         JR   Z,ink
         LD   A,D
         LD   HL,SYMTAB
         CP   $18
         JR   Z,aHLSM2
         LD   HL,CAPSTAB
         CP   $27
         JR   Z,aHLSM2
         LD   HL,NORMTAB
aHLSM2   LD   D,0
         ADD  HL,DE
         LD   A,(HL)
         OR   A
         JR   Z,ink

aLAST_KEY LD   B,0
         CP   B
         JR   Z,aSEDI_KEY

aLOOP_LST HALT
aSEDI_KEY
        LD   (aLAST_KEY+1),A
        PUSH AF
        CALL beepk
        POP AF
        RET

keysound DB 1    ;key sound 0= yes,1= no, klavesnicove echo
;KeyScan od Busyho z MRSu
KEYSCAN  LD   L,47   ;testovani klavesnice
         LD   DE,65535
         LD   BC,65278
KEYLINE  IN   A,(C)
         CPL
         AND  31
         JR   Z,KEYDONE
         LD   H,A
         LD   A,L
KEY3KEYS INC  D
         RET  NZ
KEYBITS  SUB  8
         SRL  H
         JR   NC,KEYBITS
         LD   D,E
         LD   E,A
         JR   NZ,KEY3KEYS
KEYDONE  DEC  L
         RLC  B
         JR   C,KEYLINE
         LD   A,D
         INC  A
         RET  Z
         CP   40
         RET  Z
         CP   25
         RET  Z
         LD   A,E
         LD   E,D
         LD   D,A
         CP   24
         RET

SYMTAB   DB "*^[&%>}/"
         DB ",-]'$<{?"
         DB ".+($"
         DB 200
         DB "/"," "
         DB 0
         DB "=;)@"
         DB 201
         DB "|:"
         DB 32,13,34
         DB "_!"
         DB 199
         DB "~",0

CAPSTAB  DB "BHY"
         DB 10,8
         DB "TGV"
         DB "NJU"
         DB 11,5
         DB "RFC"
         DB "MKI"
         DB 9,4
         DB "EDX"
         DB 2
         DB "LO"
         DB 15,6
         DB "WSZ"
         DB 1,13,"P"
         DB 12,7
         DB "QA"

NORMTAB  DB "bhy65tgv"
         DB "nju74rfc"
         DB "mki83edx"
         DB 0
         DB "lo92wsz"
         DB 32,13
         DB "p01qa"
         DB 0

beepk  LD A,(keysound)  ;Busyho nahradni rutina,kratsi
       OR A
       RET NZ
       LD A,(BORDER)
       LD E,A
       LD B,$10
       ADD A,B
       OUT ($fe),A
       LD B,$6c
beepk1 DJNZ beepk1
       LD A,$07
       ADD A,E
       OUT ($fe),A
       RET
BORDER DB 7    ;okraj

