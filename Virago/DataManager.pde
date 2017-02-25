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

    // Open the port you are using at the rate you want:
    //unit1 = new Serial(this, Serial.list()[0], 115200);
    //unit2 = new Serial(this, Serial.list()[1], 115200);

    //unit1.write("255,155,55,200");
    //unit2.write("Red two, standing by..." + stamp());
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
