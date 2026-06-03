require_relative 'shot'

class Frame
  def initialize
    @shots = []
  end

  def add(pins)
    shot = Shot.new(pins)
    @shots << shot
  end

  def shot_count
    @shots.length
  end

  def first_shot
    @shots[0]
  end
  
  def second_shot
    @shots[1]
  end
  
  def strike?
    first_shot.point == 10
  end
  
  def sum
    @shots.sum { |shot| shot.point }
  end
  
  def point(next_frame, after_next_frame)
    sum +
    if strike?
      next_frame.first_shot.point + (next_frame.second_shot&.point || after_next_frame.first_shot.point)
    elsif spare?
      next_frame.first_shot.point
    else
      0
    end
  end
  
  private
  
  def spare?
    !strike? && sum == 10
  end
end
