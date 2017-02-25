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
int BRIGHTNESS;

void setup() {
  // Init the NeoPixel library and turn off all the LEDs
  strip.setBrightness(10);
  strip.begin();
  strip.show();
  
  // Do a quick test/demo to show that things are working
  for (int i=0; i<60; i++) { flashAll(strip.Color((i%20)*2,i%30,i%60)); delay(10); }

  // Initialize the buffer to all black
  memset(colorValues, 0, sizeof(colorValues));

  // Initialize serial and wait for port to open:
  Serial.begin(115200);
  while (!Serial) {
    ; // wait for port to be ready
  }
  
  // Tell the computer that we're ready for data
  Serial.println("READY");
}


void loop() {
  while (true) {
//    int bufferPos = 0;
//    
//    // Read the data for each pixel
//    while (bufferPos < NUMPIXELS*3) {
//      int color = Serial.read();
//      Serial.println(color);
//      if (color >= 0) {
//        colorValues[bufferPos++] = color;
//      }
//    }
//    
//    // Feed the data to the NeoPixel library
//    for(int i=0; i<NUMPIXELS; i++) {
//      int d = i*3;
//      uint32_t c = strip.Color(colorValues[d], colorValues[d+1], colorValues[d+2]);
//      strip.setPixelColor(i, c);
//    }
//    
//    // update the strip
//    strip.show();

    //String msg = Serial.readString();

    String first  = Serial.readStringUntil(',');
    Serial.read(); 
    String second = Serial.readStringUntil(',');
    Serial.read();
    String third  = Serial.readStringUntil(',');
    Serial.read();
    String fourth = Serial.readStringUntil('\0');
    //parse your data here. example:
    //double x = Double.parseDouble(first);

    Serial.println("Unit two: ");
    Serial.println("R: " + first + " G:" + second + " B:" + third + " Brightness:" + fourth);
    
    // Clear up the serial buffer
    while (Serial.available() > 0) Serial.read();
    
    // Let the sender know we're ready for more data
    //Serial.println("READY AGAIN");
  }
}


void flashAll(uint32_t color) {
  // Do a quick test/demo to show that things are working
  for (int i=0; i < NUMPIXELS; i++) {
    strip.setPixelColor(i, color);
  }
  strip.show();
}
