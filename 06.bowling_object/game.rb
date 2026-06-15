# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(marks)
    @frames = []
    build_frames(marks)
  end

  def score
    @frames.each_with_index.sum do |frame, i|
      next_frame = @frames[i + 1]
      after_next_frame = @frames[i + 2]
      i == 9 ? frame.sum : frame.point(next_frame, after_next_frame)
    end
  end

  private

  def build_frames(marks)
    frame = Frame.new
    marks.split(',').each do |mark|
      frame.add(mark)

      next if @frames.size == 9
      if frame.strike? || frame.shot_count == 2
        @frames << frame
        frame = Frame.new
      end
    end
    @frames << frame # 最終フレーム分
  end
end
