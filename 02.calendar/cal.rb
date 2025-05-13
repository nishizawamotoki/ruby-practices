#!/usr/bin/env ruby
require 'date'
require 'optparse'

params = ARGV.getopts("y:m:")
if !params["y"].nil? && !(1..9999).include?(params["y"].to_i)
  puts "年は1~9999の中で指定してください" 
  exit
end
if !params["m"].nil? && !(1..12).include?(params["m"].to_i)
  puts "月は1~12の中で指定してください"
  exit
end

year = params["y"] ? params["y"].to_i : Date.today.year
month = params["m"] ? params["m"].to_i : Date.today.month

first_date = Date.new(year, month, 1)
last_date = Date.new(year, month, -1)

calender_cells = Array.new(42)
case first_date.cwday
when 1
  cell_of_first_day = 1
when 2
  cell_of_first_day = 2
when 3
  cell_of_first_day = 3
when 4
  cell_of_first_day = 4
when 5
  cell_of_first_day = 5
when 6
  cell_of_first_day = 6
when 7
  cell_of_first_day = 0
end
index = cell_of_first_day
(1..last_date.day).each do |day|
  calender_cells[index] = day
  index += 1
end

print " " * 6, "#{month}月 #{year}", " " * 9, "\n"
print "日 月 火 水 木 金 土  \n"
calender_cells.each_with_index do |day, i|
  if day.nil?
    print "   "
  else
    print "#{day}".rjust(2), " "
  end
  
  if (i + 1) % 7 == 0
    print  " \n"
  end
end
