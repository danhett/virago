import netP5.*;
import oscP5.*;
import controlP5.*;
import http.requests.*;
import processing.serial.*;

// Pebble locations
String pebble1 = "http://192.168.0.111";
String pebble2 = "http://192.168.0.222";

Boolean canIssueCommand = true;
GetRequest get1;
GetRequest get2;
ControlP5 cp5;
Slider slider;

void setup() {
  size(1280, 800);
  background(0);
  
  buildInterface();
}

void buildInterface() {
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
}

void draw() {
  
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
  String[] lines = loadStrings(pebble1 + req); 
  String[] lines2 = loadStrings(pebble2 + req); 
  
  /*
  get1 = new GetRequest(pebble1 + req);
  get1.send();
  
  get2 = new GetRequest(pebble2 + req);
  get2.send();
  */
  
  //println("Reponse Content: " + get1.getContent());
  //println("Reponse Content-Length Header: " + get1.getHeader("Content-Length"));
}