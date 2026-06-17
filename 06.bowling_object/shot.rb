# frozen_string_literal: true

require_relative 'game'

class Shot
  def initialize(mark)
    @mark = mark
  end

  def pins
    @mark == 'X' ? Game::PINS_PER_FRAME : @mark.to_i
  end
end
