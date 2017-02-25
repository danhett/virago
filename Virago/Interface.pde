import controlP5.*;

class Interface {  
  ControlP5 cp5;
  Slider slider;
  Virago virago;

  Interface(Virago ref) {  
    println("[Interface]");

    virago = ref;
    init();
  } 

  void init() {
    buildSelectionControls();
    buildPresetMenu();
  }

  /**
   * Creates the light selection panel
   */
  void buildSelectionControls() {
    cp5 = new ControlP5(virago);

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
      .setColorBackground(color(0, 155, 0))
      .setColorForeground(color(0, 100, 0))
      .setColorActive(color(0, 255, 0)); 
    cp5.addButton("SELECT NONE").setPosition(1060, 80)
      .setSize(200, 50)
      .setColorBackground(color(125, 0, 0))
      .setColorForeground(color(100, 0, 0))
      .setColorActive(color(255, 0, 0));
    cp5.addButton("ALL ON").setPosition(1060, 150)
      .setSize(95, 50)
      .setColorBackground(color(0, 155, 0))
      .setColorForeground(color(0, 100, 0))
      .setColorActive(color(0, 255, 0)); 
    cp5.addButton("ALL OFF").setPosition(1165, 150)
      .setSize(95, 50)
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
        .setColorBackground(color(130, 130, 130))
        .setColorForeground(color(90, 90, 90))
        .setColorActive(color(255, 255, 0));
    }

    line(20, 720, 1260, 720);
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