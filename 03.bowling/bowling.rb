#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0] # 引数を受け取る"6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8" #
scores = score.split(',')# 受け取った引数を1投ずつに,を入れる
shots = []# 数字に変換（配列に入れる）

scores.each do |s|
  if s == 'X' # ストライク
    shots << 10 # 1投目
    shots << 0 # 2投目 
  else
    shots << s.to_i # 整数に変換
  end
end

frames = []# フレーム毎に分割
shots.each_slice(2) do |s|
  frames << s
end

# ストライクとスペア加算
point = 0
frames[0..8].each_with_index do |frame, idx| 
  # 最後のフレームの投球結果を3つに分割し、フレーム毎の配列に追加
  if frame[0] == 10 # strike # [10, 0]この状態のこと
    if frames[idx + 0][0] == 10 && frames[idx + 1][0] == 10 # 今回と次の投球がストライクだった場合
            point += frame.sum + 
            frames[idx + 1][0] +  # 次の投球の1本目
            frames[idx + 2][0] # 次の次の投球の1本目
    else
      point += frame.sum + 
      frames[idx + 1][0] + # 次の投球の1本目
      frames[idx + 1][1] # 次の投球の2本目
    end

    elsif frame.sum == 10 # spare 
      point += frames[idx + 1][0] + 10
    else
      point += frame.sum
  end
end

# 最後のフレーム
last_frame = frames[9]
if last_frame[0] == 10 || last_frame.sum == 10
  if last_frame[0] == 10 && frames[10][0] == 10
  point += frames[9][0] + frames[10][0] + frames[11][0]
  else
    point += last_frame.sum + frames[10].sum
  end
else
  point += last_frame.sum
end

puts point
