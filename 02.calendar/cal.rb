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
calendar_cells = [*Array.new(first_date.wday), *first_date..last_date]

puts "      #{month}月 #{year}         "
puts "日 月 火 水 木 金 土  "
calendar_cells.each do |date|
  print date&.day.to_s.rjust(2), " "
  
  if date&.saturday?
    puts " "
  end
end
