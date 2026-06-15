# frozen_string_literal: true

require_relative 'game'

class Shot
  def initialize(mark)
    @mark = mark
  end

  def mark?
    !!@mark
  end

  def point
    @mark == 'X' ? Game::STRIKE_POINT : @mark.to_i
  end
end
