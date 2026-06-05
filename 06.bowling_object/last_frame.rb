# frozen_string_literal: true

class LastFrame < Frame
  def finished?
    (!strike? && !spare? && shot_count == 2) || shot_count == 3
  end

  def point(_next_frame, _after_next_frame)
    sum
  end
end
