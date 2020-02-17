//Objeto Coordenada (X,Y)
class coordenadas{
  float x, y;
  PShape s;
  
  public coordenadas(float x, float y){
    this.x = x;
    this.y = y;
    s = createShape(ELLIPSE,0,0,5,5);
  }
  
  public void display(){
    //Lado derecho
    pushMatrix();
    translate(this.x,this.y);
    shape(s);
    popMatrix();
    //Lado izquierdo
    pushMatrix();
    translate(width/2 - (this.x-width/2),this.y);
    shape(s);
    popMatrix();
  }
}
