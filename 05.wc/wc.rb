#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

BLANK_CELL = 8

file_name = ARGV
params = ARGV.getopts('lwc')

def main(file_name, params)
  if file_name.empty?
    standard_input
  else
    print_display(file_name, params)
  end
end

def standard_input
  input = $stdin.read
  print input.count("\n").to_s.rjust(BLANK_CELL)
  print input.split(/\s+/).size.to_s.rjust(BLANK_CELL)
  print input.bytesize.to_s.rjust(BLANK_CELL)
end

def print_display(file_name, params)
  total_lines = total_words = total_bytes = 0

  read_and_count(file_name).each do |result|
    file = result[:file]
    lines = result[:lines]
    words = result[:words]
    bytes = result[:bytes]

    if no_option(params)
      print lines.to_s.rjust(BLANK_CELL)
      print words.to_s.rjust(BLANK_CELL)
      print bytes.to_s.rjust(BLANK_CELL)
    else
      print lines.to_s.rjust(BLANK_CELL) if params['l']
      print words.to_s.rjust(BLANK_CELL) if params['w']
      print bytes.to_s.rjust(BLANK_CELL) if params['c']
    end
    puts " #{file}"

   total_lines += lines
   total_words += words
   total_bytes += bytes
  end

  print_total(total_lines, total_words, total_bytes) if file_name.size >= 2
end

def read_and_count(file_name)
  file_name.map do |file|
    sentence = File.read(file)
    lines = sentence.count("\n")
    words = sentence.split(/\s+/).size
    bytes = sentence.bytesize

    { file:file, lines:lines, words:words, bytes:bytes }
  end
end

def no_option(params)
  params['l'] == false && params['w'] == false && params['c'] == false
end

def print_total(total_lines, total_words, total_bytes)
  print total_lines.to_s.rjust(BLANK_CELL)
  print total_words.to_s.rjust(BLANK_CELL)
  print total_bytes.to_s.rjust(BLANK_CELL)
  puts ' total'
end

main(file_name,params)
