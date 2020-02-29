import processing.svg.*;
Table nightTable; 
int num_rows;
//the number of months in one year
final int SEGMENT_NUM = 12;
final float SEGMENT_ANGLE = 2 * PI / SEGMENT_NUM;
final int F1_CENTER_X = 320;
final int F1_CENTER_Y = 400;
final int F2_CENTER_X = 850;
final int F2_CENTER_Y = 400;
final int F1_FACTOR = 12;
final int F2_FACTOR = 9;
final int offset = -15;
 
 
void setup(){
  //size(1200,800);
  size(1200,800,SVG,"Nightingale_visualization.svg");
  nightTable = loadTable("nightingale.csv","header");
  background(240, 243, 244);
  num_rows = nightTable.getRowCount();
  println(nightTable.getRowCount() + " total rows in table"); 
  //Legend
  fill(72, 201, 176);
  stroke(22, 160, 133);
  rect(500 + offset, 700, 30, 30, 3);
  
  fill(245, 176, 65);
  stroke(220, 118, 51); 
  rect(600 + offset, 700, 30, 30 , 3);
  
  fill(84, 153, 199);
  stroke(31, 97, 141);
  rect(700 + offset, 700, 30, 30 , 3);
  
  
  PFont legend = createFont("Times",14,true);
  textFont(legend);
  fill(33, 47, 60);
  text("Disease", 540 + offset, 720);
  text("Wound", 640 + offset, 720);
  text("Other", 740 + offset, 720);
  
  //Title
  PFont title = createFont("Times",25,true);
  textFont(title);
  textAlign(CENTER, CENTER);
  // Title text
  fill(31, 97, 141);//title color
  text("Nightingale's Rose Chart", 600, 40);
  //First Drawing
  smooth(2);
  fill(0,0.8);
  stroke(251, 252, 252);
  circle(F1_CENTER_X, F1_CENTER_Y, 400);
  circle(F1_CENTER_X, F1_CENTER_Y, 300);
  circle(F1_CENTER_X, F1_CENTER_Y, 200);
  drawRose(F1_CENTER_X, F1_CENTER_Y, F1_FACTOR);
  drawLine(F1_CENTER_X, F1_CENTER_Y, 200);
   
  //Second Drawing
  translate(F2_CENTER_X, -100);
  rotate(PI/6.0);
  fill(0,0.8);
  stroke(251, 252, 252);
  circle(F1_CENTER_X, F1_CENTER_Y, 300);
  circle(F1_CENTER_X, F1_CENTER_Y, 200);
  circle(F1_CENTER_X, F1_CENTER_Y, 100);
  drawRose(F1_CENTER_X, F1_CENTER_Y, F2_FACTOR);
  drawLine(F1_CENTER_X, F1_CENTER_Y, 150);
  
  exit();
  
}

void drawDisease(int i, float disease, int factor, int x, int y){
  fill(72, 201, 176);
  stroke(130, 224, 170);  // Line color
  strokeWeight(1); 
  arc(x, y, factor * sqrt(disease),factor * sqrt(disease),i*SEGMENT_ANGLE, i*SEGMENT_ANGLE+SEGMENT_ANGLE);
}

void drawInjuries(int i, float injuries, int factor, int x, int y){
  fill(245, 176, 65);
  stroke(220, 118, 51);  // Line color
  strokeWeight(1); 
  arc(x, y, factor * sqrt(injuries), factor * sqrt(injuries),i*SEGMENT_ANGLE, i*SEGMENT_ANGLE+SEGMENT_ANGLE);
}

void drawOthers(int i, float others, int factor, int x, int y){
  fill(84, 153, 199);
  stroke(31, 97, 141);  // Line color
  strokeWeight(1); 
  arc(x, y, factor * sqrt(others), factor * sqrt(others),i*SEGMENT_ANGLE, i*SEGMENT_ANGLE+SEGMENT_ANGLE);
}

void drawLine(int x, int y, int radius){
  for(int i = 0; i < 6; i++){
    stroke(251, 252, 252);
    strokeWeight(1.5);
    line(x + radius * cos(i * SEGMENT_ANGLE + 2 * PI/SEGMENT_NUM + PI), y + radius * sin(i * SEGMENT_ANGLE + 2 * PI/SEGMENT_NUM + PI), 
                           x + radius * cos(i * SEGMENT_ANGLE + 2 * PI/SEGMENT_NUM), y + radius * sin(i * SEGMENT_ANGLE + 2 * PI/SEGMENT_NUM ));
  }
}

void drawRose(int x, int y, int factor){
  for(int i = 0; i < SEGMENT_NUM; i++){

    float disease = nightTable.getRow(i).getFloat("Zymotic diseases");
    float injuries = nightTable.getRow(i).getFloat("Wounds & injuries");
    float others = nightTable.getRow(i).getFloat("All other causes");
    
    //fill(72, 201, 176);
    //arc(500 , 350, 40*(i+1), 40*(i+1), i*SEGMENT_ANGLE, i*SEGMENT_ANGLE+SEGMENT_ANGLE);
    drawDisease(i, disease,factor, x, y);
    if(injuries > others){
      drawInjuries(i, injuries, factor, x, y);
      drawOthers(i, others, factor, x, y);
    }else{
      drawOthers(i, others, factor, x, y);
      drawInjuries(i, injuries, factor, x, y);
    }
    PFont label = createFont("Times",13,true);
    textFont(label);
    fill(33, 47, 60);
    text(nightTable.getRow(i).getString("Month"), x + 17.5 * factor * cos(i * SEGMENT_ANGLE + PI/SEGMENT_NUM), y + 17.5 * factor * sin(i * SEGMENT_ANGLE + PI/SEGMENT_NUM));
  }
}
