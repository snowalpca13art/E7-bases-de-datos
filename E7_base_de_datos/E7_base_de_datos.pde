//varibles
class Juego {
  String nombre;
  int anio;
  String plataforma;
  String tipoComida;
  String comensal;

  float xPos, yPos, targetX, targetY;
  float diametro, targetDiametro;

  // clasifiacion de columnas
  Juego(TableRow row) {
    this.nombre = row.getString("Game_Name");
    String fechaRaw = row.getString("Release_Year");
    // Manejo de error por si la fecha viene vacia o en formato inesperado
    if (fechaRaw!= null && fechaRaw.length()>0) {
      this.anio= int(fechaRaw.split("-")[0]);
    } else {
      this.anio=0;
    }
    this.plataforma = row.getString("Platform");
    this.tipoComida = row.getString("Food_Type");
    this.comensal = row.getString("Customer_Name");
    this.xPos = width/2;
    this.yPos = height/2;
  }

  void actualizar() {
    xPos = lerp(xPos, targetX, 0.1);
    yPos = lerp(yPos, targetY, 0.1);
    diametro = lerp(diametro, targetDiametro, 0.1);
  }

  // solo dibuja la burbuja
  void dibujarBurbuja() {
    // contornear la burbuja
    if (dist(mouseX, mouseY, xPos, yPos) < diametro/2) {
      stroke(255);
      strokeWeight(2.5);
    } else {
      noStroke();
    }
    fill(map(anio, 2007, 2020, 100, 255), 150, 200, 180);
    ellipse(xPos, yPos, diametro, diametro);
  }

  // Dibuja cuadro con informacion, separado para que aparezca encima de las burbujas
  void dibujarInfo() {
    if (dist(mouseX, mouseY, xPos, yPos) < diametro/2) {
      float tx = xPos + 30;
      float ty = yPos + 10;
      if (tx + 180 > width) tx = xPos - 195;

      fill(#FF0313);
      stroke(#4D060B);
      strokeWeight(1.5);
      rect(tx, ty, 180, 80, 8);

      noStroke();
      fill(0);
      textSize(11);
      text(nombre, tx + 10, ty + 18);
      fill(0);
      text("Año: " + anio, tx + 10, ty + 36);
      text("Plataforma: " + plataforma, tx + 10, ty + 52);
      text("Comida: " + tipoComida, tx + 10, ty + 68);
    }
  }
}

Table tabla;
ArrayList<Juego> listaJuegos = new ArrayList<Juego>();
// Variables de interfaz
String plataformaUI = "Flash";
int anioUI = 2013;

void setup() {
  size(1000, 600);
  //Carga de de datos
  tabla = loadTable("papa_games_dataset.csv", "header");
  if (tabla != null) {
    for (TableRow row : tabla.rows()) {
      listaJuegos.add(new Juego(row));
    }
  }
}

//interfaz
void draw() {
  background(20, 20, 40);
  dibujarEscalaEjes();
  dibujarPanel();

  ArrayList<Juego> filtrados = filtrarDatos();

  // primer loop: solo burbujas
  for (Juego j : listaJuegos) {
    if (filtrados.contains(j)) {
      j.targetX = map(j.anio, 2007, 2016, 300, 950);
      j.targetY = map(j.nombre.length(), 5, 25, 500, 100);
      j.targetDiametro = 40;
    } else {
      j.targetDiametro = 0;
      j.targetX = 125;
      j.targetY = height/2;
    }
    j.actualizar();
    j.dibujarBurbuja();
  }

  // segundo loop: tooltips encima de todo
  for (Juego j : listaJuegos) {
    j.dibujarInfo();
  }
}

void dibujarEscalaEjes() {
  stroke(100);
  line(300, 520, 950, 520);
  fill(150);
  textSize(20);
  text("Línea de Tiempo (Años)", 550, 550);
}

void dibujarPanel() {
  noStroke();
  fill(255, 180, 0);
  rect(0, 0, 250, height, 20);
  fill(0);
  // titulo
  fill(255, 180, 0);
  textSize(30);
  text("Papa's Games Dataset", 495, 50);
  
  textSize(18);
  text("FILTROS", 89, 40);

  dibujarBoton("Flash", 80, plataformaUI.equals("Flash"));
  dibujarBoton("HTML5", 140, plataformaUI.equals("HTML5"));

  fill(0);
  text("Hasta el año: " + anioUI, 30, 240);
  rect(20, 260, 200, 10, 5);
  fill(255);
  ellipse(map(anioUI, 2007, 2016, 20, 220), 265, 20, 20);
}

void dibujarBoton(String t, int y, boolean sel) {
  fill(sel ? color(0, 150, 255) : 255);
  rect(20, y, 200, 40, 10);
  fill(0);
  text(t, 90, y + 25);
}

void mousePressed() {
  if (mouseX > 20 && mouseX < 220) {
    if (mouseY > 80 && mouseY < 120) plataformaUI = "Flash";
    if (mouseY > 140 && mouseY < 180) plataformaUI = "HTML5";
    if (mouseY > 250 && mouseY < 280) {
      anioUI = int(map(mouseX, 20, 220, 2007, 2016));
    }
  }
}

ArrayList<Juego> filtrarDatos() {
  ArrayList<Juego> res = new ArrayList<Juego>();
  for (Juego j : listaJuegos) {
    if (j.plataforma != null && j.plataforma.equalsIgnoreCase(plataformaUI) && j.anio <= anioUI) {
      res.add(j);
    }
  }
  return res;
}
