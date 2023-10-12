import fisica.*;
import oscP5.*;
import ddf.minim.*;
Plataformas obstaculos;

public enum TipoPantalla
{
  INICIO, COMO_JUGAR, JUGANDO, PERDISTE, GANASTE
}

class juegoPrincipal {
  public boolean shouldReset  = false;
  Jugador player;
  Minim Ingame, Intro, Disclamer, Perdiste, Ganaste;
  AudioPlayer ingamesound, introSound, perdisteSound, ganasteSound;
  FWorld mundo;
  ArrayList<Enemigos> enemigos;
  int enemigoIntervalo = 2000;
  int contadorEnemigos = 0;
  int tiempoActual = 0;
  int vidas= 3;
  PApplet parent;
  PImage fondo, tiempo;
  PFont font;
  int ultimaManoCerrada = -6000;
  float posYplayer=550;
  OscP5 myOsc;
  Float[] topLeft = {null, 100.0};
  Float[] bottomRight = {null, null};
  float movimientoPlataformaDelMedio;
  TipoPantalla pantallaActual = TipoPantalla.INICIO;
  PImage Pantalla1, Pantalla2, Pantalla3, Pantalla4;
  boolean reproduciendoSonido = false;
  boolean cuentaRegresivaIniciada = false;
  int tiempoRestante = 30;
  long tiempoFinal=0;
  boolean ganasteMostrado = false;

  juegoPrincipal(PApplet parent) {
    this.parent = parent;
    mundo = new FWorld();
    player = new Jugador(mundo);
    obstaculos = new Plataformas(mundo);
    font = loadFont("AgencyFB-Bold-48.vlw");
    textFont(font);

    tiempoActual = millis();

    tiempoFinal = millis() + tiempoRestante * 1000;
    Intro=new Minim(parent);
    Ingame= new Minim(parent);
    Perdiste = new Minim(parent);
    Ganaste = new Minim(parent);

    introSound = Intro.loadFile("sounds/intro.mp3");
    ingamesound = Ingame.loadFile("sounds/ingame.mp3");
    perdisteSound = Perdiste.loadFile("sounds/gameover.mp3");
    ganasteSound = Ganaste.loadFile("sounds/superado (op3).mp3");
    mundo.setEdges();

    Pantalla1 = parent.loadImage("menu_o8.jpg");
    Pantalla1.resize(parent.width, parent.height);
    Pantalla2 = parent.loadImage("gmo_1.jpg");
    Pantalla2.resize(parent.width, parent.height);
    Pantalla3 = parent.loadImage("comojugar_2.jpg");
    Pantalla3.resize(parent.width, parent.height);
    Pantalla4 = parent.loadImage("sup_1.jpg");
    Pantalla4.resize(parent.width, parent.height);
    OscProperties myProperties = new OscProperties();
    myProperties.setDatagramSize(10000);
    myProperties.setListeningPort(8008); // Puerto del que recibe datos
    myOsc = new OscP5(this, myProperties);
    enemigos = new ArrayList<Enemigos>();
    tiempo= loadImage("time.png");
    tiempo.resize(280, 140);
    fondo= loadImage("dungeon.png");
    fondo.resize(1200, 800);
  }

  void oscEvent(OscMessage theOscMessage) {
    String name =theOscMessage.addrPattern();

    if (name.startsWith("/boundingBox")) {

      if (name.equals("/boundingBox/topLeft")) {

        topLeft[0] = theOscMessage.get(0).floatValue();
        topLeft[1] = theOscMessage.get(1).floatValue();
      }
      if (name.equals("/boundingBox/bottomRight")) {
        bottomRight[0] = theOscMessage.get(0).floatValue();
        bottomRight[1] = theOscMessage.get(1).floatValue();
      }
    };
  }

  void draw() {
    float size = CosasMano.getHandSize(topLeft, bottomRight);
    if (size != -10 && size < 110) {
      onManoCerrada();
    }
    if (pantallaActual == TipoPantalla.INICIO) {
      if (!reproduciendoSonido) {
        reproduciendoSonido = true;
        introSound.play();
      }
      parent.image(Pantalla1, 0, 0);
    } else if (pantallaActual == TipoPantalla.COMO_JUGAR) {
      if (!reproduciendoSonido) {
        reproduciendoSonido = true;
      }
      parent.image(Pantalla3, 0, 0);
    } else if (pantallaActual == TipoPantalla.PERDISTE) {
      if (!reproduciendoSonido) {
        reproduciendoSonido = true;
      }
      parent.image(Pantalla2, 0, 0);
    } else if (pantallaActual == TipoPantalla.GANASTE) {
      if (!reproduciendoSonido) {
        reproduciendoSonido=true;
      }
      parent.image(Pantalla4, 0, 0);
    } else {


      reproduciendoSonido = false;
      introSound.pause();
      background(fondo);
      image(tiempo, 905, 40);
      obstaculos.AjustarPlataformaDelMedio();
      mundo.step();
      mundo.draw();
      ingamesound.play();

      // Verificar colisión entre jugador y enemigos
      for (Enemigos enemigo : enemigos) {
        if (player.colisionConEnemigo(enemigo)) {
          vidas--;
          enemigo.borrarEnemigo();
          if (vidas<=0) {
            ingamesound.pause();
            reproduciendoSonido = true;
            pantallaActual = TipoPantalla.PERDISTE;
            perdisteSound.play();
          }
        }
      }
      player.dibujarVidas();

      if (bottomRight[0] != null && topLeft[0] != null) {

        float middle = (900 - bottomRight[0] + 900- topLeft[0]) / 2;

        player.actualizarPosicion(middle);
      }
      player.DibujarSiguienteFrame(frameCount);

      int tiempoTranscurrido = (int)((millis() - tiempoFinal) / 1000);
      int tiempoRestanteActual = max(0, tiempoRestante - tiempoTranscurrido);


      if (tiempoRestanteActual <= 0) {
        println("cuenta terminada");
        // El tiempo ha llegado a 0, muestra la pantalla de "Ganaste"
        pantallaActual = TipoPantalla.GANASTE;
        ingamesound.pause();
        ganasteSound.play();
      }




      fill(255);
      textSize(50);
      text("" + tiempoRestanteActual, 1098, 128);
      int tiempoTranscurridoEnemigo = millis() - tiempoActual;
      if (tiempoTranscurridoEnemigo > enemigoIntervalo) {
        // Generar un enemigo
        for (int i = 0; i < 1; i++) {
          float x = random(30, width-30); // Posición x aleatoria dentro del ancho de la ventana
          float y = random(0); // Posición y arriba de la ventana
          Enemigos nuevoEnemigo = new Enemigos(mundo);
          nuevoEnemigo.getCirculo().setPosition(x, y);
          enemigos.add(nuevoEnemigo);
        }

        // Reiniciar el temporizador y actualizar el contador
        tiempoActual = millis();
        contadorEnemigos++;
      }
      for ( Enemigos este : enemigos)
      {
        este.actualizar();
        este.dibujarCaco();
      }
    }
  }


  void onManoCerrada() {
    if (millis() - ultimaManoCerrada > 3000) {
      ultimaManoCerrada = millis();
    } else {
      return;
    }
      

    if (pantallaActual == TipoPantalla.INICIO) {
      reproduciendoSonido = false;
      pantallaActual = TipoPantalla.COMO_JUGAR;
    } else if (pantallaActual == TipoPantalla.COMO_JUGAR) {
      pantallaActual = TipoPantalla.JUGANDO;
    } else if (pantallaActual == TipoPantalla.PERDISTE || pantallaActual == TipoPantalla.GANASTE) {
      reiniciarJuego();
    }
  }

  void reiniciarJuego() {
    ingamesound.pause(); 
    introSound.pause(); 
    perdisteSound.pause(); 
    ganasteSound.pause();
    mundo.clear();
    shouldReset = true;
  }
}
