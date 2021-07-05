pocitadlo
        NOP

pozice
        LD (X),HL
        LD A,L
        OR H
        JR Z,nula_pos

        PUSH HL                 ;uloz X a Y



        LD L,H                  ;dej Y do reg HL
        LD H,0
        ADD HL,HL               ;vynasob 2

        LD DE,tabvram
        ADD HL,DE
        LD A,(HL)
        INC HL
        LD H,(HL)
        LD L,A
        EX DE,HL

        POP HL

        LD H,0
        ADD HL,DE
        LD (printpos),HL

        RET
nula_pos
        LD HL,$4000
        LD (printpos),HL
        RET

enter
        LD HL,(X)
        LD A,H
        ADD A,8
        LD H,A
        XOR A
        LD L,A


        LD (X),HL
        RET

print_char
        PUSH AF
        EXX
        LD L,A
        LD H,0
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        LD BC,font-256

        ADD HL,BC

        PUSH HL
        LD HL,(X)
        CALL pozice
        POP HL
        LD DE,(printpos)
        PUSH DE
        LD B,8
char1a
        LD A,(HL)
        LD (DE),A
        INC HL
        INC D
        DJNZ char1a
        POP DE
        INC E
        JR NZ,char1b
        LD A,D
        ADD A,8
        LD D,A
        CP 88
        JR C,char1b
        LD D,64

char1b  LD HL,X
        INC (HL)
        LD (printpos),DE
        EXX
        POP AF
        RET

printpos
        DW 16384

X       DEFB 0
Y       DEFB 0

        RET

tabvram DEFS 192 * 2
        DS -$&$ff
font    INCBIN "font.bin"
sss
ppp     EQU sss - font
