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

point = frames.each_with_index.sum do |frame, i|
  next_frame = frames[i + 1]
  frame_after_next = frames[i + 2]

  next frame.sum if i == 9

  frame.sum +
    if frame[0] == 10 && next_frame[0] == 10
      10 + (i == 8 ? next_frame[1] : frame_after_next[0])
    elsif frame[0] == 10
      next_frame[0] + next_frame[1]
    elsif frame.sum == 10
      next_frame[0]
    else
      0
    end
end
puts point
