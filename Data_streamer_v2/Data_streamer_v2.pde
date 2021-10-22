
import controlP5.*;
import processing.serial.*;

Serial myPort;

ControlP5 cp5;

Chart dataStream;

boolean device_stream;


String [] data;
float rawData [];
int max, min;
int streamCounter = 0;  // Variable to iterate over the dataset choosing the sample to stream next 
int incrementStep = 16; // number of samples to skip forward with the streamCounter, for each frame
                        // 16,66 equals 1000Hz (1000 samples jumps pr. 60 frames)
                        // 1000/60 = 16,66


void setup(){
  size(1000, 550);
  
  data = loadStrings("opensignals_002106BE162B_2021-10-11--reading &chatting.txt");
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
  dataStream = cp5.addChart("datachart")
               .setPosition(50, 50)
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
     .setPosition(50,300)
     .setSize(30,30)
     .plugTo(this)
     ;
  
  String portName = Serial.list()[9];
  println( Serial.list());
  
  myPort = new Serial(this, portName, 115200);
}




void draw(){
  
  if (streamCounter+incrementStep < rawData.length-1) { 
    dataStream.push("data-stream", rawData[streamCounter]);
    if (device_stream) myPort.write(1+"c"+int(map(rawData[streamCounter], min, max, 0, 255))+"w");
    streamCounter+=incrementStep;
  } 
}





/*
float [] getMinMax(float [] inputArray){
  
  float [] minMax = {10000000, -1};
  
  for (int i = 0; i < inputArray.length; i++){
    if (inputArray[i] < minMax[0]) minMax[0] = inputArray[i];
    if (inputArray[i] > minMax[1]) minMax[1] = inputArray[i];
  }
  
  return minMax;
}
*/
