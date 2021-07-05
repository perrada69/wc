maketab
        LD B,192
        LD DE,16384
        LD HL,tabvram
maketab2
        LD (HL),E
        INC HL
        LD (HL),D
        INC HL
        EX DE,HL
        CALL downhl
        EX DE,HL
        DJNZ maketab2
        RET

downhl
        INC H
        LD A,H
        AND 7
        RET NZ
        LD A,L
        ADD A,32
        LD L,A
        LD A,H
        JR C,downhl2
        SUB 8
        LD H,A

downhl2
        CP 88
        RET C
        LD H,64
        RET

