#include <Keyboard.h>

#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
  #include <avr/power.h>
#endif

#define PIN 6

//change number of blocks and number of pixels:
#define NUMBLOCKS 12
#define NUMPIXELS 16

Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUMBLOCKS * NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

int RED;
int GREEN;
int BLUE;
int bright;
int i = 0;

int values[NUMBLOCKS*3]; // RGB

void setup() {
  bright = 200;

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
    for (int i = 0; i < NUMBLOCKS; i ++){
      RED = Serial.parseInt();
      RED = Serial.parseInt();
      RED = Serial.parseInt();
    }
      //values[i] = 255; //Serial.parseInt(); // RED
      //values[(i * NUMPIXELS)+1] = 255; //Serial.parseInt(); // GREEN
      //values[(i * NUMPIXELS)+2] = 0; //Serial.parseInt(); // BLUE
    if (Serial.read() == '\n') {
      doLights();
    }
  }
}

void doLights() {
  i = 0;
  //colourBlock(0,0,0,200);
  
  for (int i = 0; i < NUMBLOCKS; i++){
    //colourBlock(i, values[i*NUMPIXELS], values[(i*NUMPIXELS)+1], values[(i*NUMPIXELS)+2]);
    colourBlock(i, 0, 0, 255);
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
