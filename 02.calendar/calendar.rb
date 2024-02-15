#!/usr/bin/env ruby

require 'optparse'
require 'date'

options = {}
opt = OptionParser.new

opt.on("-y YEAR", Integer) do |year|
    options[:year] = year
end

opt.on("-m MONTH", Integer) do |month|
    options[:month] = month
end

opt.parse!(ARGV)

year = options[:year] || Date.today.year
month = options[:month] || Date.today.month

def print_calendar(year, month)
  first_day = Date.new(year, month, 1)
  last_day = Date.new(year, month, -1)

  puts "#{month}月 #{year}".center(20)

  wdays = ["日", "月", "火", "水", "木", "金", "土"]
  puts wdays.join(" ")

  print "   " * first_day.wday

  (first_day..last_day).each do |date|
    printf("%2d ", date.day)
    if date.saturday?
      puts "\n"
    end
  end
  puts
end

print_calendar(year, month)
