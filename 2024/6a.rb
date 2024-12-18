class World
  @board = nil
  @bw = nil
  @bh = nil

  @gd_vec = nil
  @gd_pos = nil

  @stepped = []

  def initialize(input)
    @board = input
    input.each_with_index do |line, row|
      line.each_char.with_index do |ch, col|
        if ch == "^"
          @gd_pos = [row, col]
          @gd_vec = [-1, 0]
        end
      end
    end
    @bh = input.length
    @bw = input.first.length
    @finished = false
    @stepped = []
  end

  def turn_right()
    case @gd_vec
    when [0, 1]
      @gd_vec = [1, 0]
    when [1, 0]
      @gd_vec = [0, -1]
    when [0, -1]
      @gd_vec = [-1, 0]
    when [-1, 0]
      @gd_vec = [0, 1]
    else
      raise "WTF"
    end
  end

  def move_guard() # -> new pos
    # if there's something directly in front of you, turn right 90 degrees
    # otherwise take step forward

    @board[@gd_pos[0]][@gd_pos[1]] = "X"

    new_row = @gd_pos[0] + @gd_vec[0]
    new_col = @gd_pos[1] + @gd_vec[1]


    if new_row > @bh || new_row < 0 || new_col > @bw || new_col < 0
      self.finish()
    end

    if @board[new_row][new_col] == "#"
      turn_right()
      new_row = @gd_pos[0] + @gd_vec[0]
      new_col = @gd_pos[1] + @gd_vec[1]
    end

    if @stepped.include?([[new_row, new_col], @gd_vec.dup])
      self.has_loop()
    end

    @gd_pos = [new_row, new_col]
    @stepped << [@gd_pos.dup, @gd_vec.dup]

  end

  def print
    puts @board
  end

  def finished?
    @finished
  end

  def has_loop()
    @finished = true
    puts "has a loop"
  end

  def finish()
    @finished = true
    spots = 0
    @board.each do |line|
      line.each_char do |c|
        spots += 1 if c == "X"
      end
    end
    puts spots
  end
end

w = World.new(File.readlines('d6'))
while !w.finished? do
  w.move_guard
  #w.print
end