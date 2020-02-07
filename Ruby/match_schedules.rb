require 'json'
require 'open-uri'
require 'date'
require 'time'
require 'axlsx'
require 'csv'

require './tba_basic_operations.rb'

# ########################################################################### #

EVENT_CODE = 'ausp'
YEAR = '2019'
EVENT_KEY = "#{YEAR}#{EVENT_CODE}"

WRITE_TO_DIR = __dir__ + '/../written-files/'

# ########################################################################### #

# generates a match schedule with only match number and alliances
def gen_match_schedule(is_write_file)
  m_sh = {}

  tba_matches = tba_call("event/#{EVENT_KEY}/matches/simple")

  tba_matches.each do |m|
    # f m[:comp_level] == 'qm'
    m_sh["#{m['comp_level']}_#{m['match_number'].to_s.rjust(2, "0")}"] = {
      # match_key: m['key'],
      red_alliance: m['alliances']['red']['team_keys'].each {|n| n.slice!(0..2)},
      blue_alliance: m['alliances']['blue']['team_keys'].each {|n| n.slice!(0..2)},
      time: Time.at(m['time']).to_datetime.strftime('%H:%M %d-%m-%Y %:z'),
    }
    # end
  end

  # m_sh = m_sh.sort.to_h

  if is_write_file 
    write_to_pretty_json(WRITE_TO_DIR, "#{EVENT_KEY}_match_schedule", m_sh)
  end
  m_sh
end

# finds all matches that <team> is in, then outputs a hash w/ approx times

def find_teams_matches(tm, pre_dta)
  matches = {}
  # col = "blank"
  pre_dta.each do |m, d|
    if d[:red_alliance].any? { |t| t==tm.to_s } || d[:blue_alliance].any? { |t| t==tm.to_s }
      matches[m] = d
    end
  end
  matches
end


def export_to_csv(dta)

  CSV.open("#{WRITE_TO_DIR}#{EVENT_KEY}_match_schedule.csv", 'wb') do |csv|
    csv << ["Match Number", "Time", "Red1", "Red2", "Red3", "Blue1", "Blue2", "Blue3"]
    dta.each do |matchnum, m|
      row = [ matchnum, m[:time] ] +  m[:red_alliance] + m[:blue_alliance]
      csv << row
    end 
  end
end

# ########################################################################### #


match_schedule = gen_match_schedule(false)
# print(match_schedule)

# match_schedule = open_json_file("#{EVENT_KEY}_match_schedule")
export_to_csv(match_schedule)
# jj find_teams_matches(5333, match_schedule)

