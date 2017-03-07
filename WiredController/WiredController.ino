#include <Keyboard.h>

#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
  #include <avr/power.h>
#endif

#define PIN 6

//change number of blocks and number of pixels:
#define NUMBLOCKS 8
#define NUMPIXELS 8

Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUMBLOCKS * NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

int MODE;
int RED;
int GREEN;
int BLUE;
int bright;
int i = 0;

int values[NUMBLOCKS * NUMPIXELS * 3]; // RGB

void setup() {
  bright = 100;

  // Init the NeoPixel library and turn off all the LEDs
  strip.setBrightness(bright);
  strip.begin();
  for (int i = 0; i < NUMBLOCKS * NUMPIXELS; i++) {
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
    MODE = Serial.parseInt();
    RED = Serial.parseInt();
    GREEN = Serial.parseInt();
    BLUE = Serial.parseInt();
    
    if (Serial.read() == '\n') {
      doLights();
    }
  }
}

void doLights() {

  // All the lights on
  if(MODE == 0) {
    for (int i = 0; i < NUMBLOCKS; i++){
      colourBlock(i, RED, GREEN, BLUE);
    }
  }

  // Specific strips
  if(MODE == 1) {
    colourBlock(0, 0, 0, 0);
    colourBlock(1, RED, GREEN, BLUE);
    colourBlock(2, 0, 0, 0);
    colourBlock(3, 0, 0, 0);
    colourBlock(4, 0, 0, 0);
    colourBlock(5, RED, GREEN, BLUE);
    colourBlock(6, 0, 0, 0);
    colourBlock(7, 0, 0, 0);
    colourBlock(8, RED, GREEN, BLUE);
    colourBlock(9, 0, 0, 0);
    colourBlock(10, 0, 0, 0);
    colourBlock(11, RED, GREEN, BLUE);
  }
  
  // Pairs
  if(MODE == 2) {
    colourBlock(0, RED, GREEN, BLUE);
    colourBlock(1, RED, GREEN, BLUE);
    colourBlock(2, 0, 0, 0);
    colourBlock(3, RED, GREEN, BLUE);
    colourBlock(4, RED, GREEN, BLUE);
    colourBlock(5, 0, 0, 0);
    colourBlock(6, RED, GREEN, BLUE);
    colourBlock(7, RED, GREEN, BLUE);
    colourBlock(8, 0, 0, 0);
    colourBlock(9, RED, GREEN, BLUE);
    colourBlock(10, RED, GREEN, BLUE);
    colourBlock(11, 0, 0, 0);
  }
}

//address blocks (0-7) with RGB
void colourBlock(int block, int r, int g, int b) {
  int blockStartLED = block * NUMPIXELS;
  int blockLastLED = blockStartLED + NUMPIXELS;
  for (int i = blockStartLED; i < blockLastLED; i++) {
    strip.setPixelColor(i, r, g, b);
  }
  strip.show();
}
