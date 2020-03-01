import processing.svg.*;
Table MinardTable; 
int num_rows;
final int NUM_OF_CITY = 20;
final int NUM_OF_TEMP = 9;
final int MAIN_TROOP = 27;
final int SEC_TROOP = 16;
final int LAS_TRROP = 5;

final int LON_OFFSET = 50;
final int LAT_OFFSET = 300;
final int OFFSET_X = 1050;
final int OFFSET_Y = -350;

void setup(){

  //size(1600,1000);
  size(1600,900,SVG,"Minard_visualization.svg");
  MinardTable = loadTable("minard-data.csv","header");
  smooth(); //<>//
}

void draw(){
   //Title
  background(254, 249, 231);
  PFont title = createFont("Times",25,true);
  textFont(title);
  textAlign(CENTER, CENTER);
  fill(33, 47, 61);//title color
  text("MINARD’S MAP OF NAPOLEON’S RUSSIA CAMPAIGN", 800, 40);
  
  //Draw the match of troop
  //The function will draw the line between the coordinate of current line and next line, -1 is necessary.
  stroke(93, 173, 226);
  drawTroop(0, MAIN_TROOP - 1);
  stroke(243, 156, 18);
  drawTroop(MAIN_TROOP, MAIN_TROOP + SEC_TROOP - 1);
  stroke(82, 190, 128);
  drawTroop(MAIN_TROOP + SEC_TROOP, MinardTable.getRowCount() - 1);
  numLabel();
  
  //Draw City
  strokeWeight(0);
  drawCity();
  
  //Legend
  fill(93, 173, 226);
  rect(300 + OFFSET_X, 500 + OFFSET_Y, 50, 30, 3);
  
  fill(243, 156, 18);
  rect(300 + OFFSET_X, 550 + OFFSET_Y, 50, 20, 3);
  
  fill(82, 190, 128);
  rect(300 + OFFSET_X, 600 + OFFSET_Y, 50, 10, 3);
  
  fill(165, 105, 189);
  rect(300 + OFFSET_X, 640 + OFFSET_Y, 50, 10, 3);
  
  fill(84, 153, 199);
  rect(300 + OFFSET_X, 700 + OFFSET_Y, 50, 34, 3);
  rect(300 + OFFSET_X, 750 + OFFSET_Y, 50, 17, 3);
  rect(300 + OFFSET_X, 780 + OFFSET_Y, 50, 10, 3);
  
  PFont legend = createFont("Times",14,true);
  textFont(legend);
  fill(33, 47, 60);
  text("First-Batch-Troop-A", 410 + OFFSET_X, 513 + OFFSET_Y);
  text("Second-Batch-Troop-A", 417 + OFFSET_X, 558 + OFFSET_Y);
  text("Third-Batch-Troop-A", 413 + OFFSET_X, 602 + OFFSET_Y);
  text("Troop-Return", 391 + OFFSET_X, 643 + OFFSET_Y);
  
  text("340,000",391 + OFFSET_X, 715 + OFFSET_Y);
  text("170,000",391 + OFFSET_X, 758 + OFFSET_Y);
  text("100,000",391 + OFFSET_X, 783 + OFFSET_Y);
  
  fill(255, 0.8);
  stroke(255);
  strokeWeight(3);
  rect(280+OFFSET_X, 470+OFFSET_Y,220,360);
   
  tempScale();
  tempCurve();
  exit();
}

void drawCity(){
   //Draw points of City
  for(int i = 0; i < NUM_OF_CITY; i++){
    float longt = transferLON(MinardTable.getRow(i).getFloat("LONC"));
    float lat = transferLAT(MinardTable.getRow(i).getFloat("LATC"));
    fill(0);
    circle(longt, lat, 5);
    PFont cityLabel = createFont("Times",12,true);
    textFont(cityLabel);
    text(MinardTable.getRow(i).getString("CITY"), longt + 5, lat + 2);
  }
  
}


void drawTroop(int startRow, int endRow){
  for(int i = startRow; i < endRow; i++){
    int troopNum = MinardTable.getRow(i).getInt("SURV");
    strokeWeight(troopNum / 10000 +1);
    if(MinardTable.getRow(i).getString("DIR").equals("R"))
      stroke(165, 105, 189);
    float startLON = transferLON(MinardTable.getRow(i).getFloat("LONP"));
    float startLAT = transferLAT(MinardTable.getRow(i).getFloat("LATP"));
    float endLON = transferLON(MinardTable.getRow(i + 1).getFloat("LONP"));
    float endLAT = transferLAT(MinardTable.getRow(i + 1).getFloat("LATP"));
    line(startLON, startLAT, endLON, endLAT);
  }
}

void numLabel(){
  for(int i = 0; i < MinardTable.getRowCount(); i++){
    float startLON = transferLON(MinardTable.getRow(i).getFloat("LONP"));
    float startLAT = transferLAT(MinardTable.getRow(i).getFloat("LATP"));
    int troopNum = MinardTable.getRow(i).getInt("SURV");
    if((i % 7) == 0){ //<>//
      fill(26, 82, 118);
      PFont title = createFont("Times",10,true);
      textFont(title);
      text(troopNum,startLON + 2, startLAT + 11);
    }
  }
}

void tempScale(){
  float startLONG = transferLON(MinardTable.getRow(0).getFloat("LONT"));
  float endLONG = transferLON(MinardTable.getRow(8).getFloat("LONT"));
  PFont title = createFont("Times",80,true);
  textFont(title);
  fill(204, 209, 209);
  text("Temperature [°C]", endLONG + 520, 730);
  for(int i = 0; i < 9; i++){
    stroke(202, 207, 210);
    line(startLONG, 650 + i * 25, endLONG, 650 + i * 25);
    stroke(0);
    strokeWeight(1);
    line(startLONG-5,  650 + i * 25, startLONG + 5, 650 + i * 25);
    title = createFont("Times",13,true);
    textFont(title);
    fill(0);
    text(i * -5,  startLONG +18, 648 + i * 25);
  }
  stroke(0);
  line(startLONG, 650, startLONG, 650 + 8 * 25); 
}

void tempCurve(){
  PFont label = createFont("Times",15,true);
  textFont(label);
  for(int i = 0; i < 8; i++){
    float startLONG = transferLON(MinardTable.getRow(i).getFloat("LONT"));
    float endLONG = transferLON(MinardTable.getRow(i + 1).getFloat("LONT"));
    float startLAT = MinardTable.getRow(i).getFloat("TEMP");
    float endLAT = MinardTable.getRow(i + 1).getFloat("TEMP");
    int tempt = MinardTable.getRow(i).getInt("TEMP");
    int day = MinardTable.getRow(i).getInt("DAYS");
    String month = MinardTable.getRow(i).getString("MON");
    strokeWeight(4);
    stroke(231, 76, 60);
    line(startLONG,650 - startLAT / 5.0 * 25.0, endLONG, 650 - endLAT / 5.0 * 25.0);
    fill(46, 134, 193);
    text( tempt + "°C on " + day + "-" + month , startLONG, 650 - startLAT / 5.0 * 25.0 + 15);
  }
  fill(46, 134, 193);
  text(MinardTable.getRow(8).getInt("TEMP") + "°C on " +MinardTable.getRow(8).getInt("DAYS") + "-" + MinardTable.getRow(8).getString("MON"), 
       transferLON(MinardTable.getRow(8).getFloat("LONT")) + 2 ,
      650 - MinardTable.getRow(8).getFloat("TEMP") / 5.0 * 25.0 + 10);
}

float transferLON(float longitude){
  return (longitude - 24.0)*90 + LON_OFFSET; 
}

float transferLAT(float latitude){
  return (90 - latitude - 35)*120 + LAT_OFFSET;
}
