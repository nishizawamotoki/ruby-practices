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
    @shots[0].pins
  end
  
  def second_shot
    @shots[1].pins
  end

  def strike?
    first_shot == 10
  end

  def spare?
    first_shot != 10 && sum == 10
  end

  def sum
    @shots.sum { |shot| shot.pins }
  end
end
