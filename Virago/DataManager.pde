/**
 * SONIA SABRI // VIRAGO DATA HANDLER
 * Checks for connected devices at startup, pings data down the pipe.
 *
 * @author Dan Hett (hellodanhett@gmail.com)
 */
class DataManager {
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

  DataManager(Virago ref, Interface controlsRef) {
    println("[Data Manager]");

    virago = ref;
    controls = controlsRef;
    handshake();
  }

  // called on startup, says hello to all our connected devices
  void handshake() {
    // List all the available serial ports:
    //printArray(Serial.list());

    // Open the port you are using at the rate you want:
    wireless1 = new Serial(virago, "/dev/ttyACM0", 9600);
    wireless2 = new Serial(virago, "/dev/ttyACM1", 9600);
    //wireless3 = new Serial(virago, "/dev/ttyACM2", 9600);
    //wireless4 = new Serial(virago, "/dev/ttyACM3", 9600);
    //wireless5 = new Serial(virago, "/dev/ttyACM4", 9600);
    //strip = new Serial(virago, "/dev/ttyACM5", 9600);
  }

  void update() {
    /*
    while (unit1.available() > 0) {
      String inBuffer = unit1.readString();
      if (inBuffer != null) {
        println(inBuffer);
      }
    }
    */
  }

  /**
   * Sends the instructions to the lights
   */
  void transmit() {
    brightness = controls.brightness.getValue();

    red = str(round(controls.red.getValue() * brightness));
    green = str(round(controls.green.getValue() * brightness));
    blue = str(round(controls.blue.getValue() * brightness));
    speed = str(round(controls.speed.getValue()));

    wireless1.write(red + "," + green + "," + blue + "," + speed);
    wireless1.write(10);

    wireless2.write(red + "," + green + "," + blue + "," + speed);
    wireless2.write(10);
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
