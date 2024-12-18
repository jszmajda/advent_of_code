data = File.readlines('d10').map(&:chomp)

class Map
  attr_accessor :board, :trailheads, :found
  def initialize(board)
    @board = board.map do |line|
      line.chars.map do |char|
        if char == '.'
          -1
        else
          char.to_i
        end
      end
    end
    @width = @board.first.length
    @height = @board.length
    init_trailheads
  end

  def init_trailheads
    @trailheads = []
    @board.each_with_index do |line, row|
      line.each_with_index do |num, col|
        @trailheads << [row, col] if num == 0
      end
    end
  end

  def neighbors(pos)
    [
      [pos[0] - 1, pos[1]],
      [pos[0] + 1, pos[1]],
      [pos[0], pos[1] - 1],
      [pos[0], pos[1] + 1],
    ].reject {|(r,c)| r < 0 || c < 0 || r >= @height || c >= @width }
      .map {|(r,c)| [[r,c], board[r][c]] }
  end

  def trace_trail(pos, pos_val, path, found)
    next_path = path + [[pos, pos_val]]
    if pos_val == 9
      found << next_path
      return
    end
    path_opts = neighbors(pos).select { |(row, col), val| val == pos_val + 1 }
    return nil if path_opts.empty?

    #puts "from #{pos} (#{pos_val}), investigating #{path_opts}"

    path_opts.each do |opt, val|
      trace_trail(opt, val, next_path, found)
    end
    found
  end

  def build_trails
    @found = []
    trailheads.each do |pos|
      trace_trail(pos, 0, [], @found)
    end
    @found.each do |path|
      p path
    end
  end

  def unique_9s
    @found.map {|p| [p.first, p.last] }.uniq
  end
end

# trails always start from 0 and monotonically increase to 9
# trails are always orthogonal

m = Map.new(data)
m.build_trails
puts m.found.count