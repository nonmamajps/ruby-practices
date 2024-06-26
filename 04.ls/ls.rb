#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

BLANK_SIZE = 23
COL_FULL_SIZE = 3
STAT_BLANK_SIZE = 6

def check_option
  options = {}
  opt = OptionParser.new
  opt.on('-a') do |all_files|
    options[:all_files] = all_files
  end

  opt.on('-r') do |reverse_files|
    options[:reverse_files] = reverse_files
  end

  opt.on('-l') do |long_name_files|
    options[:long_name_files] = long_name_files
  end

  opt.parse!(ARGV)
  options
end

def fetch_files(all_files)
  option = all_files ? File::FNM_DOTMATCH : 0
  Dir.glob('*', option)
end

def files_to_matrix(file_list, reverse_files)
  files = reverse_files ? file_list.reverse : file_list
  sliced_files = files.each_slice(COL_FULL_SIZE).to_a
  # 配列内の要素が3つに揃うように空白を追加
  sliced_files.each do |cols|
    cols.concat([''] * (COL_FULL_SIZE - cols.size)) if cols.size < COL_FULL_SIZE
  end
  sliced_files
end

def print_file(matrix)
  # 各要素を縦に並べる
  matrix.transpose.each do |rows|
    print_file_to_display(rows)
  end
end

def print_file_to_display(files)
  max_length = files.map(&:length).max
  files.each do |file|
    print "#{file.ljust(max_length + 1)}#{' ' * (BLANK_SIZE - max_length)}"
  end
  puts
end

def file_type(stat)
  check_file_type =
    {
      'file' => '-',
      'directory' => 'd',
      'link' => 'l',
      'characterSpecial' => 'c',
      'blockSpecial' => 'b',
      'fifo' => 'f',
      'socket' => 's'
    }
  check_file_type[stat.ftype]
end

def permission(mode)
  check_permission =
    {
      0 => '---',
      1 => '--x',
      2 => '-w-',
      3 => '-wx',
      4 => 'r--',
      5 => 'r-x',
      6 => 'rw-',
      7 => 'rwx'
    }
  check_permission[mode]
end

def conversion_permission(stat)
  permissions = format('%o', stat.mode.to_i)[-3..]
  permissions.chars.map { |x| permission(x.to_i) }.join
end

def file_stat(file_list)
  file_list.map { |name| File.lstat(name) }
end

def print_of_l_option(file_list, file_stat)
  total_blocks = file_stat.sum(&:blocks)
  puts "total #{total_blocks}"
  file_list.each_with_index do |name, idx|
    stat = file_stat[idx]
    print = "#{file_type(stat)}"\
    "#{conversion_permission(stat)} "\
    "#{stat.nlink.to_s.rjust(2)} "\
    "#{Etc.getpwuid(stat.uid).name}  "\
    "#{Etc.getgrgid(stat.gid).name}"\
    "#{stat.size.to_s.rjust(STAT_BLANK_SIZE)} "\
    "#{stat.atime.mon.to_s.rjust(2)} "\
    "#{stat.atime.day.to_s.rjust(2)} "\
    "#{stat.atime.strftime('%H:%M')} "
    print += FileTest.symlink?(name) ? "#{name} -> #{File.readlink(name)}" : name
    puts print
  end
end

options = check_option
file_list = fetch_files(options[:all_files])

if options[:long_name_files]
  file_stat = file_stat(file_list)
  print_of_l_option(file_list, file_stat)
else
  matrix = files_to_matrix(file_list, options[:reverse_files])
  print_file(matrix)
end
