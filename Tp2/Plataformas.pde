class Plataformas {
  float movimientoPlataformaDelMedio;
  FBox plataformaMedio, plataforma1, plataforma2, plataforma3, plataforma4, plataforma5, plataforma6;
  PImage barraDeFriccion, barraDeRebote, barraDeReboteLarga;
  boolean plataformaEstaVolviendo=false;
  float velocidadMovimientoPlataformaDelMedio= 1.5;

  Plataformas(FWorld mundo) {


    barraDeRebote= loadImage("barraRebota.png");
    barraDeFriccion= loadImage("barraFriccion.png");
    barraDeReboteLarga=loadImage("barraRebotaLarga.png");
    barraDeFriccion.resize(300, 100);
    barraDeRebote.resize(300, 100);
    barraDeReboteLarga.resize(300, 100);


    movimientoPlataformaDelMedio= width/2;
    FBox plataforma1 =new FBox(150, 15);
    FBox plataforma2 =new FBox(150, 15);
    FBox plataforma3 =new FBox(150, 15);
    FBox plataforma4 =new FBox(150, 15);
    FBox plataforma5 =new FBox(150, 15);
    FBox plataforma6 =new FBox(150, 15);
    plataformaMedio  =new FBox(300, 15);

    plataforma1.setPosition(300, 100);
    plataforma2.setPosition(900, 100);
    plataforma3.setPosition(750, 320);
    plataforma4.setPosition(450, 320);
    plataforma5.setPosition(150, 550);
    plataforma6.setPosition(1050, 550);
    plataformaMedio.setPosition(movimientoPlataformaDelMedio, 300);

    plataforma1.setStatic(true);
    plataforma2.setStatic(true);
    plataforma3.setStatic(true);
    plataforma4.setStatic(true);
    plataforma5.setStatic(true);
    plataforma6.setStatic(true);
    plataformaMedio.setStatic(true);

    plataforma1.setRotation(radians(15));
    plataforma2.setRotation(radians(-15));
    plataforma3.setRotation(radians(30));
    plataforma4.setRotation(radians(-30));
    plataforma5.setRotation(radians(35));
    plataforma6.setRotation(radians(-35));

    mundo.add(plataforma1);
    mundo.add(plataforma2);
    mundo.add(plataforma3);
    mundo.add(plataforma4);
    mundo.add(plataforma5);
    mundo.add(plataforma6);
    mundo.add(plataformaMedio);

    plataforma1.setFriction(0.4);
    plataforma2.setRestitution(0.4);
    plataforma3.setRestitution(0.6);
    plataforma4.setFriction(1);
    plataforma5.setRestitution(3.0);
    plataforma6.setRestitution(3.0);
    plataformaMedio.setRestitution(3.0);

    plataforma1.attachImage(barraDeFriccion);
    plataforma2.attachImage(barraDeRebote);
    plataforma3.attachImage(barraDeFriccion);
    plataforma4.attachImage(barraDeRebote);
    plataforma5.attachImage(barraDeRebote);
    plataforma6.attachImage(barraDeRebote);
    plataformaMedio.attachImage(barraDeReboteLarga);
  }


  void AjustarPlataformaDelMedio() {
    this.plataformaMedio.setPosition(movimientoPlataformaDelMedio, 500);


    if (this.movimientoPlataformaDelMedio>=900) {
      plataformaEstaVolviendo=true;
    }
    if (this.movimientoPlataformaDelMedio<=300) {
      plataformaEstaVolviendo=false;
    }
    if (plataformaEstaVolviendo==false) {
      this. movimientoPlataformaDelMedio+=2;
    } else {
      movimientoPlataformaDelMedio-=2;
    }
  }
}
