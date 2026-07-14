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

    def initialize(file_metadata)
      @file_metadata = file_metadata
    end

    def file_mode
      file_type = MAPPING_FILETYPE_TO_SYMBOL[@file_metadata.stat.ftype]
      user_permission = convert_to_symbolic_permission(@file_metadata.stat.mode, S_IRWXU, S_IRUSR, S_IWUSR, S_IXUSR)
      group_permission = convert_to_symbolic_permission(@file_metadata.stat.mode, S_IRWXG, S_IRGRP, S_IWGRP, S_IXGRP)
      other_permission = convert_to_symbolic_permission(@file_metadata.stat.mode, S_IRWXO, S_IROTH, S_IWOTH, S_IXOTH)
      "#{file_type}#{user_permission}#{group_permission}#{other_permission} "
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

    def convert_to_symbolic_permission(mode, permission_bit_mask, read_permission_bit, write_permission_bit, execute_permission_bit)
      permission_bit = mode & permission_bit_mask
      [
        permission_bit & read_permission_bit == read_permission_bit ? 'r' : '-',
        permission_bit & write_permission_bit == write_permission_bit ? 'w' : '-',
        permission_bit & execute_permission_bit == execute_permission_bit ? 'x' : '-'
      ].join
    end
  end
end
