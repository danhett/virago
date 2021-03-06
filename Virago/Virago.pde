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
Animation anim;

void setup() {
  size(1280, 800);
  //fullScreen();
  background(30);

  anim = new Animation(this);
  controls = new Interface(this);
  data = new DataManager(this, controls, anim);
  presets = new Presets(this, controls, data);
}

/**
 * These are events from the Interface class -
 * for some reason Processing tips over if these
 * aren't stored in the root of the application!
 */
public void controlEvent(ControlEvent e) {
  String cmd = e.getController().getName();

  if(cmd.contains("cue")) {
    presets.loadPreset(cmd);
    controls.setActiveCue(cmd);
    data.proxySendWireless(false);
  }
  if(cmd.contains("save")) {
    presets.savePreset(cmd);
  }
  if(cmd.contains("wireless")) {
    data.setWirelessMode(cmd);
  }
  else {
    switch(cmd) {
      case "fadeoff":
        controls.fadeAllDown();
        data.proxySendWireless(true);
        break;
      case "fadeon":
        controls.fadeAllUp();
        data.proxySendWireless(false);
        break;
      case "instaoff":
        controls.forceAllDown();
        data.proxySendWireless(true);
        break;
      case "instaon":
        controls.forceAllUp();
        data.proxySendWireless(false);
        break;
      case "AUDIO":
        controls.updateAudioSetting();
        break;
      case "MODE1":
        data.mode = 0;
        break;
      case "MODE2":
        data.mode = 1;
        break;
      case "MODE3":
        data.mode = 2;
        break;
      case "RANDOM":
        controls.updateRandomSetting();
        break;
      case "SLOWPULSE":
        controls.updateSlowPulseSetting();
        break;
      case "FASTPULSE":
        controls.updateFastPulseSetting();
        break;
      case "WIREDTOGGLE":
        controls.updateSendToWired();
        break;
      case "WIRELESSTOGGLE":
        controls.updateSendToWireless();
        break;
    }
  }
}

void mousePressed() {
  controls.dragging = true;
}
void mouseReleased() {
  controls.dragging = false;
}

void draw() {
  data.update();
  controls.update();
  anim.update();
}
