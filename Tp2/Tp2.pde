import netP5.*;
import oscP5.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import fisica.*;
import netP5.*;
import oscP5.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import fisica.*;
import netP5.*;
import oscP5.*;
import fisica.*;


juegoPrincipal miJuego;

void setup() {
  size(1200, 800);
  Fisica.init(this);
  miJuego = new juegoPrincipal(this);
}

void draw() {
  miJuego.draw();
  if(miJuego.shouldReset){
    miJuego = new juegoPrincipal(this);
  };
}
