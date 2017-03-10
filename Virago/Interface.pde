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
  Slider limiterSlider;
  Float lowThreshold = 0.2;

  Toggle randomToggle;
  Boolean usingRandomness = false;
  Toggle slowPulseToggle;
  Boolean usingSlowPulse = false;
  Toggle fastPulseToggle;
  Boolean usingFastPulse = false;

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

  Toggle wiredToggle;
  Boolean sendingToWired = true;
  Toggle wirelessToggle;
  Boolean sendingToWireless = true;

  int colHeight = 30;
  String[] cueNames;

  Interface(Virago ref) {
    println("[Interface]");

    virago = ref;

    minim = new Minim(virago);
    mic = minim.getLineIn();

    init();
  }

  public void init() {
    setupControlP5();

    buildTargetControls();
    buildSelectionControls();
    buildPresetMenu();
    buildColorControls();
    buildAudioControls();
    buildModeControls();
  }

  /**
   * Init ControlP5 and create a custom font in advance.
   */
  void setupControlP5() {
    cp5 = new ControlP5(virago);
    PFont pfont = createFont("Courier",14,true); // use true/false for smooth/no-smooth
    font = new ControlFont(pfont,16);
  }

  /**
   * Builds two large filter buttons for WIRES and WIRELSS transmission.
   */
  void buildTargetControls() {
    wiredToggle = cp5.addToggle("WIREDTOGGLE").setPosition(20, 20)
      .setSize(350, 80)
      .setFont(font)
      .setCaptionLabel("WIRED")
      .setColorBackground(color(255, 0, 0))
      .setColorForeground(color(155, 0, 0))
      .setColorActive(color(0, 255, 0));

    wirelessToggle = cp5.addToggle("WIRELESSTOGGLE").setPosition(380, 20)
      .setSize(350, 80)
      .setFont(font)
      .setCaptionLabel("WIRELESS")
      .setColorBackground(color(255, 0, 0))
      .setColorForeground(color(155, 0, 0))
      .setColorActive(color(0, 255, 0));
  }

  /**
   * Creates the wireless mode selection panel
   */
  public void buildSelectionControls() {
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
      Button button = cp5.addButton("wireless"+i).setPosition(20 + (i * 80), 160)
        .setSize(70, 70)
        .setCaptionLabel(wirelessNames[i])
        .setColorBackground(color(125, 0, 0))
        .setColorForeground(color(100, 0, 0))
        .setColorActive(color(0, 255, 0));
    }

    cp5.addButton("fadeon").setPosition(20, 250)
      .setCaptionLabel("FADE ON")
      .setSize(95, 50)
      .setFont(font)
      .setColorBackground(color(0, 155, 0))
      .setColorForeground(color(0, 100, 0))
      .setColorActive(color(0, 255, 0));
    cp5.addButton("fadeoff").setPosition(125, 250)
      .setCaptionLabel("FADE OFF")
      .setSize(95, 50)
      .setFont(font)
      .setColorBackground(color(0, 155, 0))
      .setColorForeground(color(0, 100, 0))
      .setColorActive(color(0, 255, 0));

    cp5.addButton("instaon").setPosition(300, 250)
      .setCaptionLabel("INSTA ON")
      .setSize(95, 50)
      .setFont(font)
      .setColorBackground(color(0, 155, 0))
      .setColorForeground(color(0, 100, 0))
      .setColorActive(color(0, 255, 0));
    cp5.addButton("instaoff").setPosition(405, 250)
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
         .setPosition(20, 350)
         .setSize(400, 50)
         .setColorBackground(color(55, 0, 0))
         .setColorActive(color(255, 0, 0))
         .setColorForeground(color(255, 0, 0))
         .setRange(0, 255)
         .setValue(targetRed)
         .setColorCaptionLabel(color(255,255,255));

     green = cp5.addSlider("GREEN")
            .setPosition(20, 410)
            .setSize(400, 50)
            .setColorBackground(color(0, 55, 0))
            .setColorActive(color(0, 255, 0))
            .setColorForeground(color(0, 255, 0))
            .setRange(0, 255)
            .setValue(targetGreen)
            .setColorCaptionLabel(color(255,255,255));

    blue = cp5.addSlider("BLUE")
           .setPosition(20, 470)
           .setSize(400, 50)
           .setColorBackground(color(0, 0, 55))
           .setColorActive(color(0, 0, 255))
           .setColorForeground(color(0, 0, 255))
           .setRange(0, 255)
           .setValue(targetBlue)
           .setColorCaptionLabel(color(255,255,255));

    brightness = cp5.addSlider("BRIGHTNESS")
            .setPosition(20, 530)
            .setSize(400, 50)
            .setColorBackground(color(55, 55, 55))
            .setColorActive(color(255, 255, 255))
            .setColorForeground(color(255, 255, 255))
            .setRange(0.0, 1)
            .setValue(targetBrightness)
            .setColorCaptionLabel(color(255,255,255));
  }

  /**
   * Creates checkboxes for audio controls, allowing the use of audio
   * input and animation. Also creates a top-end limiter slider.
   */
  void buildAudioControls() {
    audioToggle = cp5.addToggle("AUDIO").setPosition(20, 630)
      .setCaptionLabel("AUDIO REACT")
      .setSize(50, 50)
      .setColorBackground(color(255, 0, 0))
      .setColorForeground(color(155, 0, 0))
      .setColorActive(color(0, 255, 0));

    limiterSlider = cp5.addSlider("LIMITER")
         .setPosition(90, 630)
         .setSize(300, 20)
         .setColorBackground(color(55, 55, 55))
         .setColorActive(color(255, 255, 255))
         .setColorForeground(color(255, 255, 255))
         .setRange(0, 1)
         .setValue(1)
         .setColorCaptionLabel(color(255,255,255));

     randomToggle = cp5.addToggle("RANDOM").setPosition(500, 630)
       .setCaptionLabel("RANDOM")
       .setSize(50, 50)
       .setColorBackground(color(255, 0, 0))
       .setColorForeground(color(155, 0, 0))
       .setColorActive(color(0, 255, 0));

     slowPulseToggle = cp5.addToggle("SLOWPULSE").setPosition(560, 630)
       .setCaptionLabel("SLOW PULSE")
       .setSize(50, 50)
       .setColorBackground(color(255, 0, 0))
       .setColorForeground(color(155, 0, 0))
       .setColorActive(color(0, 255, 0));

     fastPulseToggle = cp5.addToggle("FASTPULSE").setPosition(620, 630)
       .setCaptionLabel("FAST PULSE")
       .setSize(50, 50)
       .setColorBackground(color(255, 0, 0))
       .setColorForeground(color(155, 0, 0))
       .setColorActive(color(0, 255, 0));
  }

  /**
   * Quick update handlers for our checkboxes
   */
  void updateAudioSetting() {
    usingLiveAudio = !usingLiveAudio;
  }

  void updateRandomSetting() {
    usingRandomness = !usingRandomness;
  }

  void updateSlowPulseSetting() {
    usingSlowPulse = !usingSlowPulse;
  }

  void updateFastPulseSetting() {
    usingFastPulse = !usingFastPulse;
  }

  void updateSendToWired() {
    sendingToWired = !sendingToWired;
  }

  void updateSendToWireless() {
    sendingToWireless = !sendingToWireless;
  }

  /**
   * Tick
   */
  void update() {
    background(30);

    // draw the dividing lines
    stroke(125);
    line(20, 610, 730, 610);
    line(20, 710, 730, 710);
    line(20, 320, 730, 320);
    line(20, 140, 730, 140);

    // draw the active selection
    if(activePosition > 0) {
      // col 1
      if(activePosition < (colHeight+1)) {
        fill(255,255,255);
        rect(760, (25*activePosition)-5, 20, 20);
      }
      // col 2
      else {
        fill(255,255,255);
        rect(1015, 20 + (((activePosition-1)-colHeight)*25), 20, 20);
      }
    }

    drawColorPreview();
    drawAudioLevel();
    updateColorValues();
  }

  void drawAudioLevel() {
    audioLevel = getAudioLevel() * limiterSlider.getValue();

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

  void drawColorPreview() {
    fill(red.getValue() * brightness.getValue(),
         green.getValue() * brightness.getValue(),
         blue.getValue() * brightness.getValue());
    rect(500, 350, 200, 230);
  }

  /**
   * Pushes our controllers towards their targets,
   * so we get a nice fade when changing presets.
   */
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
    // TODO
  }
  public void forceAllUp() {
    // TODO
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

    String[] cueList = {
      "ALLOFF",
      "CONVO1",
      "CONVO2",
      "CONVO3",
      "CONVO4",
      "CONVO5",
      "CONVO6",
      "CONVO7",
      "CONVO8",
      "W6PINK",
      "LRUNWAY",
      "W1FADEUP",
      "W2FADEUP",
      "W3FADEUP",
      "W4FADEUP",
      "W5FADEUP",
      "ALL_LOW_ORANGE",
      "W0TEAL",
      "W0ORANGE",
      "W0PINK",
      "W3TEAL",
      "W8KILL",
      "TABLAVOX1",
      "TABLAVOXPAIR1",
      "TABLAVOXPAIR2",
      "TABLAVOXPAIR3",
      "TABLAVOXPAIR4",
      "TABLAVOX2",
      "PAIRCHATTER1",
      "PAIRCHATTER2",
      "PAIRCHATTER3",
      "PAIRCHATTER4",
      "PAIRCHATTER5",
      "ALLCHATTER",
      "W3GRAVESTART",
      "W0GRAVE",
      "SAFETY1",
      "SAFETY2",
      "SAFETY3",
      "SAFETY4",
      "SAFETY5",
      "W0PULSE",
      "FOOTWORK",
      "W0KFA",
      "L12FK",
      "L11FK",
      "L10FK",
      "L9FK",
      "L8FK",
      "L7FK",
      "L6FK",
      "L5FK",
      "L4FK",
      "L3FK",
      "L2FK",
      "L1FK"
    };

    cueNames = cueList;

    for (int i = 0; i < cueNames.length; i++) {
      if(i < colHeight) {
        cp5.addButton("cue"+(i+1)).setPosition(780, 20 + (i*25))
          .setCaptionLabel((i+1) + ": " + cueNames[i])
          .setSize(200, 20)
          .setFont(font)
          .setColorBackground(color(130, 130, 130))
          .setColorForeground(color(90, 90, 90))
          .setColorActive(color(255, 255, 0));

        cp5.addButton("save"+(i+1)).setPosition(985, 20 + (i*25))
          .setCaptionLabel("S")
          .setSize(20, 20)
          .setFont(font)
          .setColorBackground(color(0, 155, 0))
          .setColorForeground(color(0, 100, 0))
          .setColorActive(color(0, 255, 0));
      }

      else {
        cp5.addButton("cue"+(i+1)).setPosition(1040, 20 + ((i-colHeight)*25))
          .setCaptionLabel((i+1) + ": " + cueNames[i])
          .setSize(200, 20)
          .setFont(font)
          .setColorBackground(color(130, 130, 130))
          .setColorForeground(color(90, 90, 90))
          .setColorActive(color(255, 255, 0));

        cp5.addButton("save"+(i+1)).setPosition(1245, 20 + ((i-colHeight)*25))
          .setCaptionLabel("S")
          .setSize(20, 20)
          .setFont(font)
          .setColorBackground(color(0, 155, 0))
          .setColorForeground(color(0, 100, 0))
          .setColorActive(color(0, 255, 0));
      }
    }
  }

  public void setActiveCue(String cmd) {
    activePosition = int(cmd.replace("cue", ""));
  }
}
