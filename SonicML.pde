import controlP5.*;
import beads.*;
import java.io.File;
import java.util.*;


ControlP5 p5;
SamplePlayer newIndividualSamplePlayer;
Gain newIndividualGain;
SamplePlayer newHoFSamplePlayer; 
Gain newHoFGain;
SamplePlayer evalErrorSamplePlayer; 
Gain evalErrorGain;
SamplePlayer successEvalSamplePlayer; 
Gain successEvalGain;
SamplePlayer endOfGenSamplePlayer;
Gain endOfGenGain;

Glide gainGlide;
Gain masterGain;

TextToSpeechMaker ttsMaker; 

int streamFileValue;

NotificationServer notificationServer;
ArrayList<Notification> notifications;

MyNotificationListener myNotificationListener;

Textlabel lastGenOutput;

void setup() {

  
  size(1200, 600);  
  
  // get sound and data options
  
  List<String> soundFileNames = new ArrayList<String>();
  List<String> streamFileNames = new ArrayList<String>();
  //for (File file : new File(sketchPath("data")).listFiles()) {
  //      String fileName = file.getName();
  //      println(fileName, fileName.contains("."));
  //      if (fileName.contains(".")) {
  //        if (fileName.split(".")[1] == "wav")
  //          soundFileNames.add(fileName);
  //        else if (fileName.split(".")[1] == "json")
  //          streamFileNames.add(fileName);
  //      }
  //}
  for (File file : new File(sketchPath("data")).listFiles()) {
    if (file.getName().endsWith(".wav")) {
      soundFileNames.add(file.getName());
    } else if (file.getName().endsWith(".json")) {
      streamFileNames.add(file.getName());
    }
  }
  Collections.sort(soundFileNames);
  Collections.sort(streamFileNames);
  print(soundFileNames.toString());
  
  
  
  // -------------------------
  // Audio
  // -------------------------
  ac = new AudioContext();
  
  // // TTS
  ttsMaker = new TextToSpeechMaker();
  ttsImmediate("Welcome to Sonic eM eL ", 1);
  
  newIndividualSamplePlayer = getSamplePlayer("base.wav");
  newIndividualSamplePlayer.pause(true);
  newIndividualGain = new Gain(ac, 1);
  newIndividualGain.addInput(newIndividualSamplePlayer);
  newHoFSamplePlayer = getSamplePlayer("success_tetris.wav");
  newHoFSamplePlayer.pause(true);
  newHoFGain = new Gain(ac, 1);
  newHoFGain.addInput(newHoFSamplePlayer);
  evalErrorSamplePlayer = getSamplePlayer("error_bounce.wav");
  evalErrorSamplePlayer.pause(true);
  evalErrorGain = new Gain(ac, 1);
  evalErrorGain.addInput(evalErrorSamplePlayer);
  
  successEvalSamplePlayer = getSamplePlayer("marimba.wav");
  successEvalSamplePlayer.pause(true);
  successEvalGain = new Gain(ac, 1);
  successEvalGain.addInput(successEvalSamplePlayer);
  
  endOfGenSamplePlayer = getSamplePlayer("trumpet_up.wav");
  endOfGenSamplePlayer.pause(true);
  endOfGenGain = new Gain(ac, 1);
  endOfGenGain.addInput(endOfGenSamplePlayer);
  
  gainGlide = new Glide(ac, 1.0, 200);
  masterGain = new Gain(ac, 1, gainGlide);
  
  masterGain.addInput(newIndividualGain);
  masterGain.addInput(newHoFGain);
  masterGain.addInput(evalErrorGain);
  masterGain.addInput(successEvalGain);
  masterGain.addInput(endOfGenGain);
  
  ac.out.addInput(masterGain);
  
  ac.start();
  
  // -------------------------
  // Notifications
  // -------------------------
  

  //START NotificationServer setup
  notificationServer = new NotificationServer();
  
  //instantiating a custom class (seen below) and registering it as a listener to the server
  myNotificationListener = new MyNotificationListener();
  notificationServer.addListener(myNotificationListener);
  
  // -------------------------
  // GUI
  // -------------------------
  
  p5 = new ControlP5(this);
  // TITLE
  p5.addTextlabel("Title")
    .setText("SonicML")
    .setPosition(40-4, 40)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-BoldItalic", 48));
    
  // (HEREINAFTER REVERSE ORDER FOR LAYERING)
  
  
  
  // New 
  // ScrollableList newIndivSound = p5.addScrollableList("NewIndividualSound");
  
  // END OF GENERATION STATISTICS
  ScrollableList endOfGenSound = p5.addScrollableList("EndOfGenSound")
    .setPosition(40, 360)
    .setSize(240, 240)
    .setLabel("trumpet_up.wav")
    .setItemHeight(24)
    .setBarHeight(40)
    .setColorBackground(0x333333)
    .setItems(soundFileNames)
    .close()
    .setFont(createFont("PTSerif-Regular", 12));
  p5.addSlider("EndOfGenVol")
    //.setLabel("Volume")
    .setPosition(40, 335)
    .setSize(240, 20)
    .setRange(0, 100)
    .setValue(50);
  p5.addTextlabel("EndOfGenLabel")
    .setText("End of Generation Statistics")
    .setPosition(40-4, 310)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Regular", 14));
  p5.addTextlabel("EndOfGenTTSLabel")
    .setText("Text To Speech (TTS)")
    .setPosition(300-4, 310)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Regular", 14));
  p5.addToggle("GenNumTTS")
    .setPosition(300, 335)
    .setSize(120,20)
    .setLabel("Gen Number TTS")
    .setValue(true)
    .setColorLabel(0x00000)
    .setFont(createFont("PTSerif-Regular", 12));  // // TTS  
  p5.addToggle("AvgFitnessTTS")
    .setPosition(425, 335)
    .setSize(120,20)
    .setLabel("Avg Fitness TTS")
    .setValue(true)
    .setColorLabel(0x00000)
    .setFont(createFont("PTSerif-Regular", 12));  // // TTS  
  p5.addToggle("dAvgFitnessTTS")
    .setPosition(550, 335)
    .setSize(120,20)
    .setLabel("Δ Avg Fitness TTS")
    .setValue(true)
    .setColorLabel(0x00000)
    .setFont(createFont("PTSerif-Regular", 12));  // // TTS  
  p5.addToggle("NumIndividualsTTS")
    .setPosition(675, 335)
    .setSize(120,20)
    .setLabel("Population Size TTS")
    .setValue(true)
    .setColorLabel(0x00000)
    .setFont(createFont("PTSerif-Regular", 12));  // // TTS  
  p5.addToggle("NewHofTTS")
    .setPosition(300, 400)
    .setSize(120,20)
    .setLabel("HoFs Found TTS")
    .setValue(true)
    .setColorLabel(0x00000)
    .setFont(createFont("PTSerif-Regular", 12));  // // TTS  
  p5.addToggle("HofSizeTTS")
    .setPosition(425, 400)
    .setSize(120,20)
    .setLabel("Curr HoF Size TTS")
    .setValue(true)
    .setColorLabel(0x00000)
    .setFont(createFont("PTSerif-Regular", 12));  // // TTS  
  p5.addToggle("FailedEvalsTTS")
    .setPosition(550, 400)
    .setSize(120,20)
    .setLabel("Failed Evals TTS")
    .setValue(true)
    .setColorLabel(0x00000)
    .setFont(createFont("PTSerif-Regular", 12));  // // TTS  
    
  lastGenOutput = p5.addTextlabel("lastGenOutput")
    .setPosition(300-4, 450)
    .setSize(370, 100)
    .setText("")
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Regular", 12));
  
  // PITCHED EVENTS
  // // Successful Evaluation
  
  ScrollableList successfulEvalSound = p5.addScrollableList("SuccessEvalSound")
    .setPosition(40, 260)
    .setSize(240, 240)
    .setLabel("marimba.wav")
    .setItemHeight(24)
    .setBarHeight(40)
    .setColorBackground(0x333333)
    .setItems(soundFileNames)
    .close()
    .setFont(createFont("PTSerif-Regular", 12));
  p5.addSlider("SuccessEvalVol")
    //.setLabel("Volume")
    .setPosition(40, 235)
    .setSize(240, 20)
    .setRange(0, 100)
    .setValue(50);
  p5.addTextlabel("SuccessfulEvalLabel")
    .setText("Successful Evaluation")
    .setPosition(40-4, 210)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Regular", 14));
  p5.addToggle("EnablePitchModulation")
    .setPosition(300, 235)
    .setSize(120,20)
    .setLabel("Enable Pitch Modulation")
    .setValue(true)
    .setColorLabel(0x00000)
    .setFont(createFont("PTSerif-Regular", 12));
  
    
    
    
  
  // SINGLETON EVENTS 
    
  // // New Individual
  
  
  
  ScrollableList newIndivSound = p5.addScrollableList("NewIndividualSound")
    .setPosition(40, 160)
    .setSize(240, 240)
    .setLabel("base.wav")
    .setItemHeight(24)
    .setBarHeight(40)
    .setColorBackground(0x333333)
    .setItems(soundFileNames)
    .close()
    .setFont(createFont("PTSerif-Regular", 12));
  p5.addTextlabel("NewIndividualLabel")
    .setText("New Individual")
    .setPosition(40-4, 110)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Regular", 14));
  p5.addSlider("NewIndividualVol")
    //.setLabel("Volume")
    .setPosition(40, 135)
    .setSize(240, 20)
    .setRange(0, 100)
    .setValue(50);
    
  // // New HoF
  
  ScrollableList newHoFSound = p5.addScrollableList("NewHoFSound")
    .setPosition(300, 160)
    .setSize(240, 240)
    .setLabel("success_tetris.wav")
    .setItemHeight(24)
    .setBarHeight(40)
    .setColorBackground(0x333333)
    .setItems(soundFileNames)
    .close()
    .setFont(createFont("PTSerif-Regular", 12));
  p5.addTextlabel("NewHoFLabel")
    .setText("New HoF Found")
    .setPosition(300-4, 110)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Regular", 14));
  p5.addSlider("NewHoFVol")
    //.setLabel("Volume")
    .setPosition(300, 135)
    .setSize(240, 20)
    .setRange(0, 100)
    .setValue(50);
    
  // // Evaluation Error
  
  ScrollableList evalErrorSound = p5.addScrollableList("EvalErrorSound")
    .setPosition(560, 160)
    .setSize(240, 240)
    .setLabel("error_bounce.wav")
    .setItemHeight(24)
    .setBarHeight(40)
    .setColorBackground(0x333333)
    .setItems(soundFileNames)
    .close()
    .setFont(createFont("PTSerif-Regular", 12));
  p5.addTextlabel("EvalErrorLabel")
    .setText("Evaluation Error")
    .setPosition(560-4, 110)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Regular", 14));
  p5.addSlider("EvalErrorVol")
    .setLabel("")
    .setPosition(560, 135)
    .setSize(240, 20)
    .setRange(0, 100)
    .setValue(50);
    
  
  // DATA SIMULATOR
    
  p5.addTextlabel("DataStreamSimTitle")
    .setText("Data Stream Simulator")
    .setPosition(840-4, 75)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Bold", 22));
    
  // // Stream Controls Section  
    
  p5.addTextlabel("StreamControlsLabel")
    .setText("Stream Controls")
    .setPosition(840-4, 110)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Regular", 14));
    
  p5.addButton("StartStream")
    .setPosition(840, 135)
    .setSize(90, 32)
    .setLabel("Start")
    .activateBy((ControlP5.RELEASE));
  p5.addButton("PauseStream")
    .setPosition(940, 135)
    .setSize(90, 32)
    .setLabel("Pause")
    .activateBy((ControlP5.RELEASE));
  p5.addButton("StopStream")
    .setPosition(1040, 135)
    .setSize(90, 32)
    .setLabel("Stop")
    .activateBy((ControlP5.RELEASE));
  
  
    
  // // Single Events Section
    
  p5.addTextlabel("SimulateSingletonEventsLabel")
    .setText("Singleton Events")
    .setPosition(840-4, 210)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Regular", 14));
  p5.addButton("NewIndividualEvent")
    .setPosition(840, 235)
    .setSize(90, 32)
    .setLabel("New Individual")
    .activateBy((ControlP5.RELEASE));
  p5.addButton("NewHoFEvent")
    .setPosition(940, 235)
    .setSize(90, 32)
    .setLabel("New HoF")
    .activateBy((ControlP5.RELEASE));
  p5.addButton("FailedEvalEvent")
    .setPosition(1040, 235)
    .setSize(90, 32)
    .setLabel("Failed Evaluation")
    .activateBy((ControlP5.RELEASE));
    
    
  // // Successful Evaluation Event Section  
  
  p5.addTextlabel("SuccessEvalLabel")
    .setText("Successful Evaluation Event")
    .setPosition(840-4, 280)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Regular", 14));  
  p5.addButton("SuccessEvalEvent")
    .setPosition(840, 305)
    .setSize(90, 32)
    .setLabel("Fire")
    .activateBy((ControlP5.RELEASE));
  p5.addSlider("EvaluationFitnessSimSlider")
    .setPosition(940, 305)
    .setSize(190, 32)
    .setLabel("Fitness")
    .setColorLabel(0x000000)
    .setRange(0, 1)
    .setValue(.5);
    
  // // End of Generation Event Section
  
  p5.addTextlabel("EndOfGenerationSimLabel")
    .setText("End Of Generation Statistics")
    .setPosition(840-4, 350)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Regular", 14));
  p5.addButton("EndOfGenEvent")
    .setPosition(840, 375)
    .setSize(290, 32)
    .setLabel("Fire")
    .activateBy((ControlP5.RELEASE));
    
  p5.addTextfield("GenNumSimInput")
    .setPosition(840, 415)
    .setSize(90, 22)
    .setValue("1");
  p5.addTextfield("AvgFitnessSimInput")
    .setPosition(940, 415)
    .setSize(90, 22)
    .setValue("0.5");
  p5.addTextfield("dAvgFitnessSimInput")
    .setPosition(1040, 415)
    .setSize(90, 22)
    .setValue("0.05");
  p5.addTextlabel("GenNumSimInputLabel")
    .setText("(int) Gen #")
    .setPosition(840-4, 435)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Regular", 10));  
  p5.addTextlabel("AvgFitnessSimInputLabel")
    .setText("(float) Avg Fit")
    .setPosition(940-4, 435)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Regular", 10)); 
  p5.addTextlabel("dAvgFitnessSimInputLabel")
    .setText("(float) Δ Avg Fit")
    .setPosition(1040-4, 435)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Regular", 10)); 
    
  p5.addTextfield("NumIndividualsSimInput")
    .setPosition(840, 455)
    .setSize(90, 22)
    .setValue("40");
  p5.addTextfield("NewHofsSimInput")
    .setPosition(940, 455)
    .setSize(90, 22)
    .setValue("4");
  p5.addTextfield("HofSizeSimInput")
    .setPosition(1040, 455)
    .setSize(90, 22)
    .setValue("10");
  p5.addTextlabel("NumIndividualsSimInputLabel")
    .setText("(int) pop size")
    .setPosition(840-4, 475)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Regular", 10));  
  p5.addTextlabel("NewHofsSimInputLabel")
    .setText("(int) New HoFs")
    .setPosition(940-4, 475)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Regular", 10)); 
  p5.addTextlabel("HofSizeSimInputLabel")
    .setText("(int) HoF Size")
    .setPosition(1040-4, 475)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Regular", 10)); 
    
  p5.addTextfield("FailedEvalsSimInput")
    .setPosition(840, 495)
    .setSize(90, 22)
    .setValue("1");
  p5.addTextlabel("FailedEvalsSimInputLabel")
    .setText("(int) failed evals")
    .setPosition(840-4, 515)
    .setSize(200, 50)
    .setColorValue(0x000000)
    .setFont(createFont("PTSerif-Regular", 10)); 
    
    
  p5.addScrollableList("StreamFileSelect")
    .setPosition(840, 170)
    .setSize(290, 240)
    .setLabel("Make Selection")
    .setItemHeight(24)
    .setBarHeight(29)
    .setItems(streamFileNames)
    .close()
    .setFont(createFont("PTSerif-Regular", 12));

}

void PlaySuccessfulEvaluation(float rate) {
  if (1.0 == p5.get(Toggle.class, "EnablePitchModulation").getValue())
    successEvalSamplePlayer.setRate(new Glide(ac,rate,0));
  else
    successEvalSamplePlayer.setRate(new Glide(ac,1,0));
  successEvalSamplePlayer.start(0);
}



void NewIndividualVol(float value) {
  newIndividualGain.setGain(value/ 100.0);
}
void NewHoFVol(float value) {
  newHoFGain.setGain(value/ 100.0);
}
void EvalErrorVol(float value) {
  evalErrorGain.setGain(value/ 100.0);
}
void SuccessEvalVol(float value) {
  successEvalGain.setGain(value/ 100.0);
}
void EndOfGenVol(float value) {
  endOfGenGain.setGain(value/ 100.0);
}


void NewIndividualEvent() {
  newIndividualSamplePlayer.start(0);
}
void NewHoFEvent() {
  newHoFSamplePlayer.start(0);
}
void FailedEvalEvent() {
  evalErrorSamplePlayer.start(0);
}
void SuccessEvalEvent() {
  float rate = p5.get(Slider.class, "EvaluationFitnessSimSlider").getValue() + 0.005;
  //print(rate);
  PlaySuccessfulEvaluation(rate * 3);
}


void EndOfGenEvent() {
  
  handleEndOfGen(new Notification(
    Integer.parseInt( p5.get(Textfield.class, "GenNumSimInput").getText() ),
    Float.parseFloat( p5.get(Textfield.class, "AvgFitnessSimInput").getText() ),
    Float.parseFloat( p5.get(Textfield.class, "dAvgFitnessSimInput").getText() ),
    Integer.parseInt( p5.get(Textfield.class, "NumIndividualsSimInput").getText() ),
    Integer.parseInt( p5.get(Textfield.class, "NewHofsSimInput").getText() ),
    Integer.parseInt( p5.get(Textfield.class, "HofSizeSimInput").getText() ),
    Integer.parseInt( p5.get(Textfield.class, "FailedEvalsSimInput").getText() )
  ));
  
}

void NewIndividualSound(int value) {
  String fileName = (String) p5.get(ScrollableList.class, "NewIndividualSound").getItem(value).get("name");
  newIndividualSamplePlayer.setSample(getSample(fileName));
  newIndividualSamplePlayer.start(0);
}
void NewHoFSound(int value) {
  String fileName = (String) p5.get(ScrollableList.class, "NewHoFSound").getItem(value).get("name");
  newHoFSamplePlayer.setSample(getSample(fileName));
  newHoFSamplePlayer.start(0);
}
void EvalErrorSound(int value) {
  String fileName = (String) p5.get(ScrollableList.class, "EvalErrorSound").getItem(value).get("name");
  evalErrorSamplePlayer.setSample(getSample(fileName));
  evalErrorSamplePlayer.start(0);
}
void SuccessEvalSound(int value) {
  String fileName = (String) p5.get(ScrollableList.class, "SuccessEvalSound").getItem(value).get("name");
  successEvalSamplePlayer.setSample(getSample(fileName));
  successEvalSamplePlayer.start(0);
}
void EndOfGenSound(int value) {
  String fileName = (String) p5.get(ScrollableList.class, "EndOfGenSound").getItem(value).get("name");
  endOfGenSamplePlayer.setSample(getSample(fileName));
  endOfGenSamplePlayer.start(0);
}

void ttsImmediate(String inputSpeech, float gain) {
  //create TTS file and play it back immediately
  //the SamplePlayer will remove itself when it is finished in this case
  
  String ttsFilePath = ttsMaker.createTTSWavFile(inputSpeech);
  println("File created at " + ttsFilePath);
  
  //createTTSWavFile makes a new WAV file of name ttsX.wav, where X is a unique integer
  //it returns the path relative to the sketch's data directory to the wav file
  
  //see helper_functions.pde for actual loading of the WAV file into a SamplePlayer
  
  SamplePlayer sp = getSamplePlayer(ttsFilePath, true); 
  //true means it will delete itself when it is finished playing
  //you may or may not want this behavior!
  
  if (gain != 1) {
    Gain spGain = new Gain(ac, 1);
    spGain.setGain(gain);
    spGain.addInput(sp);
    ac.out.addInput(spGain);
  } else {
    ac.out.addInput(sp);
  }
  
  sp.start(0);
  println("TTS: " + inputSpeech);
}

void StreamFileSelect(int value) {
  streamFileValue = value;
}

void StartStream(int value) {
  //loading the event stream, which also starts the timer serving events
  notificationServer.stopEventStream(); //always call this before loading a new stream
  
  String fileName = (String) p5.get(ScrollableList.class, "StreamFileSelect").getItem(streamFileValue).get("name");
  println(fileName);
  notificationServer.loadEventStream(fileName);
  
  
}

void PauseStream(int value) {
  notificationServer.pauseEventStream();
}

void StopStream(int value) {
  notificationServer.stopEventStream();
}




// enum NotificationType { NewIndividual, NewHoF, EvalError, SuccessEval, EndOfGen }

class MyNotificationListener implements NotificationListener {
  
  public MyNotificationListener() {
    //setup here
  }
  
  //this method must be implemented to receive notifications
  public void notificationReceived(Notification notification) { 
    println("<Example> " + notification.getType().toString() + " notification received at " 
    + Integer.toString(notification.getTimestamp()) + " ms");
    
    String debugOutput = ">>> ";
    switch (notification.getType()) {
      case NewIndividual:
        NewIndividualEvent();
        break;
      case NewHoF:
        NewHoFEvent();
        break;
      case EvalError:
        FailedEvalEvent();
        break;
      case SuccessEval:
        float fitness = Float.parseFloat(notification.getNote());
        PlaySuccessfulEvaluation(fitness * 3);
        break;
      case EndOfGen:
        println("sending to handleEndOfGen");
        handleEndOfGen(notification);
        break;
    }
    debugOutput += notification.toString();
    //debugOutput += notification.getLocation() + ", " + notification.getTag();
    
    //println(debugOutput);
    
   //You can experiment with the timing by altering the timestamp values (in ms) in the exampleData.json file
    //(located in the data directory)
  }
}

void handleEndOfGen(Notification noteFromJson) {
  
  endOfGenSamplePlayer.start(0);
  
  String ttsStr = "";
  
  if (1.0 == p5.get(Toggle.class, "GenNumTTS").getValue()) {
    ttsStr += "Generation Number " +  noteFromJson.getGenNum() + "\n";
  }
  if (1.0 == p5.get(Toggle.class, "AvgFitnessTTS").getValue()) {
    ttsStr += "Average Fitness " +  noteFromJson.getAvgFitness() + "\n";
  }
  if (1.0 == p5.get(Toggle.class, "dAvgFitnessTTS").getValue()) {
    ttsStr += "Change in Average Fitness " +  noteFromJson.getdAvgFitness() + "\n";
  }
  if (1.0 == p5.get(Toggle.class, "NumIndividualsTTS").getValue()) {
    ttsStr += "Population Size " +  noteFromJson.getNumIndividuals() + "\n";
  }
  if (1.0 == p5.get(Toggle.class, "NewHofTTS").getValue()) {
    ttsStr += "New Hall of Fame Individuals Found " +  noteFromJson.getNewHof() + "\n";
  }
  if (1.0 == p5.get(Toggle.class, "HofSizeTTS").getValue()) {
    ttsStr += "Current Hall of Fame Size " +  noteFromJson.getHofSize() + "\n";
  }
  if (1.0 == p5.get(Toggle.class, "FailedEvalsTTS").getValue()) {
    ttsStr += "Failed Evaluations " +  noteFromJson.getFailedEvals() + "\n";
  }
  ttsImmediate(ttsStr, p5.get(Slider.class, "EndOfGenVol").getValue() / 100);
  lastGenOutput.setText(ttsStr);
}

void draw() {
      
background(#ffffff);
  //rect(30, 160, 260, 220);\
  line(240, 55, 600, 55);
  line(240, 65, 400, 65);
  line(240, 75, 300, 75);
  line(240, 85, 260, 85);
  rect(820, 55, 360, 490);
}
