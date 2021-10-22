
import controlP5.*;
import processing.serial.*;

Serial myPort;

ControlP5 cp5;

Chart dataStream;
Chart dataOverview;
PImage dataOverviewImg;

boolean device_stream;
boolean air_valve;


String [] data;
float rawData [];
int max, min;
int streamCounter = 0;  // Variable to iterate over the dataset choosing the sample to stream next 
int incrementStep = 16; // number of samples to skip forward with the streamCounter, for each frame
                        // 16,66 equals 1000Hz (1000 samples jumps pr. 60 frames)
                        // 1000/60 = 16,66


void setup(){
  size(1000, 600);
  
  //data = loadStrings("../Breathing_data_vol_1/opensignals_002106BE162B_2021-09-23_17-32-05.txt");
  data = loadStrings("../Breathing_data_vol_1/opensignals_002106BE162B_2021-10-11- walking etc.txt");
  //data = loadStrings("../Breathing_data_vol_1/opensignals_002106BE162B_2021-10-11--reading &chatting.txt");
  //data = loadStrings("../Breathing_data_vol_1/opensignals_002106BE162B_2021-10-11- walking etc.txt");




  max = -1;
  min = 100000000;
  
  rawData = new float [data.length-3];
  
  for (int i = 3; i < data.length; i++){      
      String[] split = split(data[i], "\t");
      if (int(split[5]) < min) min = int(split[5]);
      if (int(split[5]) > max) max = int(split[5]);
      rawData[i-3] = int(split[5]);      
  }
  data = null;
  println(min, max);
  println(rawData.length);
  
  cp5 = new ControlP5(this);
  dataOverview = cp5.addChart("data_overview")
               .setPosition(50, 50)
               .setSize(900, 200)
               .setRange(min, max)
               .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               .setStrokeWeight(1.0)
               .setColorCaptionLabel(color(40))
               ;

  dataOverview.addDataSet("data-overview");
  dataOverview.setData("data-overview", rawData);
  //dataOverview.remove();
  
  // data stream
  cp5 = new ControlP5(this);
  dataStream = cp5.addChart("data_stream")
               .setPosition(50, 300)
               .setSize(900, 200)
               .setRange(min, max)
               .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               .setStrokeWeight(1.0)
               .setColorCaptionLabel(color(40))
               ;

  dataStream.addDataSet("data-stream");
  dataStream.setData("data-stream", new float [1000]);
  
  // create a toggle for activating streaming to device
  cp5.addToggle("device_stream")
     .setPosition(50,520)
     .setSize(30,30)
     .plugTo(this)
     ;
  
    // create a toggle for controlling the air valve
  cp5.addToggle("air_valve")
     .setPosition(140,520)
     .setSize(30,30)
     .plugTo(this)
     ;
  
  String portName = Serial.list()[9];
  println( Serial.list());
  
  myPort = new Serial(this, portName, 115200);
}




void draw(){
  

  if (frameCount < 2) return; // wait until frame 2
  if (frameCount == 2){ // make the data overvire snapshot
    dataOverviewImg = get(50,50,900,200);
    println("Data overview snapshot taken");
    dataOverview.remove();
    println("Data overview gui element removed");
  }
  
  
  // -- Procees with draw code --
  background(0);
  image(dataOverviewImg, 50, 50, 900, 200);
  text(frameRate, 10, 10);
  
  if (streamCounter+incrementStep < rawData.length-1) { 
    dataStream.push("data-stream", rawData[streamCounter]);
    if (device_stream) myPort.write(1+"c"+int(map(rawData[streamCounter], min, max, 0, 255))+"w");
    streamCounter+=incrementStep;
    float cursorX = map(streamCounter, 0, rawData.length-1, 50, 950);
    stroke(255);
    line(cursorX, 50, cursorX, 250);
  }
}

// event function for the air_valve toggle
void air_valve(boolean value) {
  if (value == false) myPort.write("2c0w");
  if (value == true) myPort.write("2c255w");
}

void mouseReleased(){
  if (mouseX > 50 && mouseX < 950 && mouseY > 50 && mouseY < 250){
    streamCounter = int(map(mouseX - 50, 0, 900, 0, rawData.length-1));
  }
}
