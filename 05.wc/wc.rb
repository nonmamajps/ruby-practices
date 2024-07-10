#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

file_name = ARGV
params = ARGV.getopts('lwc')


def no_option(params)
  params["l"] == false && params["w"] == false && params["c"] == false
end

total_lines = 0
total_words = 0
total_bytes = 0

file_name.each do |file|
  sentence = File.read(file)
  lines = sentence.count("\n")
  words = sentence.split(/\s+/).size
  bytes = sentence.bytesize

  if no_option(params)
    print line_count = lines.to_s.rjust(8)
    print words_count = words.to_s.rjust(8)
    print byte_count = bytes.to_s.rjust(8)
    puts " #{file}"
  else
  print line_count = lines.to_s.rjust(8) if params["l"]
  print words_count = words.to_s.rjust(8) if params["w"]
  print byte_count = bytes.to_s.rjust(8) if params["c"]
  puts " #{file}"
  end

  total_lines += lines
  total_words += words
  total_bytes+= bytes

end

if file_name.size >= 2
  print total_lines.to_s.rjust(8)
  print total_words.to_s.rjust(8)
  print total_bytes.to_s.rjust(8)
  puts " total"
end

if file_name.empty?
  input = $stdin.read
  line_count = input.count("\n").to_s.rjust(8)
  words_count = input.split(/\s+/).size.to_s.rjust(8)
  byte_size = input.bytesize.to_s.rjust(8)

  print line_count
  print words_count
  print byte_size
end
