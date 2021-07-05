TX       EQU  $133B
RX       EQU  $143B
delka_bufferu EQU 600
         ORG $,$2000

START
ZA
        PUSH HL
        NEXTREG 2,0
        LD B,25
w       HALT
        DJNZ w

        LD DE,ParametryBuffer
        LD BC,128
        LDIR
        CALL maketab

        LD HL,$4000
        LD DE,$4001
        LD BC,6144
        XOR A
        LD (HL),A
        LDIR
        LD A,%00111000
        LD (HL),A
        LD BC,767
        LDIR
        LD HL,80*256+3
        CALL pozice
        CALL CLEAR

;        LD HL,24
;        CALL pozice
;        LD HL,list
;        CALL PRINT

;        LD HL,32*256+0
;        CALL pozice
;        LD HL,ParametryBuffer
;        CALL PRINT

        POP HL
        LD A,L
        OR H
        JP Z,gui

        LD HL,ParametryBuffer
        LD DE,status
        CALL find_param

        JP Z,statuscmd

        LD HL,ParametryBuffer
        LD DE,helppar
        CALL find_param

        JP Z,help

        LD HL,ParametryBuffer
        LD DE,listpar
        CALL find_param
        JR Z,list

        LD HL,ParametryBuffer
        LD DE,connectpar
        CALL find_param

        JR Z,connect

        LD A,2
        OUT (254),A
        RET

list
        LD A,201
        LD (KonecVypisu),A
        LD HL,mezera
        LD (napoveda+1),HL
        LD HL,t_list
        LD (nadpis+1),HL
        JP gui

mezera  DEFZ " "
t_list  DEFZ "List WiFi"

connect
        CALL menu

        LD HL,48*256+2
        CALL pozice
        LD HL,connecting
        CALL PRINT

        LD HL,ParametryBuffer + 8
        LD (AdresaWiFi),HL
        LD A,32                 ;hledame mezeru
        LD BC,100               ;maximalni delka nazvu WiFiny je 100 znaku
        CPIR

        LD (AdresaHesla),HL
        LD (AdresaHeslaInput+1),HL

        DEC HL
        XOR A
        LD (HL),A
conr2
        INC HL                  ;preskocime mezeru - do budoucna
                                ;preskocit vice mezer
        LD A,(HL)
        CP 13
        JR NZ,conr2

        XOR A
        LD (HL),A

        EX DE,HL
        LD HL,(AdresaHesla)
        EX DE,HL
        OR A
        SBC HL,DE
        LD A,L
        LD (CURSORI+1),A


        XOR A                   ;Vymazeme CALL INPCLEAR
        LD (VymazInput+0),A
        LD (VymazInput+1),A
        LD (VymazInput+2),A

        LD HL,(AdresaHesla)
        LD DE,(AdresaWiFi)
        OR A
        SBC HL,DE

        LD B,H
        LD C,L

        LD HL,(AdresaWiFi)
        LD DE,WLIST
        LDIR


        CALL VypisNadpis
        JP Pokracuj

AdresaWiFi
        DEFW 0

AdresaHesla
        DEFW 0

helppar DEFB "help",13,0
listpar DEFB "list",13,0

connectpar
        DEFZ "connect"
connecting
        DEFZ "Connecting..."

;Porovnavani parametru
;
;   HL ... adresa parametru
;   DE ... adresa vzoru
;
;Vystup:
;        Z .... nalezeno
;        NZ ... nenalezeno

find_param
        LD A,(DE)
        OR A
        RET Z
        CP (HL)
        JR Z,f2ano
        XOR A
        LD B,1
        OR B
        RET

f2ano   INC HL
        INC DE
        JR find_param

;Vyska ... A
NastavRozmeryOkna
        LD (v1+1),A
        LD (v2+1),A
        LD (v3+1),A
        RET

help
        LD A,72
        CALL NastavRozmeryOkna
        CALL menu
        LD HL,48*256+2
        CALL pozice
        LD HL,t_help
        CALL PRINT

        LD HL,64*256+3
        CALL pozice
        LD HL,t_help1
        CALL PRINT

        LD HL,72*256+3
        CALL pozice
        LD HL,t_help2
        CALL PRINT

        LD HL,80*256+3
        CALL pozice
        LD HL,t_help3
        CALL PRINT

        LD HL,88*256+3
        CALL pozice
        LD HL,t_help6
        CALL PRINT

        LD HL,104*256+3
        CALL pozice
        LD HL,t_help4
        CALL PRINT

        LD HL,112*256+3
        CALL pozice
        LD HL,t_help5
        CALL PRINT

        CALL VypisNadpis

        RET

t_help1 DEFZ ".wc        - start gui"
t_help2 DEFZ ".wc help   - this help"
t_help3 DEFZ ".wc status - conn. info"
t_help4 DEFZ "Connect to WiFi:"
t_help5 DEFZ ".wc connect ssid password"

t_help6 DEFZ ".wc list   - list WiFi"

statuscmd
        LD A,1
        OUT (254),A

        LD A,30
        LD (v1+1),A
        LD (v2+1),A
        LD (v3+1),A

        LD HL,64*256+4
        LD (p1+1),HL
        LD HL,72*256+4
        LD (p2+1),HL
        EI
        CALL menu

        LD HL,48*256+2
        CALL pozice
        LD HL,t_stat
        CALL PRINT

        CALL VypisNadpis

        JP wok2

VypisNadpis

        LD HL,0*256+6
        CALL pozice
        LD   HL,NAZEV
        CALL PRINT

        LD HL,16*256+2
        CALL pozice
        LD   HL,CREDIT
        CALL PRINT
        RET




t_stat  DEFZ "Status info"
t_help  DEFZ "Help"

gui
         LD   HL,BUF
         LD   DE,BUF+1
         LD   BC,512
         XOR  A
         LD   (HL),A
         LDIR

         LD   HL,WLIST
         LD   DE,WLIST+1
         LD   BC,1024
         LD   (HL),0
         LDIR

         LD HL,OUTPUT
         LD DE,OUTPUT+1
         LD BC,delka_bufferu
         LD A,255
         LD (HL),A
         LDIR

         LD HL,0*256+6
         CALL pozice

         LD   HL,NAZEV
         CALL PRINT

         LD HL,160*256+2
         CALL pozice

napoveda LD   HL,HELP

         CALL PRINT

         LD HL,16*256+2
         CALL pozice

         LD   HL,CREDIT
         CALL PRINT

         LD HL,40*256+1
         CALL pozice

         LD   HL,WCHECK
         CALL PRINT

         LD HL,24*256+4
         CALL pozice

         LD   HL,CMD1
         LD   DE,F_OK
         CALL EXECUTE

         LD   HL,CMD2
         LD   DE,F_OK
         CALL EXECUTE

         LD   HL,CMD3
         LD   DE,F_OK
         CALL EXECUTE

         LD   HL,OUTPUT
NEXTN
         LD   DE,CWLAP
         CALL FIND
         LD   DE,ST_NAME
         CALL FIND
LOOPW
         LD   A,(HL)
         CP   255
         JR   Z,AA

         CP   34
         JR   Z,NEXT_W

BUFFER   LD   DE,WLIST
         LD   (DE),A
         INC  DE
         INC  HL
         LD   (BUFFER+1),DE
         JR   LOOPW
NEXT_W
         PUSH DE

         DEC  DE
         LD   A,(DE)
         CP   34                ;hledej uvozovky

         POP  DE
         JP   Z,NEXTN           ;pokud to jsou uvozovky, tak skoc na dalsi
         XOR  A
         LD   (DE),A
         INC  DE
         PUSH HL

         LD   HL,MAX+1
         INC  (HL)
         POP  HL

         LD   (BUFFER+1),DE
         JP   NEXTN
AA
         LD   HL,WLIST
         LD   A,(HL)
         CP   255
         RET  Z

         LD   A,(MAX+1)
         CP   MAXW
         JR   C,CC

         LD   A,MAXW
         LD   (MAX+1),A
CC
         CALL menu ;vykresleni okna

         CALL PRINTWI

         LD HL,48*256+2
         CALL pozice
nadpis   LD HL,WNADPIS
         CALL PRINT

         LD A,7
         OUT  (254),A
KonecVypisu

NAV
         CALL CURSOR
         CALL ink

AD
         CP   " "
         JR   Z,AASS
         CP   13
         JR   Z,AASS

         CP   10
         JP   Z,DOWN

         CP   11
         JP   Z,UP

         CP   "m"
         JP   Z,MANUAL
         JP   NAV

AASS
                                ;stisknuty SPACE nebo ENTER
         CALL WINDOW2
         LD HL,168*256+3
         CALL pozice

         LD   HL,PSWD
         CALL PRINT

         XOR A
         LD (hvezdickuj),A

         LD   IXH,14
INPOSV   LD   HL,20652

VymazInput
         CALL INPCLR
         LD A,201
         LD (hvezdickuj),A

         LD   HL,CMD0
         LD   DE,F_OK
         CALL EXECUTE

         CALL white_border

         LD   HL,CMD4
         LD   DE,BUF
         LD   BC,CMD4_LN
         LDIR

         PUSH DE

STOP
         LD   A,(POSITION)

         CP   1
         LD   HL,WLIST




         JR   Z,NNAME0
         DEC  A
         LD   B,A

NNAME

         PUSH BC
         LD   BC,1024
         LD   A,0
         CPIR
         POP  BC

         DJNZ NNAME

NNAME0
         POP  DE

         LD   (WN+1),HL
NNAME2
         LD   A,(HL)
         LD   (DE),A
         INC  HL
         INC  DE
         OR   A
         JR   NZ,NNAME2

         LD   HL,CMD41
         LD   BC,CMD41_LN
         LDIR

AdresaHeslaInput
         LD   HL,23296
         LD   A,(CURSORI+1)
         LD   C,A
         LD   B,0
         LDIR
         LD   HL,CMD42
         LD   BC,CMD42_LN
         LDIR
AA11
         LD   HL,OUTPUT
         LD   (R0+1),HL
         LD   DE,OUTPUT+1
         LD   BC,delka_bufferu
         LD   (HL),255
         LDIR

         LD HL,168*256+3
         CALL pozice

         LD   HL,COON
         CALL PRINT

         LD   HL,BUF
         CALL SEND

         CALL NACTI

         CALL white_border

RD
         CALL CHECK
         JR   Z,RD

         CALL NACTI
POSLE
         CALL white_border
         LD   HL,OUTPUT
         LD   DE,F_WIFIOK
         CALL FIND

         LD   A,255
         CP   (HL)
         JP   NZ,WIFI_OK

         LD HL,168*256+3
         CALL pozice

         LD   HL,NOOK
         CALL PRINT
         CALL INK
         RET


WIFION   LD   BC,$203B
         LD   A,5
         OUT  (C),A
         INC  B
         IN   A,(C)
         OR   1
         OUT  (C),A
         LD   B,6
WFLOOP1  LD   DE,0
WFTIME   DEC  DE
         LD   A,D
         OR   E
         JR   NZ,WFTIME
         DJNZ WFLOOP1

         LD   B,$13
WFBUSY0  IN   A,(C)
         BIT  0,A
         JR   Z,WFBUSY0

;         LD   A,3
;         OUT  (254),A
         LD   HL,WFPOWER
WFBACK1  LD   A,(HL)
         OUT  (C),A
         EX   AF,AF'
WFBUSY   IN   A,(C)
         BIT  1,A
         JR   NZ,WFBUSY
         INC  HL
         EX   AF,AF'
         CP   10
         JR   NZ,WFBACK1
         XOR  A
         OUT  (254),A
         RET


WFPOWER  DEFB "AT+RFPOWER=0"
         DEFB 13,10

WIFIOFF
         RET

HELP     DEFB "SPACE..select"
         DEFB "   M..add SSID"
         DEFB 0

MANUAL
         LD   HL,32*7+22528
         LD   D,H
         LD   E,L
         INC  DE
         LD   BC,32*12-1

         LD   A,%00111000
         LD   (HL),A
         LDIR

         CALL menu
         CALL WINDOW2
         LD HL,168*256+3
         CALL pozice

         LD   HL,SSID
         CALL PRINT

         LD   IXH,18
         LD   HL,20652-3
         CALL INPUT

         LD   HL,23296
         LD   DE,WLIST
         LD   A,(CURSORI+1)
         LD   C,A
         LD   B,0
         LDIR
;tady jsem udelal opravu, xor a ld byl za poslednim call print
         XOR A
         LD (DE),A
Pokracuj
         LD HL,80*256+4
         CALL pozice

         LD   HL,SSID
         CALL PRINT

         LD   HL,WLIST
         CALL PRINT


         LD   A,1
         LD   (POSITION),A
         JP   AASS

SSID     DEFB "SSID: "
         DEFB 0
WCHECK   DEFB "Checking..."
         DEFB 0
COON     DEFB "Connecting..."
         DEFB 0

TOK      DEFB "Connected!!!!"
         DEFB 0
NOOK     DEFB "Not Conected!!!"
         DEFB " "
         DEFB 0

MAXW     EQU  11

WIFI_OK

         LD   HL,32*7+22528
         LD   D,H
         LD   E,L
         INC  DE
         LD   BC,32*12-1
         LD   A,%00111000
         LD   (HL),A
         LDIR

         CALL menu
         LD HL,80*256+4
         CALL pozice

         LD   HL,SSID
         CALL PRINT


WN       LD   HL,0

         CALL PRINT

         LD   HL,OUTPUT
         LD   (R0+1),HL
         LD   DE,OUTPUT+1
         LD   BC,delka_bufferu
         LD   A,255
         LD   (HL),A
         LDIR


RD2
         CALL CHECK
         JR   Z,RD2

         LD   BC,50*3
CEK2     HALT
         DEC  BC
         LD   A,B
         OR   C
         JR   NZ,CEK2


         CALL NACTI

wok2
         CALL CLEAR

         LD   HL,IP
         LD   DE,F_OK
         CALL EXECUTE

p1       LD HL,96*256+4
         CALL pozice

         LD   HL,TIP
         CALL PRINT



         LD   HL,OUTPUT
         LD   DE,F_IP
         CALL FIND

         PUSH HL
         LD   DE,UVO
         CALL FIND

         DEC  HL
         LD   (HL),0
         POP  HL
         CALL PRINT

         LD HL,OUTPUT
         LD DE,F_MAC
         CALL FIND
         PUSH HL
         LD DE,UVO
         CALL FIND

         DEC HL
         LD (HL),0

p2       LD HL,104*256+4
         CALL pozice

         LD HL,TMAC
         CALL PRINT

         POP HL
         CALL PRINT


         LD HL,168*256+3
         CALL pozice

         LD   HL,T_MEZ
         CALL PRINT

         RET
T_MEZ    DEFZ "                      "
status  DEFB "status",0

UVO      DEFB 34,0
TMAC     DEFZ "Mac: "
TIP      DEFB "Your IP: "
         DEFB 0
F_IP     DEFB "STAIP,"
         DEFB 34
         DEFB 0

F_MAC    DEFB "STAMAC,"
         DEFB 34
         DEFB 0

IP       DEFB "AT+CIFSR"
         DEFB 13,10

NACTI
         LD   HL,4096
HH
         LD   A,R
         AND  %111
         OUT  (254),A

         PUSH HL
         CALL CHECK

         JR   Z,NOHH
         LD   HL,(R0+1)
         LD   BC,RX

         IN   A,(C)

         LD   (HL),A
         INC  HL
         LD   (R0+1),HL


NOHH

         POP  HL
         DEC  HL
         LD   A,L
         OR   H
         JR   NZ,HH

         RET


F_FAIL   DEFB 10
         DEFB "FAI"
         DEFB 0

F_CONNEC DEFB "CONNECT"
         DEFB 0

F_WIFIOK DEFB 10
         DEFB "WIFI CONNEC"
         DEFB 0

UP       LD   HL,POSITION
         LD   A,(HL)
         CP   1
         JP   Z,NAV
         DEC  A
         LD   (POSITION),A
         JP   NAV


DOWN     LD   HL,POSITION
         LD   A,(HL)
MAX      CP   0
         JP   Z,NAV
         INC  A
         LD   (POSITION),A
         JP   NAV


PSWD     DEFB "Password:"
         DEFB 0

INK      EI
         HALT
         BIT  5,(IY+1)
         JR   Z,INK
         RES  5,(IY+1)

         PUSH BC
         PUSH HL
         LD   HL,0
         LD   B,L
INK2     LD   A,(HL)
         INC  HL
         AND  24
         OR   7
         OUT  (254),A
         DJNZ INK2
         POP  HL
         POP  BC
         LD   A,(23560)
         RET

CURSOR   HALT
         LD   HL,32*8+22528
         LD   D,H
         LD   E,L
         INC  DE
         LD   BC,32*12-1
         LD   A,%00111000
         LD   (HL),A
         LDIR

         LD   A,(POSITION)
         LD   B,A
         LD   HL,32*7+22528+3

         LD   DE,32

C1       ADD  HL,DE

         DJNZ C1



         LD   B,25
C2       LD   (HL),7
         INC  HL
         DJNZ C2
         RET

WINDOW
         LD   B,54
         CALL NUMX
         LD   DE,2
         ADD  HL,DE
         LD   B,27

W1
         LD   (HL),255
         INC  HL
         DJNZ W1

         LD   B,100
W15      PUSH BC
         LD   DE,27
         OR   A
         SBC  HL,DE
         CALL DOWNHL

W2
         LD   (HL),%10000000
         LD   B,25
         INC  HL

         XOR  A
WW3      LD   (HL),A
         INC  HL
         DJNZ WW3

         LD   (HL),%000000001

         INC  HL
         POP  BC
         DJNZ W15

         LD   B,27

         LD   DE,27
         OR   A
         SBC  HL,DE
W3
         LD   (HL),255
         INC  HL
         DJNZ W3
         RET

INPCLR   PUSH HL
         POP HL
INPUT    LD   (INPOS+1),HL
         LD   HL,23296
         LD   B,IXH
IN1      LD   (HL),32
         INC  HL
         DJNZ IN1
         LD   (HL),B

         RES  5,(IY+1)
         XOR  A
         LD   (CURSORI+1),A

IN2      LD   B,IXH
INPOS    LD   HL,0
         LD   (printpos),HL
         LD HL,168*256+12
         LD (X),HL
         LD   HL,23296

CURSORI  LD   C,0
IN3      LD   A,L
         CP   C
         LD   A,"_"
         CALL Z,print_char
         LD   A,(HL)
         CALL hvezdickuj
         CALL print_char
         INC  HL
         DJNZ IN3

         LD   A,L
         CP   C
         LD   A,"<"
         CALL Z,print_char

         CALL INK
         CP   7
         RET  Z
         CP   13
         JR   Z,INPCLEAR

         LD   HL,IN2
         PUSH HL
         LD   HL,CURSORI+1
         CP   8
         JR   Z,CURSLEFT
         CP   9
         JR   Z,CURSRGHT
         CP   12
         JR   Z,BCKSPACE
         CP   199
         JR   Z,DELETE
         CP   32
         RET  C
         CP   128
         RET  NC
         EX   AF,AF'

         LD   A,(HL)
         CP   IXH
         RET  NC

         INC  (HL)
         LD   L,(HL)
         DEC  L
         LD   H,23296/256

INS      LD   A,(HL)
         OR   A
         RET  Z
         EX   AF,AF'
         LD   (HL),A
         INC  HL
         JR   INS

CURSLEFT LD   A,(HL)
         OR   A
         RET  Z
         DEC  (HL)
         RET

CURSRGHT LD   A,(HL)
         CP   IXH
         RET  NC
         INC  (HL)
         RET

DELETE   LD   A,(HL)
         CP   IXH

         RET  Z
         INC  A
         JR   BCK2

BCKSPACE LD   A,(HL)
         OR   A

         RET  Z
         DEC  (HL)

BCK2     LD   L,A
         LD   H,23296/256
         LD   E,L
         LD   D,H
         DEC  E

DEL2     LD   A,(HL)
         LDI
         OR   A
         JR   NZ,DEL2
         EX   DE,HL
         DEC  HL
         LD   (HL)," "
         RET

hvezdickuj
        RET
        LD A,"*"
        RET


DOWNDE   INC  D
         LD   A,D
         AND  7
         RET  NZ
         LD   A,E
         ADD  A,32
         LD   E,A
         LD   A,D
         JR   C,DOWNDE2
         SUB  8
         LD   D,A
DOWNDE2  CP   88
         RET  C
         LD   D,64
         RET


INPCLEAR LD   DE,(INPOS+1)
         LD   C,8
INPC2    LD   B,IXH
         INC  B
         XOR  A
         PUSH DE
INPC3    LD   (DE),A
         INC  DE
         DJNZ INPC3
         POP  DE
         CALL DOWNDE
         DEC  C
         JR   NZ,INPC2
         RET

CHAR     EXX
         ADD  A,A
         LD   L,A
         SBC  A,A
         LD   C,A
         LD   H,15
         ADD  HL,HL
         ADD  HL,HL

PPOS     LD   DE,16384
         PUSH DE
         LD   B,8
CHAR2    LD   A,(HL)
;         rrca
         OR   (HL)
         XOR  C
         LD   (DE),A
         CALL DOWNDE
;         ld   a,(hl)
;         xor  c
;         ld   (de),a
;         call DOWNDE
         INC  HL
         DJNZ CHAR2

         POP  DE
         INC  E

         LD   A,E
         AND  31
         JR   NZ,CHAR3
         DEC  E
         LD   A,E
         AND  %11100000
         LD   E,A
         LD   B,16

CHAR4    CALL DOWNDE
         DJNZ CHAR4
CHAR3    LD   (PPOS+1),DE
         EXX
         RET

WINDOW2
         LD   B,163
         CALL NUMX
         LD   DE,2
         ADD  HL,DE

         LD   B,27

W21
         LD   (HL),255
         INC  HL
         DJNZ W21

         LD   B,17
W215     PUSH BC
         LD   DE,27
         OR   A
         SBC  HL,DE
         CALL DOWNHL

W22
         LD   (HL),%10000000
         LD   B,26
         XOR  A
W223     INC  HL
         LD   (HL),A
         DJNZ W223
         LD   (HL),%000000001

         INC  HL
         POP  BC
         DJNZ W215

         LD   B,27

         LD   DE,27
         OR   A
         SBC  HL,DE
W23
         LD   (HL),255
         INC  HL
         DJNZ W23
         RET


INKEY    CALL 654
         JR   NZ,INKEY
         CALL 798
         JR   NC,INKEY
         DEC  D
         LD   E,A
         JP   819

POSITION DEFB 1

NUMX     LD   HL,16384
NUMX1    CALL DOWNHL
         DJNZ NUMX1
         RET

DOWNHL   INC  H
         LD   A,H
         AND  7
         RET  NZ

         LD   A,L
         ADD  A,32
         LD   L,A
         LD   A,H
         JR   C,DOWNHL2

         SUB  8
         LD   H,A
DOWNHL2  CP   88
         RET  C
         LD   H,64
         RET

WNADPIS  DEFB "Choose a networ"
         DEFB "k:"
         DEFB 0

;vypis vsech dostupnych WiFi

PRINTWI  LD   B,MAXW
         LD   A,8*8
         LD   (YPOS+1),A
         LD   HL,WLIST
WLOP     PUSH BC
         PUSH HL
YPOS     LD   H,5*8
         LD   L,3
         CALL pozice
         POP  HL
         CALL prwifi

         POP  BC
         INC  HL
         LD   A,(HL)
         CP   255
         RET  Z

         DEC  B
         RET  Z
         LD   A,(YPOS+1)
         LD E,8
         ADD A,E
         LD   (YPOS+1),A
         JR   WLOP


CWLAP    DEFB 10
         DEFB "+CWLAP"
         DEFB 0

ST_NAME  DEFB ",",34
         DEFB 0

EXECUTE  LD   (COMMAND+1),DE
         CALL SEND

COMMAND  LD   DE,F_CLOSE
         CALL READOK

         LD   HL,OUTPUT

         LD   DE,F_ERROR
         CALL FIND
         LD   A,(HL)
         CP   255
         JP   NZ,ERROR

         RET

EXECUTE2 LD   (COMMAND1+1),DE
         CALL SEND

COMMAND1 LD   DE,F_CLOSE

         CALL READ

         LD   HL,OUTPUT

         LD   DE,F_ERROR
         CALL FIND
         LD   A,(HL)
         CP   255
         JP   NZ,ERROR

         RET


F_OK
         DEFB 10
         DEFB "OK"
         DEFB 0

F_ERROR  DEFB "ERROR"
         DEFB 0
PRINT
         LD   A,(HL)
         OR   A
         RET  Z
         CALL print_char
         INC  HL
         JR   PRINT

prwifi
        LD A,25

        LD (pocitadlo),A
prwifi0 LD A,(HL)

        OR A
        RET Z
        CALL print_char

        INC HL

        LD A,(pocitadlo)
        DEC A
        OR A
        JR Z,prwifi1
        LD (pocitadlo),A
        JR prwifi0
prwifi1
        LD D,H
        LD E,L
        INC DE
        LD BC,40
        XOR A
        CPIR
        DEC HL
        RET

;HL ... adresa vystupu
;DE ... adresa retezce, ktery
;       hledame
;Vystup ... HL adresa

FIND
         LD   (DEFAULT+1),DE
         LD   (ADR+1),HL
ADR      LD   HL,0
         LD   A,(DE)
         CP   (HL)
         JR   Z,SOUHLAS

         LD   A,(HL)
         CP   255
         RET  Z
DEFAULT  LD   DE,0
         INC  HL
         LD   (ADR+1),HL
         JR   ADR
SOUHLAS
         INC  DE
         INC  HL
         LD   (ADR+1),HL
         LD   A,(DE)
         CP   0
         RET  Z

         JR   ADR


NAZEV    DEFB "WiFi Connection 2.1"
         DEFB 0

WON      DEFB "Turning on the "
         DEFB "WiFi module"
         DEFB 0

CREDIT   DEFB "Programmed: "
         DEFB "Shrek/MB Maniax"
         DEFB 0
CREDIT2  DEFB "Team leader: "
         DEFB "Logout/CI5"
         DEFB 0

SYNCING  DEFB "Syncing..."
         DEFB 0

NEWTIME  DEFB "New time: "
         DEFB 0

UTC      DEFB " UTC"
         DEFB 0

SYNCOK   DEFB " OK"
         DEFB 0

;nastaveni datumu
RTC
         LD   BC,$203B
         OUT  (C),E
         OR   A
         DAA
         LD   BC,$273B
         OUT  (C),A
         RET

ADRDNY   LD   HL,0
         CALL TXT16
         RET

TXT16
         LD   DE,0
         PUSH DE
         EX   DE,HL
         LD   A,(DE)
         INC  DE
         LD   (T0+1),DE
         LD   HL,10000
         CALL MULT

         POP  HL
         ADD  HL,DE

         PUSH HL
         EX   DE,HL
T0       LD   DE,0
         LD   A,(DE)
         INC  DE
         LD   (T1+1),DE
         LD   HL,1000
         CALL MULT
         POP  HL
         ADD  HL,DE

         PUSH HL
         EX   DE,HL
T1       LD   DE,0
         LD   A,(DE)
         INC  DE
         LD   (T2+1),DE
         LD   HL,100
         CALL MULT
         POP  HL
         ADD  HL,DE

         PUSH HL
         EX   DE,HL
T2       LD   DE,0
         LD   A,(DE)
         INC  DE
         LD   (T3+1),DE
         LD   HL,10
         CALL MULT
         POP  HL
         ADD  HL,DE


         PUSH HL
         EX   DE,HL
T3       LD   DE,0
         LD   A,(DE)
         LD   HL,1
         CALL MULT
         POP  HL
         ADD  HL,DE

         RET


;a ... pocet cyklu
;hl .. nasobek
MULT
         LD   C,48
         OR   A
         SBC  A,C
         LD   B,A
         LD   DE,0
         EX   DE,HL
MULT1
         ADD  HL,DE
         DJNZ MULT1
         EX   DE,HL
         RET

DEN      DEFB 0
MESIC    DEFB 0
ROK      DEFB 0
HODINA   DEFB 0
MINUTA   DEFB 0
VTERINA  DEFB 0


;HL ... Divident
;C .... Divisor

;Vystup
;HL ... vysledek
;A .... zbytek

DELENO
         LD B,16

del2
         ADD  HL,HL
         RLA
         CP   C
         JR   C,$+3
         SUB  C
         INC  L
         DJNZ del2
         RET

;vstup HL
FINDIPD  LD   A,(HL)
         CP   "I"
         JR   Z,F1
         INC  HL
         JR   FINDIPD
F1       INC  HL
         LD   A,(HL)
         CP   "P"
         JR   NZ,FINDIPD
F2       INC  HL
         LD   A,(HL)
         CP   "D"
         JR   Z,MEZERA0
         JR   FINDIPD

MEZERA0  INC  HL
         LD   A,(HL)
         CP   10
         JR   NZ,MEZERA0
;v HL je adresa kde je pocet
;dni od nejake stredy

         INC  HL
         LD   (ADRDNY+1),HL

MEZERA   INC  HL
         LD   A,(HL)
         CP   32
         JR   NZ,MEZERA
         INC  HL
         RET

;hl,adresa s textem
;a ... vystup


TXT2DEC
         LD   A,(HL)
         OR   A
         SBC  A,48

         RLA
         RLA
         RLA
         RLA

         LD   E,A
         INC  HL
         LD   A,(HL)
         OR   A
         SBC  A,48
         OR   E
         RET


;zjitovani jesti mame data
;NZ .... data pripravene na
;        cteni
;Z ..... data nejsou pripravene
CHECK    LD   BC,TX
         IN   A,(C)
         BIT  0,A
         RET


F_CLOSE  DEFB 10
         DEFB "CLOSE"
         DEFB 0


READ     CALL CHECK
         PUSH AF
         LD   HL,(R0+1)
         LD   BC,RX

         IN   A,(C)

         LD   (HL),A
         INC  HL
         LD   (R0+1),HL

         POP  AF
         RET  Z
         JR   READ

READOK   EI
         LD   (CMP+1),DE
         LD   (CMP2+1),DE
         LD   DE,0
READ0    CALL CHECK
         PUSH AF
         LD   A,R
         AND  %111
         OUT  (254),A

         JR   POK
ERROR
         LD   A,2
         OUT  (254),A
;time out!!!
         LD HL,80*256+10
         CALL pozice
         LD   HL,TIMEOUT
         CALL PRINT
         RET

TIMEOUT  DEFB "Timeout!!!"
         DEFB 0
POK
         POP  AF
         JR   Z,READ0
         LD   HL,(R0+1)
         LD   BC,RX

         IN   A,(C)

         LD   (HL),A
         INC  HL
         LD   (R0+1),HL
CMP      LD   HL,F_CLOSE
POR      CP   (HL)
         JR   Z,DALSI
CMP2     LD   HL,F_CLOSE
         LD   (CMP+1),HL
         JR   READ0
DALSI
         INC  HL
         LD   (CMP+1),HL
         LD   A,(HL)
         OR   A
         JR Z,white_border
         JR   READ0

white_border
;        RET
        LD A,7
        OUT (254),A
;        XOR A
        RET

OK
         LD   BC,RX
         IN   A,(C)
         RET

R0       LD   HL,OUTPUT
R1
         LD   BC,RX
         IN   A,(C)
         LD   (HL),A
         INC  HL
         LD   (R0+1),HL
         CALL CHECK
         JR   NZ,R0
         RET

;hl ... adresa prikazu
SEND
         LD   BC,TX
AS
         IN   A,(C)
         BIT  1,A
         JR   NZ,AS

         LD   A,(HL)
         OUT  (C),A

         INC  HL

         CP   10
         JR   NZ,SEND
         RET

CLEAR
         LD   HL,4096
         LD   BC,RX
CLEAN    IN   A,(C)
         DEC  HL
         LD   A,L
         OR   H
         JR   NZ,CLEAN
         RET


CMD0     DEFB "AT+CWQAP"
         DEFB 13,10
CMD1     DEFB "AT+CIPMUX=0"
         DEFB 13,10

CMD2     DEFB "AT+CWMODE=1"
         DEFB 13,10

CMD3     DEFB "AT+CWLAP"
         DEFB 13,10


CMD4     DEFB "AT+CWJAP="

         DEFB 34

CMD4_LN  EQU  $-CMD4

CMD41
         DEFB 34,44,34
CMD41_LN EQU  3

CMD42
         DEFB 34
         DEFB 13,10
CMD42_LN EQU  3

         INCLUDE "print.odn"
         INCLUDE  "maketab.odn"
         INCLUDE "inkey.odn"
         INCLUDE "help_menu.odn"
konec

ParametryBuffer
        DEFS 128

WLIST    DEFS 1024

BUF      DEFS 512
OUTPUT   DEFS delka_bufferu
LE       EQU  konec-START

         SAVE "/dot/wc",$8000,$2000

