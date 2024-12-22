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

def blink_stones(stones, times_rem)
  return stones.count if times_rem < 1
  final_sum = 0
  stones.each do |stone|
    r = blink_one(stone)
    num = blink_stones(Array(r), times_rem - 1)
    final_sum += num
  end
  final_sum
end

def blink_lr(l, r, times_rem)
  if times_rem < 1
    if r
      return 2
    else
      return 1
    end
  end
  sum = 0
  bl = Array(blink_one(l))
  br = Array(blink_one(r)) if r

  numl = blink_lr(bl[0], bl[1], times_rem - 1)
  numr = blink_lr(br[0], br[1], times_rem - 1) if r

  numl + numr.to_i
end

t0 = Time.now.to_f
result = blink_stones(stones, 30)
puts result
t1 = Time.now.to_f
puts t1 - t0

t0 = Time.now.to_f
fsum = 0
stones.each_slice(2) { |l,r| fsum += blink_lr(l, r, 30) }
puts fsum
t1 = Time.now.to_f
puts t1 - t0



