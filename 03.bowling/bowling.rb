#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

frames = []
tmp_frame = []
scores.each do |shot|
  tmp_frame << (shot == 'X' ? 10 : shot.to_i)

  next if frames.length == 9

  if tmp_frame[0] == 10 || tmp_frame.length == 2
    frames << [*tmp_frame]
    tmp_frame.clear
  end
end
frames << [*tmp_frame]

point = 0
frames.each_with_index do |frame, i|
  next_frame = frames[i + 1]
  frame_after_next = frames[i + 2]

  if i == 9
    point += frame.sum
    break
  end

  point +=
    if frame[0] == 10 && next_frame[0] == 10
      if i == 8
        20 + next_frame[1]
      else
        20 + frame_after_next[0]
      end
    elsif frame[0] == 10
      10 + next_frame[0] + next_frame[1]
    elsif frame.sum == 10
      10 + next_frame[0]
    else
      frame.sum
    end
end
puts point
