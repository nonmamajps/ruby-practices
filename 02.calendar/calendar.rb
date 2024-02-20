#!/usr/bin/env ruby
# Dateクラス取り込む
require 'date'

# opt取り込む
require 'optparse'
opt = OptionParser.new

#ハッシュに格納
params = {}

#opt.on('-m') {|m| params[:month] = m } #これと18行目のmonthは違うもの（do...endにしてみる）
opt.on('-m MONTH', Integer) do |m|
  params[:month] = m
end
opt.on('-y YEAR', Integer) do |y|
  params[:year] = y
end

opt.parse!(ARGV)

today = Date.today
year = params[:year] || Date.today.year 
month = params[:month] || Date.today.month 


# 今月の最初の日
first_day = Date.new(year, month, 1)
# 今月の最後の日
last_day = Date.new(year, month,-1)

# m月yを表示させる
puts "#{month}月 #{year}".center(20)

# 曜日を日本語で横並びにする
puts "日 月 火 水 木 金 土"

#　月初を合わせる（わからん）
print "   " * first_day.wday

#　日付を並べる
(first_day..last_day).each do |date|
    
  # 1桁の数字は右つめにする
  print date.day.to_s.rjust(2) + " "
  # 数字を土曜日で折り返しにする
  if date.saturday?
    puts "\n"
  end
end
