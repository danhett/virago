#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
  #include <avr/power.h>
#endif

#define PIN 6
#define NUMPIXELS 32

Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

char colorValues[NUMPIXELS*3];
int RED;
int GREEN;
int BLUE;
int WHITE;
int bright;

void setup() {
  bright = 128;
  
  // Init the NeoPixel library and turn off all the LEDs
  strip.setBrightness(bright);
  strip.begin();
  for (int i = 0; i < NUMPIXELS; i ++) {
    strip.setPixelColor(i, 0, 0, 0, 0);
  }
  strip.show();

  // Initialize serial and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
  }
  // Tell the computer that we're ready for data
  Serial.println("READY");
}


void loop() {
  if (Serial.available() > 0) {
    RED  = Serial.parseInt();
    GREEN  = Serial.parseInt();
    BLUE = Serial.parseInt();
    if (Serial.read() == '\n') {
      colourAll(RED, GREEN, BLUE);
      //colorWipe(RED, GREEN, BLUE, SPEED);
      Serial.println("R: " + String(RED) + " G:" + String(GREEN) + " B:" + String(BLUE));
    }
  }
}


void colourAll(int r, int g, int b) {
  for (int i = 0; i < NUMPIXELS; i++) {
    strip.setPixelColor(i, r, g, b);
  }
  strip.show();
}

// OLD
void colorWipe(int r, int g, int b, uint8_t wait) {
  for(uint16_t i=0; i<NUMPIXELS; i++) {
    strip.setPixelColor(i, r, g, b);
    strip.show();
    delay(wait);
  }
}

