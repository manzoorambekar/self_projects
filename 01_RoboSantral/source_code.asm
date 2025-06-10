        list     P=16F877A
        __CONFIG  _CP_OFF & _WDT_OFF  & _BODEN_ON  & _PWRTE_ON  & _HS_OSC & _LVP_OFF & _CPD_OFF 
        include "P16F877A.inc"

bank0ram equ h'20'

rs       equ h'06'
e        equ h'07'
rp0      equ 05h

        cblock bank0ram
time1    
time2    
count0   
count1   
counter  
time0    
bcd1     
bcd2     
bcd3     
temp     
minu
countl   
counth   
TEMPA
TEMPB
DELAY
dat1
dat2
dat3
dat4
dat5
dat6
dat7
dat8
dat9
dat10
dat11
dat12
TMP
        Endc

        org   0x000
        goto  main

        org   0x004
        goto  GIEOFF

        org   0x005

GIEOFF: bcf INTCON,GIE    ;turn off global interrupts
        btfsc INTCON,GIE  ;Polling till set
        goto GIEOFF
        goto main

;-------------------------------------------------------------------
msgwl1:     addwf   PCL,f
 dt         "ROBOT          ",0

msgwl2:     addwf   PCL,f
 dt         "SANTRAL        ",0

msgblank:   addwf   PCL,f
 dt         "                ",0

msgmain:    addwf   PCL,f
 dt         "RFID TAG NO.    ",0
;------------------------------
display1
                movlw   d'16'
		movwf	counter
message1
                movf	counter,w
                sublw   d'16'            
                call    msgwl1             
                bsf     PORTD,rs        
                ;bcf     PORTD,rw        
                movwf   PORTB           
                call    pulse_e         
                call    t48us           
                decfsz  counter,f       
                goto    message1         
                return                  
display2
                movlw   d'16'
		movwf	counter
message2
                movf	counter,w
                sublw   d'16'            
                call    msgwl2             
                bsf     PORTD,rs        
                movwf   PORTB           
                call    pulse_e         
                call    t48us           
                decfsz  counter,f       
                goto    message2         
                return                  
dispmain
                movlw   d'16'
		movwf	counter
message3
                movf	counter,w
                sublw   d'16'            
                call    msgmain             
                bsf     PORTD,rs        
                movwf   PORTB           
                call    pulse_e         
                call    t48us           
                decfsz  counter,f       
                goto    message3         
                return                  
blanklcd1:
         movwf   FSR
ot3:
         movf    FSR,w
         incf    FSR,f
         call    msgblank
         iorlw    0
         btfsc   STATUS,2
         call    wr_data 
         return
         goto    ot3
;--------------------------------------------
XBCD:
         movlw   0
         movwf   bcd1
         movwf   bcd2
         movwf   bcd3
         bsf     STATUS,0
         movf    temp,w
         movwf   minu
         movlw   64h
hun:     subwf   minu
         incf    bcd3
         btfsc   STATUS,0
         goto    hun
         addwf   minu
         decf    bcd3
         bsf     STATUS,0
         movlw   0ah
dec:     subwf   minu
         incf    bcd2
         btfsc   STATUS,0
         goto    dec
         addwf   minu
         decf    bcd2
         movf    minu,w
         movwf   bcd1
         return
;------------------------------------------
delay10ms
	; 10ms delay routine
	bcf	STATUS,RP0
	bcf	STATUS,RP1
	clrf	TEMPA
	movlw	.5
	movwf	TEMPB
	goto	Dly1

Dly1	; the delay loop
	goto	$+1
	goto	$+1
	nop
	decfsz	TEMPA,F
	goto	Dly1
	decfsz	TEMPB,F
	goto	Dly1
	return

mscounter                     ;app 95ms delay
	movlw d'255'
	movwf time1
loop1	movlw d'124'
	movwf time2
loop2	nop
	decfsz time2,f
	goto loop2
	decfsz time1,f
	goto loop1
	return

t48us				;app 3.5ms delay
	movlw d'255'
	movwf count0
t_loop call t12us
	decfsz count0,f
	goto t_loop
	return

t12us				;12us delay
	movlw d'13'
	movwf count1
loop3	decfsz count1
	goto loop3
	return	
;------------------------------------------------------------
;LCD ROUTINES
wr_ctrl

        bcf   PORTD,rs              ;sending data to lcd
        movwf PORTB
        call  strobe
        call  t48us
        return
wr_data
        bsf   PORTD,rs
        movwf PORTB
        call  strobe
        call  t48us
        bcf   PORTD,rs
        ;bcf   PORTD,rw
        return
strobe  
        bcf   PORTD,e
        bsf   PORTD,e
        call  t48us
        bcf   PORTD,e
        return
lcdinit
        bcf   PORTD,rs              ;sending data to lcd

        bcf   PORTD,rs
	movlw h'02'
        movwf PORTB
        call  pulse_e
        call  t48us

        bcf   PORTD,rs
	movlw h'06'
        movwf PORTB
        call  pulse_e
        call  t48us

        bcf   PORTD,rs
	movlw h'01'
        movwf PORTB
        call  pulse_e
        call  t48us

        bcf   PORTD,rs
	movlw h'38'
        movwf PORTB
        call  pulse_e
        call  t48us

        bcf   PORTD,rs
	movlw d'12'
        movwf PORTB
        call  pulse_e
        call  t48us

        return
pulse_e				;enable lcd
        bsf PORTD,e
	call t12us
        bcf PORTD,e
	return
;----------------------------------------
blankline
	movwf FSR
OT4
	movf FSR,w
	incf FSR,f
	call msgblank
	iorlw 0
	btfsc STATUS,2
	return
        call wr_data
	goto OT4
blanklcd
        movlw   h'80'
        call    wr_ctrl
        movlw   h'00'
        call    blankline
        movlw   h'c0'
        call    wr_ctrl
        movlw   h'00'
        call    blankline
        return
;-------------------------------------------------
tx:                                ;transmit data
        bcf   STATUS,rp0
        btfss PIR1,TXIF
        goto  tx
        movwf TXREG
        return

rx11:   btfss  PIR1,RCIF
        goto   rx11
        movf   RCREG,w
        return

rx1:    btfss  PORTD,1
        goto   rx2
        goto   rx
rx2:    return

rx:     btfss  PIR1,RCIF
        goto   rx
        movf   RCREG,w
        ;bcf    RCSTA, CREN     ; RS232 Empfänger reset
        nop
        bsf     RCSTA, CREN
        return
;--------------------------------------
dispbcd3:
        movlw  30h
        addwf  bcd3,w
        call   tx
        call   wr_data

        movlw  30h
        addwf  bcd2,w
        call   tx
        call   wr_data

        movlw  30h
        addwf  bcd1,w
        call   tx
        call   wr_data
        return
dispbcd2:
        movlw  30h
        addwf  bcd2,w
        ;call   tx
        call   wr_data

        movlw  30h
        addwf  bcd1,w
        ;call   tx
        call   wr_data
        return
;-----------------------------------------------
getdat:
        call    rx
        movwf   dat1

        call    rx
        movwf   dat2

        call    rx
        movwf   dat3

        call    rx
        movwf   dat4

        call    rx
        movwf   dat5

        call    rx
        movwf   dat6

        call    rx
        movwf   dat7

        call    rx
        movwf   dat8

        call    rx
        movwf   dat9

        call    rx
        movwf   dat10

        call    rx
        movwf   dat11

        call    rx
        movwf   dat12

        movf    dat1,w
        call    wr_data
        movf    dat2,w
        call    wr_data
        movf    dat3,w
        call    wr_data
        movf    dat4,w
        call    wr_data
        movf    dat5,w
        call    wr_data
        movf    dat6,w
        call    wr_data
        movf    dat7,w
        call    wr_data
        movf    dat8,w
        call    wr_data
        movf    dat9,w
        call    wr_data
        movf    dat10,w
        call    wr_data

        call    mscounter
        call    mscounter
        call    mscounter
        call    mscounter
        call    mscounter
        call    mscounter
        call    mscounter
        call    mscounter
        call    mscounter
        call    mscounter
        call    mscounter
        call    mscounter
        call    mscounter
        call    mscounter
        call    mscounter
        call    mscounter
        call    mscounter
        call    mscounter

     movlw   h'01'
     lcall   wr_ctrl
                
     movlw   h'80'
     lcall   wr_ctrl

     movlw  '0'
     movwf  TMP
     movf   dat9,w
     SUBWF  TMP,w
     BTFSC  STATUS,Z
     goto   a0
     goto   a1
a0:
     movlw  'L'
     lcall  wr_data
     movlw  'O'
     lcall  wr_data
     movlw  'C'
     lcall  wr_data
     movlw  'A'
     lcall  wr_data
     movlw  'T'
     lcall  wr_data
     movlw  'I'
     lcall  wr_data
     movlw  'O'
     lcall  wr_data
     movlw  'N'
     lcall  wr_data
     movlw  '1'
     lcall  wr_data

     movlw  'P'
     call    tx
     movlw  't'
     call    tx
     movlw  'e'
     call    tx
     movlw  's'
     call    tx
     movlw  't'
     call    tx
     movlw  '1'
     call    tx

     movlw  d'13'
     call   tx

     goto   a7
a1:  
     movlw  '1'
     movwf  TMP
     movf   dat9,w
     SUBWF  TMP,w
     BTFSC  STATUS,Z
     goto   a2
     goto   a3
a2:
     movlw  'L'
     lcall  wr_data
     movlw  'O'
     lcall  wr_data
     movlw  'C'
     lcall  wr_data
     movlw  'A'
     lcall  wr_data
     movlw  'T'
     lcall  wr_data
     movlw  'I'
     lcall  wr_data
     movlw  'O'
     lcall  wr_data
     movlw  'N'
     lcall  wr_data
     movlw  '2'
     lcall  wr_data

     movlw  'P'
     call    tx
     movlw  't'
     call    tx
     movlw  'e'
     call    tx
     movlw  's'
     call    tx
     movlw  't'
     call    tx
     movlw  '2'
     call    tx

     movlw  d'13'
     call   tx

     goto   a7
a3:
     movlw  '4'
     movwf  TMP
     movf   dat9,w
     SUBWF  TMP,w
     BTFSC  STATUS,Z
     goto   a4
     goto   a5
a4:
     movlw  'L'
     lcall  wr_data
     movlw  'O'
     lcall  wr_data
     movlw  'C'
     lcall  wr_data
     movlw  'A'
     lcall  wr_data
     movlw  'T'
     lcall  wr_data
     movlw  'I'
     lcall  wr_data
     movlw  'O'
     lcall  wr_data
     movlw  'N'
     lcall  wr_data
     movlw  '3'
     lcall  wr_data

     movlw  'P'
     call    tx
     movlw  't'
     call    tx
     movlw  'e'
     call    tx
     movlw  's'
     call    tx
     movlw  't'
     call    tx
     movlw  '3'
     call    tx

     movlw  d'13'
     call   tx

     goto   a7
a5:
     movlw  '7'
     movwf  TMP
     movf   dat9,w
     SUBWF  TMP,w
     BTFSC  STATUS,Z
     goto   a6
     goto   a7
a6:
     movlw  'L'
     lcall  wr_data
     movlw  'O'
     lcall  wr_data
     movlw  'C'
     lcall  wr_data
     movlw  'A'
     lcall  wr_data
     movlw  'T'
     lcall  wr_data
     movlw  'I'
     lcall  wr_data
     movlw  'O'
     lcall  wr_data
     movlw  'N'
     lcall  wr_data
     movlw  '4'
     lcall  wr_data

     movlw  'P'
     call    tx
     movlw  't'
     call    tx
     movlw  'e'
     call    tx
     movlw  's'
     call    tx
     movlw  't'
     call    tx
     movlw  '4'
     call    tx

     movlw  d'13'
     call   tx
a7:
                bcf    PORTD,0    ;motor off
                bcf    PORTD,1    ;
                bcf    PORTD,2    ;motor off
                bcf    PORTD,3    ;

                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter

                return
;-------------------------------------------------
main            bsf   STATUS,RP0         ;bank 1 is chosen
                bcf   STATUS,RP1

                call  mscounter          ;pon delay

                movlw   b'11111111'        ;port A input
                movwf   TRISA              ;other ports output 
                movlw   b'00000000'
                movwf   TRISB
                movlw   b'11001111'
                movwf   TRISC
                movlw   b'00010000'
                movwf   TRISD

                movlw   b'00000101'
                movwf   ADCON1             ;left justified format 

                movlw   d'25'
                movwf   SPBRG
                movlw   b'00100100'
                movwf   TXSTA

                bsf    STATUS,RP0
                bsf    STATUS,RP1
               
                movlw   B'00100000'    ; pull-ups enabled
                                       ; prescaler assigned to RA4
                                       ; prescaler set to 1:8
                movwf   OPTION_REG

                bcf    STATUS,RP0
                bcf    STATUS,RP1

                movlw  b'10010000'
                movwf  RCSTA

                call    lcdinit
               
                movlw   h'80'
                lcall   wr_ctrl
               
                movlw   h'00'
                call    display1

                movlw   h'C0'
                lcall   wr_ctrl

                movlw   h'00'
                call    display2
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter
                call    mscounter

                bcf    PORTD,0    ;motor off
                bcf    PORTD,1    ;
                bcf    PORTD,2    ;motor off
                bcf    PORTD,3    ;
runprog:
;loc1
                movlw   h'01'
                lcall   wr_ctrl
                
                movlw   h'80'
                lcall   wr_ctrl
                
                movlw   h'00'
                call    dispmain   

                bcf    PORTD,0    ;motor on
                bsf    PORTD,1
                bcf    PORTD,2    ;motor off
                bsf    PORTD,3    ;
                
                movlw   h'C0'
                lcall   wr_ctrl
                call   getdat

                bcf    PORTD,0    ;motor off
                bcf    PORTD,1
                bcf    PORTD,2    ;motor off
                bcf    PORTD,3    ;

                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
;loc2
                movlw   h'01'
                lcall   wr_ctrl
                
                movlw   h'80'
                lcall   wr_ctrl
                
                movlw   h'00'
                call    dispmain   

                bcf    PORTD,0    ;motor on
                bsf    PORTD,1
                bcf    PORTD,2    ;motor off
                bsf    PORTD,3    ;
                
                movlw   h'C0'
                lcall   wr_ctrl

                call   getdat

                bcf    PORTD,0    ;motor off
                bcf    PORTD,1
                bcf    PORTD,2    ;motor off
                bcf    PORTD,3    ;

                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
;turn to right
                bcf    PORTD,0    ;
                bsf    PORTD,1
                bcf    PORTD,2    ;
                bsf    PORTD,3    ;

                call   mscounter  ;delay
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter

                call   mscounter  ;delay
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter

                bcf    PORTD,0    ;turn right
                bsf    PORTD,1
                bsf    PORTD,2   
                bcf    PORTD,3    ;
                
                call   mscounter  ;delay
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
;loc3
                movlw   h'01'
                lcall   wr_ctrl
                
                movlw   h'80'
                lcall   wr_ctrl
                movlw   h'00'
                call    dispmain   

                bcf    PORTD,0    ;motor on
                bsf    PORTD,1
                bcf    PORTD,2    ;motor off
                bsf    PORTD,3    ;
                
                movlw   h'C0'
                lcall   wr_ctrl
                call   getdat

                bcf    PORTD,0    ;motor off
                bcf    PORTD,1
                bcf    PORTD,2    ;motor off
                bcf    PORTD,3    ;

                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
;loc4
                movlw   h'01'
                lcall   wr_ctrl
                
                movlw   h'80'
                lcall   wr_ctrl
                
                movlw   h'00'
                call    dispmain   

                bcf    PORTD,0    ;motor on
                bsf    PORTD,1
                bcf    PORTD,2    ;motor off
                bsf    PORTD,3    ;
                
                movlw   h'C0'
                lcall   wr_ctrl

                call   getdat

                bcf    PORTD,0    ;motor off
                bcf    PORTD,1
                bcf    PORTD,2    ;motor off
                bcf    PORTD,3    ;

                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter
                call   mscounter

                goto   $
                end
