# TODO
# - find averages of scores and all that


# ########################################################################### #

# require 'json' # required already in tba_basic_operations so don't need to
# require 'open-uri'

require './tba_basic_operations.rb'

EVENT_CODE = 'ausp'
YEAR = '2018'
EVENT_KEY = "#{YEAR}#{EVENT_CODE}"

WRITE_TO_DIR = __dir__ + '/../written-files/'

# ########################################################################### #

# changes the keys of hash from "robot1" -> "robot####"
def swap_robotnum_to_teamnum(teams, dta)
  scoring = {}
  nums = [1, 2, 3]

  dta.each do |k, v|
    is_done = false
    if k.to_s.include? 'Robot'

      nums.each do |n|
        if k.to_s.include? "Robot#{n}"
          scoring[k.to_s.sub(nums[n - 1].to_s, teams[n - 1]).to_sym] = v
          is_done = true
        end
      end
    end
    unless is_done
      scoring[k] = v
    end
  end

  scoring
end

# generates a match schedule with all scores and score breakdown
def post_match_data_summary(dta, is_write_file)
  m_sh = {qm: {}, sf: {}, qf: {}, f: {}}

  dta.each do |m|
    red_tms = m['alliances']['red']['team_keys'].each { |n| n.slice!(0..2) }
    blue_tms = m['alliances']['blue']['team_keys'].each { |n| n.slice!(0..2) }

    m_sh[m['comp_level'].to_sym]["#{m['comp_level']}_#{m['match_number']}.#{m['set_number']-1}"] = {
      match_key: m['key'],
      red_alliance: red_tms,
      red_score: m['alliances']['red']['score'],
      blue_alliance: blue_tms,
      blue_score: m['alliances']['blue']['score'],
      winner: m['winning_alliance'],
      score_breakdown: {
        red: swap_robotnum_to_teamnum(red_tms, m['score_breakdown']['red']),
        blue: swap_robotnum_to_teamnum(blue_tms, m['score_breakdown']['blue'])
      }
    }
  end

  if is_write_file
    write_to_pretty_json(WRITE_TO_DIR, "#{EVENT_KEY}_post_match", m_sh)
  else
    m_sh
  end

end

# requires data outputted by post_match_data_summary
def teams_matches_find(tm, post_dta)
  performance = {}
  post_dta['qm'].each do |k, v|
    ['red', 'blue'].each do |col|
      if v["#{col}_alliance"].any? { |t| t == tm.to_s }
        performance[k.to_sym] = {
          alliance: col.to_s,
          score_breakdown: v['score_breakdown'][col]
        }
      end
    end
  end
  performance
end

# ########################################################################### #

# # pulls data from tba and creates file
tba_matches = tba_call("event/#{EVENT_KEY}/matches")
post_match_data_summary(tba_matches, true)

# post_match_data = open_json_file( "#{EVENT_KEY}_post_match")

# jj teams_matches_find('5333', post_match_data)
