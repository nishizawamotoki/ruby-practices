# frozen_string_literal: true

module Ls
  class ShortFormattedFile
    def initialize(file_metadata)
      @file_metadata = file_metadata
    end

    def name
      @file_metadata.basename
    end
  end
end
