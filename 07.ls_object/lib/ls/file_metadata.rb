# frozen_string_literal: true

require 'etc'

module Ls
  class FileMetadata
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

    def initialize(path)
      @path = path
      @stat = ::File.lstat(path)
    end

    def file_mode
      mode = @stat.mode
      [
        MAPPING_FILETYPE_TO_SYMBOL[@stat.ftype],
        convert_to_symbolic_permission(mode, USER_PERMISSION_BITS),
        convert_to_symbolic_permission(mode, GROUP_PERMISSION_BITS),
        convert_to_symbolic_permission(mode, OTHER_PERMISSION_BITS)
      ].join
    end

    def nlink
      @stat.nlink
    end

    def owner
      Etc.getpwuid(@stat.uid).name
    end

    def group
      Etc.getgrgid(@stat.gid).name
    end

    def bytesize
      @stat.size
    end

    def mtime
      @stat.mtime
    end

    def blocks
      @stat.blocks
    end

    def symlink?
      @stat.symlink?
    end

    def readlink
      ::File.readlink(@path)
    end

    def basename
      ::File.basename(@path)
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
