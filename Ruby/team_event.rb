require 'json'
require 'open-uri'

require './tba_basic_operations.rb'

# TODO:#
#     - copy over crosscheck stuff from python
#     - have a checklist/show what data is for each team
#         (ie. team # has data: nickname, country, wildcard, match stats, etc)
#     - asks for YEAR and EVENT_CODE ( gets )

write_to_dir = __dir__ + '/../written-files/'

EVENT_CODE = 'ausc'
YEAR = '2019'
EVENT_KEY = "#{YEAR}#{EVENT_CODE}"


HALL_OF_FAME = [1311, 2834, 3132, 2614, 987, 597, 27, 1538, 1114, 359, 341,
                236, 842, 365, 111, 67, 254, 103, 175, 22, 16, 120, 23, 47, 144, 151, 191]

# ########################################################################### #

# creates a hash with basic team data, and an empty hash for events
def initialise_teams_hash()
  tba_teams_simple = tba_call("event/#{EVENT_KEY}/teams/simple")

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
def teams_events(dta)
  team_by_event_data = {}

  dta.each do |n, _d| # iterates each team and their data
    # current_teams_events is an array of hashes [{e1}, {e2}, {etc}]
    current_teams_events = tba_call("team/frc#{n}/events/#{YEAR}/simple")

    team_by_event_data[n] = {}

    current_teams_events.each do |e|
      team_by_event_data[n][e['EVENT_CODE']] = {
        name: e['name'],
        code: e['EVENT_CODE'],
        location: "#{e['city']}, #{e['state_prov']}, #{e['country']}",
        start_date: e['start_date'], 
        end_date: e['end_date'],
        event_type: e['event_type']
      }
    end
  end
  team_by_event_data
end


def gen_teams_and_events(is_write_file, write_to_dir)
  # download data from tba and write to file
  team_data = initialise_teams_hash(EVENT_KEY)
  # team_data = JSON.parse(File.read('team_data.json'))

  # creates a hash in the form {team#: {ausp: {ausp_data}, ausc: {ausc_data}}}
  events_by_team = teams_events(YEAR, team_data)
  # puts the event data into the main team_data hash
  events_by_team.each do |n, d|
    team_data[n]['events_attended'] = d
  end

  if is_write_file
    write_to_pretty_json(write_to_dir, "#{EVENT_KEY}_team_and_event_data", team_data)
  end
  team_data
end


# finds which teams attended an event other than <EVENT_CODEe> 
def potential_wildcards(tms_data)
  poten_wilds = {}

  # get all the teams that attended more than one event into poten_wilds
  tms_data.each do |num, data|
    data['events_attended'].each do |ekey, edata| # for each teams event
      if edata['code'] != EVENT_CODE && edata['event_type'] != 0 # if not this regional
        poten_wilds[num] = data # overrides
      end
    end
  end

  # for all teams in potenwilds find if won any awards
  wdcd = {}
  poten_wilds.each do |num, data|
    wdcd[num] = find_wildcard_reason(num, data)
  end

  wdcd
end


def find_wildcard_reason(tm, dta)
  deet = {}

  dta['events_attended'].each do |ecode, edata|
    team_awards = tba_call("team/frc#{tm}/event/#{YEAR}#{EVENT_CODE}/awards")
    team_awards.each do |award|
      if [0,1,9,10].include?(award['award_type'])
        # print(aware[:name:])
        deet[EVENT_CODE] = award['award_name']
      end
    end
  end
  
  if HALL_OF_FAME.include?(tm)
    # print('hall of farm')
    deet[' '] = 'Hall of Fame'
  end
  # jj deet
  deet
end

# ######################################################################## #

# tms = gen_teams_and_events(event_keyEVENT_KEY, YEAR, true, write_to_dir)
tms = open_json_file(__dir__ + "/../written-files", "#{EVENT_KEY}_team_and_event_data")
# jj tms
jj potential_wildcards(tms)