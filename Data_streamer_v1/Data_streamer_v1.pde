String [] data;
int rawData [];
int max, min;

float dataAveraged [] = new float[500];
int avarageInterval = 10;
int sampleCount = 0;

void setup(){
  data = loadStrings("opensignals_002106BE162B_2021-10-11--reading &chatting.txt");
  max = -1;
  min = 100000000;
  
  rawData = new int [data.length-3];
  
  println(data.length);
  for (int i = 3; i < data.length; i++){
      
      
      //println(data[i], i);
      String[] split = split(data[i], "\t");
      //println(split[5], i);
      if (int(split[5]) < min) min = int(split[5]);
      if (int(split[5]) > max) max = int(split[5]);
      
      rawData[i-3] = int(split[5]);
      
      sampleCount++;
      if (sampleCount > 10){
        if (sampleCount%avarageInterval == 0){
          println(sampleCount%avarageInterval);
          float average = 0;
          
          for (int j = -10; j < 0; j++){
            average += rawData[sampleCount-j];
          }
          average = average/10;
          println(average, sampleCount, sampleCount%avarageInterval);
        }
        
      }
      //if ()
      
      
      
      //if (split.length ==  7) println(split[5], split[6]);
      
  }
  println(min, max);

}

void draw(){

}
