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

  def sum
    [@first_shot, @second_shot, @third_shot].sum(&:point)
  end

  def point(next_frame, after_next_frame)
    sum +
      if strike?
        next_frame.first_shot.point + (next_frame.second_shot.mark? ? next_frame.second_shot.point : after_next_frame.first_shot.point)
      elsif spare?
        next_frame.first_shot.point
      else
        0
      end
  end

  private

  def strike?
    first_shot.point == Game::STRIKE_POINT
  end

  def spare?
    !strike? && sum == 10
  end
end
