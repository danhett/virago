/**
 * SONIA SABRI // VIRAGO DATA HANDLER
 * Checks for connected devices at startup, pings data down the pipe.
 *
 * @author Dan Hett (hellodanhett@gmail.com)
 */
class DataManager {

  Boolean WIRED_LIVE = true;
  Boolean WIRELESS_LIVE = false;
  int frameCountRate = 5;

  Virago virago;
  Interface controls;
  Serial wireless;
  Serial strip; // the chained neopixels, all on one arduino

  String red;
  String green;
  String blue;
  Float brightness;
  String speed;
  int i;
  int t;
  int w;

  int mode;
  int random;

  String commandChunk;
  String command; // one huge command for the strip

  DataManager(Virago ref, Interface controlsRef) {
    println("[Data Manager]");

    virago = ref;
    controls = controlsRef;

    handshake();
  }

  // called on startup, says hello to all our connected devices
  void handshake() {
    // List all the available serial ports:
    // printArray(Serial.list());

    if(WIRED_LIVE) {
      strip = new Serial(virago, "/dev/ttyACM0", 115200);
    }

    if(WIRELESS_LIVE) {
      wireless = new Serial(virago, "/dev/ttyUSB0", 115200);
    }
  }

  void update() {
    if(frameCount % frameCountRate == 0)
      transmit();
  }

  /**
   * Sends the instructions to the lights
   */
  void transmit() {
    // if we're not using live audio, check the reading on the dial
    if(!controls.usingLiveAudio) {
      brightness = controls.brightness.getValue();
    }
    // else listen for the microphone
    else {
      if(controls.audioLevel > controls.lowThreshold)
        brightness = controls.audioLevel;
      else
        brightness = 0.0;
    }

    red = str(round(controls.red.getValue() * brightness));
    green = str(round(controls.green.getValue() * brightness));
    blue = str(round(controls.blue.getValue() * brightness));

    if(WIRED_LIVE) {
      sendWired();
    }
    if(WIRELESS_LIVE) {
      sendWireless();
    }
  }

  /**
   * Sends a signal to the wireless units.
   * These are numbered 1-5, or send a zero to address them all.
   */
  void sendWireless() {
    wireless.write("0" + "," + int(random(255)) + "," + int(random(255)) + "," + int(random(255)));
    wireless.write(10);
  }

  /**
   * Sends an update signal to the wired unit.
   * These are numbered 1-5, or send a zero to address them all.
   */
  void sendWired() {
    command = "";

    if(controls.usingRandomness)
      random = 1;
    else
      random = 0;

    commandChunk = mode + "," + random + "," + red + "," + green + "," + blue;

    //println(commandChunk);
    strip.write(commandChunk);
    strip.write(10);
  }
}
