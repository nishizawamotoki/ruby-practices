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
index = first_date.wday
(first_date..last_date).each do |date|
  calender_cells[index] = date
  index += 1
end

print " " * 6, "#{month}月 #{year}", " " * 9, "\n"
print "日 月 火 水 木 金 土  \n"
calender_cells.each_with_index do |date, i|
  if date.nil?
    print "   "
  else
    print "#{date.day}".rjust(2), " "
  end
  
  if (i + 1) % 7 == 0
    print  " \n"
  end
end
