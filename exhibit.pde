/* @pjs preload="anode.png,anodeblank.png,cathode.png,cathodeblank.png,color.png,colorblank.png,fc.png,fcblank.png,hf.png,hfblank.png,hp.png,hpblank.png,shadow.png,shadowblank.png,tube.png,vp.png,vpblank.png"; */
ArrayList<Piece> pieces;
boolean isFinished;
String activeMessage;
PImage tube;
int closestPiece;
boolean holding = false;
boolean message = true;
int current=-1;
int wait=100;
String currentTitle="Cathode Ray Tube Assembly";
Piece horizontal, cathode, anode, colour, focus, filament, shadow, vertical;
void setup() {
  tube = loadImage("tube.png");
  activeMessage = "We need to put this cathode ray tube back together! Drag the components of the cathode ray tube to see what they do and where they go!";
  pieces = new ArrayList<Piece>();
  size(1024, 768);
  imageMode(CENTER);
  isFinished = false;
  horizontal = new Piece("Horizontal Plates", false, 148, 400, "hp.png", 70, 70, 546, 300, false, true, "These plates work to adjust the image on the left-right/X-axis.", "hpblank.png");
  cathode = new Piece("Cathode", false, 148, 400, "cathode.png", 80, 80, 370, 300, false, true, "The cathode is a negatively charged electrode. It is also where the cathode ray tube gets it's name. When heated, the cathode generates electrons. To heat it, we need to place it near the heating filament that we just placed.", "cathodeblank.png");
  anode = new Piece("Anode", false, 148, 400, "anode.png", 80, 80, 434, 300, false, true, "The anode is a positively charged electrode. This will attract the electrons created by the cathode and get them moving towards the screen. This part should go somewhere in front of the cathode that we placed so that the beam moves forward.", "anodeblank.png");
  focus = new Piece("Focusing Coil", false, 148, 400, "fc.png", 80, 80, 455, 300, false, true, "Let's focus this beam of light! By varying the magentic field this component works to change the electron beam's direction and vary its strength which focuses the image.", "fcblank.png");
  filament = new Piece("Heating Filament", false, 148, 400, "hf.png", 120, 120, 350, 300, false, true, "To start, we need to heat things up! We need heat to get electrons moving.This should go towards the base of the tube.", "hfblank.png");
  shadow = new Piece("Shadow Mask", false, 148, 400, "shadow.png", 330, 260, 908, 300, false, true, "Each stream travels through a shadow mask where the electrons are spread to illuminate the correct color in each part of the screen. The resultant color that is seen by the viewer will be a combination of these three primary colors.", "shadowblank.png");
  vertical = new Piece("Vertical Plates", false, 148, 400, "vp.png", 70, 70, 488, 300, false, true, "These plates work to adjust the image on the up-down/Y-axis.", "vpblank.png");
  
  pieces.add(filament);
  pieces.add(cathode);
  pieces.add(anode);
  pieces.add(focus);
  pieces.add(vertical);
  pieces.add(horizontal);
  pieces.add(shadow);
}

void draw() {
  noTint();
  rectMode(CORNER);
  background(240);
  strokeWeight(0);
  strokeWeight(1);
  stroke(100);
  fill(137,160,176);
  rect(0, 0, 290, 768);
  image(tube, 655, 300, 700, 280);
  fill(232,207,146);
  rect(0,0,290,70);
  textSize(40);
  textAlign(LEFT);
  fill(255);
  text("Workbench", 35, 50);


  if (current==-1) {
    if (message) {
      drawMessage();
    }
    else {
      message=true;
      current=0;
    }
  }


  if (current>-1&&current<=6) {
    if(!mousePressed){
    holding=false;
    }
    else {
      if (pieces.get(current).getDist()<100) {
        holding=true;
      }
    }
    activeMessage=pieces.get(current).message;
    currentTitle=pieces.get(current).title;
    if(message&&current>0){
      for(int i=0;i<=current-1;i++){
        pieces.get(i).drawPiece();
      }
    }
    if (message) {
      drawMessage();
    }
    else {
      for(int i=0;i<=current;i++){
        pieces.get(i).drawPiece();
      }
      if (holding) {   
        pieces.get(current).movePiece();
        if (!pieces.get(current).isActive) {
          holding=false;
          current++;
          message=true;
          wait=0;
          
        }
      }
      
    }
  }
  if(current>=7){
    for(int i=0;i<=6;i++){
      pieces.get(i).drawPiece();
    }
    currentTitle= "Congratulations";
    activeMessage = "You successfully built a cathode ray tube! David Sarnoff thanks you for your help fixing this piece of television history.";  
    drawMessage();
  }
  textAlign(LEFT);
  textSize(14);
  fill(100);
  text("Assembler 2.0", 915, 760);
  wait++;
}



void drawMessage() {
  if(wait>50){
  fill(255, 255, 255, 220);
  rect(50, 100, 920, 600);
  fill(229,198,118, 200);
  
  rect(50, 100, 920, 50);
  textSize(40);
  fill(255);
  text(currentTitle, 70, 140);
  textSize(20);
  fill(0);
  text(activeMessage, 70, 180,880,600);
  if (mouseX>=810&&mouseX<=960&&mouseY>=640&&mouseY<=690) {
    fill(200, 200, 200, 200);
  }
  else {
    fill(137,160,176);
  }
  rect(810, 640, 150, 50);
  textSize(30);
  fill(0);
  if(current<7){
    text("Next", 850, 675);
  }
  else{
    text("Replay", 830, 675);
  }
  }
}



void mousePressed() {
  if (message) {
    if (mouseX>=810&&mouseX<=960&&mouseY>=640&&mouseY<=690) {
      message=false;
      if(current==7){
        link("index.html");
      }
    }
  }
}

class Piece {
  String title;
  int initX;
  int initY;
  int x;
  int y;
  String fileName;
  int sizeX;
  int sizeY;
  int targetX;
  int targetY;
  boolean inPlace;
  boolean isActive;
  String message;
  PImage img;
  PImage tarimg;
  boolean holding;

  Piece(String t, boolean hold, int tempX, int tempY, String file, int tempSizeX, int tempSizeY, int tarx, int tary, boolean place, boolean active, String mess, String targ) {
    title=t;
    holding=hold;
    x = tempX;
    initX = tempX;
    initY = tempY;
    y = tempY;
    fileName = file;
    sizeX = tempSizeX;
    sizeY = tempSizeY;
    targetX = tarx;
    targetY = tary;
    inPlace = place;
    isActive = active;
    message = mess;
    img = loadImage(file);
    tarimg = loadImage(targ);
  }

  void drawPiece() {
    image(img, x, y, sizeX, sizeY);
  }
  int getDist() {
    return int(dist(x, y, mouseX, mouseY));
  }
  void movePiece() {
    if (isActive) {
      x = mouseX;
      y = mouseY;
      fill(255);
      if(dist(x,y,targetX,targetY)>100){
        tint(255,0);
      }
      else if(dist(x,y,targetX,targetY)<=100){
        tint(255,255-int(dist(x,y,targetX,targetY)*2.55));
      }
      image(tarimg, targetX, targetY, sizeX, sizeY);
      if (dist(x, y, targetX, targetY)<20) {
        inPlace = true;
        isActive = false;
        x = targetX;
        y = targetY;
      }
    }
  }
  void reset() {
    x = initX;
    y = initY;
    isActive = true;
  }
}

