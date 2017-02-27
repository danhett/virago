/**
 * SONIA SABRI // VIRAGO DATA HANDLER
 * Checks for connected devices at startup, pings data down the pipe.
 *
 * @author Dan Hett (hellodanhett@gmail.com)
 */
class DataManager {
  Virago virago;
  Serial unit1;
  Serial unit2;

  DataManager(Virago ref) {
    println("[Data Manager]");

    virago = ref;
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

    unit1.write("255,0,255,0" );
    unit1.write(10);

    unit2.write("255,0,255,0" );
    unit2.write(10);
    //unit2.write("Red two, standing by..." + stamp());
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
   * Add a timestamp to responses
   */
  String stamp() {
    SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss.SSS");

    Date d = new Date();
    return sdf.format(d.getTime());
  }
}
