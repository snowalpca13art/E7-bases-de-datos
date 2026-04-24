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

void setup() {
  size(800, 600);
  
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

void draw() {
  background(40);
  fill(255);
  text("Arquitectura de Datos lista. Revisa la consola (abajo).", 50, height/2);
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
