/**
 * SONIA SABRI // VIRAGO DATA HANDLER
 * Checks for connected devices at startup, pings data down the pipe.
 *
 * @author Dan Hett (hellodanhett@gmail.com)
 */
class DataManager {

  Boolean LIVE = false;

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

  String commandChunk;
  String command; // one huge command for the strip

  DataManager(Virago ref, Interface controlsRef) {
    println("[Data Manager]");

    virago = ref;
    controls = controlsRef;

    if(LIVE)
      handshake();
  }

  // called on startup, says hello to all our connected devices
  void handshake() {
    // List all the available serial ports:
    // printArray(Serial.list());

    // Open the port you are using at the rate you want
    // wireless = new Serial(virago, "/dev/ttyUSB0", 115200);
    strip = new Serial(virago, "/dev/ttyACM0", 9600);
  }

  void update() {
    /*
    if(LIVE) {
      while (wireless.available() > 0) {
        String inBuffer = wireless.readString();
        if (inBuffer != null) {
          println(inBuffer);
        }
      }
    }
    */

    if(frameCount % 3 == 0)
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
      brightness = controls.audioLevel;
    }

    red = str(round(controls.red.getValue() * brightness));
    green = str(round(controls.green.getValue() * brightness));
    blue = str(round(controls.blue.getValue() * brightness));

    if(LIVE) {
      //sendWireless();
      sendWired();
    }
  }

  // WIRELESS LIGHTS
  void sendWireless() {
    wireless.write("4" + "," + int(random(255)) + "," + int(random(255)) + "," + int(random(255)));
    wireless.write(10);
  }

  // WIRED LIGHTS
  void sendWired() {
    command = "";

    for(Toggle toggle:controls.staticToggles) {
      if(toggle.getValue() == 1.0) {
        commandChunk = mode + "," + red + "," + green + "," + blue;
        command += commandChunk;
      }
    }

    //println(command);
    strip.write(commandChunk);
    strip.write(10);
  }

  /**
   * Add a timestamp to responses
   */
  String stamp() {
    SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss.SSS");

    Date d = new Date();
    return sdf.format(d.getTime());
  }
}
