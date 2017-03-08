/**
 * SONIA SABRI // VIRAGO ANIMATIONS
 * Handles animation for pulsing.
 *
 * @author Dan Hett (hellodanhett@gmail.com)
 */
class Animation {
  Virago virago;

  Float slow = 0.0;
  Float slowRate = 0.004;
  Boolean slowUp = false;

  Float fast = 0.0;
  Float fastRate = 0.01;
  Boolean fastUp = false;

  Animation(Virago ref) {
    println("[Animation]");

    virago = ref;
  }

  void update() {
    updateSlowClock();
    updateFastClock();
  }

  void updateSlowClock() {
    if(slowUp) {
      if(slow < 1) {
        slow += slowRate;
      }
      else {
        slowUp = false;
      }
    }
    else if(!slowUp) {
      if(slow > 0.0) {
        slow -= slowRate;
      }
      else {
        slowUp = true;
      }
    }

    if(slow > 1.0) slow = 1.0;
    if(slow < 0.0) slow = 0.0;

    //println(slow);
  }

  void updateFastClock() {
    if(fastUp) {
      if(fast < 1) {
        fast += fastRate;
      }
      else {
        fastUp = false;
      }
    }
    else if(!fastUp) {
      if(fast > 0.0) {
        fast -= fastRate;
      }
      else {
        fastUp = true;
      }
    }

    if(fast > 1.0) fast = 1.0;
    if(fast < 0.0) fast = 0.0;

    //println(fast);
  }

  void resetClocks() {

  }
}
