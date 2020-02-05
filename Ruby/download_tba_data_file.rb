require './tba_basic_operations.rb'
write_to_dir = __dir__ + '/../written-files/'

data = tba_call("event/2019ausp/teams/simple")
# write_to_text_file(direc, "2019ausp_team_keys", data)

write_to_json(direc, "tba_2019ausp_teams_simple", data)