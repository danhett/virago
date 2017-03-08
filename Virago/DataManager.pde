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
  int i;
  int t;
  int w;

  int mode;
  int random;

  String wiredCommand;
  String wirelessCommand;
  String lastWirelessCommand = "";
  int speed = 100;

  DataManager(Virago ref, Interface controlsRef) {
    println("[Data Manager]");

    virago = ref;
    controls = controlsRef;

    handshake();
  }

  // called on startup, says hello to all our connected devices
  void handshake() {
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

    applyColours();

    if(WIRED_LIVE) {
      sendWired();
    }
    if(WIRELESS_LIVE) {
      sendWireless();
    }
  }

  /**
   * Sends an update signal to the wired unit.
   * These are numbered 1-5, or send a zero to address them all.
   */
  void sendWired() {
    if(controls.usingRandomness)
      random = 1;
    else
      random = 0;

    wiredCommand = mode + "," + random + "," + red + "," + green + "," + blue;

    strip.write(wiredCommand);
    strip.write(10);
  }

  /**
   * Sends a signal to the wireless units.
   * These are numbered 1-5, or send a zero to address them all.
   */
  void sendWireless() {
    brightness = controls.audioLevel;
    applyColours();

    wirelessCommand = "0" + "," + red + "," + green + "," + blue + "," + speed;

    if(wirelessCommand != lastWirelessCommand) {
      println("writing to wireless units");
      lastWirelessCommand = wirelessCommand;
      wireless.write(wirelessCommand);
      wireless.write(10);
    }
  }

  void applyColours() {
    red = str(round(controls.red.getValue() * brightness));
    green = str(round(controls.green.getValue() * brightness));
    blue = str(round(controls.blue.getValue() * brightness));
  }
}
