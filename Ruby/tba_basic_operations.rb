require 'json'
require 'open-uri'

AUTH_KEY = 

def tba_call(api_ref)
  response = open("https://www.thebluealliance.com/api/v3/#{api_ref}?X-TBA-Auth-Key=#{AUTH_KEY}").read
  response = JSON.parse response
  response
end

def write_to_pretty_json(dir, file_nm, dta)
  Dir.chdir(dir)
  File.open("#{dir}#{file_nm}.json", mode: 'w') do |f|  
    f.write(JSON.pretty_generate(dta))
  end
end

def write_to_json(dir, file_nm, dta)
  Dir.chdir(dir)
  File.open("#{dir}#{file_nm}.json", mode: 'w') do |f|  
    f.write(JSON.generate(dta))
  end
end

def open_json_file(dir, file_nm)
  Dir.chdir(dir)
  JSON.parse(File.read("#{file_nm}.json"))
end


def write_to_text_file(dir, file_nm, dta)
  Dir.chdir(dir)
  File.open("#{dir}#{file_nm}.txt", mode: 'w') do |f|  
    f.write(dta)
  end
end