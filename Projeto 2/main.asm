
_INTERRUPCAO_HIGH:

;main.c,20 :: 		void INTERRUPCAO_HIGH() iv 0x0008 ics ICS_AUTO {
;main.c,31 :: 		if(INTCON.INT0IF)  // verifica se a INT0 ocorreu
	BTFSS       INTCON+0, 1 
	GOTO        L_INTERRUPCAO_HIGH0
;main.c,34 :: 		flag_isStarted = 1;
	MOVLW       1
	MOVWF       _flag_isStarted+0 
;main.c,35 :: 		tmr0h_save = TMR0H_1000ms;
	MOVLW       11
	MOVWF       _tmr0h_save+0 
;main.c,36 :: 		tmr0l_save = TMR0L_1000ms;
	MOVLW       220
	MOVWF       _tmr0l_save+0 
;main.c,37 :: 		ucContador = -1; LedDisplay(++ucContador);
	MOVLW       255
	MOVWF       _ucContador+0 
	CLRF        _ucContador+0 
	CLRF        FARG_LedDisplay_value+0 
	CALL        _LedDisplay+0, 0
;main.c,38 :: 		resetTimer();
	CALL        _resetTimer+0, 0
;main.c,40 :: 		INTCON.INT0IF = 0;
	BCF         INTCON+0, 1 
;main.c,41 :: 		}
L_INTERRUPCAO_HIGH0:
;main.c,44 :: 		if(INTCON3.INT1IF)         // verifica se a INT1 ocorreu
	BTFSS       INTCON3+0, 0 
	GOTO        L_INTERRUPCAO_HIGH1
;main.c,47 :: 		flag_isStarted = 1;
	MOVLW       1
	MOVWF       _flag_isStarted+0 
;main.c,48 :: 		tmr0h_save = TMR0H_250ms;
	MOVLW       194
	MOVWF       _tmr0h_save+0 
;main.c,49 :: 		tmr0l_save = TMR0L_250ms;
	MOVLW       247
	MOVWF       _tmr0l_save+0 
;main.c,50 :: 		ucContador = -1; LedDisplay(++ucContador);
	MOVLW       255
	MOVWF       _ucContador+0 
	CLRF        _ucContador+0 
	CLRF        FARG_LedDisplay_value+0 
	CALL        _LedDisplay+0, 0
;main.c,51 :: 		resetTimer();
	CALL        _resetTimer+0, 0
;main.c,53 :: 		INTCON3.INT1IF = 0;
	BCF         INTCON3+0, 0 
;main.c,54 :: 		}
L_INTERRUPCAO_HIGH1:
;main.c,56 :: 		if(INTCON.TMR0IF && flag_isStarted)    //Foi o TIMER0 que gerou a interrupção ?
	BTFSS       INTCON+0, 2 
	GOTO        L_INTERRUPCAO_HIGH4
	MOVF        _flag_isStarted+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_INTERRUPCAO_HIGH4
L__INTERRUPCAO_HIGH21:
;main.c,58 :: 		LedDisplay(++ucContador);
	INCF        _ucContador+0, 1 
	MOVF        _ucContador+0, 0 
	MOVWF       FARG_LedDisplay_value+0 
	CALL        _LedDisplay+0, 0
;main.c,59 :: 		if(ucContador>=9) ucContador = -1;
	MOVLW       128
	XORWF       _ucContador+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       9
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_INTERRUPCAO_HIGH5
	MOVLW       255
	MOVWF       _ucContador+0 
L_INTERRUPCAO_HIGH5:
;main.c,60 :: 		resetTimer();
	CALL        _resetTimer+0, 0
;main.c,62 :: 		}
L_INTERRUPCAO_HIGH4:
;main.c,64 :: 		}       // Fim do atendimento à interrupção
L_end_INTERRUPCAO_HIGH:
L__INTERRUPCAO_HIGH23:
	RETFIE      1
; end of _INTERRUPCAO_HIGH

_resetTimer:

;main.c,66 :: 		void resetTimer(){
;main.c,68 :: 		TMR0H = tmr0h_save;          //Recarregar o TIMER para 200ms
	MOVF        _tmr0h_save+0, 0 
	MOVWF       TMR0H+0 
;main.c,69 :: 		TMR0L = tmr0l_save;
	MOVF        _tmr0l_save+0, 0 
	MOVWF       TMR0L+0 
;main.c,71 :: 		INTCON.TMR0IF = 0;   //Não esquecer de zerar a Flag, pois é responsável por
	BCF         INTCON+0, 2 
;main.c,73 :: 		}
L_end_resetTimer:
	RETURN      0
; end of _resetTimer

_ConfigMCU:

;main.c,75 :: 		void ConfigMCU()
;main.c,77 :: 		ADCON1 |= 0X0F;    // pinos do microcontrolador como digitais
	MOVLW       15
	IORWF       ADCON1+0, 1 
;main.c,79 :: 		TRISD = 0;       //Configurar os pinos de controle dos LEDs
	CLRF        TRISD+0 
;main.c,80 :: 		PORTD = 0;      // inicialmente desligado
	CLRF        PORTD+0 
;main.c,83 :: 		INTCON2.RBPU = 0; //RBPU é barrado, portanto acionado em 0
	BCF         INTCON2+0, 7 
;main.c,86 :: 		}
L_end_ConfigMCU:
	RETURN      0
; end of _ConfigMCU

_ConfigTIMER:

;main.c,88 :: 		void ConfigTIMER()
;main.c,98 :: 		T0CON = 0B00000100;  //TIMER_OFF, MOD_16BITS, TIMER, PRES_1:32
	MOVLW       4
	MOVWF       T0CON+0 
;main.c,99 :: 		resetTimer();
	CALL        _resetTimer+0, 0
;main.c,100 :: 		INTCON.TMR0IE = 1;
	BSF         INTCON+0, 5 
;main.c,101 :: 		T0CON.TMR0ON = 1;   //Liga o TIMER0
	BSF         T0CON+0, 7 
;main.c,102 :: 		}
L_end_ConfigTIMER:
	RETURN      0
; end of _ConfigTIMER

_ConfigInterrupt:

;main.c,104 :: 		void ConfigInterrupt()
;main.c,106 :: 		INTCON.GIE = 1;   //Chave Geral, Habilita o uso de interrupção
	BSF         INTCON+0, 7 
;main.c,107 :: 		RCON.IPEN = 0; //0 -> (default) herança da família PIC16F, onde existe apenas
	BCF         RCON+0, 7 
;main.c,111 :: 		TRISB.RB0 = 1;        //Pino RB0/INT0 como entrada
	BSF         TRISB+0, 0 
;main.c,112 :: 		INTCON2.INTEDG0 = 0 ;   //borda da INT0 descida
	BCF         INTCON2+0, 6 
;main.c,113 :: 		INTCON.INT0IF = 0;    //Flag responsável em gerar/acionar a interrupção
	BCF         INTCON+0, 1 
;main.c,114 :: 		INTCON.INT0IE = 1;  //Habilita a interrupção específica INT0
	BSF         INTCON+0, 4 
;main.c,116 :: 		TRISB.RB1 = 1;     // pino RB1/INT1 como entrada
	BSF         TRISB+0, 1 
;main.c,117 :: 		INTCON2.INTEDG1 = 0 ;   //borda da INT1 descida
	BCF         INTCON2+0, 5 
;main.c,118 :: 		INTCON3.INT1IF = 0;   // zera a flag da INT0 (vai p/ 1 quando a interrupção ocorrer)
	BCF         INTCON3+0, 0 
;main.c,119 :: 		INTCON3.INT1IE = 1;       // habilita interrupção INT1
	BSF         INTCON3+0, 3 
;main.c,125 :: 		}
L_end_ConfigInterrupt:
	RETURN      0
; end of _ConfigInterrupt

_LedDisplay:

;main.c,127 :: 		void LedDisplay(unsigned char value)  // Funcao para iluminar display 7seg
;main.c,129 :: 		switch (value)
	GOTO        L_LedDisplay6
;main.c,131 :: 		case 0:{ latd = 0b00111111; break;}   // 0 no display de 7seg.
L_LedDisplay8:
	MOVLW       63
	MOVWF       LATD+0 
	GOTO        L_LedDisplay7
;main.c,132 :: 		case 1:{ latd = 0b00000110; break;}   // 1 no display de 7seg.
L_LedDisplay9:
	MOVLW       6
	MOVWF       LATD+0 
	GOTO        L_LedDisplay7
;main.c,133 :: 		case 2:{ latd = 0b01011011; break;}   // 2 no display de 7seg.
L_LedDisplay10:
	MOVLW       91
	MOVWF       LATD+0 
	GOTO        L_LedDisplay7
;main.c,134 :: 		case 3:{ latd = 0b01001111; break;}   // 3 no display de 7seg.
L_LedDisplay11:
	MOVLW       79
	MOVWF       LATD+0 
	GOTO        L_LedDisplay7
;main.c,135 :: 		case 4:{ latd = 0b01100110; break;}   // 4 no display de 7seg.
L_LedDisplay12:
	MOVLW       102
	MOVWF       LATD+0 
	GOTO        L_LedDisplay7
;main.c,136 :: 		case 5:{ latd = 0b01101101; break;}   // 5 no display de 7seg.
L_LedDisplay13:
	MOVLW       109
	MOVWF       LATD+0 
	GOTO        L_LedDisplay7
;main.c,137 :: 		case 6:{ latd = 0b01111101; break;}   // 6 no display de 7seg.
L_LedDisplay14:
	MOVLW       125
	MOVWF       LATD+0 
	GOTO        L_LedDisplay7
;main.c,138 :: 		case 7:{ latd = 0b00000111; break;}   // 7 no display de 7seg.
L_LedDisplay15:
	MOVLW       7
	MOVWF       LATD+0 
	GOTO        L_LedDisplay7
;main.c,139 :: 		case 8:{ latd = 0b01111111; break;}   // 8 no display de 7seg.
L_LedDisplay16:
	MOVLW       127
	MOVWF       LATD+0 
	GOTO        L_LedDisplay7
;main.c,140 :: 		case 9:{ latd = 0b01101111; break;}   // 9 no display de 7seg.
L_LedDisplay17:
	MOVLW       111
	MOVWF       LATD+0 
	GOTO        L_LedDisplay7
;main.c,141 :: 		default:{ PORTD =0; break;} // zera todo o PORTD e
L_LedDisplay18:
	CLRF        PORTD+0 
	GOTO        L_LedDisplay7
;main.c,143 :: 		}
L_LedDisplay6:
	MOVF        FARG_LedDisplay_value+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_LedDisplay8
	MOVF        FARG_LedDisplay_value+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_LedDisplay9
	MOVF        FARG_LedDisplay_value+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_LedDisplay10
	MOVF        FARG_LedDisplay_value+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_LedDisplay11
	MOVF        FARG_LedDisplay_value+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_LedDisplay12
	MOVF        FARG_LedDisplay_value+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L_LedDisplay13
	MOVF        FARG_LedDisplay_value+0, 0 
	XORLW       6
	BTFSC       STATUS+0, 2 
	GOTO        L_LedDisplay14
	MOVF        FARG_LedDisplay_value+0, 0 
	XORLW       7
	BTFSC       STATUS+0, 2 
	GOTO        L_LedDisplay15
	MOVF        FARG_LedDisplay_value+0, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L_LedDisplay16
	MOVF        FARG_LedDisplay_value+0, 0 
	XORLW       9
	BTFSC       STATUS+0, 2 
	GOTO        L_LedDisplay17
	GOTO        L_LedDisplay18
L_LedDisplay7:
;main.c,145 :: 		}
L_end_LedDisplay:
	RETURN      0
; end of _LedDisplay

_main:

;main.c,148 :: 		void main() {
;main.c,149 :: 		ConfigMCU();           //pinos do MCU config. para acionar os LEDS
	CALL        _ConfigMCU+0, 0
;main.c,150 :: 		ConfigTIMER();         // tempo config. e TIMER ligado
	CALL        _ConfigTIMER+0, 0
;main.c,151 :: 		ConfigInterrupt(); //Configuração global das interrupções
	CALL        _ConfigInterrupt+0, 0
;main.c,154 :: 		while(1) {  // Endless loop
L_main19:
;main.c,155 :: 		} //while
	GOTO        L_main19
;main.c,156 :: 		} //main
L_end_main:
	GOTO        $+0
; end of _main
