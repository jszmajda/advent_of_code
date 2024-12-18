# part one

left = []
right = []

ARGF.each do |line|
  inp = line.split
  left << inp[0].to_i
  right << inp[1].to_i
end

fmap_right = right.inject(Hash.new(0)) { |h, v| h[v] += 1 ; h }

result = 0
left.each do |l|
  freq = fmap_right[l]
  result += l * freq
end

puts "Final #{result}"
