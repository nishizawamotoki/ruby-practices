# frozen_string_literal: true

class Shot
  PINS_PER_FRAME = 10

  def initialize(mark)
    @mark = mark
  end

  def pins
    @mark == 'X' ? PINS_PER_FRAME : @mark.to_i
  end
end
