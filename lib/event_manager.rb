require "csv"
require "sunlight/congress"
require "erb"
require "date"

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
	zipcode.to_s.rjust(5, "0")[0..4]
end

def clean_phone_number(number)
  number = number.gsub(/\W/, '')
  if number.to_s.length < 10
	false
  elsif number.to_s.length > 10 && number.to_s[0] != "1"
	false
  elsif number.to_s.length == 11 && number.to_s[0] == "1"
	number[1..11]
  elsif number.to_s.length == 10
	number
  end
end

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id, form_letter)
  Dir.mkdir("output") unless Dir.exists? "output"

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
  	file.puts form_letter
  end
end

puts "EventManager Initialized!"

if File.exist? "event_attendees.csv"
  content = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
end

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

content.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  phone_number = clean_phone_number(row[:homephone])
  d = row[:regdate].gsub(/\//, ' ')
  date = DateTime.parse(row[:regdate].gsub(/\//, ' ')) rescue DateTime.strptime(d, '%-d %-m %y %:z')
  #date = DateTime.parse(row[:regdate])
  #date2 = DateTime.strptime(d, '%-d %-m %y %:z')
  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letters(id, form_letter)

  puts d
  puts date

end




