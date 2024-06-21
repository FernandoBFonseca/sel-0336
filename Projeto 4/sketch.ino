// Biblioteca para controlar o servo
#include <Arduino.h>
#include <ESP32Servo.h>
// Biblioteca para comunicacao I2C
#include <Wire.h>
// Bibliotecas para controlar o display
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

// Pinos dos botoes
#define START_BUTTON_PIN  14
#define STOP_BUTTON_PIN   12

// Pino do servo
#define SERVO_PIN         4

// Step utilizado no servo
#define SERVO_STEP        4

// Objeto para controlar o display
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, -1);

// Flag para controlar se o sistema
// esta ligado ou desligado
bool startFlag = false;

// Objeto para controlar o servo
Servo servo;
// Variaveis que armazenam o estado
// atual do servo
int servoAngle = 0;
int servoDirection = 1;
int servoLastMove = 0;
int servoMovePeriod = 100;

void setup() {
  // Setup do serial
  Serial.begin(115200);

  // Setup do display
  display.begin(SSD1306_SWITCHCAPVCC, 0x3C);
  display.clearDisplay();
  display.display();

  // Setup dos pinos dos botoes
  pinMode(START_BUTTON_PIN, INPUT);
  pinMode(STOP_BUTTON_PIN, INPUT);

  // Setup do servo
  servo.setPeriodHertz(50);
  servo.attach(SERVO_PIN, 500, 2500);
  servo.write(servoAngle);
}

void loop() {
  // Printa as informacoes no serial


  writeInfosSerial();
  // Printa as informacoes no display
  writeInfosDisplay();

  // Move o servo para o angulo atual
  servo.write(servoAngle);

  // Caso o sistema esteja ligado e o botao stop seja
  // pressionado, desliga o sistema
  if(startFlag && digitalRead(STOP_BUTTON_PIN) == HIGH) {
    startFlag = false;
  }
  
  // Caso o sistema esteja desligado e o botao start seja
  // pressionado, liga o sistema
  else if (!startFlag && digitalRead(START_BUTTON_PIN) == HIGH) {
    startFlag = true;
  }
  
  // Atualiza a posicao do servo
  moveServo();
  
  // Delay de 10ms
  delay(10);
  
}

void moveServo() {
  // Garante que o servo sera movido apenas a cada
  // 'servoMovePeriod' milisegundos
  if(millis() < servoLastMove + servoMovePeriod) {
    return;
  }

  // Caso o sistema esteja ligado
  if(startFlag) {
    // Caso o servo atinja 180 graus, inverte o sentido
    // e altera o periodo de movimento ('servoMovePeriod')
    if(servoAngle >= 180) {
      servoDirection = -1;
      servoAngle = 180;
      servoMovePeriod = 200;
    }
    // Caso o servo atinja 0 graus, inverte o sentido
    // e altera o periodo de movimento ('servoMovePeriod')
    else if(servoAngle <= 0) {
      servoDirection = 1;
      servoAngle = 0;
      servoMovePeriod = 100;
    }

    // Quando o servo estiver em 180 graus, aguarda 1s antes
    // de recomecar o movimento
    if(servoAngle == 180 && millis() < servoLastMove + 1000) {
      return;
    }

    // Move o servo na direcao correta
    servoAngle += servoDirection*SERVO_STEP;

    // Salva o momento do ultimo movimento
    servoLastMove = millis();
  }
}

void writeInfosSerial() {
  // Printa as informacoes do servo no serial
  Serial.println("\n\n\n\n\n\n\n\n\n\n");
  Serial.print("Servo Motor: ");
  Serial.println(startFlag ? "ON" : "OFF");
  Serial.println("");
  Serial.print("Sentido: ");
  Serial.println(servoDirection == 1 ? "H" : "AH");
  Serial.print("Angulo: ");
  Serial.print(servoAngle);
  Serial.println(" deg");
}

void writeInfosDisplay() {
  // Printa as informacoes do servo no display
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(SSD1306_WHITE);
  display.setCursor(0, 0);
  display.print("Servo Motor: ");
  display.println(startFlag ? "ON" : "OFF");
  display.println("");
  display.print("Sentido: ");
  display.println(servoDirection == 1 ? "H" : "AH");
  display.print("Angulo: ");
  display.print(servoAngle);
  display.println(" deg");
  display.display();
}