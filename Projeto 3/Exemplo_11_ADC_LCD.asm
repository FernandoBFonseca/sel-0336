
_main:

;Exemplo_11_ADC_LCD.c,46 :: 		void main(){
;Exemplo_11_ADC_LCD.c,47 :: 		unsigned int Valor_ADC = 0;  // var. para leitura
;Exemplo_11_ADC_LCD.c,51 :: 		TRISA.RA5 = 1; // pino AN4 qeu receberá sinal analógico do potenciometro configurado como entrada
	BSF         TRISA+0, 5 
;Exemplo_11_ADC_LCD.c,52 :: 		TRISA.RA2 = 1; // pino AN2 que receberá o valor referencia externa negativo para o ADC
	BSF         TRISA+0, 2 
;Exemplo_11_ADC_LCD.c,53 :: 		TRISA.RA3 = 1; // pino AN3 que receberá o valor referencia externa postivo para o ADC
	BSF         TRISA+0, 3 
;Exemplo_11_ADC_LCD.c,56 :: 		Lcd_Init();                 // Inicializa a lib. Lcd
	CALL        _Lcd_Init+0, 0
;Exemplo_11_ADC_LCD.c,57 :: 		Lcd_Cmd(_LCD_CLEAR);       // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Exemplo_11_ADC_LCD.c,58 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);  // Cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Exemplo_11_ADC_LCD.c,59 :: 		Lcd_Out(1,1,"ADC0:");   //Escreve na Linha x Coluna do LCD o texto(valor do ADC)
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_Exemplo_11_ADC_LCD+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_Exemplo_11_ADC_LCD+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Exemplo_11_ADC_LCD.c,61 :: 		ADC_Init();
	CALL        _ADC_Init+0, 0
;Exemplo_11_ADC_LCD.c,67 :: 		ADCON1 = 0B00110000;
	MOVLW       48
	MOVWF       ADCON1+0 
;Exemplo_11_ADC_LCD.c,69 :: 		while(TRUE)
L_main0:
;Exemplo_11_ADC_LCD.c,74 :: 		ADCON0 = 0B00010001;
	MOVLW       17
	MOVWF       ADCON0+0 
;Exemplo_11_ADC_LCD.c,77 :: 		ADCON0.GO_DONE = 1;
	BSF         ADCON0+0, 1 
;Exemplo_11_ADC_LCD.c,81 :: 		while(ADCON0.GO_DONE == 1);
L_main2:
	BTFSS       ADCON0+0, 1 
	GOTO        L_main3
	GOTO        L_main2
L_main3:
;Exemplo_11_ADC_LCD.c,84 :: 		Valor_ADC = ((ADRESH << 8)| ADRESL);   // desloca o valor de ADRESH 8 bits a esquerda para combinar os valores dos registradores
	MOVF        ADRESH+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        ADRESL+0, 0 
	IORWF       R0, 1 
	MOVLW       0
	IORWF       R1, 1 
;Exemplo_11_ADC_LCD.c,87 :: 		Valor_ADC = Valor_ADC * (1000/1023.); // formata o valor de entrada (neste caso o valor de exemplo '100.0')
	CALL        _word2double+0, 0
	MOVLW       144
	MOVWF       R4 
	MOVLW       62
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       126
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2word+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVF        R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
;Exemplo_11_ADC_LCD.c,91 :: 		Tensao[0] = (Valor_ADC/1000) + '0';// div. de 2 n° inteiros - em programação
	MOVLW       48
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       main_Tensao_L0+0 
;Exemplo_11_ADC_LCD.c,95 :: 		Tensao[1] = (Valor_ADC/100)%10 + '0'; // div. de n° inteiros => 1000/100 = 0
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       main_Tensao_L0+1 
;Exemplo_11_ADC_LCD.c,99 :: 		Tensao[2] = (Valor_ADC/10)%10 + '0';  // faz similar para obter a casa das unidades
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       main_Tensao_L0+2 
;Exemplo_11_ADC_LCD.c,101 :: 		Tensao[3] = '.';  // poe o ponto decimal das virgulas
	MOVLW       46
	MOVWF       main_Tensao_L0+3 
;Exemplo_11_ADC_LCD.c,103 :: 		Tensao[4] = (Valor_ADC/1)%10 + '0';  // formata o valor da 1ª casa decimal
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       main_Tensao_L0+4 
;Exemplo_11_ADC_LCD.c,105 :: 		Tensao[5] = 0; //terminador NULL (ultima posição da matriz - zero indica o
	CLRF        main_Tensao_L0+5 
;Exemplo_11_ADC_LCD.c,114 :: 		Lcd_Out(1,6,Tensao); // Mostra os valores no display
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_Tensao_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_Tensao_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Exemplo_11_ADC_LCD.c,115 :: 		Delay_ms(20);   // atualizar display
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main4:
	DECFSZ      R13, 1, 1
	BRA         L_main4
	DECFSZ      R12, 1, 1
	BRA         L_main4
	NOP
	NOP
;Exemplo_11_ADC_LCD.c,116 :: 		}
	GOTO        L_main0
;Exemplo_11_ADC_LCD.c,117 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
