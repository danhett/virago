/**
 * SONIA SABRI // VIRAGO DATA HANDLER
 * Checks for connected devices at startup, pings data down the pipe.
 *
 * @author Dan Hett (hellodanhett@gmail.com)
 */
class DataManager {

  Boolean WIRED_LIVE = false;
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
  int wirelessRed;
  int wirelessGreen;
  int wirelessBlue;

  int mode;
  int wirelessMode;
  int random;

  String wiredCommand;
  String wirelessCommand;
  String lastWirelessCommand = "";
  int speed = 50;

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
  }

  void proxySendWireless(Boolean ignoreBrightness) {
    if(WIRELESS_LIVE) {
      sendWireless(ignoreBrightness);
    }
  }

  void setWirelessMode(String cmd) {
    wirelessMode = int(cmd.replace("wireless", ""));
    println(wirelessMode);
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
  void sendWireless(Boolean ignoreBrightness) {
    brightness = controls.brightness.getValue();

    if(ignoreBrightness) {
      wirelessRed = 0;
      wirelessGreen = 0;
      wirelessBlue = 0;
    }
    else {
      wirelessRed = int(controls.targetRed * controls.targetBrightness);
      wirelessGreen = int(controls.targetGreen * controls.targetBrightness);
      wirelessBlue = int(controls.targetBlue * controls.targetBrightness);
    }

    wirelessCommand = wirelessMode + ","
                    + wirelessRed + ","
                    + wirelessGreen + ","
                    + wirelessBlue + ","
                    + speed;

    wireless.write(wirelessCommand);
    wireless.write(10);
  }

  void applyColours() {
    red = str(round(controls.red.getValue() * brightness));
    green = str(round(controls.green.getValue() * brightness));
    blue = str(round(controls.blue.getValue() * brightness));
  }
}
