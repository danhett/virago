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

void setup() {
  size(1280, 800);
  background(50);

  data = new DataManager(this);
  controls = new Interface(this);
}

void draw() {

}
