  // SEL0433/SEL0614/SEL0336 - Aplic. de Microprocessadores
  
  // Projeto 3 - Termometro Digital
  
// Uso do conversor ADC para realizar uma leitura analógica (sinal de tensão)
// com número float e 1 casa decimal

  // será o usado o canal analógico AN4/RA5 - para ler o sinal de tensão analógico
  // o qual irá variar conforme um potenciometro, simulando um sensor de temperatura de tensão entre 0-1V
  // que mede de 0 a 100 graus celsius

  // Device:  PIC18F4550 - Clock  = 8 MHz
  // Tensão de ref. interna do ADC 0 - 1V
  
  // ***Necessário add bibliotecas LCD e conversão de dados em "Libray Manager"***
  
  // habilitar o display LCD em SW4

//------------------------------------------------------------------------------
// Config. de pinos do LCD  (PORTB)

/*Include*/

/*Diretivas de pré-compilação*/
 #define TRUE  1  // assim: while(TRUE) = while(1)

// config. dos pinos para o LCD

// pinos utilizados para comunicação com o display LCD
sbit LCD_RS at LATB4_bit; // pino 4 do PORTB interligado ao RS do display
sbit LCD_EN at LATB5_bit; // pino 5 do PORTB " " ao EN do display
sbit LCD_D4 at LATB0_bit; // pino 0 do PORTB ao D4
sbit LCD_D5 at LATB1_bit;  // " "
sbit LCD_D6 at LATB2_bit;  // " "
sbit LCD_D7 at LATB3_bit;  // " "
// direção do fluxo de dados nos pinos selecionados
sbit LCD_RS_Direction at TRISB4_bit;  // direção do fluxo de dados do pino RB4
sbit LCD_EN_Direction at TRISB5_bit;  // " "
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;

/*Programa Principal*/

void main(){
  unsigned int Valor_ADC = 0;  // var. para leitura
  unsigned char Tensao[10];    // arranjo textual para exibir no display

  //Configurando os pinos usados como entrada
  TRISA.RA5 = 1; // pino AN4 qeu receberá sinal analógico do potenciometro configurado como entrada
  TRISA.RA2 = 1; // pino AN2 que receberá o valor referencia externa negativo para o ADC
  TRISA.RA3 = 1; // pino AN3 que receberá o valor referencia externa postivo para o ADC

 // Configuração do módulo LCD
  Lcd_Init();                 // Inicializa a lib. Lcd
  Lcd_Cmd(_LCD_CLEAR);       // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);  // Cursor off
  Lcd_Out(1,1,"ADC0:");   //Escreve na Linha x Coluna do LCD o texto(valor do ADC)

  ADC_Init();
  //- incializa o módulo ADC
  
  // Configura ADC para usar a referência externa nos pinos AN2 (ref externa negativa)
  // e AN3(referencia externa positiva) (bit 5 e 4, respectivamente, setados como 1)
  // Também configura os bits PCFG3:PCFG(bit 0-3) como 0000, colocando todas portas AN como analógicas
  ADCON1 = 0B00110000;
  
 while(TRUE)
  {
    // Configurando qual porta AN será lido o sinal analógico.
    // bits CHS3:CHS0(bit 5-2) iguais a 0100 = Channel 4 (AN4)
    // bit 0 ADON setado para habilitar a conversao A/D
    ADCON0 = 0B00010001;
    
    // Bit Go_DONE setado como 1 para comecar a conversao A/D da entrada escolhida
    ADCON0.GO_DONE = 1;
    
    // Espera a conversao que esta em progresso. Quando a conversao termina, valor do bit
    // GO_DONE iguala 0 e com isso podemos ler o valor
    while(ADCON0.GO_DONE == 1);
    
    // Leitura do valor da conversao A/D que foi carregado nos regitradores ADRESH:ADRESL
    Valor_ADC = ((ADRESH << 8)| ADRESL);   // desloca o valor de ADRESH 8 bits a esquerda para combinar os valores dos registradores
    // e conseguir o resultado total em 16 bits (apesar da resolucao de 10 bits)
    
    Valor_ADC = Valor_ADC * (1000/1023.); // formata o valor de entrada (neste caso o valor de exemplo '100.0')
    // para 0 a 1023 -> com ponto no final para n° float,i.e.,o display mostrara: '100.0'

    // Formatando cada valor a ser exibido no display como "100.0"
    Tensao[0] = (Valor_ADC/1000) + '0';// div. de 2 n° inteiros - em programação
    // resulta na parte inteira do primeiro n° (ex.: 1000/1000 = 1)
    // E '1' + '0'  = 1; ou seja,  converte o valor para ASCI  para exibir no display

    Tensao[1] = (Valor_ADC/100)%10 + '0'; // div. de n° inteiros => 1000/100 = 0
    // '%' em ling. C é operação "mod"  c/ resto da divisão, ou seja, 10%10 = 0
    // portanto, formata o segundo n° no display no padrão ASCI ( '1' + '0' = 1)

    Tensao[2] = (Valor_ADC/10)%10 + '0';  // faz similar para obter a casa das unidades
    
    Tensao[3] = '.';  // poe o ponto decimal das virgulas
    
    Tensao[4] = (Valor_ADC/1)%10 + '0';  // formata o valor da 1ª casa decimal

    Tensao[5] = 0; //terminador NULL (ultima posição da matriz - zero indica o
    //final opeação e limita a exibição dos 5 valores anteriores: 100.0), ou seja
    // a partir daqui, não serão mais exibidos valores, os quais poderão ser
    //adicionados caso se deseja exibir, por ex., mais casas decimais

    //floatToStr(Valor_ADC , Tensao);
    //Tensao[5] = 0;

     // Exibir os valores na config. acima no display LCD:
    Lcd_Out(1,6,Tensao); // Mostra os valores no display
    Delay_ms(20);   // atualizar display
  }
}