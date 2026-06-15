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
    pins_list = marks.split(',').map { |s| s == 'X' ? 10 : s.to_i }

    frame = Frame.new
    pins_list.each do |pins|
      frame.add(pins)

      next if @frames.size == 9
      if frame.strike? || frame.shot_count == 2
        @frames << frame
        frame = Frame.new
      end
    end
    @frames << frame # 最終フレーム分
  end
end
