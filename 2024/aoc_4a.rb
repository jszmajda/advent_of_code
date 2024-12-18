data = File.readlines('day_4_input')

def has_rest?(data, position, vector, remaining)
  return true if remaining.length == 0

  (row, col) = position
  (dy, dx) = vector
  target_row = row + dy
  target_col = col + dx

  # bounds check
  return false if target_row < 0 || target_col < 0 || target_row >= data.length || target_col >= data.first.length

  next_char, *rest = remaining

  if data[target_row][target_col] == next_char
    return has_rest?(data, [target_row, target_col], vector, rest)
  end

  false
end

found = 0
data.each_with_index do |row_text, row|
  row_text.each_grapheme_cluster.with_index do |char, col|
    if char == "X"
      [
        [0,1],
        [0,-1],
        [1,0],
        [1,1],
        [1,-1],
        [-1,0],
        [-1,-1],
        [-1,1]
      ].each do |vector|
        found += 1 if has_rest?(data, [row, col], vector, %w{M A S})
      end
    end
  end
end

puts found
