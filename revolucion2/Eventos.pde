//Método para añadir los puntos al perfil de la figura que vamos a diseñar
/*
*  Se emplea la variable pantalla para saber que estamos en la fase de perfilado
*  Usamos la variable primero para saber si se trata del primer punto que dibujamos
*    este siempre estará conectado al medio
*/
void mouseReleased(){
  if(pantalla == 1){
    coordenadas nuevoPunto;
    if(primero){
      vectorPuntos.add(new coordenadas(width/2, mouseY));
      primero = false;
    }else{
      if(mouseX < width/2){
        nuevoPunto = new coordenadas((width/2-mouseX)+width/2,mouseY);
      }else{
        nuevoPunto = new coordenadas(mouseX,mouseY);
      }
      vectorPuntos.add(nuevoPunto); 
    }
  }
}
/*
* m -> al pulsar la m, se pasa de la fase 1 (perfilado) a la fase 2(figura de revolución) y viceversa 
*  Paso de fase 1 a fase 2: Se crea la figura con los puntos almacenados en vectorPuntos
*  Paso de fase 2 a fase 1: Se reinician las variables adecuadas
*
* b -> Se borra la figura, solo se puede usar en la fase 1
* 
*/
void keyReleased(){
  //Si pulsan la tecla m se cambia de modo
  if (key == 'm'){
    if (pantalla == 1 && vectorPuntos.size() != 0){
      size(800,900,P3D);
      pantalla = 2;
      //Añadimos la última coordenada, pegada a la linea vertical central
      coordenadas ultimoValor = vectorPuntos.get(vectorPuntos.size()-1);
      vectorPuntos.add(new coordenadas(width/2,ultimoValor.y));
      //Creamos la figura 3D
      revol = revolucionCreacion();
      
      //Reutilizamos estas variables del mov. del raton para el mov. de la figura
      raton_x = width/2;
      raton_y = 0;
      raton_z = -raton_x;
      translate(raton_x,raton_y,raton_z);
      
    }else if (vectorPuntos.size() != 0){
      size(800,900,P3D);
      pantalla = 1;
      vectorPuntos.remove(vectorPuntos.size()-1);
      //Pasamos a la siguiente figura
    }
  }
  if (key == 'p'){
    pantalla =0;
  }
  //Borramos la lista de coordenadas guardadas
  if (pantalla == 1 && key == 'b'){
    vectorPuntos = new ArrayList<coordenadas>();
    primero = true;
  }
  if(pantalla == 1 && key == 'z' && vectorPuntos.size() > 0){
    vectorPuntos.remove(vectorPuntos.size()-1);
    if(vectorPuntos.size() == 0){ primero = true;} 
  }
  if (pantalla == 1 && key == 'g' && vectorPuntos.size() >0){
    
    coordenadas ultimoValor = vectorPuntos.get(vectorPuntos.size()-1);
    vectorPuntos.add(new coordenadas(width/2,ultimoValor.y));
    vectorPuntosg = vectorPuntos;
    azul = true;
    revolGuardado = revolucionCreacion();
    azul = false;
    figura3 = createShape();
    figura3.beginShape();
    figura3.fill(0,0,255,100);
    for(coordenadas a : vectorPuntosg){
     figura3.vertex(a.x,a.y);
   }
    figura3.endShape();
    vectorPuntos = new ArrayList<coordenadas>();
    primero = true;
  }
}

//Movimiento de la figura por la pantalla, podemos moverla en el eje x y z (arriba, abajo, derecha, izquierda, w, s);
//Podemos rotarla (q, e)
void keyPressed(){
  if(pantalla == 0){
    vectorPuntos = new ArrayList<coordenadas>();
    pantalla = 1;
    
  }
  if(pantalla == 2){
    switch (keyCode){
      case UP:
        raton_y -= mov;
        break;
      case DOWN:
        raton_y += mov;
        break;
      case LEFT:
        raton_x += mov;
        break;
      case RIGHT:
        raton_x -= mov;
        break;
    }
    switch (key){
      case 'w':
        raton_z += mov;
        break;
      case 's':
        raton_z -= mov;
        break;
    }
  }
}
