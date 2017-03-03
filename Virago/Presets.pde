/**
 * SONIA SABRI // VIRAGO PRESETS
 * Saves and loads user presets.
 * "LAUNCH CUE" will do the load too,
 * and "SAVE" will overwrite the cue.
 *
 * @author Dan Hett (hellodanhett@gmail.com)
 */
class Presets {
  Virago virago;
  Interface controls;

  Presets(Virago ref, Interface controlsRef) {
    println("[Presets]");

    virago = ref;
    controls = controlsRef;
  }

  // To save:
  // STATICS-ON WIRELESS-ON RED GREEN BLUE BRIGHTNESS AUDIO
  public void savePreset(String presetName) {
    XML xml = new XML("settings");

    // save the static toggles
    int i = 0;
    for(Toggle toggle:controls.staticToggles) {
      i++;
      XML newChild = xml.addChild("static"+str(i));
      if(toggle.getValue() == 1.0)
        newChild.setContent("true");
      else
        newChild.setContent("false");
    }

    // save the free toggles
    int j = 0;
    for(Toggle toggle:controls.freeToggles) {
      j++;
      XML newChild = xml.addChild("free"+str(i));
      if(toggle.getValue() == 1.0)
        newChild.setContent("true");
      else
        newChild.setContent("false");
    }

    // save the R/G/B and brightness
    XML red = xml.addChild("red");
    red.setContent(str(controls.red.getValue()));

    XML green = xml.addChild("green");
    green.setContent(str(controls.green.getValue()));

    XML blue = xml.addChild("blue");
    blue.setContent(str(controls.blue.getValue()));

    XML brightness = xml.addChild("brightness");
    brightness.setContent(str(controls.brightness.getValue()));

    // save the audio on/off setting
    XML audio = xml.addChild("audio");
    if(controls.audioToggle.getValue() == 1.0)
      audio.setContent("true");
    else
      audio.setContent("false");

    // write the file
    saveXML(xml, "presets/" + presetName + ".xml");
  }
}
