/**
 * SONIA SABRI // VIRAGO DATA HANDLER
 * Checks for connected devices at startup, pings data down the pipe.
 *
 * @author Dan Hett (hellodanhett@gmail.com)
 */
class DataManager {

  Boolean WIRED_LIVE = true;
  Boolean WIRELESS_LIVE = true;
  int frameCountRate = 5;

  Virago virago;
  Interface controls;
  Animation anim;
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

  DataManager(Virago ref, Interface controlsRef, Animation animRef) {
    println("[Data Manager]");

    virago = ref;
    controls = controlsRef;
    anim = animRef;

    handshake();
  }

  /**
   * Called on startup, says hello to our connected devices.
   */
  void handshake() {
    if(WIRED_LIVE) {
      strip = new Serial(virago, "/dev/ttyACM0", 115200);
    }

    if(WIRELESS_LIVE) {
      wireless = new Serial(virago, "/dev/ttyUSB0", 115200);
    }
  }


  /**
   * Tick
   */
  void update() {
    if(frameCount % frameCountRate == 0)
      transmit();
  }

  /**
   * Sends the instructions to the lights
   */
  void transmit() {
    getBrightnessSetting();
    applyColours();

    if(WIRED_LIVE) {
      sendWired();
    }
  }

  /**
   * Gets the correct input for brightness, from audio
   * input or animation sources, or the slider.
   */
  void getBrightnessSetting() {
    // if we're not using live audio, use the reading on the dial
    if(!controls.usingLiveAudio) {
      brightness = controls.brightness.getValue();
    }
    // else listen for the microphone
    else {
      if(controls.usingLiveAudio) {
        if(controls.audioLevel > controls.lowThreshold)
          brightness = controls.audioLevel;
        else
          brightness = 0.0;
      }
    }

    // override everything if pulse is being used
    if(controls.usingSlowPulse) {
      brightness = anim.slow * controls.limiterSlider.getValue();
    }
    if(controls.usingFastPulse) {
      brightness = anim.fast * controls.limiterSlider.getValue();
    }
  }

  /**
   * Adds the brightness modifier to the three colour channels.
   */
  void applyColours() {
    red = str(round(controls.red.getValue() * brightness));
    green = str(round(controls.green.getValue() * brightness));
    blue = str(round(controls.blue.getValue() * brightness));
  }

  void proxySendWireless(Boolean ignoreBrightness) {
    if(WIRELESS_LIVE) {
      sendWireless(ignoreBrightness);
    }
  }

  void setWirelessMode(String cmd) {
    wirelessMode = int(cmd.replace("wireless", ""));
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

    if(controls.sendingToWired) {
      strip.write(wiredCommand);
      strip.write(10);
    }
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

    if(controls.sendingToWireless) {
      wireless.write(wirelessCommand);
      wireless.write(10);
    }
  }
}
