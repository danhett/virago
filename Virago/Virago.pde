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

Serial unit1;
Serial unit2;
  
void setup() {
  size(1280, 800);
  background(50);
  
  data = new DataManager();
  controls = new Interface(this);
  
  //pingUnits();  
}


 
void pingUnits() {
 // List all the available serial ports:
  //printArray(Serial.list());
  
  // Open the port you are using at the rate you want:
  unit1 = new Serial(this, Serial.list()[0], 115200);
  //unit2 = new Serial(this, Serial.list()[1], 115200);
  
  unit1.write("255,155,55,200"); 
  //unit2.write("Red two, standing by..." + stamp()); 
}

String stamp() {
  SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss.SSS");
  
  Date d = new Date();  
  return sdf.format(d.getTime());
}

void draw() {
  /*
  while (unit1.available() > 0) {
    String inBuffer = unit1.readString();   
    if (inBuffer != null && inBuffer.length() > 0) {
      println(inBuffer.length());
    }
  }
  */
  
  /*
  while (unit2.available() > 0) {
    String inBuffer = unit2.readString();   
    if (inBuffer != null) {
      println(inBuffer);
    }
  } 
  */
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