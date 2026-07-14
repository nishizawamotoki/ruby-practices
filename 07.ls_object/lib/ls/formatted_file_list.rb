# frozen_string_literal: true

module Ls
  class FormattedFileList
    attr_reader :formatted_files

    def initialize(pathname, dot_match:, reverse:, long:)
      @formatted_files = build_formatted_files(pathname, dot_match:, reverse:, long:)
    end

    def empty?
      @formatted_files.empty?
    end

    def size
      @formatted_files.size
    end

    def total_blocks
      @formatted_files.sum(&:blocks)
    end

    def max_name_length
      max_length(:name)
    end

    def max_links_length
      max_length(:links)
    end

    def max_owner_length
      max_length(:owner)
    end

    def max_group_length
      max_length(:group)
    end

    def max_bytes_length
      max_length(:bytes)
    end

    private

    def build_formatted_files(pathname, dot_match:, reverse:, long:)
      pattern = pathname.join('*')
      flags = dot_match ? ::File::FNM_DOTMATCH : 0
      paths = reverse ? Dir.glob(pattern, flags).reverse : Dir.glob(pattern, flags)
      paths.map do |path|
        file_metadata = FileMetadata.new(path)
        long ? LongFormattedFile.new(file_metadata) : ShortFormattedFile.new(file_metadata)
      end
    end

    def max_length(attr)
      @formatted_files.map { |f| f.public_send(attr).length }.max
    end
  end
end
