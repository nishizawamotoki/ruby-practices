# frozen_string_literal: true

module Ls
  class Command
    COLUMN_COUNT = 3
    MULTIPLES_FOR_DISPLAY_WIDTH = 8

    def initialize(pathname, dot_match: false, reverse: false, long: false)
      @list = FileMetadataList.new(pathname, dot_match:, reverse:)
      @long = long
    end

    def run
      @long ? long_layout : short_layout
    end

    private

    def short_layout
      return '' if @list.empty?

      max_basename_length = @list.file_metadata_list.map { |f| f.basename.length }.max
      display_width = MULTIPLES_FOR_DISPLAY_WIDTH * (max_basename_length.div(MULTIPLES_FOR_DISPLAY_WIDTH) + 1)
      to_rectangular_matrix(@list.file_metadata_list, @list.size.ceildiv(COLUMN_COUNT)).transpose.reduce('') do |result, file_metadata_list|
        row = file_metadata_list.reduce('') do |result, file_metadata|
          result + (file_metadata&.basename&.ljust(display_width) || '')
        end
        "#{result}#{row}\n"
      end
    end

    def to_rectangular_matrix(arr, column_count)
      arr.each_slice(column_count).map { |row| row.values_at(0...column_count) }
    end

    def long_layout
      formatters = @list.file_metadata_list.map { |file_metadata| LongFormatter.new(file_metadata) }
      max_lengths = {
        links: formatters.map { |formatter| formatter.links.length }.max,
        owner: formatters.map { |formatter| formatter.owner.length }.max,
        group: formatters.map { |formatter| formatter.group.length }.max,
        bytes: formatters.map { |formatter| formatter.bytes.length }.max
      }

      header = "total #{@list.total_blocks}\n"
      detail = formatters.reduce('') do |result, formatter|
        row = formatter.format(max_lengths)
        "#{result}#{row}\n"
      end
      header + detail
    end
  end
end
