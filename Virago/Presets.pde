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
  DataManager data;

  Presets(Virago ref, Interface controlsRef, DataManager dataRef) {
    println("[Presets]");

    virago = ref;
    controls = controlsRef;
    data = dataRef;
  }

  /**
   * Save an XML for the specified preset.
   */
  public void savePreset(String presetName) {
    XML xml = new XML("settings");

    // save the R/G/B, brightness and limiter
    XML red = xml.addChild("red");
    red.setContent(str(controls.red.getValue()));

    XML green = xml.addChild("green");
    green.setContent(str(controls.green.getValue()));

    XML blue = xml.addChild("blue");
    blue.setContent(str(controls.blue.getValue()));

    XML brightness = xml.addChild("brightness");
    brightness.setContent(str(controls.brightness.getValue()));

    XML limiter = xml.addChild("limiter");
    limiter.setContent(str(controls.limiterSlider.getValue()));

    // save the audio on/off setting
    XML audio = xml.addChild("audio");
    if(controls.audioToggle.getValue() == 1.0)
      audio.setContent("true");
    else
      audio.setContent("false");

    // save the mode
    XML mode = xml.addChild("mode");
    mode.setContent(str(data.mode));

    // save the wireless mode
    XML wirelessMode = xml.addChild("wirelessMode");
    wirelessMode.setContent(str(data.wirelessMode));

    // save the randomness on/off setting
    XML random = xml.addChild("random");
    if(controls.randomToggle.getValue() == 1.0)
      random.setContent("true");
    else
      random.setContent("false");

    // save the slowPulse on/off setting
    XML slowPulse = xml.addChild("slowPulse");
    if(controls.slowPulseToggle.getValue() == 1.0)
      slowPulse.setContent("true");
    else
      slowPulse.setContent("false");

    // save the fastPulse on/off setting
    XML fastPulse = xml.addChild("fastPulse");
    if(controls.fastPulseToggle.getValue() == 1.0)
      fastPulse.setContent("true");
    else
      fastPulse.setContent("false");

    // save the SEND TO WIRED setting
    XML sendToWired = xml.addChild("sendToWired");
    if(controls.wiredToggle.getValue() == 1.0)
      sendToWired.setContent("true");
    else
      sendToWired.setContent("false");

    // save the SEND TO WIRELESS setting
    XML sendToWireless = xml.addChild("sendToWireless");
    if(controls.wirelessToggle.getValue() == 1.0)
      sendToWireless.setContent("true");
    else
      sendToWireless.setContent("false");

    // write the file
    saveXML(xml, "presets/" + presetName + ".xml");
  }

  /**
   * Load the preset back in, and update the interface
   */
  public void loadPreset(String presetName) {
    XML xml = loadXML("presets/" + presetName.replace("cue", "save") + ".xml");

    controls.targetRed = float(xml.getChild("red").getContent());
    controls.targetGreen = float(xml.getChild("green").getContent());
    controls.targetBlue = float(xml.getChild("blue").getContent());
    controls.targetBrightness = float(xml.getChild("brightness").getContent());
    controls.limiterSlider.setValue(float(xml.getChild("limiter").getContent()));

    // restore the audio toggle
    if(xml.getChild("audio").getContent().contains("true")) {
      controls.audioToggle.setValue(true);
      controls.usingLiveAudio = true;
    }
    else {
      controls.audioToggle.setValue(false);
      controls.usingLiveAudio = false;
    }

    // restore the mode
    data.mode = int(xml.getChild("mode").getContent());

    // restore the wirelessMode
    data.wirelessMode = int(xml.getChild("wirelessMode").getContent());

    // restore the randomness
    if(xml.getChild("random").getContent().contains("true")) {
      controls.randomToggle.setValue(true);
      controls.usingRandomness = true;
    }
    else {
      controls.randomToggle.setValue(false);
      controls.usingRandomness = false;
    }

    // restore the slowpulse
    if(xml.getChild("slowPulse").getContent().contains("true")) {
      controls.slowPulseToggle.setValue(true);
      controls.usingSlowPulse = true;
    }
    else {
      controls.slowPulseToggle.setValue(false);
      controls.usingSlowPulse = false;
    }

    // restore the fastpulse
    if(xml.getChild("fastPulse").getContent().contains("true")) {
      controls.fastPulseToggle.setValue(true);
      controls.usingFastPulse = true;
    }
    else {
      controls.fastPulseToggle.setValue(false);
      controls.usingFastPulse = false;
    }

    // restore SEND TO WIRED
    if(xml.getChild("sendToWired").getContent().contains("true")) {
      controls.wiredToggle.setValue(true);
      controls.sendingToWired = true;
    }
    else {
      controls.wiredToggle.setValue(false);
      controls.sendingToWired = false;
    }

    // restore SEND TO WIRELESS
    if(xml.getChild("sendToWireless").getContent().contains("true")) {
      controls.wirelessToggle.setValue(true);
      controls.sendingToWireless = true;
    }
    else {
      controls.wirelessToggle.setValue(false);
      controls.sendingToWireless = false;
    }
  }
}
