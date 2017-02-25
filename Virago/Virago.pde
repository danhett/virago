/**
 * SONIA SABRI // VIRAGO
 * Light controller application. Designed to allow precise control
 * over both placed and wireless light units, using free commands
 * and pre-set cued styles.
 *
 * @author Dan Hett (hellodanhett@gmail.com)
 */
import processing.serial.*;
import java.text.SimpleDateFormat;
import java.util.Date;

DataManager data;
Interface controls;

void setup() {
  size(1280, 800);
  background(50);

  data = new DataManager(this);
  controls = new Interface(this);
}

/**
 * These are events from the Interface class -
 * for some reason Processing tips over if these
 * aren't stored in the root of the application!
 */
public void controlEvent(ControlEvent e) {
  switch(e.getController().getName()) {
    case "alloff":
      println("TURNING EVERYTHING OFF");
      break;
    case "allon":
      println("TURNING EVERYTHING ON");
      break;
}

  //if(btn == "RED")
  //  makeRequest("/R");

  //else if(btn == "GREEN")
  //  makeRequest("/G");

  //else if(btn == "BLUE")
  //  makeRequest("/B");
}

void draw() {

}
