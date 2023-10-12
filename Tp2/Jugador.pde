//falta hacer la animacion, las vidas y que se resten si colisionan, hay un metodo de la libreria de fisica para saber si un objeto con fisica
//choca con otro con fisica, el tema es que el jugador no tiene fisica, se podria hacer un objeto de fisica pero con 0 gravedad
//video parea detectar contactos = https://www.youtube.com/watch?v=THn7Xy1lpLs&ab_channel=Inform%C3%A1ticaAplicada2C%C3%A1tedraCausa-ATAM-UNA

class Jugador {

  FBox instanciaFBox;
  String direccionJugadorSprite = "quieto";
  ArrayList<PImage> SpritesIzquierda= new ArrayList();
  ArrayList<PImage> SpritesDerecha = new ArrayList();
  ArrayList<PImage> vidasPerdidasImages = new ArrayList<PImage>();
  int SpriteIndex;
  PImage previousSprite;
  int vidasJugador;
  PImage vidaLlena, vidaMedia, vidaBaja, vidaCero;

  Jugador(FWorld mundo) {
    instanciaFBox = new FBox(120, 120);
    instanciaFBox.setName("player");
    instanciaFBox.setPosition(600, 600);
    instanciaFBox.setDrawable(false);
    vidasJugador=4;
    vidaLlena=loadImage("vida_00.png");
    vidaLlena.resize(280, 140);
    vidaMedia=loadImage("vida_01.png");
    vidaMedia.resize(280, 140);
    vidaBaja=loadImage("vida_02.png");
    vidaBaja.resize(280, 140);
    vidaCero=loadImage("vida_03.png");
    vidaCero.resize(280, 140);

    for ( int i=0; i<14; i++ ) {
      PImage frameIzquierda = loadImage("mizq_"+nf(i, 2)+".png" );
      PImage frameDerecha = loadImage("mder_"+nf(i, 2)+".png" );
      frameIzquierda.resize(120, 130);
      frameDerecha.resize(120, 130);
      SpritesIzquierda.add(frameIzquierda);
      SpritesDerecha.add(frameDerecha);
    }
    mundo.add(this.instanciaFBox);
  }

  void actualizarPosicion(float nuevoX) {
    float xActual = instanciaFBox.getX();
    if (xActual > nuevoX) {
      direccionJugadorSprite="derecha";
    } else if (xActual < nuevoX) {
      direccionJugadorSprite="izquierda";
    } else {
      direccionJugadorSprite="quieto";
    }
   
    instanciaFBox.setPosition(nuevoX, 700);
  }



  void DibujarSiguienteFrame(int frameCount) {
    PImage siguienteSprite = previousSprite;
    if (siguienteSprite == null) {
      siguienteSprite = SpritesIzquierda.get(0);
    }
    if (frameCount % 4 == 0) {
      if (direccionJugadorSprite.equals("izquierda")) {
        siguienteSprite = SpritesIzquierda.get(SpriteIndex);
      }
      if (direccionJugadorSprite.equals("derecha")) {
        siguienteSprite = SpritesDerecha.get(SpriteIndex);
      } else {
        // El primer spriteIzquierda está de espaldas
        // y es lo mismo que estar quieto
        siguienteSprite = SpritesIzquierda.get(0);
      }
      previousSprite = siguienteSprite;
      SpriteIndex++;
      SpriteIndex = (SpriteIndex % 14) ;
    }
    push();
    imageMode(CENTER);
    image(siguienteSprite, instanciaFBox.getX(), instanciaFBox.getY());
    pop();
  }

  boolean colisionConEnemigo(Enemigos enemigo) {
    FBox jugadorBox = instanciaFBox;
    FCircle enemigoBox = enemigo.getCirculo();
    if (jugadorBox.isTouchingBody(enemigoBox)) {
      vidasJugador--;
      if (vidasJugador < 0) {
        vidasJugador = 0;
      }
      return true;
    }
    return false;
  }

  void dibujarVidas() {
    float yOffset = 40; // Ajusta la posición vertical de las imágenes de las vidas
    float xOffset = 20; // Ajusta la posición horizontal de las imágenes de las vidas
    // Dibujo las imagenes de
    for (int i = 0; i < vidasJugador; i++) {
      if (i == 3) {
        image(vidaLlena, xOffset, yOffset);
      } else if (i == 2) {
        image(vidaMedia, xOffset, yOffset);
      } else if (i == 1) {
        image(vidaBaja, xOffset, yOffset);
      } else if (i==0) {
        image(vidaCero, xOffset, yOffset);
      }
    }
  }

  void reset() {
    instanciaFBox.setPosition(600, 600);
    direccionJugadorSprite = "quieto";
    vidasJugador = 4;
    dibujarVidas();
  }
}
