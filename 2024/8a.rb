board = File.readlines('d8').map(&:chomp)

antennas = {}
board.each_with_index do |line, row|
  line.each_char.with_index do |ch, col|
    if ch =~ /[a-zA-Z0-9]/
      antennas[ch] ||= []
      antennas[ch] << [row, col]
    end
  end
end

antinodes = []
antennas.each do |ant, locs|
  antinodes_start = antinodes.count
  locs.permutation(2).each do |fst, snd|
    #puts "#{fst.inspect}, #{snd.inspect}"
    dr = snd[0] - fst[0]
    dc = snd[1] - fst[1]
    row = snd[0] + dr
    col = snd[1] + dc
    while row >= 0 && row < board.length && col >= 0 && col < board.first.length
      antinodes << [row, col]
      if board[row][col] == "."
        board[row][col] = "#"
      end
      row = row + dr
      col = col + dc
    end

    if antinodes.count > antinodes_start
      # generated antinodes
      antinodes << fst
      antinodes << snd
    end
  end
end

puts board
puts antinodes.uniq.length