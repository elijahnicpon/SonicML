//modified
enum NotificationType { NewIndividual, NewHoF, EvalError, SuccessEval, EndOfGen }

class Notification {
   
  int timestamp;
  NotificationType type; // door, person_move, object_move, appliance_state_change, package_delivery, message
  String note;
  //String location;
  String tag;
  String flag;
  int priority;
  
  // end of gen
  int genNum;
  float avgFitness;
  float dAvgFitness;
  int numIndividuals;
  int newHof;
  int hofSize;
  int failedEvals;
  
  // for data stream simulator end of gen stats
  public Notification(int genNum, float avgFitness, float dAvgFitness, int numIndividuals, int newHof, int hofSize, int failedEvals) {
    this.genNum = genNum;
    this.avgFitness = avgFitness;
    this.dAvgFitness = dAvgFitness;
    this.numIndividuals = numIndividuals;
    this.newHof = newHof;
    this.hofSize = hofSize;
    this.failedEvals = failedEvals;
  }
  
  public Notification(JSONObject json) {
    this.timestamp = json.getInt("timestamp");
    //time in milliseconds for playback from sketch start
    
    String typeString = json.getString("type");
    
    try {
      this.type = NotificationType.valueOf(typeString);
    }
    catch (IllegalArgumentException e) {
      throw new RuntimeException(typeString + " is not a valid value for enum NotificationType.");
    }
    
    
    if (json.isNull("note")) {
      this.note = "";
    }
    else {
      this.note = json.getString("note");
    }
    
    //if (json.isNull("location")) {
    //  this.location = "";
    //}
    //else {
    //  this.location = json.getString("location");      
    //}
    
    if (json.isNull("tag")) {
      this.tag = "";
    }
    else {
      this.tag = json.getString("tag");      
    }
    
    if (json.isNull("flag")) {
      this.flag = "";
    }
    else {
      this.flag = json.getString("flag");      
    }
    
    this.priority = json.getInt("priority");
    //1-3 levels (1 is highest, 3 is lowest)  
    
    // end of gen
    
    if (json.isNull("genNum")) {
      this.genNum = 0;
    } else {
      this.genNum = json.getInt("genNum");      
    }
    if (json.isNull("avgFitness")) {
      this.avgFitness = 0;
    } else {
      this.avgFitness = json.getFloat("avgFitness");      
    }
    if (json.isNull("dAvgFitness")) {
      this.dAvgFitness = 0;
    } else {
      this.dAvgFitness = json.getFloat("dAvgFitness");      
    }
    if (json.isNull("numIndividuals")) {
      this.numIndividuals = 0;
    } else {
      this.numIndividuals = json.getInt("numIndividuals");      
    }
    if (json.isNull("newHof")) {
      this.newHof = 0;
    } else {
      this.newHof = json.getInt("newHof");      
    }
    if (json.isNull("hofSize")) {
      this.hofSize = 0;
    } else {
      this.hofSize = json.getInt("hofSize");      
    }
    if (json.isNull("failedEvals")) {
      this.failedEvals = 0;
    } else {
      this.failedEvals = json.getInt("failedEvals");      
    }

    
    
    
    
  }
  
  public int getTimestamp() { return timestamp; }
  public NotificationType getType() { return type; }
  public String getNote() { return note; }
  //public String getLocation() { return location; }
  public String getTag() { return tag; }
  public String getFlag() { return flag; }
  public int getPriorityLevel() { return priority; }
  
  public int getGenNum() { return genNum; }
  public float getAvgFitness() { return avgFitness; }
  public float getdAvgFitness() { return dAvgFitness; }
  public int getNumIndividuals() { return numIndividuals; }
  public int getNewHof() { return newHof; }
  public int getHofSize() { return hofSize; }
  public int getFailedEvals() { return failedEvals; }
  
  public String toString() {
      String output = getType().toString() + ": ";
      //output += "(location: " + getLocation() + ") ";
      output += "(tag: " + getTag() + ") ";
      output += "(flag: " + getFlag() + ") ";
      output += "(priority: " + getPriorityLevel() + ") ";
      output += "(note: " + getNote() + ") ";
      return output;
    }
}
