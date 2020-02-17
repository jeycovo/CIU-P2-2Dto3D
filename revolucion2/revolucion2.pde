// Permitir que usuario escriba puntos en un lado de la pantalla
//en ese lado los puntos formaran un perfil del que se formara una figura de revolución

/*
* pantalla   -> Indica en que estado se encuentra el programa
* cursor     -> Figura del cursor (un círculo rojo)
* primero    -> variable para saber si hemos pintado el primer punto
*/
int pantalla = 0;
PShape cursor;
ArrayList <coordenadas> vectorPuntos, vectorPuntosg;

//Fase inicio
int intensidad = 0;
int direccion = 1;

//Textos en pantalla
PFont Pf_black;
PFont Pf_regular;
PFont Pf_italic;
PFont Delicadate;

//cosas de la fase perfil
boolean primero = true;

//variables coordenadas
float raton_x;
float raton_y;
float raton_z = 0;

//figura de revolución
PShape revol, revolChild, revolGuardado;
int mov;
boolean azul = false;
//Ejemplo1
PShape figura, figura2, figura3, ejemplo;

void setup(){
  //Textos en pantalla
  Pf_black = createFont("PlayfairDisplay-Black.ttf",42);
  Pf_regular = createFont("PlayfairDisplay-Regular.ttf",24);
  Delicadate = createFont("Delicadate.ttf",24);
  
  //tamaño, figura 3D
  size(800,900,P3D);
  smooth();
  mov = 30;
  vectorPuntos = new ArrayList<coordenadas>();
  
  //Configurando el cursor
  cursor = createShape(ELLIPSE,0,0,5,5);
  cursor.setFill(color(255,0,0));

  //Cargamos un ejemplo (un cono)
  vectorPuntos.add(new coordenadas(width/2,height/2));
  vectorPuntos.add(new coordenadas(width/2+100,height/2));
  vectorPuntos.add(new coordenadas(width/2,height/2-400));
  ejemplo = revolucionCreacion();
}

void draw(){
 //Seleccionar puntos
 switch (pantalla){
   case 0:
    inicio();
    break;
    
   case 1:
    perfilFase();
    textoPantalla();
    break;
    
   case 2:
    background(153, 255, 204);
    fill(255,0,0);
    pushMatrix();
    translate(raton_x,raton_y,raton_z);
    shape(revol);
    if(revolGuardado != null){
      shape(revolGuardado);
    }
    popMatrix();
    textoPantalla();
    break;
 }
}

//TextoenPantalla
void textoPantalla(){
  pushMatrix();
  if(pantalla == 1){
    translate(0,0,0);
    textAlign(LEFT);
    textFont(Pf_black);
    fill(0,parpadeo());
    text("Modo Diseño",40,50);
    fill(0);
    textFont(Pf_regular,16);
    text("b -  borra la figura actual",60,70);
    text("m -  cambia de modo Diseño a modo visualizacion 3D",60,90);
    text("z -  borra el último punto",60,110);
    text("g -  guarda la figura actual",60,130);
  }else{
    translate(0,0,0);
    textAlign(CENTER);
    textFont(Pf_black);
    fill(0,parpadeo());
    text("Modo 3D",width/2,100,0);
    fill(0);
    textFont(Pf_regular,16);
    text("m -   cambia de modo visualizacion 3D a modo Diseño",width/2+20,130,0);
    //Translate for the win
    pushMatrix();
    translate(20,height-70,0);
    textAlign(LEFT);
    textFont(Pf_regular,20);
    text("flechas de dirección: Mover la figura por la pantalla",0,0);
    text("w -  Acercar la figura",0,20);
    text("s -  Alejar la figura",0,40);
    popMatrix();
  }
  popMatrix();
}

//Inicio
void inicio(){
  fill(153, 255, 204);
  background(0);
  textAlign(CENTER);
  
  textFont(Pf_black);
  text("Bienvenido a 2Dto3D",width/2,100);
  textFont(Delicadate);
  text("donde los diseñadores de copas prueban sus diseños...",width/2,135);
  textFont(Pf_regular,20);
  fill(255,parpadeo());
  text("Recordatorio: puedes guardar un diseño con la g,\n al guardar el actual pierdes el anterior...",width/2,height-60);
  //Dibujo ejemplo1
  pushMatrix();
  translate(width/2,100,-(width/2+20));
  shape(ejemplo);
  ejemplo.rotateY(radians(0.2));
  popMatrix();
  
  //Texto inferior
  fill(153, 255, 204,parpadeo());
  textFont(Pf_regular);
  text("Para comenzar pulse cualquier tecla...",width/2,height-100);
}

int parpadeo(){
  if(intensidad > 255 || intensidad < 0){
    direccion = - direccion;
  }
  intensidad += 2*direccion;
  return intensidad;
}
//Perfil
void perfilFase(){
   background (153, 255, 204);
   fill(255,0,0);
   //separador central
   line(width/2,0,width/2,height);
   raton_x=mouseX;
   raton_y=mouseY;
   
   //cursores, simétricos de paso
   if(primero){
     raton_x = width/2;
   }
   
   pushMatrix();
   translate(raton_x,raton_y);
   shape(cursor);
   popMatrix();
   
   pushMatrix();
   if (raton_x < width/2){
     translate((width/2-raton_x)+width/2,raton_y);
   }else{
     translate(width/2 - (raton_x-width/2),raton_y);
   }
   shape(cursor);
   popMatrix();
   
   //Pintar todos los puntos
   figura = createShape();
   figura2 = createShape();

   figura.beginShape();
   figura2.beginShape();
   figura.fill(255,0,0);
   figura2.fill(255,0,0);
   //Pintamos los puntos y añadimos vertices a la figura
   for(coordenadas a : vectorPuntos){
     a.display();
     figura.vertex(a.x,a.y);
     figura2.vertex(width/2 - (a.x-width/2),a.y);
   }
   //Pintamos el punto del ratón 
   if (mouseX < width/2){
     figura.vertex((width/2-mouseX)+width/2,mouseY);
     figura2.vertex(mouseX, mouseY);
   }else{
     figura.vertex(mouseX, mouseY);
     figura2.vertex(width/2 - (mouseX-width/2), mouseY);
   }
   
   //Pintamos El último punto siempre conecta a la linea del medio
   figura.vertex(width/2,mouseY);
   figura2.vertex(width/2,mouseY);
   figura.endShape();
   figura2.endShape();
   shape(figura);
   shape(figura2);
   if(figura3 != null){
     shape(figura3);
   }
}

// Método para crear la figura de revolución, empleado en la fase 2
PShape revolucionCreacion(){
  PShape figura = createShape(GROUP);
  
  float x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4;
  
  //Pasamos los valores de un Arraylist a un vector para facilitar su uso.
  float vectorPuntosT[][] = new float[vectorPuntos.size()][3];
  int i = 0;
  //Rellenamos la primera iteracion
  //Las z seran iguales a las x para que tengan la misma dimension
  //Hay que restarle el width/2 a las x, ya que se usaban esos puntos para la visualizacion
  for(coordenadas a : vectorPuntos){
    vectorPuntosT[i][0] = a.x - width/2;
    vectorPuntosT[i][1] = a.y;
    vectorPuntosT[i][2] = a.x - width/2;
    i++;
  }
  int calidad = 5; 
  for( i = 0; i<360; i=i+calidad){
    for(int j = 0; j<vectorPuntos.size()-1; j++){
      revolChild = createShape();
      revolChild.beginShape(TRIANGLE);
      revolChild.noFill();
      if(azul == false){
        revolChild.stroke(255,0,0);
      }else{
        revolChild.stroke(0,0,255);
      }
      x1 = vectorPuntosT[j][0];
      y1 = vectorPuntosT[j][1];
      z1 = vectorPuntosT[j][2];
      
      x2 = x1 * cos(radians(calidad)) - z1 * sin(radians(calidad));
      y2 = y1;
      z2 = x1 * sin(radians(calidad)) + z1 * cos(radians(calidad));
      
      x3 = vectorPuntosT[j+1][0];
      y3 = vectorPuntosT[j+1][1];
      z3 = vectorPuntosT[j+1][2];
      
      x4 = x3 * cos(radians(calidad)) - z3 * sin(radians(calidad));
      y4 = y3;
      z4 = x3 * sin(radians(calidad)) + z3 * cos(radians(calidad));
      
      //Triangulo superior
      revolChild.vertex(x1,y1,z1);
      revolChild.vertex(x2,y2,z2);
      revolChild.vertex(x3,y3,z3);
      
      //Triangulo inferior
      revolChild.vertex(x3,y3,z3);
      revolChild.vertex(x2,y2,z2);
      revolChild.vertex(x4,y4,z4);
      
      revolChild.endShape();
      figura.addChild(revolChild);
      vectorPuntosT[j][0] = x2;
      vectorPuntosT[j][1] = y2;
      vectorPuntosT[j][2] = z2;
    }
  }
  return figura;
}
