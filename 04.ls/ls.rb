#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN_COUNT = 3
MULTIPLES_FOR_COLUMN_WIDTH = 8 # 列幅の長さはこの定数の倍数になる

MAPPING_FILETYPE_TO_SYMBOL = {
  'file' => '-',
  'directory' => 'd',
  'characterSpecial' => 'c',
  'blockSpecial' => 'b',
  'fifo' => 'p',
  'link' => 'l',
  'socket' => 's',
  'unknown' => 'w'
}.freeze

# File::Stat.mode の数値を、シンボルを用いたパーミッションに変換するためのビット値
S_IRWXU = 0o000700
S_IRUSR = 0o000400
S_IWUSR = 0o000200
S_IXUSR = 0o000100

S_IRWXG = 0o000070
S_IRGRP = 0o000040
S_IWGRP = 0o000020
S_IXGRP = 0o000010

S_IRWXO = 0o000007
S_IROTH = 0o000004
S_IWOTH = 0o000002
S_IXOTH = 0o000001

def calculate_col_width(filenames, multiples = MULTIPLES_FOR_COLUMN_WIDTH)
  longest_filename = filenames.max_by(&:length)
  (longest_filename.length / multiples + 1) * multiples
end

def generate_output_rows(filenames, max_row, col_width)
  output_rows = Array.new(max_row) { '' }
  filenames.each_with_index do |filename, filename_index|
    row_index = filename_index % max_row
    output_rows[row_index] = output_rows[row_index] + filename.ljust(col_width)
  end
  output_rows
end

def convert_to_symbolic_permission(mode, permission_bit_mask, read_permission_bit, write_permission_bit, execute_permission_bit)
  symbolic_permission = '---'
  permission_bit = mode & permission_bit_mask
  (permission_bit & read_permission_bit == read_permission_bit) && symbolic_permission = "r#{symbolic_permission[1..]}"
  (permission_bit & write_permission_bit == write_permission_bit) && symbolic_permission = "#{symbolic_permission[0]}w#{symbolic_permission[2]}"
  (permission_bit & execute_permission_bit == execute_permission_bit) && symbolic_permission = "#{symbolic_permission[..1]}x"
  symbolic_permission
end

def convert_to_symbolic_file_mode(file_stat)
  file_type = MAPPING_FILETYPE_TO_SYMBOL[file_stat.ftype]
  user_permission = convert_to_symbolic_permission(file_stat.mode, S_IRWXU, S_IRUSR, S_IWUSR, S_IXUSR)
  group_permission = convert_to_symbolic_permission(file_stat.mode, S_IRWXG, S_IRGRP, S_IWGRP, S_IXGRP)
  other_permission = convert_to_symbolic_permission(file_stat.mode, S_IRWXO, S_IROTH, S_IWOTH, S_IXOTH)
  "#{file_type}#{user_permission}#{group_permission}#{other_permission} "
end

def calculate_max_width(file_details, attr)
  file_details.max_by { |detail| detail[attr].length }[attr].length
end

params = ARGV.getopts('l')
filenames = Dir.glob('*')
if filenames.empty?
  params['l'] && (puts 'total 0')
  exit
end

if !params['l']
  max_row = filenames.length.ceildiv(COLUMN_COUNT)
  col_width = calculate_col_width(filenames)
  puts generate_output_rows(filenames, max_row, col_width).join("\n")
  exit
end

file_details = filenames.map do |filename|
  fs = File.lstat(filename)
  {
    file_mode: convert_to_symbolic_file_mode(fs),
    links: fs.nlink.to_s,
    owner_name: Etc.getpwuid(fs.uid).name,
    group_name: Etc.getgrgid(fs.gid).name,
    bytes: fs.size.to_s,
    last_modified_time: fs.mtime.strftime('%_m %d %H:%M'),
    pathname: fs.symlink? ? "#{filename} -> #{File.readlink(filename)}" : filename,
    blocks: fs.blocks
  }
end
total_blocks = file_details.sum { |detail| detail[:blocks] }

max_width = {
  links: calculate_max_width(file_details, :links),
  owner_name: calculate_max_width(file_details, :owner_name),
  group_name: calculate_max_width(file_details, :group_name),
  bytes: calculate_max_width(file_details, :bytes)
}

puts "total #{total_blocks}"
file_details.each do |detail|
  print "#{detail[:file_mode]} ",
        "#{detail[:links].rjust(max_width[:links])} ",
        "#{detail[:owner_name].ljust(max_width[:owner_name])}  ", # OSのlsコマンドとフォーマットを合わせるために2スペース出力している
        "#{detail[:group_name].ljust(max_width[:group_name])}  ", # OSのlsコマンドとフォーマットを合わせるために2スペース出力している
        "#{detail[:bytes].rjust(max_width[:bytes])} ",
        "#{detail[:last_modified_time]} ",
        "#{detail[:pathname]}\n"
end
