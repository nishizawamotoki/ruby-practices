require_relative 'frame'

class Game
  def initialize(marks)
    @frames = []
    build_frames(marks)
  end

  def score
    result = @frames.each_with_index.sum do |frame, i|
      next_frame = @frames[i + 1]
      after_next_frame = @frames[i + 2]

      next frame.sum if i == 9

      frame.sum +
        if frame.strike? && next_frame.strike?
          10 + (i == 8 ? next_frame.second_shot : after_next_frame.first_shot) # 9フレーム目のみ10フレーム目の2投目を加算する
        elsif frame.strike?
          next_frame.first_shot + next_frame.second_shot # next_frame.sum は9フレーム目がストライクのときにおかしくなるので使えない
        elsif frame.spare?
          next_frame.first_shot
        else
          0
        end
    end
    result
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
