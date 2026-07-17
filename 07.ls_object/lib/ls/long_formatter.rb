# frozen_string_literal: true

module Ls
  class LongFormatter
    def initialize(file_metadata)
      @file_metadata = file_metadata
    end

    def format(max_lengths)
      [
        "#{file_mode}  ", # OSのlsコマンドとフォーマットを合わせるために2スペース出力している
        "#{links.rjust(max_lengths[:links])} ",
        "#{owner.ljust(max_lengths[:owner])}  ", # 同上
        "#{group.ljust(max_lengths[:group])}  ", # 同上
        "#{bytes.rjust(max_lengths[:bytes])} ",
        "#{last_modified_time} ",
        pathname
      ].join
    end

    def file_mode
      @file_metadata.file_mode
    end

    def owner
      @file_metadata.owner
    end

    def group
      @file_metadata.group
    end

    def links
      @file_metadata.nlink.to_s
    end

    def bytes
      @file_metadata.bytesize.to_s
    end

    def last_modified_time
      @file_metadata.mtime.strftime('%_m月 %e %H:%M')
    end

    def pathname
      basename = @file_metadata.basename
      @file_metadata.symlink? ? "#{basename} -> #{@file_metadata.readlink}" : basename
    end

    def blocks
      @file_metadata.blocks
    end

    def self.max_length(attr, file_metadata_list)
      file_metadata_list.map do |file_metadata|
        new(file_metadata).public_send(attr).length
      end.max
    end
  end
end
