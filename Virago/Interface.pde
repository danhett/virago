/**
 * SONIA SABRI // VIRAGO INTERFACE
 * Makes buttons and widgets that do nice things. Some manual
 * controls, some preset triggers.
 *
 * @author Dan Hett (hellodanhett@gmail.com)
 */
import controlP5.*;
import ddf.minim.analysis.*;
import ddf.minim.*;

class Interface {
  ControlP5 cp5;
  Virago virago;
  ControlFont font;
  ArrayList<Toggle> staticToggles;
  ArrayList<Toggle> freeToggles;
  Slider red;
  Slider green;
  Slider blue;
  Slider brightness;
  int activePosition;

  Minim minim;
  AudioInput mic;
  Float audioLevel;
  Boolean usingLiveAudio = false;
  Toggle audioToggle;
  Slider gainSlider;
  Float lowThreshold = 0.2;

  Toggle randomToggle;
  Boolean usingRandomness = false;

  Button mode1;
  Button mode2;
  Button mode3;

  Float targetRed = 0.0;
  Float targetGreen = 0.0;
  Float targetBlue = 0.0;
  Float targetBrightness = 0.0;
  int rate = 2;
  Float brightnessRate = 0.01;
  Float savedBrightness;
  Boolean dragging = false;

  Interface(Virago ref) {
    println("[Interface]");

    staticToggles = new ArrayList<Toggle>();
    freeToggles = new ArrayList<Toggle>();

    virago = ref;

    minim = new Minim(virago);
    mic = minim.getLineIn();

    init();
  }

  public void init() {
    buildSelectionControls();
    buildPresetMenu();
    buildColorControls();
    buildAudioControls();
    buildModeControls();
  }

  /**
   * Creates the light selection panel
   */
  public void buildSelectionControls() {
    cp5 = new ControlP5(virago);
    PFont pfont = createFont("Courier",14,true); // use true/false for smooth/no-smooth
    font = new ControlFont(pfont,16);

    String[] wirelessNames = {
      "ALL",
      "W1",
      "W2",
      "W3",
      "W4",
      "W5",
      "PAIR1",
      "PAIR2",
      "BOOM DIE"
    };
    // create the free lights
    for (int i = 0; i < 9; i++) {
      Button button = cp5.addButton("wireless"+i).setPosition(20 + (i * 80), 20)
        .setSize(70, 70)
        .setCaptionLabel(wirelessNames[i])
        .setColorBackground(color(125, 0, 0))
        .setColorForeground(color(100, 0, 0))
        .setColorActive(color(0, 255, 0));

      //freeToggles.add(toggle);
    }


    cp5.addButton("fadeon").setPosition(20, 100)
      .setCaptionLabel("FADE ON")
      .setSize(95, 50)
      .setFont(font)
      .setColorBackground(color(0, 155, 0))
      .setColorForeground(color(0, 100, 0))
      .setColorActive(color(0, 255, 0));
    cp5.addButton("fadeoff").setPosition(125, 100)
      .setCaptionLabel("FADE OFF")
      .setSize(95, 50)
      .setFont(font)
      .setColorBackground(color(0, 155, 0))
      .setColorForeground(color(0, 100, 0))
      .setColorActive(color(0, 255, 0));

    cp5.addButton("instaon").setPosition(300, 100)
      .setCaptionLabel("INSTA ON")
      .setSize(95, 50)
      .setFont(font)
      .setColorBackground(color(0, 155, 0))
      .setColorForeground(color(0, 100, 0))
      .setColorActive(color(0, 255, 0));
    cp5.addButton("instaoff").setPosition(405, 100)
      .setCaptionLabel("INSTA OFF")
      .setSize(95, 50)
      .setFont(font)
      .setColorBackground(color(0, 155, 0))
      .setColorForeground(color(0, 100, 0))
      .setColorActive(color(0, 255, 0));

  }


  /**
   * Creates sliders to control our colors
   */
  public void buildColorControls() {
    red = cp5.addSlider("RED")
         .setPosition(20, 280)
         .setSize(400, 50)
         .setColorBackground(color(55, 0, 0))
         .setColorActive(color(255, 0, 0))
         .setColorForeground(color(255, 0, 0))
         .setRange(0, 255)
         .setValue(targetRed)
         .setColorCaptionLabel(color(255,255,255));

     green = cp5.addSlider("GREEN")
            .setPosition(20, 340)
            .setSize(400, 50)
            .setColorBackground(color(0, 55, 0))
            .setColorActive(color(0, 255, 0))
            .setColorForeground(color(0, 255, 0))
            .setRange(0, 255)
            .setValue(targetGreen)
            .setColorCaptionLabel(color(255,255,255));

    blue = cp5.addSlider("BLUE")
           .setPosition(20, 400)
           .setSize(400, 50)
           .setColorBackground(color(0, 0, 55))
           .setColorActive(color(0, 0, 255))
           .setColorForeground(color(0, 0, 255))
           .setRange(0, 255)
           .setValue(targetBlue)
           .setColorCaptionLabel(color(255,255,255));

      brightness = cp5.addSlider("BRIGHTNESS")
              .setPosition(20, 460)
              .setSize(400, 50)
              .setColorBackground(color(55, 55, 55))
              .setColorActive(color(255, 255, 255))
              .setColorForeground(color(255, 255, 255))
              .setRange(0.0, 1)
              .setValue(targetBrightness)
              .setColorCaptionLabel(color(255,255,255));
  }


  void buildAudioControls() {
    audioToggle = cp5.addToggle("AUDIO").setPosition(20, 630)
      .setCaptionLabel("AUDIO REACT")
      .setSize(50, 50)
      .setColorBackground(color(255, 0, 0))
      .setColorForeground(color(155, 0, 0))
      .setColorActive(color(0, 255, 0));

    gainSlider = cp5.addSlider("gain")
         .setPosition(90, 630)
         .setSize(300, 20)
         .setColorBackground(color(55, 55, 55))
         .setColorActive(color(255, 255, 255))
         .setColorForeground(color(255, 255, 255))
         .setRange(0, 1)
         .setValue(1)
         .setColorCaptionLabel(color(255,255,255));

     randomToggle = cp5.addToggle("RANDOM").setPosition(500, 630)
       .setCaptionLabel("RANDOMNESS")
       .setSize(50, 50)
       .setColorBackground(color(255, 0, 0))
       .setColorForeground(color(155, 0, 0))
       .setColorActive(color(0, 255, 0));
  }

  void updateRandomSetting() {
    if(randomToggle.getValue() == 1.0)
      usingRandomness = true;
    else
      usingRandomness = false;
  }

  void update() {
    background(30);

    // draw the dividing lines
    stroke(125);
    line(20, 610, 720, 610);
    line(20, 710, 720, 710);
    line(20, 250, 720, 250);

    // draw the active selection
    if(activePosition > 0) {
      fill(255,255,255);
      rect(760, (25*activePosition)-5, 20, 20);
    }

    drawColorPreview();
    drawAudioLevel();
    updateColorValues();
  }

  void drawAudioLevel() {
    audioLevel = getAudioLevel() * gainSlider.getValue();

    // draw the background
    fill(55, 55, 55);
    rect(90, 660, 300, 20);

    // draw the audio level
    if(audioLevel * 300 < 100)
      fill(0, 255, 0);
    else if(audioLevel * 300 < 200)
      fill(255, 255, 0);
    else
      fill(255, 0, 0);

    rect(90, 660, audioLevel * 300, 20); // 300 is the box width
  }

  float getAudioLevel() {
    return mic.left.level();
  }

  void toggleAudio() {
    usingLiveAudio = !usingLiveAudio;
  }

  void drawColorPreview() {
    fill(red.getValue() * brightness.getValue(),
         green.getValue() * brightness.getValue(),
         blue.getValue() * brightness.getValue());
    rect(500, 280, 200, 230);
  }

  public void updateColorValues() {
    if(!dragging) {
      if(red.getValue() < targetRed)
        red.setValue(red.getValue() + rate);
      if(red.getValue() > targetRed)
        red.setValue(red.getValue() - rate);

      if(blue.getValue() < targetBlue)
        blue.setValue(blue.getValue() + rate);
      if(blue.getValue() > targetBlue)
        blue.setValue(blue.getValue() - rate);

      if(green.getValue() < targetGreen)
        green.setValue(green.getValue() + rate);
      if(green.getValue() > targetGreen)
        green.setValue(green.getValue() - rate);

      if(brightness.getValue() < targetBrightness)
        brightness.setValue(brightness.getValue() + brightnessRate);
      if(brightness.getValue() > targetBrightness)
        brightness.setValue(brightness.getValue() - brightnessRate);
    }
    else {
      targetRed = red.getValue();
      targetGreen = green.getValue();
      targetBlue = blue.getValue();
      targetBrightness = brightness.getValue();
    }
  }

  /**
   * Slowly fade up and down
   */
  public void fadeAllDown() {
    savedBrightness = targetBrightness;
    targetBrightness = 0.0;
  }
  public void fadeAllUp() {
    targetBrightness = savedBrightness;
  }

  /**
   * Instantly turn on and off
   */
  public void forceAllDown() {

  }
  public void forceAllUp() {

  }

  public void buildModeControls() {
    mode1 = cp5.addButton("MODE1").setPosition(20, 725)
      .setCaptionLabel("ALL LIGHTS")
      .setSize(100, 50)
      .setColorBackground(color(130, 130, 130))
      .setColorForeground(color(90, 90, 90))
      .setColorActive(color(255, 255, 0));

    mode2 = cp5.addButton("MODE2").setPosition(130, 725)
      .setCaptionLabel("ODD ONES")
      .setSize(100, 50)
      .setColorBackground(color(130, 130, 130))
      .setColorForeground(color(90, 90, 90))
      .setColorActive(color(255, 255, 0));

    mode3 = cp5.addButton("MODE3").setPosition(240, 725)
      .setCaptionLabel("PAIRS")
      .setSize(100, 50)
      .setColorBackground(color(130, 130, 130))
      .setColorForeground(color(90, 90, 90))
      .setColorActive(color(255, 255, 0));

  }

  /**
   * Creates the preset list
   */
  public void buildPresetMenu() {
    String[] cueNames = {
      "CONVO1",
      "CONVO2",
      "CONVO3",
      "CONVO4",
      "CONVO5",
      "CONVO6",
      "CONVO7",
      "CONVO8",
      "W6",
      "LRUNWAY",
      "WRUNWAY",
      "ALL_LOW_ORANGE",
      "W0TEAL",
      "W0ORANGE",
      "W0PINK",
      "W3TEAL",
      "W3TEALBOOM",
      "W8KILL",
      "TABLAVOX",
      "SOLOPAIR1",
      "SOLOPAIR2",
      "SOLOPAIR3",
      "SOLOPAIR4",
      "SOLOPAIR5",
      "W0GRAVE",
      "SAFETY",
      "W0PULSE",
      "FOOTWORK",
      "W0FKA"
    };

    for (int i = 0; i < cueNames.length; i++) {
      cp5.addButton("cue"+(i+1)).setPosition(780, 20 + (i*25))
        .setCaptionLabel((i+1) + ": " + cueNames[i])
        .setSize(360, 20)
        .setFont(font)
        .setColorBackground(color(130, 130, 130))
        .setColorForeground(color(90, 90, 90))
        .setColorActive(color(255, 255, 0));

      cp5.addButton("save"+(i+1)).setPosition(1145, 20 + (i*25))
        .setCaptionLabel("SAVE")
        .setSize(120, 20)
        .setFont(font)
        .setColorBackground(color(0, 155, 0))
        .setColorForeground(color(0, 100, 0))
        .setColorActive(color(0, 255, 0));
    }
  }

  public void setActiveCue(String cmd) {
    activePosition = int(cmd.replace("cue", ""));
  }
}
