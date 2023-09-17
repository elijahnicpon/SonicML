# Welcome to SonicML!


## Project Purpose
SonicML is a tool intended for the eyes-free monitoring of genetic algorithm training. As this process can sometimes last hours or days at a time, it is unreasonable to think that someone should stare at a SQLWorkbench table to monitor progress.


## Usage


#### Singleton Events
There are three singleton events, located at the top of the program, which merely play a tone with no further modifications. Each event has an individual volume slider, and a dropdown menu that allows users to select the tone they would like to have played when the event occurs. The volume slider and dropdown menu are intended to allow researchers to find combinations of sounds and volumes that they can selectively tune in/out, depending on what they're monitoring during the training process.
The events and their descriptions as follows:
- New Individual Created
  - Genetic algorithms make use of individuals, which represent a possible solution to be evaluated against the objectives. Each generation, new individuals are created by crossing the previous generation's well-performing individuals and randomly applying mutations to increase variance.
- New Hall Of Fame Individuals
  - Hall of Fame individuals are high-performing individuals that persist in populations across generations until they are beaten by other high-performing individuals. This is a strong indicator that training is going well.
- Failed Evaluation
  - During the training process, individuals are evaluated against the objectives. If they fail to evaluate, their fitness cannot be determined and must be purged from the generation. If this happens often, it could be a sign of a bug or other training issue.


#### Successful Evaluation Event
Successful Evaluation Events are similar to singleton events as described above and share the volume slider and dropdown menu controllers. They additionally feature a toggle that allows SonicML to modify the pitch of the notification tone based on the evaluated fitness of the individual. This allows researchers to listen for the gradual increase in pitch over time, and monitor for any sudden drops or increases that may be of concern. This also allows researchers to determine when to stop the training process to prevent overfitting the algorithm to the training data.


#### End of Generation Statistics
Genetic Algorithm Training occurs in generations. At the end of each generation, lots of useful data is available and can be converted into speech. In the "Text To Speech" section of the program, each datum can be toggled on or off depending on what features of the data a particular researcher may be listening for. Additionally, the output is displayed as text on the screen for convenience.


![Application Screenshot](image.png)


#### Simulator
The Data Stream Simulator on the right-hand side of the application allows users to simulate each of the above events, and modify their data to hear the changes in the sonification. It is divided into 4 sections:
1. Stream Controls
   1. This section allows users to select a JSON file representing a stream of events. Each of the files and their respective use cases are enumerated in the "Potential Use Cases & Respective JSON Event Files" section.
2. Singleton Events
   1. This section contains buttons to fire each of the three singleton events
3. Successful Evaluation Event
   1. This section contains a button to fire a successful evaluation event, as well as a slider that can adjust the evaluation value (i.e. fitness) of the event, resulting in a change in pitch, when toggled on.
4. End-of-Generation Statistics
   1. This section contains a button to fire an end-of-generation event, and 7 fields to modify. When each of the field's respective TTS buttons is toggled on, they will be announced by a tts engine. 


## Potential Use Cases & Respective JSON Event Files
1. `end_of_gen_sample.json`: Sample of the end of a generation.
2. `gen_1_example.json`: Sample of a full generation being run.
3. `short_full_run`: 3 generation training run with increasing fitness over time.
4. `long_full_run`: 10 generation training run with incraseing fitness over time. 

