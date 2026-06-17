# frozen_string_literal: true

require_relative 'game'
require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def total_pins
    [@first_shot, @second_shot, @third_shot].sum(&:pins)
  end

  def point(next_frame, after_next_frame)
    total_pins +
      if strike?
        next_frame.first_shot.pins + (next_frame.second_shot.mark? ? next_frame.second_shot.pins : after_next_frame.first_shot.pins)
      elsif spare?
        next_frame.first_shot.pins
      else
        0
      end
  end

  private

  def strike?
    first_shot.pins == Game::PINS_PER_FRAME
  end

  def spare?
    !strike? && total_pins == Game::PINS_PER_FRAME
  end
end
