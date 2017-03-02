#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
  #include <avr/power.h>
#endif

#define PIN 6

//change number of blocks and number of pixels:
#define NUMBLOCKS 8
#define NUMPIXELS 8

Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUMBLOCKS * NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

int BLOCK;
int RED;
int GREEN;
int BLUE;
int bright;

void setup() {
  bright = 128;

  // Init the NeoPixel library and turn off all the LEDs
  strip.setBrightness(bright);
  strip.begin();
  for (int i = 0; i < NUMBLOCKS * NUMPIXELS; i ++) {
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
    BLOCK = Serial.parseInt();
    RED  = Serial.parseInt();
    GREEN  = Serial.parseInt();
    BLUE = Serial.parseInt();
    if (Serial.read() == '\n') {
      Serial.println(BLOCK);
      Serial.println(RED);
      Serial.println(GREEN);
      Serial.println(BLUE);
      colourBlock(BLOCK, RED, GREEN, BLUE);
    }
  }
}

//address blocks (0-7) with RGB
void colourBlock(int block, int r, int g, int b) {
  int blockStartLED = block * NUMPIXELS;
  int blockLastLED = blockStartLED + NUMPIXELS;
  for (int i = blockStartLED; i < blockLastLED; i++) {
    Serial.println(i);
    strip.setPixelColor(i, r, g, b);
  }
  strip.show();
}
