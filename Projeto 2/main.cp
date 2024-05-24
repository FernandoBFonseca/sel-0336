#line 1 "C:/Users/Fernando Fonseca/Documents/Micros/Projetos/sel-0336/Projeto 2/main.c"


signed char ucContador = -1;

void ConfigMCU();
void ConfigTIMER();
void ConfigInterrupt();
void LedDisplay(unsigned char value);
void resetTimer();






char tmr0h_save =  0x0B ;
char tmr0l_save =  0xDC ;
unsigned char flag_isStarted = 0;

void INTERRUPCAO_HIGH() iv 0x0008 ics ICS_AUTO {










 if(INTCON.INT0IF)
 {

 flag_isStarted = 1;
 tmr0h_save =  0x0B ;
 tmr0l_save =  0xDC ;
 ucContador = -1; LedDisplay(++ucContador);
 resetTimer();

 INTCON.INT0IF = 0;
 }


 if(INTCON3.INT1IF)
 {

 flag_isStarted = 1;
 tmr0h_save =  0xC2 ;
 tmr0l_save =  0xF7 ;
 ucContador = -1; LedDisplay(++ucContador);
 resetTimer();

 INTCON3.INT1IF = 0;
 }

 if(INTCON.TMR0IF && flag_isStarted)
 {
 LedDisplay(++ucContador);
 if(ucContador>=9) ucContador = -1;
 resetTimer();

 }

}

void resetTimer(){

 TMR0H = tmr0h_save;
 TMR0L = tmr0l_save;

 INTCON.TMR0IF = 0;

}

void ConfigMCU()
{
 ADCON1 |= 0X0F;

 TRISD = 0;
 PORTD = 0;


 INTCON2.RBPU = 0;


}

void ConfigTIMER()
{








 T0CON = 0B00000100;
 resetTimer();
 INTCON.TMR0IE = 1;
 T0CON.TMR0ON = 1;
}

void ConfigInterrupt()
{
 INTCON.GIE = 1;
 RCON.IPEN = 0;



 TRISB.RB0 = 1;
 INTCON2.INTEDG0 = 0 ;
 INTCON.INT0IF = 0;
 INTCON.INT0IE = 1;

 TRISB.RB1 = 1;
 INTCON2.INTEDG1 = 0 ;
 INTCON3.INT1IF = 0;
 INTCON3.INT1IE = 1;





}

void LedDisplay(unsigned char value)
{
 switch (value)
 {
 case 0:{ latd = 0b00111111; break;}
 case 1:{ latd = 0b00000110; break;}
 case 2:{ latd = 0b01011011; break;}
 case 3:{ latd = 0b01001111; break;}
 case 4:{ latd = 0b01100110; break;}
 case 5:{ latd = 0b01101101; break;}
 case 6:{ latd = 0b01111101; break;}
 case 7:{ latd = 0b00000111; break;}
 case 8:{ latd = 0b01111111; break;}
 case 9:{ latd = 0b01101111; break;}
 default:{ PORTD =0; break;}

 }

}


void main() {
 ConfigMCU();
 ConfigTIMER();
 ConfigInterrupt();


 while(1) {
 }
 }
