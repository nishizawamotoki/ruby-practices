# frozen_string_literal: true

module Ls
  class FileMetadataList
    attr_reader :file_metadata_list

    def initialize(pathname, dot_match:, reverse:)
      @file_metadata_list = build_file_metadata_list(pathname, dot_match:, reverse:)
    end

    def empty?
      @file_metadata_list.empty?
    end

    def size
      @file_metadata_list.size
    end

    def total_blocks
      @file_metadata_list.sum(&:blocks)
    end

    private

    def build_file_metadata_list(pathname, dot_match:, reverse:)
      pattern = pathname.join('*')
      flags = dot_match ? ::File::FNM_DOTMATCH : 0
      paths = reverse ? Dir.glob(pattern, flags).reverse : Dir.glob(pattern, flags)
      paths.map do |path|
        FileMetadata.new(path)
      end
    end
  end
end
