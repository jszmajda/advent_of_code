test = "125 17"
puzzle_input = "6563348 67 395 0 6 4425 89567 739318"

puzzle = puzzle_input

stones = puzzle.split.map(&:to_i)

def blink_one(stone)
  return nil unless stone
  if stone == 0
    1
  elsif (chs = stone.to_s.chars).length % 2 == 0
    half = chs.length / 2
    fst = chs[0...half].join
    snd = chs[half..].join
    [fst.to_i, snd.to_i]
  else
    stone * 2024
  end
end

tl = Time.now.to_f
tn = tl
75.times do |i|
  tn = Time.now.to_f
  puts "#{i}: #{stones.length} #{tn - tl}"
  stones = stones.map{|s| blink_one(s) }.flatten
  # next_stones = []
  # stones.each_slice(8) do |(s1,s2,s3,s4,s5,s6,s7,s8)|
  #   t1 = Thread.new { s1 = blink_one(s1) } if s1
  #   t2 = Thread.new { s2 = blink_one(s2) } if s2
  #   t3 = Thread.new { s3 = blink_one(s3) } if s3
  #   t4 = Thread.new { s4 = blink_one(s4) } if s4
  #   t5 = Thread.new { s5 = blink_one(s5) } if s5
  #   t6 = Thread.new { s6 = blink_one(s6) } if s6
  #   t7 = Thread.new { s7 = blink_one(s7) } if s7
  #   t8 = Thread.new { s8 = blink_one(s8) } if s8
  #   [t1,t2,t3,t4,t5,t6,t7,t8].compact.map(&:join)
  #   next_stones += [s1,s2,s3,s4,s5,s6,s7,s8].flatten.compact
  # end
  # stones = next_stones.flatten
  tl = tn
  #puts stones.join(" ")
  #stones = stones.map{|s| blink_one(s) }.flatten
end

#puts stones.join(" ")
puts stones.flatten.length


