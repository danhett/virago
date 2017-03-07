/**
 * SONIA SABRI // VIRAGO DATA HANDLER
 * Checks for connected devices at startup, pings data down the pipe.
 *
 * @author Dan Hett (hellodanhett@gmail.com)
 */
class DataManager {

  Boolean LIVE = true;

  Virago virago;
  Interface controls;
  Serial wireless1;
  Serial wireless2;
  Serial wireless3;
  Serial wireless4;
  Serial wireless5;
  Serial strip; // the chained neopixels, all on one arduino

  String red;
  String green;
  String blue;
  Float brightness;
  String speed;
  int i;
  int t;

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
    //printArray(Serial.list());

    // Open the port you are using at the rate you want:
    //wireless1 = new Serial(virago, "/dev/ttyACM0", 9600);
    //wireless2 = new Serial(virago, "/dev/ttyACM1", 9600);
    //wireless3 = new Serial(virago, "/dev/ttyACM2", 9600);
    //wireless4 = new Serial(virago, "/dev/ttyACM3", 9600);
    //wireless5 = new Serial(virago, "/dev/ttyACM4", 9600);
    strip = new Serial(virago, "/dev/ttyACM0", 9600);
  }

  void update() {
    /*
    if(LIVE) {
      while (wireless1.available() > 0) {
        String inBuffer = wireless1.readString();
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
      if(controls.freeToggles.get(0).getValue() == 1.0) {
        //wireless1.write(red + "," + green + "," + blue);
        //wireless1.write(10);
        //wireless1.clear();
      }

      if(controls.freeToggles.get(1).getValue() == 1.0) {
        //wireless2.write(red + "," + green + "," + blue);
        //wireless2.write(10);
        //wireless2.clear();
      }

      if(controls.freeToggles.get(2).getValue() == 1.0) {
        //wireless3.write(red + "," + green + "," + blue + "," + speed);
        //wireless3.write(10);
      }

      if(controls.freeToggles.get(3).getValue() == 1.0) {
        //wireless4.write(red + "," + green + "," + blue + "," + speed);
        //wireless4.write(10);
      }

      if(controls.freeToggles.get(4).getValue() == 1.0) {
        //wireless5.write(red + "," + green + "," + blue + "," + speed);
        //wireless5.write(10);
      }

      // STATIC TOGGLES
      command = "";
      t = 0;
      for(Toggle toggle:controls.staticToggles) {
        //if(toggle.getValue() == 1.0) {
          commandChunk = t + "," + red + "," + green + "," + blue + "\n";
          command += commandChunk;
        //}

        //if(t < 11) command += ",";

        t++;
      }

      command = 0 + "," + 255 + "," + 200 + "," + 0 + ",";
      command += 1 + "," + 255 + "," + 200 + "," + 0;

      //command = "0,100,0,200,1,100,0,200";

      println(command);
      strip.write(command);
      strip.write(10);
    }
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
