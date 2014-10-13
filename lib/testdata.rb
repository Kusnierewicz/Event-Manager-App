require "date"

d = "11/12/08 10:47"
d2 = "2/2/09 11:29"
puts DateTime.parse(d) 
puts DateTime.parse(d2)
puts DateTime.strptime(d, '%-d/%-m/%y %k:%M')
puts DateTime.strptime(d2, '%-d/%-m/%y %k:%M')
#date = DateTime.strptime(d, '%-d %-m %y %:z')
puts date
puts date2