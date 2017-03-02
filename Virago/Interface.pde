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

  Minim minim;
  AudioInput mic;
  Float audioLevel;
  Boolean usingLiveAudio = false;
  Slider gainSlider;

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
  }

  /**
   * Creates the light selection panel
   */
  public void buildSelectionControls() {
    cp5 = new ControlP5(virago);
    PFont pfont = createFont("Courier",14,true); // use true/false for smooth/no-smooth
    font = new ControlFont(pfont,16);

    // create the static lights
    for (int i = 0; i < 12; i++) {
      Toggle toggle = cp5.addToggle("static"+(i+1)).setPosition(20 + (i * 80), 20)
        .setSize(70, 70)
        .setState(true)
        .setColorBackground(color(255, 0, 0))
        .setColorForeground(color(155, 0, 0))
        .setColorActive(color(0, 255, 0));

      staticToggles.add(toggle);
    }

    // create the free lights
    for (int i = 0; i < 5; i++) {
      Toggle toggle = cp5.addToggle("wireless"+(i+1)).setPosition(20 + (i * 80), 130)
        .setSize(70, 70)
        .setState(true)
        .setColorBackground(color(125, 0, 0))
        .setColorForeground(color(100, 0, 0))
        .setColorActive(color(0, 255, 0));

      freeToggles.add(toggle);
    }

    // create the shortcut buttons
    cp5.addButton("selectall").setPosition(1060, 20)
      .setCaptionLabel("SELECT ALL")
      .setSize(200, 50)
      .setFont(font)
      .setColorBackground(color(0, 155, 0))
      .setColorForeground(color(0, 100, 0))
      .setColorActive(color(0, 255, 0));
    cp5.addButton("selectnone").setPosition(1060, 80)
      .setCaptionLabel("SELECT NONE")
      .setSize(200, 50)
      .setFont(font)
      .setColorBackground(color(125, 0, 0))
      .setColorForeground(color(100, 0, 0))
      .setColorActive(color(255, 0, 0));
    cp5.addButton("allon").setPosition(1060, 150)
      .setCaptionLabel("ALL ON")
      .setSize(95, 50)
      .setFont(font)
      .setColorBackground(color(0, 155, 0))
      .setColorForeground(color(0, 100, 0))
      .setColorActive(color(0, 255, 0));
    cp5.addButton("alloff").setPosition(1165, 150)
      .setCaptionLabel("ALL OFF")
      .setSize(95, 50)
      .setFont(font)
      .setColorBackground(color(0, 155, 0))
      .setColorForeground(color(0, 100, 0))
      .setColorActive(color(0, 255, 0));

    stroke(125);
    line(20, 250, 1260, 250);
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
         .setValue(255)
         .setColorCaptionLabel(color(255,255,255));

     green = cp5.addSlider("GREEN")
            .setPosition(20, 340)
            .setSize(400, 50)
            .setColorBackground(color(0, 55, 0))
            .setColorActive(color(0, 255, 0))
            .setColorForeground(color(0, 255, 0))
            .setRange(0, 255)
            .setValue(100)
            .setColorCaptionLabel(color(255,255,255));

    blue = cp5.addSlider("BLUE")
           .setPosition(20, 400)
           .setSize(400, 50)
           .setColorBackground(color(0, 0, 55))
           .setColorActive(color(0, 0, 255))
           .setColorForeground(color(0, 0, 255))
           .setRange(0, 255)
           .setValue(255)
           .setColorCaptionLabel(color(255,255,255));

      brightness = cp5.addSlider("BRIGHTNESS")
              .setPosition(20, 460)
              .setSize(400, 50)
              .setColorBackground(color(55, 55, 55))
              .setColorActive(color(255, 255, 255))
              .setColorForeground(color(255, 255, 255))
              .setRange(0.01, 1)
              .setValue(0.2)
              .setColorCaptionLabel(color(255,255,255));

      stroke(125);
      line(20, 610, 820, 610);
  }

  void buildAudioControls() {
    Toggle audioToggle = cp5.addToggle("AUDIO").setPosition(20, 630)
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
  }

  void update() {
    drawColorPreview();
    drawAudioLevel();
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
    fill(red.getValue(), green.getValue(), blue.getValue());
    rect(500, 280, 300, 300);
  }

  /**
   * Creates the preset list
   */
  public void buildPresetMenu() {
    for (int i = 0; i < 10; i++) {
      cp5.addButton("cue"+(i+1)).setPosition(840, 280 + (i*42))
        .setCaptionLabel("LAUNCH CUE "+(i+1))
        .setSize(300, 30)
        .setFont(font)
        .setColorBackground(color(130, 130, 130))
        .setColorForeground(color(90, 90, 90))
        .setColorActive(color(255, 255, 0));

      cp5.addButton("save"+(i+1)).setPosition(1140, 280 + (i*42))
        .setCaptionLabel("SAVE")
        .setSize(120, 30)
        .setFont(font)
        .setColorBackground(color(0, 155, 0))
        .setColorForeground(color(0, 100, 0))
        .setColorActive(color(0, 255, 0));
    }

    line(20, 710, 1260, 710);
  }


  /**
   * Turns on all the switches.
   */
  public void selectAll() {
    for(Toggle toggle:staticToggles) {
      toggle.setState(true);
    }

    for(Toggle toggle:freeToggles) {
      toggle.setState(true);
    }
  }

  /**
   * Turns off all the switches.
   */
  public void selectNone() {
    for(Toggle toggle:staticToggles) {
      toggle.setState(false);
    }

    for(Toggle toggle:freeToggles) {
      toggle.setState(false);
    }
  }
}
