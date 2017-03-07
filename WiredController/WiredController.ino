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


// WE'RE EXPECTING A STRING LIKE '255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255'
//WITH A NEWLINE CHARACTER AT THE END
//IT ARRIVES EVERY 5-10MS WHATEVER YOU DECIDE
//YOUR PARSE IT DOWN UNTIL THE NEWLINE
//ON THE NEWLINE YOU USE THE VALUES TO AFFECT THE NEOPIXELS
//I WILL ENDEVAOUR TO FIND THE CODE I WROTE BEFORE, AS I ESSENTIALLY DID A SIMILAR THING, SENDING DIFFERENT VALUES TO 8 'BLOCKS'
//OF NEOPIXELS, EACH ATTACHED TO A SPEAKER. IT'S ON A DRIVE AT HOME THOUGH, SO YOU MAY NOT GET IT TIL TOMORROW!
void loop() {
  if (Serial.available() > 0) {
    for (int i = 0; i < NUMBLOCKS; i ++){
      RED = Serial.parseInt();
      GREEN = Serial.parseInt();
      BLUE = Serial.parseInt();
      //append these to an array
    }
    if (Serial.read() == '\n') {
      //we've got an array here full of values per block, iterate and change colours
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
