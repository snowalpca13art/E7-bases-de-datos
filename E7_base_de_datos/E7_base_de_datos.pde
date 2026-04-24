//variables
class Juego {
  String nombre;
  int anio;
  String plataforma;
  String tipoComida;
  String comensal;

//clasificacion de columnas de  tabla
  Juego(TableRow row) {
    this.nombre = row.getString("Game_Name");
    String fechaRaw = row.getString("Release_Year");
    // Manejo de error por si la fecha viene vacía o en formato inesperado
    if (fechaRaw != null && fechaRaw.length() > 0) {
      this.anio = int(fechaRaw.split("-")[0]);
    } else {
      this.anio = 0; 
    }
    
    this.plataforma = row.getString("Platform");
    this.tipoComida = row.getString("Food_Type"); 
    this.comensal = row.getString("Customer_Name");
  }
}

Table tabla;
ArrayList<Juego> listaJuegos = new ArrayList<Juego>();

//variables de interfaz 
String plataformaUI = "Flash";
int anioUI = 2013;


void setup() {
  size(1000, 600);
  
  //Carga de datos
  tabla = loadTable("papa_games_dataset.csv", "header");
  if (tabla == null) {
    println("ERROR: No se encontró el archivo CSV. Revisa la carpeta /data");
    return;
  }

  for (TableRow row : tabla.rows()) {
    listaJuegos.add(new Juego(row));
  }

  
  //      TEST DE FILTRADO (LOGS DE CONTROL)

  println("REPORTE DEL ARQUITECTO");
  println("Total de juegos cargados: " + listaJuegos.size());

  // Test 1: Filtrar por Plataforma (Ejemplo: Flash o HTML5)
  //aqui cambiarias el tipo de plataforma
  String platTest = "Flash";
  ArrayList<Juego> testPlataforma = filtrarPorPlataforma(platTest);
  println("Test Plataforma (" + platTest + "): " + testPlataforma.size() + " encontrados.");

  // Test 2: Filtrar por Año (Ejemplo: 2011)
  //aqui cambias el año
  int anioTest = 2013;
  ArrayList<Juego> testAnio = filtrarPorAnio(anioTest);
  println("Test Año (" + anioTest + "): " + testAnio.size() + " encontrados.");
  if(testAnio.size() > 0) {
     println("   -> Ejemplo: " + testAnio.get(0).nombre);
  }

  // Test 3: Listado de Categorías de comida
  //las categorias de comida no cambian, esto es solo para crear una lista de todo los valores comunes
  StringList comidas = obtenerCategoriasComida();
  println("Categorías de comida detectadas: " + comidas.size());
  println("Lista: " + comidas.join(", "));
}

//interfaz 
void draw() {
  background(30, 30, 50);
  dibujarPanel();        
  dibujarResultadosUI();
}

void dibujarPanel() {
  fill(255, 180, 0);
  rect(0, 0, 250, height, 20);

  fill(0);
  textSize(18);
  text("FILTROS", 70, 40);
  
 // botón Flash
  fill(plataformaUI.equals("Flash") ? color(0,200,255) : 255);
  rect(20, 80, 200, 40, 10);
  fill(0);
  text("Flash", 90, 105);

  //botón HTML5
  fill(plataformaUI.equals("HTML5") ? color(0,200,255) : 255);
  rect(20, 140, 200, 40, 10);
  fill(0);
  text("HTML5", 85, 165);

  // selector de año
  fill(0);
  text("Año: " + anioUI, 20, 240);

  fill(255);
  rect(20, 260, 200, 35, 10);
  fill(0);
  text("Cambiar Año", 50, 285);
  
}
//visualización de resultados en pantalla
void dibujarResultadosUI() {
  ArrayList<Juego> resultado = filtrarPorPlataforma(plataformaUI);
  resultado = filtrarPorAnio(anioUI);

  fill(255);
  textSize(16);
  text("Resultados: " + resultado.size(), 300, 40);

  int y = 80;

  for (int i = 0; i < min(10, resultado.size()); i++) {
    Juego j = resultado.get(i);

    // 🔵 NUEVO: tarjeta visual estilo juego
    fill(255, 100, 100);
    rect(300, y, 500, 40, 15);

    fill(0);
    text(j.nombre + " (" + j.anio + ")", 310, y + 25);

    y += 60;
  }
}

//interacción con mouse (botones)
public void mousePressed() {
  if (mouseX > 20 && mouseX < 220 && mouseY > 80 && mouseY < 120) {
    plataformaUI = "Flash";
  }

  if (mouseX > 20 && mouseX < 220 && mouseY > 140 && mouseY < 180) {
    plataformaUI = "HTML5";
  }

  if (mouseX > 20 && mouseX < 220 && mouseY > 260 && mouseY < 295) {
    anioUI++;
    if (anioUI > 2015) {
      anioUI = 2010;
    }
  }
}


// FUNCIONES DE FILTRADO

ArrayList<Juego> filtrarPorPlataforma(String plataformaDeseada) {
  ArrayList<Juego> resultado = new ArrayList<Juego>();
  for (Juego j : listaJuegos) {
    if (j.plataforma != null && j.plataforma.equalsIgnoreCase(plataformaDeseada)) {
      resultado.add(j);
    }
  }
  return resultado;
}

ArrayList<Juego> filtrarPorAnio(int anioDeseado) {
  ArrayList<Juego> resultado = new ArrayList<Juego>();
  for (Juego j : listaJuegos) {
    if (j.anio == anioDeseado) {
      resultado.add(j);
    }
  }
  return resultado;
}

StringList obtenerCategoriasComida() {
  StringList categorias = new StringList();
  for (Juego j : listaJuegos) {
    if (j.tipoComida != null && !categorias.hasValue(j.tipoComida)) {
      categorias.append(j.tipoComida);
    }
  }
  return categorias;
}
