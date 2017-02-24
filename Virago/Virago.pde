/** 
 * SONIA SABRI // VIRAGO
 * Light controller application. Designed to allow precise control
 * over both placed and wireless light units, using free commands 
 * and pre-set cued styles. 
 *
 * @author Dan Hett (hellodanhett@gmail.com)
 */
import controlP5.*;
import processing.serial.*;
import java.text.SimpleDateFormat;
import java.util.Date;

ControlP5 cp5;
Slider slider;

Serial unit1;
Serial unit2;
  
void setup() {
  size(1280, 800);
  background(50);
  
  buildSelectionControls();
  buildPresetMenu();
  pingUnits();  
}

/**
 * Creates the light selection panel
 */
void buildSelectionControls() {
  cp5 = new ControlP5(this);
  
  // create the static lights
  for(int i = 0; i < 10; i++) {
    cp5.addToggle("static"+(i+1)).setPosition(20 + (i * 90),20)
                      .setSize(80,80)
                      .setColorBackground(color(255,0,0))
                      .setColorForeground(color(155,0,0))
                      .setColorActive(color(0,255,0));
  }
  
  // create the free lights
  for(int i = 0; i < 5; i++) {
    cp5.addToggle("free"+(i+1)).setPosition(20 + (i * 90), 130)
                      .setSize(80,80)
                      .setColorBackground(color(125,0,0))
                      .setColorForeground(color(100,0,0))
                      .setColorActive(color(0,255,0));
  }
  
  // create the shortcut buttons
  cp5.addButton("SELECT ALL").setPosition(1060, 20)
                      .setSize(200,50)
                      .setColorBackground(color(0,155,0))
                      .setColorForeground(color(0,100,0))
                      .setColorActive(color(0,255,0)); 
  cp5.addButton("SELECT NONE").setPosition(1060, 80)
                      .setSize(200,50)
                      .setColorBackground(color(125,0,0))
                      .setColorForeground(color(100,0,0))
                      .setColorActive(color(255,0,0));
  cp5.addButton("ALL ON").setPosition(1060, 150)
                      .setSize(95,50)
                      .setColorBackground(color(0,155,0))
                      .setColorForeground(color(0,100,0))
                      .setColorActive(color(0,255,0)); 
  cp5.addButton("ALL OFF").setPosition(1165, 150)
                      .setSize(95,50)
                      .setColorBackground(color(0,155,0))
                      .setColorForeground(color(0,100,0))
                      .setColorActive(color(0,255,0)); 
                      
  stroke(125);
  line(20,250,1260,250);
}

/**
 * Creates the preset list
 */
void buildPresetMenu() {
  String[] trees = { "SWITCH TO", "FADE TO", "GLIMMER", "RANDOM", "PULSE", "AUDIO REACT" };
  
  for(int i = 0; i < trees.length; i++) {
    cp5.addToggle(trees[i]).setPosition(20, 280 + (i*70))
                      .setSize(300,50)
                      .setColorBackground(color(130,130,130))
                      .setColorForeground(color(90,90,90))
                      .setColorActive(color(255,255,0));
  }
  
  for(int i = 0; i < 10; i++) {
    cp5.addButton("CUE PRESET "+(i+1)).setPosition(860, 280 + (i*42))
                      .setSize(400,30)
                      .setColorBackground(color(130,130,130))
                      .setColorForeground(color(90,90,90))
                      .setColorActive(color(255,255,0));
  }
  
  line(20,720,1260,720);
}
 
void pingUnits() {
 // List all the available serial ports:
  //printArray(Serial.list());
  
  // Open the port you are using at the rate you want:
  unit1 = new Serial(this, Serial.list()[0], 115200);
  unit2 = new Serial(this, Serial.list()[1], 115200);
  
  // Send a capital "A" out the serial port
  unit1.write("Red one, standing by..." + stamp()); 
  unit2.write("Red two, standing by..." + stamp()); 
}

String stamp() {
  SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss.SSS");
  
  Date d = new Date();  
  return sdf.format(d.getTime());
}

void draw() {
  while (unit1.available() > 0) {
    String inBuffer = unit1.readString();   
    if (inBuffer != null) {
      println(inBuffer);
    }
  }
  
  while (unit2.available() > 0) {
    String inBuffer = unit2.readString();   
    if (inBuffer != null) {
      println(inBuffer);
    }
  } 
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


void makeRequest(String req) {
  //String[] lines = loadStrings(pebble1 + req); 
  //String[] lines2 = loadStrings(pebble2 + req); 
  
  /*
  get1 = new GetRequest(pebble1 + req);
  get1.send();
  
  get2 = new GetRequest(pebble2 + req);
  get2.send();
  */
  
  //println("Reponse Content: " + get1.getContent());
  //println("Reponse Content-Length Header: " + get1.getHeader("Content-Length"));
}