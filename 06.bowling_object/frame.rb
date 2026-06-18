# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = second_mark ? Shot.new(second_mark) : nil
    @third_shot = third_mark ? Shot.new(third_mark) : nil
  end

  def total_pins
    [@first_shot, @second_shot, @third_shot].sum { |shot| shot&.pins || 0 }
  end

  def point(next_frame, after_next_frame)
    total_pins +
      if strike?
        next_frame.first_shot.pins + (next_frame.second_shot&.pins || after_next_frame.first_shot.pins)
      elsif spare?
        next_frame.first_shot.pins
      else
        0
      end
  end

  private

  def strike?
    first_shot.pins == Shot::PINS_PER_FRAME
  end

  def spare?
    !strike? && total_pins == Shot::PINS_PER_FRAME
  end
end
