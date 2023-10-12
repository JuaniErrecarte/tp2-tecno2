//problemas en enemigo: solo sale el numero 1 en tipoDeEnemgio asique solo se hace caco y no mystik-  la imagen se hace por debaje del circulo pero si se hace
//falta hacer que saquen vida al jugador y que se si dos iguales se chocan se fusionen y saquen mas vida (en vez de 1 vida, 2 o 3)
// link al video para hacer que si dos objetos con fisica se chocan se fusionen: https://youtu.be/ljLwENwv0Fc
class Enemigos {
  FCircle circulo;
  ArrayList<PImage>spriteDeEnemigo= new ArrayList<PImage>();
  int cont = 0;
  int tipoDeEnemigo= int(random(1, 3));
  int primerNumeroEnemigo=0;
  float velocidadDeMovimiento=2;
  FWorld mundo;
  
  Enemigos(FWorld mundo) {
    circulo = new FCircle(30);
    circulo.setName("caco");
    circulo.setRestitution(0.4);
    circulo.setPosition(random(30, width - 30), random(0, height - 30));
    String nombreDelEnemigo="";
    if (tipoDeEnemigo==2) {
      nombreDelEnemigo="caco_";
    } else if (tipoDeEnemigo==1) {
      nombreDelEnemigo= "mystic_";
      circulo.addImpulse(100, 100, circulo.getX(), circulo.getY());
    }
    for ( int i=0; i<13; i++ ) {
      PImage esteFrame = loadImage(nombreDelEnemigo+nf(i, 2)+".png" );
      spriteDeEnemigo.add(esteFrame);
    }
    this.mundo = mundo;
    mundo.add(circulo);
  }

  void dibujarCaco() {
    push();
    spriteDeEnemigo.get(cont).resize(100, 100);
    imageMode(CENTER);
    image(spriteDeEnemigo.get(cont), circulo.getX(), circulo.getY());
    cont = (cont + 1) % 13;
    pop();
  }

  FCircle getCirculo() {
    return circulo;
  }
  void actualizar() {
    float nuevaPosY = circulo.getY() + velocidadDeMovimiento; // Actualiza la posición en Y
    circulo.setPosition(circulo.getX(), nuevaPosY);
  }
  void borrarEnemigo() {
    ArrayList<FBody> cuerpos= this.mundo.getBodies();
    for (FBody este : cuerpos) {
      String nombre=este.getName();
      if ( nombre!= null) {
        if (nombre.equals("caco")) {
          if (este.getY()>550) {
            mundo.remove(este);
          }
        }
      }
    }
  }
    void reset() {
    circulo = new FCircle(30);
    circulo.setName("caco");
    circulo.setRestitution(0.4);
    circulo.setPosition(random(30, width - 30), random(0, height - 30));
    String nombreDelEnemigo = "";
    if (tipoDeEnemigo == 2) {
      nombreDelEnemigo = "caco";
    } else if (tipoDeEnemigo == 1) {
      nombreDelEnemigo = "mystic";
      circulo.addImpulse(100, 100, circulo.getX(), circulo.getY());
    }
    spriteDeEnemigo.clear();
    for (int i = 0; i < 13; i++) {
      PImage esteFrame = loadImage(nombreDelEnemigo + "_" + nf(i, 2) + ".png");
      spriteDeEnemigo.add(esteFrame);
    }
    mundo.add(circulo);
  }

}
