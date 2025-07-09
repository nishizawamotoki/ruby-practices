#!/usr/bin/env ruby
# frozen_string_literal: true

COLUMN_COUNT = 3
MULTIPLES_FOR_COLUMN_WIDTH = 8 # 列幅の長さはこの定数の倍数になる

def calculate_col_width(filenames, multiples = MULTIPLES_FOR_COLUMN_WIDTH)
  longest_filename = filenames.max_by(&:length)
  (longest_filename.length / multiples + 1) * multiples
end

filenames = Dir.glob('*')
exit if filenames.empty?

max_row = filenames.length.ceildiv(COLUMN_COUNT)
col_width = calculate_col_width(filenames)

output_rows = Array.new(max_row) { '' }
filenames.each_with_index do |filename, filename_index|
  row_index = filename_index % max_row
  output_rows[row_index] = output_rows[row_index] + filename.ljust(col_width)
end

puts output_rows.join("\n")
