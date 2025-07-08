#!/usr/bin/env ruby
# frozen_string_literal: true

COLUMN_COUNT = 3
MULTIPLES_FOR_COLUMN_WIDTH = 8 # 列幅の長さはこの定数の倍数になる

def calculate_max_rows(filenames, column_count = COLUMN_COUNT)
  filenames.length.ceildiv(column_count)
end

def calculate_col_width(filenames, multiples = MULTIPLES_FOR_COLUMN_WIDTH)
  longest_filename = filenames.max_by(&:length)
  (longest_filename.length / multiples + 1) * multiples
end

filenames = Dir.glob('*')
exit if filenames.empty?

max_row = calculate_max_rows(filenames)
col_width = calculate_col_width(filenames)

output_rows = Array.new(max_row) { '' }
row_index = 0
filenames.each do |filename|
  output_rows[row_index] = output_rows[row_index] + filename.ljust(col_width)
  if row_index == (max_row - 1)
    row_index = 0
  else
    row_index += 1
  end
end

puts output_rows.join("\n")
