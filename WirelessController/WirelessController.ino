#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
  #include <avr/power.h>
#endif

#define PIN 6
#define NUMPIXELS 32

Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

int thisDevice = 1; //change according to device (1-5)
int globalDevice = 0;

char colorValues[NUMPIXELS*3];
int RED;
int GREEN;
int BLUE;
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
  Serial.setTimeout(10);
  while (!Serial) {
  }
  // Tell the computer that we're ready for data
  Serial.println("READY");
}

//We're expecting a message like '1,255,128,75' from the Processing (device,r,g,b)

void loop() {
  if (Serial.available() > 0) {
    int header = Serial.parseInt();
    RED  = Serial.parseInt();
    GREEN  = Serial.parseInt();
    BLUE = Serial.parseInt();
    if (Serial.read() == '\n') {
      if (header == thisDevice || header == globalDevice) {
        colourAll(RED, GREEN, BLUE);
      }
    }
  }
}


void colourAll(int r, int g, int b) {
  for (int i = 0; i < NUMPIXELS; i++) {
    strip.setPixelColor(i, r, g, b);
  }
  strip.show();
}
