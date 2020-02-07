# FRC Data Helper Thing

A collection of ruby scripts that use TBA to perform actions. Output samples are available in SampleOutputs directory.
The scripts are quite varied in their purpose, and some of them may be broken, but they all relate to FRC.
Scripts by default will export to the directory written-files. 


## Scripts 
|Script Name | Purpose | Use |
| --- | --- | ---|
tba_base_operations.rb | Contains all the basic methods used within the other files | You should never need to run this file. However, will need to change the `AUTHKEY` variable to your TBA authorisation key
find_event.rb | Finds the event code of an event based on event name. May search for the exact phrase input. | Run the file, follow prompts. 
match_performance.rb | Capable of outputting either a json or a csv file containing match schedule data | Edit the variables `event_code` and `year` at the top of the file. Change the boolean in method `gen_match_schedule()` to generate the json file, comment/uncomment the `export_to_csv` method for a csv file. 
team_event.rb | Outputs a .json with all the teams attending an event, and all the events they attend. Useful when trying to determine number of wildcards at event. | Change `event_code` and `year` at top of file. Run file. 
match_performance.rb | Outputs a monster of a file, is a match schedule combined with the scoring of the match. Works for any year (hopefully) but it's literally a raw data dump | Like above, change `event_code` and `year` and run the file