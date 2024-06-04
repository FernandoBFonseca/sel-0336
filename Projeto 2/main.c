signed char ucContador = -1;        // var global  para incremento

void ConfigMCU();
void ConfigTIMER();
void ConfigInterrupt();
void LedDisplay(unsigned char value);
void resetTimer();

#define TMR0H_1000ms 0x0B  //1s = 0.5us*32*(65536 - X) => X = 3036 = Ox0BDC
#define TMR0L_1000ms 0xDC
#define TMR0H_250ms 0xC2  //0.25s = 0.5us*32*(65536 - X) => X = 49911 = OxC2F7
#define TMR0L_250ms 0xF7

// Variaveis para salvar o timer
char tmr0h_save = TMR0H_1000ms;
char tmr0l_save = TMR0L_1000ms;

unsigned char flag_isStarted = 0; //Flag para identificar se algum bot�o j� foi precionado

void INTERRUPCAO_HIGH() iv 0x0008 ics ICS_AUTO {
// vetor de tratamento da interrup��o (endere�o fixo 0x0008)
// Definir em Tools > Interrupt Assistant
// HIGH = interrup��o de alta prioridade
// LOW = interrup��o de baixa prioridade (endere�o 0x0018)
// ics = servi�o de acionamento/tratamento da interrup��o

  if(INTCON.INT0IF) // verifica se a INT0 ocorreu
   {
     //timer == 1s
     flag_isStarted = 1;
     tmr0h_save = TMR0H_1000ms; //Set timer para 1000ms
     tmr0l_save = TMR0L_1000ms;
     ucContador = -1; LedDisplay(++ucContador); //Display 0
     
     resetTimer(); //
     
     INTCON.INT0IF = 0; //reset interrup��o do INT0
   }

  if(INTCON3.INT1IF) // verifica se a INT1 ocorreu
   {
     //timer == 0.25s
     flag_isStarted = 1;
     tmr0h_save = TMR0H_250ms; //Set timer para 250ms
     tmr0l_save = TMR0L_250ms;
     ucContador = -1; LedDisplay(++ucContador); //Display 0
     
     resetTimer();

     INTCON3.INT1IF = 0; //reset interrup��o do INT1
   }
   
   if(INTCON.TMR0IF && flag_isStarted) //verifica se a TMR0IF ocorreu e
    {
      LedDisplay(++ucContador); //Display proximo numero
      if(ucContador>=9) ucContador = -1; //Reset contator se passar de 9
      resetTimer();
    }

}       // Fim do atendimento � interrup��o

void resetTimer(){

     TMR0H = tmr0h_save; //Reset TIMER para o preset salvo
     TMR0L = tmr0l_save;

     INTCON.TMR0IF = 0; //reset interrup��o do TIMER
}

void ConfigMCU()
{
 ADCON1 |= 0X0F;    // pinos do microcontrolador como digitais

 TRISD = 0;       //Configurar os pinos de controle do display para outputs
 PORTD = 0;      // inicialmente desligado
 
 INTCON2.RBPU = 0; //RBPU � barrado, portanto acionado em 0
 
}

void ConfigTIMER()
{
  T0CON = 0B00000100;  //TIMER_OFF, MOD_16BITS, TIMER, PRES_1:32
  resetTimer();
  INTCON.TMR0IE = 1;  //Enable TIMER0
  T0CON.TMR0ON = 1;   //Ativa contagem TIMER0
}

void ConfigInterrupt()
{
  INTCON.GIE = 1;   //Chave Geral, Habilita o uso de interrup��o
  RCON.IPEN = 0; //0 -> (default) heran�a da fam�lia PIC16F, onde existe apenas
                            //um n�vel de prioridade de interrup��o
                     //IPEN=1 -> dois n�veis de prioridade de interrup��o (PIC18)

  TRISB.RB0 = 1;        //Pino RB0/INT0 como entrada
  INTCON2.INTEDG0 = 0 ;   //borda da INT0 descida
  INTCON.INT0IF = 0;    //Flag respons�vel em gerar/acionar a interrup��o
  INTCON.INT0IE = 1;  //Habilita a interrup��o espec�fica INT0
  
  TRISB.RB1 = 1;     // pino RB1/INT1 como entrada
  INTCON2.INTEDG1 = 0 ;   //borda da INT1 descida
  INTCON3.INT1IF = 0;   // zera a flag da INT0 (vai p/ 1 quando a interrup��o ocorrer)
  INTCON3.INT1IE = 1;       // habilita interrup��o INT1
}

void LedDisplay(unsigned char value)  // Funcao para iluminar display 7seg
{
     switch (value)
     {      // acionamento do display de 7 segmentos do kit EasyPIC (PORTD)
            case 0:{ latd = 0b00111111; break;}   // 0 no display de 7seg.
            case 1:{ latd = 0b00000110; break;}   // 1 no display de 7seg.
            case 2:{ latd = 0b01011011; break;}   // 2 no display de 7seg.
            case 3:{ latd = 0b01001111; break;}   // 3 no display de 7seg.
            case 4:{ latd = 0b01100110; break;}   // 4 no display de 7seg.
            case 5:{ latd = 0b01101101; break;}   // 5 no display de 7seg.
            case 6:{ latd = 0b01111101; break;}   // 6 no display de 7seg.
            case 7:{ latd = 0b00000111; break;}   // 7 no display de 7seg.
            case 8:{ latd = 0b01111111; break;}   // 8 no display de 7seg.
            case 9:{ latd = 0b01101111; break;}   // 9 no display de 7seg.
            default:{ PORTD =0; break;} // zera todo o PORTD e
     }

}

void main() {
   ConfigMCU();       //pinos do MCU config. para acionar o display
   ConfigTIMER();     //tempo config. e TIMER ligado
   ConfigInterrupt(); //Configura��o global das interrup��es


  while(1) {  // Endless loop
   } //while
 } //main