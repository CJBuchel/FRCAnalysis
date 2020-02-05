require 'json'
require 'open-uri'

require './tba_basic_operations.rb'

# TODO:#
#     - copy over crosscheck stuff from python
#     - have a checklist/show what data is for each team
#         (ie. team # has data: nickname, country, wildcard, match stats, etc)
#     - asks for year and event_code ( gets )

write_to_dir = __dir__ + '/../written-files/'

event_code = 'ausc'
year = '2020'
event_key = "#{year}#{event_code}"

# ########################################################################### #

# creates a hash with basic team data, and an empty hash for events
def initialise_teams_hash(ekey)
  tba_teams_simple = tba_call("event/#{ekey}/teams/simple")

  tm_dta = {}

  tba_teams_simple.each do |team|
    tm_dta[team['team_number']] = { nickname: team['nickname'],
                         name: team['name'],
                         country: team['country']}
  end

  tm_dta
end

# returns a dictionary of all events team attended in format
#                              {ausp: {data}, ausc: {data}}
def teams_events(yr, dta)
  team_by_event_data = {}

  dta.each do |n, _d| # iterates each team and their data
    # current_teams_events is an array of hashes [{e1}, {e2}, {etc}]
    current_teams_events = tba_call("team/frc#{n}/events/#{yr}/simple")

    team_by_event_data[n] = {}

    current_teams_events.each do |e|
      team_by_event_data[n][e['event_code']] = {
        name: e['name'],
        code: e['event_code'],
        location: "#{e['city']}, #{e['state_prov']}, #{e['country']}",
        start_date: e['start_date'], 
        end_date: e['end_date'],
        event_type: e['event_type']
      }
    end
  end
  team_by_event_data
end


# ######################################################################## #


# download data from tba and write to file
team_data = initialise_teams_hash(event_key)
# team_data = JSON.parse(File.read('team_data.json'))

# creates a hash in the form {team#: {ausp: {ausp_data}, ausc: {ausc_data}}}
events_by_team = teams_events(year, team_data)
# puts the event data into the main team_data hash
events_by_team.each do |n, d|
  team_data[n]['events_attended'] = d
end

write_to_pretty_json(write_to_dir, "#{event_key}_team_and_event_data", team_data)
