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
Presets presets;

void setup() {
  size(1280, 800);
  background(30);

  controls = new Interface(this);
  data = new DataManager(this, controls);
  presets = new Presets(this);
}

/**
 * These are events from the Interface class -
 * for some reason Processing tips over if these
 * aren't stored in the root of the application!
 */
public void controlEvent(ControlEvent e) {
  String cmd = e.getController().getName();

  if(cmd.contains("cue")) {
    println("cue: " + cmd);
  }
  if(cmd.contains("save")) {
    println("save: " + cmd);
  }
  else {
    switch(cmd) {
      case "alloff":
        println("TURNING EVERYTHING OFF");
        break;
      case "allon":
        println("TURNING EVERYTHING ON");
        break;
      case "selectall":
        controls.selectAll();
        break;
      case "selectnone":
        controls.selectNone();
        break;
      case "cancelcommands":
        println("CANCELLING EVERYTHING");
        break;
      case "go":
        //data.transmit();
        break;
      case "AUDIO":
        controls.toggleAudio();
        break;
    }
  }
}

void draw() {
  data.update();
  controls.update();
}
