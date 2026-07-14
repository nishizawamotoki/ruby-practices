# frozen_string_literal: true

require 'etc'

module Ls
  class LongFormattedFile
    MAPPING_FILETYPE_TO_SYMBOL = {
      'file' => '-',
      'directory' => 'd',
      'characterSpecial' => 'c',
      'blockSpecial' => 'b',
      'fifo' => 'p',
      'link' => 'l',
      'socket' => 's',
      'unknown' => '?'
    }.freeze

    # File::Stat.mode の数値を、シンボルを用いたパーミッションに変換するためのビット値
    USER_PERMISSION_BITS = {
      read: 0o000400,
      write: 0o000200,
      execute: 0o000100
    }.freeze

    GROUP_PERMISSION_BITS = {
      read: 0o000040,
      write: 0o000020,
      execute: 0o000010
    }.freeze

    OTHER_PERMISSION_BITS = {
      read: 0o000004,
      write: 0o000002,
      execute: 0o000001
    }.freeze

    def initialize(file_metadata)
      @file_metadata = file_metadata
    end

    def file_mode
      mode = @file_metadata.stat.mode
      [
        MAPPING_FILETYPE_TO_SYMBOL[@file_metadata.stat.ftype],
        convert_to_symbolic_permission(mode, USER_PERMISSION_BITS),
        convert_to_symbolic_permission(mode, GROUP_PERMISSION_BITS),
        convert_to_symbolic_permission(mode, OTHER_PERMISSION_BITS)
      ].join
    end

    def links
      @file_metadata.stat.nlink.to_s
    end

    def owner
      Etc.getpwuid(@file_metadata.stat.uid).name
    end

    def group
      Etc.getgrgid(@file_metadata.stat.gid).name
    end

    def bytes
      @file_metadata.stat.size.to_s
    end

    def last_modified_time
      @file_metadata.stat.mtime.strftime('%_m月 %e %H:%M')
    end

    def pathname
      basename = @file_metadata.basename
      @file_metadata.stat.symlink? ? "#{basename} -> #{@file_metadata.readlink}" : basename
    end

    def blocks
      @file_metadata.stat.blocks
    end

    private

    def convert_to_symbolic_permission(mode, permission_bits)
      [
        (mode & permission_bits[:read]).zero? ? '-' : 'r',
        (mode & permission_bits[:write]).zero? ? '-' : 'w',
        (mode & permission_bits[:execute]).zero? ? '-' : 'x'
      ].join
    end
  end
end
