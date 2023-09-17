import json
import datetime
import random

def make_json_event(timestamp, type, tag, flag, priority, note):
  event = {
    "type": type,
    "timestamp": timestamp,
    "tag": tag,
    "flag": flag,
    "priority": priority,
    "note": note
  }
  return event

def make_json_event_endOfGen(timestamp, genNum, avgFitness, dAvgFitness, numIndividuals, newHof, hofSize, failedEvals):
  event = {
    "type": "EndOfGen",
    "timestamp": timestamp,
    "priority": 1,

    "genNum": genNum, 
    "avgFitness": avgFitness,
    "dAvgFitness": dAvgFitness,
    "numIndividuals": numIndividuals,
    "newHof": newHof,
    "hofSize": hofSize,
    "failedEvals": failedEvals
  }
  return event

def make_gen_1_example():
  events = []
  t = 100
  for i in range(40):
    timestamp = t
    t += 500 + random.randint(-50,50)
    type = "NewIndividual"
    tag = ""
    flag = ""
    priority = 3
    note = ""
    event = make_json_event(timestamp, type, tag, flag, priority, note)
    events.append(event)

  for i in range(40):
    timestamp = t
    t += 1000 + random.randint(-100,100)
    type = "SuccessEval"
    tag = ""
    flag = ""
    priority = 2
    note = random.uniform(.4, .6)
    event = make_json_event(timestamp, type, tag, flag, priority, str(note))
    events.append(event)

    if note > .56:
        event = make_json_event(timestamp, "NewHoF", tag, flag, 1, "")
        events.append(event)
  
  events.append(make_json_event_endOfGen(timestamp, 1, .51, 0.0, 40, 5, 5, 0))

  with open("gen_1_example.json", "w") as f:
    json.dump(events, f)

def make_end_of_gen_sample():
  events = []
  events.append(make_json_event_endOfGen(0, 1, .51, 0.0, 40, 5, 10, 1))
  with open("end_of_gen_sample.json", "w") as f:
    json.dump(events, f)



def make_short_full_run():
  events = []
  t = 100
  baseFitness = 0
  for gen in range(1, 4):
    numIndividuals = random.randint(36,46)
    baseFitness += .2
    for i in range(numIndividuals):
        timestamp = t
        t += 500 + random.randint(-50,50)
        type = "NewIndividual"
        tag = ""
        flag = ""
        priority = 3
        note = ""
        event = make_json_event(timestamp, type, tag, flag, priority, note)
        events.append(event)
    hofCount = 0
    for i in range(numIndividuals):
        t += 1000 + random.randint(-100,100)
        if random.uniform(0,1) > .98:
          event = make_json_event(timestamp, "EvalError", tag, flag, 2, "")
          events.append(event)

        else:
            timestamp = t
            type = "SuccessEval"
            tag = ""
            flag = ""
            priority = 2
            note = baseFitness + random.uniform(.2, .3)
            event = make_json_event(timestamp, type, tag, flag, priority, str(note))
            events.append(event)

            if note > (baseFitness + .29):
                hofCount += 1
                event = make_json_event(timestamp, "NewHoF", tag, flag, 1, "")
                events.append(event)
    
    events.append(make_json_event_endOfGen(timestamp, gen, round(baseFitness + random.uniform(.2, .3), 2), round(random.uniform(-.05, .15), 2), numIndividuals, hofCount, 10, 0))

  with open("short_full_run.json", "w") as f:
    json.dump(events, f)


def make_long_full_run():
  events = []
  t = 100
  baseFitness = 0
  for gen in range(1, 11):
    numIndividuals = random.randint(36,46)
    baseFitness += .08
    for i in range(numIndividuals):
        timestamp = t
        t += 500 + random.randint(-50,50)
        type = "NewIndividual"
        tag = ""
        flag = ""
        priority = 3
        note = ""
        event = make_json_event(timestamp, type, tag, flag, priority, note)
        events.append(event)
    hofCount = 0
    for i in range(numIndividuals):
        t += 1000 + random.randint(-100,100)
        if random.uniform(0,1) > .98:
          event = make_json_event(timestamp, "EvalError", tag, flag, 2, "")
          events.append(event)

        else:
            timestamp = t
            type = "SuccessEval"
            tag = ""
            flag = ""
            priority = 2
            note = baseFitness + random.uniform(0, .1)
            event = make_json_event(timestamp, type, tag, flag, priority, str(note))
            events.append(event)

            if note > (baseFitness + .096):
                hofCount += 1
                event = make_json_event(timestamp, "NewHoF", tag, flag, 1, "")
                events.append(event)
    
    events.append(make_json_event_endOfGen(timestamp, gen, round(baseFitness + random.uniform(0, .1), 2), round(random.uniform(-.05, .15), 2), numIndividuals, hofCount, 10, 0))

  with open("long_full_run.json", "w") as f:
    json.dump(events, f)

def main():
  make_gen_1_example()
  make_end_of_gen_sample()
  make_short_full_run()
  make_long_full_run()

if __name__ == "__main__":
  main()