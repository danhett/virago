#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
  #include <avr/power.h>
#endif

#define PIN 6

//change number of blocks and number of pixels:
#define NUMBLOCKS 12
#define NUMPIXELS 16

Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUMBLOCKS * NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

int MODE;
int RANDOM;
int _RED;
int _GREEN;
int _BLUE;
int bright;
int i = 0;

int values[NUMBLOCKS * NUMPIXELS * 3]; // RGB

void setup() {
  bright = 230;

  // Init the NeoPixel library and turn off all the LEDs
  strip.setBrightness(bright);
  strip.begin();
  for (int i = 0; i < NUMBLOCKS * NUMPIXELS; i++) {
    strip.setPixelColor(i, 0, 0, 0, 0);
  }
  strip.show();

  // Initialize serial and wait for port to open:
  Serial.begin(115200);
  while (!Serial) {
  }
  // Tell the computer that we're ready for data
  Serial.println("READY");
}



void loop() {
  if (Serial.available() > 0) {
    MODE = Serial.parseInt();
    RANDOM = Serial.parseInt();
    _RED = Serial.parseInt();
    _GREEN = Serial.parseInt();
    _BLUE = Serial.parseInt();
    
    if (Serial.read() == '\n') {
      doLights();
    }
  }
}

void doLights() {

  // All the lights on
  if(MODE == 0) {
    for (int i = 0; i < NUMBLOCKS; i++){
      on(i);
    }
  }

  // Specific strips
  if(MODE == 1) {
    off(0);
    on(1);
    off(2);
    off(3);
    off(4);
    on(5);
    off(6);
    off(7);
    on(8);
    off(9);
    off(10);
    on(11);
  }
  
  // Pairs
  if(MODE == 2) {
    on(0);
    on(1);
    off(2);
    on(3);
    on(4);
    off(5);
    on(6);
    on(7);
    off(8);
    on(9);
    on(10);
    off(11);
  }
}

/**
 * Turns everything on/off
 */
void on(id) {
  colourBlock(id, RED(), GREEN(), BLUE());
}
void off(id) {
  colourBlock(id, 0, 0, 0);
}


/** 
 * Return either a given value, or a randomised version of it
 */
int RED() {
  if(RANDOM == 1)
    return random(_RED);
     
  return _RED;
}
int GREEN() {
  if(RANDOM == 1)
    return random(_GREEN);
  
  return _GREEN;
}
int BLUE() {
  if(RANDOM == 1)
    return random(_BLUE);
  
  return _BLUE;
}


/** 
 * Colour the blocks by strip/block
 */
void colourBlock(int block, int r, int g, int b) {
  int blockStartLED = block * NUMPIXELS;
  int blockLastLED = blockStartLED + NUMPIXELS;
  for (int i = blockStartLED; i < blockLastLED; i++) {
    strip.setPixelColor(i, r, g, b);
  }
  strip.show();
}
