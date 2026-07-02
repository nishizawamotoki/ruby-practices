# frozen_string_literal: true

module Ls
  class List
    attr_reader :files

    def initialize(pathname, dot_match:, reverse:)
      @files = build_files(pathname, dot_match:, reverse:)
    end

    def empty?
      @files.empty?
    end

    def size
      @files.size
    end

    def total_blocks
      @files.sum(&:blocks)
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

    def build_files(pathname, dot_match:, reverse:)
      pattern = pathname.join('*')
      flags = dot_match ? ::File::FNM_DOTMATCH : 0
      paths = reverse ? Dir.glob(pattern, flags).reverse : Dir.glob(pattern, flags)
      paths.map { |path| Ls::File.new(path) }
    end

    def max_length(attr)
      @files.map { |f| f.public_send(attr).length }.max
    end
  end
end
