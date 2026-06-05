# frozen_string_literal: true

require_relative 'frame'
require_relative 'last_frame'

class Game
  def initialize(marks)
    @frames = []
    build_frames(marks)
  end

  def score
    @frames.each_with_index.sum do |frame, i|
      next_frame = @frames[i + 1]
      after_next_frame = @frames[i + 2]
      frame.point(next_frame, after_next_frame)
    end
  end

  private

  def build_frames(marks)
    pins_list = marks.split(',').map { |s| s == 'X' ? 10 : s.to_i }

    frame = Frame.new
    pins_list.each do |pins|
      frame.add(pins)

      if frame.finished?
        @frames << frame
        frame = next_frame
      end
    end
  end

  def next_frame
    if @frames.size == 9
      LastFrame.new
    elsif @frames.size < 9
      Frame.new
    end
  end
end
