#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLUMN_WIDTH = 8

def main
  params = ARGV.getopts('lwc')
  display_settings = build_display_settings(params)

  file_statistics =
    if ARGV.empty?
      [collect_statistic($stdin.read)]
    else
      ARGV.map do |file_path|
        collect_statistic(File.open(file_path).read, file_path)
      end
    end

  file_statistics.each do |statistic|
    puts format_output_row(statistic, display_settings)
  end

  return if file_statistics.size < 2

  total_statistic = calculate_total_statistic(file_statistics)
  puts format_output_row(total_statistic, display_settings, is_total: true)
end

def build_display_settings(params)
  settings = {}
  if !params['l'] && !params['w'] && !params['c']
    settings[:lines] = true
    settings[:words] = true
    settings[:bytes] = true
  else
    settings[:lines] = params['l']
    settings[:words] = params['w']
    settings[:bytes] = params['c']
  end
  settings
end

def collect_statistic(text, file_path = nil)
  {
    lines: text.count("\n"),
    words: text.split(/\s+/).size,
    bytes: text.bytesize,
    file_path: file_path
  }
end

def format_output_row(statistic, display_settings, is_total: false)
  row = ''
  row += display_settings[:lines] ? statistic[:lines].to_s.rjust(COLUMN_WIDTH) : ''
  row += display_settings[:words] ? statistic[:words].to_s.rjust(COLUMN_WIDTH) : ''
  row += display_settings[:bytes] ? statistic[:bytes].to_s.rjust(COLUMN_WIDTH) : ''
  row +=
    if is_total
      ' total'
    else
      statistic[:file_path] ? " #{statistic[:file_path]}" : ''
    end
  row
end

def calculate_total_statistic(statistics)
  {
    lines: statistics.sum { |statistic| statistic[:lines] },
    words: statistics.sum { |statistic| statistic[:words] },
    bytes: statistics.sum { |statistic| statistic[:bytes] }
  }
end

main
