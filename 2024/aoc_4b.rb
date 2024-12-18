data = File.readlines('day_4_input')

def out?(coord, height, width)
  (row, col) = coord
  row < 0 || col < 0 || row >= height || col >= width
end

def at(coord, data)
  data[coord[0]][coord[1]]
end

def is_x_mas?(data, a_position)
  # 4 corners around A. valid if both opposite corners are M and S
  # c1 . c2
  # .  A .
  # c3 . c4

  h = data.length
  w = data.first.length
  (row, col) = a_position

  c1 = [row - 1, col - 1]
  c2 = [row - 1, col + 1]
  c3 = [row + 1, col - 1]
  c4 = [row + 1, col + 1]

  return false if out?(c1, h, w) || out?(c2, h, w) || out?(c3, h, w) || out?(c4, h, w)

  cross_1 = (at(c1, data) == "M" && at(c4, data) == "S") || (at(c4, data) == "M" && at(c1, data) == "S")
  cross_2 = (at(c2, data) == "M" && at(c3, data) == "S") || (at(c3, data) == "M" && at(c2, data) == "S")

  cross_1 && cross_2
end


found = 0
data.each_with_index do |row_text, row|
  row_text.each_grapheme_cluster.with_index do |char, col|
    if char == "A"
      found += 1 if is_x_mas?(data, [row, col])
    end
  end
end

puts found
