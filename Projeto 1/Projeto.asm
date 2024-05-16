org 0000h	; Coloca o programa na posicao 0000h (reset)
JMP setup	; Salta para o setup do programa

org 3h		; Coloca o programa na posicao 0003h (IE0)
MOV R0, #1h	; Altera R0 para 1 (cronometro com periodo de 25 ms)
CLR IE0		; Limpa a flag da IE0
RETI		; Retorna da interrupcao

org 13h 	; Coloca o programa na posicao 0003h (IE1)
MOV R0, #2h	; Altera R0 para 2 (cronometro com periodo de 1 s)
CLR IE1		; Limpa a flag da IE1
RETI		; Retorna da interrupcao

org 33h			; Coloca o programa na posicao 0033h
setup:			; Setup do programa
MOV R0, #0h		; Reseta R0 (cronometro parado)
MOV A, #0FFh	; Altera o digito no display (0xFFh = apagado)
SETB EA			; Habilita as interrupcoes
SETB EX0		; Habilita a interrupcao externa 0
SETB EX1		; Habilita a interrupcao externa 1
SETB IT0		; Interrupcao externa 0 no modo falling-edge
SETB IT1		; Interrupcao externa 1 no modo falling-edge
SETB P0.7		; Habilita o display
CLR P3.4		; Seleciona o display da direita
CLR P3.5		; Seleciona o display da direita

main:		; Loop principal do programa
CALL delay	; Chama a subrotina de delay
CALL print	; Chama a subrotina que exibe o digito atual
JMP main	; Salta novamente para o loop principal

delay:						; Subrotina de delay
CALL setup_delay			; Chama a subrotina de setup do delay
CJNE R1, #255, delay_end	; Caso o timer nao tenha sido setado, nao executa o delay
run_delay:					; Loop principal do delay
DJNZ R1, $					; Decrementa R1 ate zera-lo
MOV R1, #255				; Reseta R1
DJNZ R2, run_delay			; Decrementa R2 ate zera-lo
MOV R2, #255				; Reseta R2
DJNZ R3, run_delay			; Decrementa R3 ate zera-lo
ADD A, #1h					; Uma vez o timer finalizado, incrementa o digito a ser mostrado
CJNE A, #0Ah, delay_end		; Caso o proximo digito nao seja 10, finaliza o delay
MOV A, #0h				; Caso o proximo digito seja 10, altera para 0
delay_end:
RET						; Finaliza a subrotina de delay

setup_delay:			; Subrotina de setup do delay
MOV R1, #0				; Reseta R1
MOV R2, #0				; Reseta R2
MOV R3, #0				; Reseta R3
CJNE R0, #1h, case_2	; Caso R0 nao seja 1 (25 ms), verifica o proximo modo (1 s)
MOV R1, #255			; Altera R1 para 255
MOV R2, #255			; Altera R2 para 255
MOV R3, #2				; Altera R3 para 2
case_2:					; Modo 2
CJNE R0, #2h, setup_delay_end	; Caso R0 nao seja 2 (1 s), finaliza o setup do delay
MOV R1, #255			; Altera R1 para 255
MOV R2, #255			; Altera R2 para 255
MOV R3, #8				; Altera R3 para 8
setup_delay_end:
RET						; Finaliza a subrotina de setup do delay

print:				; Subrotina de print
CJNE A, #0FFh, 3h	; Caso A nao seja 0xFFh, verifica o proximo digito
MOV P1, #0FFh		; Caso A seja 0xFFh, apaga o display
CJNE A, #0, 3h		; Caso A nao seja 0, verifica o proximo digito
MOV P1, #0C0h		; Caso A seja 0, exibe no display
CJNE A, #1, 3h		; Caso A nao seja 1, verifica o proximo digito
MOV P1, #0F9h		; Caso A seja 1, exibe no display
CJNE A, #2, 3h		; Caso A nao seja 2, verifica o proximo digito
MOV P1, #0A4h		; Caso A seja 2, exibe no display
CJNE A, #3, 3h		; Caso A nao seja 3, verifica o proximo digito
MOV P1, #0B0h		; Caso A seja 3, exibe no display
CJNE A, #4, 3h		; Caso A nao seja 4, verifica o proximo digito
MOV P1, #99h		; Caso A seja 4, exibe no display
CJNE A, #5, 3h		; Caso A nao seja 5, verifica o proximo digito
MOV P1, #92h		; Caso A seja 5, exibe no display
CJNE A, #6, 3h		; Caso A nao seja 6, verifica o proximo digito
MOV P1, #82h		; Caso A seja 6, exibe no display
CJNE A, #7, 3h		; Caso A nao seja 7, verifica o proximo digito
MOV P1, #0F8h		; Caso A seja 7, exibe no display
CJNE A, #8, 3h		; Caso A nao seja 8, verifica o proximo digito
MOV P1, #80h		; Caso A seja 8, exibe no display
CJNE A, #9, 3h		; Caso A nao seja 9, verifica o proximo digito
MOV P1, #98h		; Caso A seja 9, exibe no display
RET					; Retorna da subrotina de print

end					; Fim logico do programa
