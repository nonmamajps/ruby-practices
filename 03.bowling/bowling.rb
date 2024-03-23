#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []

scores.each do |s|
  if s == 'X' # ストライク
    shots << 10 # 1投目
    shots << 0 # 2投目
  else
    shots << s.to_i # 整数に変換
  end
end

frames = shots.each_slice(2).to_a

# ストライクとスペア加算
point = frames[0..9].each_with_index.sum do |frame, idx|
  if frame[0] == 10 # strike # [10, 0]この状態のこと
    if frames[idx + 0][0] == 10 && frames[idx + 1][0] == 10 # 今回と次の投球がストライクだった場合
      frame.sum +
        frames[idx + 1][0] + # 次の投球の1本目
        frames[idx + 2][0] # 次の次の投球の1本目
    else
      frame.sum +
        frames[idx + 1].sum # 次の投球の合計
    end

  elsif frame.sum == 10 # spare
    frames[idx + 1][0] + 10
  else
    frame.sum
  end
end

puts point
