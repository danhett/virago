/**
 * SONIA SABRI // VIRAGO INTERFACE
 * Makes buttons and widgets that do nice things. Some manual
 * controls, some preset triggers.
 *
 * @author Dan Hett (hellodanhett@gmail.com)
 */
import controlP5.*;

class Interface {
  ControlP5 cp5;
  Slider slider;
  Virago virago;
  ControlFont font;

  Interface(Virago ref) {
    println("[Interface]");

    virago = ref;
    init();
  }

  void init() {
    buildSelectionControls();
    buildPresetMenu();
    buildTriggers();
  }

  /**
   * Creates the light selection panel
   */
  void buildSelectionControls() {
    cp5 = new ControlP5(virago);
    PFont pfont = createFont("Courier",14,true); // use true/false for smooth/no-smooth
    font = new ControlFont(pfont,16);

    // create the static lights
    for (int i = 0; i < 10; i++) {
      cp5.addToggle("static"+(i+1)).setPosition(20 + (i * 90), 20)
        .setSize(80, 80)
        .setColorBackground(color(255, 0, 0))
        .setColorForeground(color(155, 0, 0))
        .setColorActive(color(0, 255, 0));
    }

    // create the free lights
    for (int i = 0; i < 5; i++) {
      cp5.addToggle("free"+(i+1)).setPosition(20 + (i * 90), 130)
        .setSize(80, 80)
        .setColorBackground(color(125, 0, 0))
        .setColorForeground(color(100, 0, 0))
        .setColorActive(color(0, 255, 0));
    }

    // create the shortcut buttons
    cp5.addButton("SELECT ALL").setPosition(1060, 20)
      .setSize(200, 50)
      .setFont(font)
      .setColorBackground(color(0, 155, 0))
      .setColorForeground(color(0, 100, 0))
      .setColorActive(color(0, 255, 0));
    cp5.addButton("SELECT NONE").setPosition(1060, 80)
      .setSize(200, 50)
      .setFont(font)
      .setColorBackground(color(125, 0, 0))
      .setColorForeground(color(100, 0, 0))
      .setColorActive(color(255, 0, 0));
    cp5.addButton("ALL ON").setPosition(1060, 150)
      .setSize(95, 50)
      .setFont(font)
      .setColorBackground(color(0, 155, 0))
      .setColorForeground(color(0, 100, 0))
      .setColorActive(color(0, 255, 0));
    cp5.addButton("ALL OFF").setPosition(1165, 150)
      .setSize(95, 50)
      .setFont(font)
      .setColorBackground(color(0, 155, 0))
      .setColorForeground(color(0, 100, 0))
      .setColorActive(color(0, 255, 0));

    stroke(125);
    line(20, 250, 1260, 250);
  }

  /**
   * Creates the preset list
   */
  void buildPresetMenu() {
    String[] trees = { "SWITCH TO", "FADE TO", "GLIMMER", "RANDOM", "PULSE", "AUDIO REACT" };

    for (int i = 0; i < trees.length; i++) {
      cp5.addToggle(trees[i]).setPosition(20, 280 + (i*70))
        .setSize(300, 50)
        .setColorBackground(color(130, 130, 130))
        .setColorForeground(color(90, 90, 90))
        .setColorActive(color(255, 255, 0));
    }

    for (int i = 0; i < 10; i++) {
      cp5.addButton("CUE PRESET "+(i+1)).setPosition(860, 280 + (i*42))
        .setSize(400, 30)
        .setFont(font)
        .setColorBackground(color(130, 130, 130))
        .setColorForeground(color(90, 90, 90))
        .setColorActive(color(255, 255, 0));
    }

    line(20, 710, 1260, 710);
  }

  void buildTriggers() {
    cp5.addButton("CLEAR").setPosition(20, 730)
      .setSize(610, 50)
      .setFont(font)
      .setColorBackground(color(125, 0, 0))
      .setColorForeground(color(100, 0, 0))
      .setColorActive(color(255, 0, 0));

    cp5.addButton("EXECUTE SEQUENCE").setPosition(650, 730)
      .setSize(610, 50)
      .setFont(font)
      .setColorBackground(color(0, 155, 0))
      .setColorForeground(color(0, 100, 0))
      .setColorActive(color(0, 255, 0));
  }

  public void controlEvent(ControlEvent theEvent) {
    //String btn = theEvent.getController().getName();

    //if(btn == "RED")
    //  makeRequest("/R");

    //else if(btn == "GREEN")
    //  makeRequest("/G");

    //else if(btn == "BLUE")
    //  makeRequest("/B");
  }
}
