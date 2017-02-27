/**
 * SONIA SABRI // VIRAGO DATA HANDLER
 * Checks for connected devices at startup, pings data down the pipe.
 *
 * @author Dan Hett (hellodanhett@gmail.com)
 */
class DataManager {
  Virago virago;
  Interface controls;
  Serial unit1;
  Serial unit2;

  String red;
  String green;
  String blue;
  String brightness;

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

    String port1 = "/dev/ttyACM0";
    String port2 = "/dev/ttyACM1";

    // Open the port you are using at the rate you want:
    unit1 = new Serial(virago, port1, 9600);
    unit2 = new Serial(virago, port2, 9600);
  }

  void update() {
    while (unit1.available() > 0) {
      String inBuffer = unit1.readString();
      if (inBuffer != null) {
        println(inBuffer);
      }
    }

    while (unit2.available() > 0) {
      String inBuffer = unit2.readString();
      if (inBuffer != null) {
        println(inBuffer);
      }
    }
  }

  /**
   * Sends the instructions to the lights
   */
  void transmit() {
    red = str(round(controls.red.getValue()));
    green = str(round(controls.green.getValue()));
    blue = str(round(controls.blue.getValue()));
    brightness = str(round(controls.brightness.getValue()));

    println(green);

    unit1.write(red + "," + green + "," + blue + "," + brightness);
    unit1.write(10);

    unit2.write(red + "," + green + "," + blue + "," + brightness);
    unit2.write(10);
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
