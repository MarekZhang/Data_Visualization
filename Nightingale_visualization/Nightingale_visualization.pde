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
final int START_LINE = 9; //should be less than 12
 
 
void setup(){
  //size(1200,800);
  size(1200,800,SVG,"Nightingale_visualization.svg");
  nightTable = loadTable("nightingale.csv","header");
  num_rows = nightTable.getRowCount();
  smooth(2);
}

void draw(){
  background(240, 243, 244);
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
  for(int i = START_LINE; i < START_LINE + SEGMENT_NUM ; i++){

    float disease = nightTable.getRow(i).getFloat("Zymotic diseases");
    float injuries = nightTable.getRow(i).getFloat("Wounds & injuries");
    float others = nightTable.getRow(i).getFloat("All other causes");
    
    int DISEASE = (int) disease;
    int INJURIES = (int) injuries;
    
    float MAX = findMax(disease, injuries, others);
    float MIDDLE = findMiddle(disease, injuries, others);
    float MIN = findMin(disease, injuries, others);
    
    if((int)MAX == DISEASE)
      drawDisease(i, disease,factor, x, y);
    else if((int)MAX == INJURIES)
      drawInjuries(i, injuries, factor, x, y);
    else
      drawOthers(i, others, factor, x, y);
    
    if((int)MIDDLE == DISEASE)
      drawDisease(i, disease,factor, x, y);
    else if((int)MIDDLE == INJURIES)
      drawInjuries(i, injuries, factor, x, y);
    else
      drawOthers(i, others, factor, x, y);
      
    if((int)MIN == DISEASE)
      drawDisease(i, disease,factor, x, y);
    else if((int)MIN == INJURIES)
      drawInjuries(i, injuries, factor, x, y);
    else
      drawOthers(i, others, factor, x, y);      
    
    PFont label = createFont("Times",13,true);
    textFont(label);
    fill(33, 47, 60);
    text(nightTable.getRow(i).getString("Month"), x + 17.5 * factor * cos(i * SEGMENT_ANGLE + PI/SEGMENT_NUM), y + 17.5 * factor * sin(i * SEGMENT_ANGLE + PI/SEGMENT_NUM));
  }
}

float findMax(float a, float b, float c){
  float tempt = a > b ? a : b;
  return c > tempt ? c: tempt;
}

float findMiddle(float a, float b, float c){
  if((b - a)*(a - c)>=0)
    return a;
  else if((a - b) * (b -c) >= 0)
    return b;
  else
    return c;
}

float findMin(float a, float b, float c){
  float tempt = a < b ? a : b;
  return tempt < c ? tempt : c;
}
