require './tba_basic_operations.rb'

print 'input what event you want to find the key of (in all lowercase): '
keyword = gets.chomp.downcase
# puts keyword


all_events = tba_call('events/2019')

puts 'possible eventkey is : '
all_events.each do |event|
  event.each do |_k, v|
    if v.to_s.downcase.include? keyword.to_s
      puts "#{event['key']} : #{event['name']} in #{event['location_name']}, #{event['state_prov']}"
      break
    end
  end
end

puts 'no other events match the provided keywords'