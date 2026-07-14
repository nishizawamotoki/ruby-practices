# frozen_string_literal: true

module Ls
  class Command
    COLUMN_COUNT = 3
    MULTIPLES_FOR_DISPLAY_WIDTH = 8

    def initialize(pathname, dot_match: false, reverse: false, long: false)
      @list = FormattedFileList.new(pathname, dot_match:, reverse:, long:)
      @long = long
    end

    def run
      @long ? long_layout : short_layout
    end

    private

    def short_layout
      return '' if @list.empty?

      display_width = MULTIPLES_FOR_DISPLAY_WIDTH * (@list.max_name_length.div(MULTIPLES_FOR_DISPLAY_WIDTH) + 1)
      to_rectangular_matrix(@list.formatted_files, @list.size.ceildiv(COLUMN_COUNT)).transpose.reduce('') do |result, file_list|
        row = file_list.reduce('') do |result, file|
          result + (file&.name&.ljust(display_width) || '')
        end
        "#{result}#{row}\n"
      end
    end

    def to_rectangular_matrix(arr, column_count)
      arr.each_slice(column_count).map { |row| row.values_at(0...column_count) }
    end

    def long_layout
      header = "total #{@list.total_blocks}\n"
      detail = @list.formatted_files.reduce('') do |result, file|
        row = [
          "#{file.file_mode}  ", # OSのlsコマンドとフォーマットを合わせるために2スペース出力している
          "#{file.links.rjust(@list.max_links_length)} ",
          "#{file.owner.ljust(@list.max_owner_length)}  ", # 同上
          "#{file.group.ljust(@list.max_group_length)}  ", # 同上
          "#{file.bytes.rjust(@list.max_bytes_length)} ",
          "#{file.last_modified_time} ",
          file.pathname
        ].join
        "#{result}#{row}\n"
      end
      header + detail
    end
  end
end
