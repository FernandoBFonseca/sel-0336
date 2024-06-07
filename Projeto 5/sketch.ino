// Biblioteca para comunicacao Bluetooth
#include "BluetoothSerial.h"

// Pinos do LED RGB
#define R_PIN 21
#define G_PIN 19
#define B_PIN 5

// Duty-Cycle (DC) de cada cor
int DC_R = 0;
int DC_G = 0;
int DC_B = 0;

// Incremento do DC
int step = 5;

// Objeto utilizado para a conexao Bluetooth
BluetoothSerial SerialBT;

void setup() {
  // Setup do serial
  Serial.begin(115200);

  // Setup dos PWMs dos LEDS
  // (biblioteca "ledc")
  ledcAttach(R_PIN, 5000, 8);
  ledcAttach(G_PIN, 5000, 8);
  ledcAttach(B_PIN, 5000, 8);

  // Setup do Bluetooth
  SerialBT.begin("LED Control");
}

void loop() {
  // Verifica se algum valor foi enviado
  // atraves do Bluetooth
  checkBT();

  // Printa as informacoes no serial
  printInfos();

  // Envia o sinal para os LEDs
  writeLed();

  // Atualiza o DC com o step atual
  updateDC();
  
  // Delay de 200ms
  delay(200);
}

void printInfos() {
  // Printa o DC de cada LED
  Serial.print("\n\n\n\n\n\n\n\n\n\n");
  Serial.print("DC_RED: ");
  Serial.println(DC_R);
  Serial.print("DC_GREEN: ");
  Serial.println(DC_G);
  Serial.print("DC_BLUE: ");
  Serial.println(DC_B);
  Serial.println("");
  Serial.print("STEP: ");
  Serial.println(step);
}

void writeLed() {
  // Envia o sinal para os LEDs
  // (biblioteca "ledc")
  ledcWrite(R_PIN, DC_R);
  ledcWrite(G_PIN, DC_G);
  ledcWrite(B_PIN, DC_B);
}

void updateDC() {
  // Atualiza os DCs
  // Quando um DC atinge 255, reseta para 0
  DC_R += 2*step;
  if (DC_R > 255) {
    DC_R = 0;
  }

  DC_G += step;
  if (DC_G > 255) {
    DC_G = 0;
  }

  DC_B += 3*step;
  if (DC_B > 255) {
    DC_B = 0;
  }
}

void checkBT() {
  // Verifica se algum dado foi recebido
  if(SerialBT.available()) {
    // Buffer para armazenar o numero
    int buffer = 0;
    // Enquando houverem dados disponiveis
    while (SerialBT.available()) {
      // Le o dado
      int read = SerialBT.read();
      // Filtra para pegar apenas numeros
      if(read < 48 || read > 57) {
        continue;
      }
      // Armazena no buffer
      buffer = 10*buffer + (read-48);
    }
    
    // Caso seja um valor valido (> 0)
    if(buffer > 0) {
      // Atualiza o step
      step = buffer;
    }
  }
}