# frozen_string_literal: true

module Ls
  class FileMetadata
    attr_reader :stat

    def initialize(path)
      @path = path
      @stat = ::File.lstat(path)
    end

    def basename
      ::File.basename(@path)
    end

    def readlink
      ::File.readlink(@path)
    end
  end
end
