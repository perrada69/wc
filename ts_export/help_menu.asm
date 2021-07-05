

;
;            Vypise menu a napovedu k memdompu
;
;                   Shrek/MB Maniax 2021
;
;
pozice_loga  EQU $40c0+23
attr         EQU $58c0+23
sirka_okna   EQU 26
vyska_okna   EQU 112

menu

        LD HL,$40a1 - 32
v1      LD B,vyska_okna + 8
smaz_okno
        PUSH BC
        PUSH HL
        LD D,H
        LD E,L
        INC DE
        LD BC,sirka_okna
        XOR A
        LD (HL),A
        LDIR

        POP HL

        CALL downhl
        POP BC
        DJNZ smaz_okno

        LD HL,pozice_loga
        CALL kresli_logo
        LD HL,pozice_loga+1
        CALL kresli_logo
        LD HL,pozice_loga+2
        CALL kresli_logo
        LD HL,pozice_loga+3
        CALL kresli_logo
        LD HL,pozice_loga+4
        CALL kresli_logo
        LD B,sirka_okna+1
        LD HL,attr-21
a5      LD (HL),7
        INC HL
        DJNZ a5

        LD A,%00000010
        LD (attr),A

        LD A,%00010110
        LD (attr+1),A

        LD A,%00110100
        LD (attr+2),A
        LD A,%00100001
        LD (attr+3),A
        LD A,%00001000
        LD (attr+4),A
        CALL window
        RET

window
        LD HL,$40a0+2
        LD B,7

w0
        PUSH BC
        CALL downhl
        POP BC
        DJNZ w0
        PUSH HL
        LD B,8
w3      CALL downhl
        DJNZ w3
        LD (zacatek_pozice+1),HL
        POP HL
        PUSH HL
        LD B,9
zzz     CALL downhl
        DJNZ zzz
        LD B,sirka_okna+1
w4      LD (HL),255
        INC HL
        DJNZ w4
        POP HL
        LD B,sirka_okna+1

w1
        LD (HL),255
        INC HL
        DJNZ w1
        DEC HL
        LD B,8
aa      CALL downhl
        DJNZ aa
        LD (konec_pozice+1),HL

zacatek_pozice
        LD HL,0
        LD A,%10000000
v2      LD B,vyska_okna-9
        CALL cara_dolu
        CALL downhl
        LD (spodni_pozice+1),HL
konec_pozice
        LD HL,0
        LD A,1
v3      LD B,vyska_okna-8
        CALL cara_dolu

spodni_pozice
        LD HL,0
        LD B,sirka_okna+1
w2      LD (HL),255
        INC HL
        DJNZ w2

        RET

cara_dolu
        LD E,A
c0      PUSH BC

        PUSH DE
        CALL downhl
        POP DE
        LD A,(HL)
        OR E
        LD (HL),A
        POP BC
        DJNZ c0


        RET

kresli_logo
        LD DE,sprite
        LD B,8
menu0
        PUSH BC
        PUSH DE

        LD A,(DE)
        LD (HL),A

        CALL downhl

        POP DE
        INC DE
        POP BC
        DJNZ menu0
        OPT pause
        RET

sprite
        DEFB %00000001
        DEFB %00000011
        DEFB %00000111
        DEFB %00001111
        DEFB %00011111
        DEFB %00111111
        DEFB %01111111
        DEFB %11111111

