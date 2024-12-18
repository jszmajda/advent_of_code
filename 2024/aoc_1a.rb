# part one

left = []
right = []

ARGF.each do |line|
  inp = line.split
  left << inp[0].to_i
  right << inp[1].to_i
end

final = 0
left.sort.zip(right.sort).each do |(l, r)|
  final += (l - r).abs
end

puts "final is #{final}"