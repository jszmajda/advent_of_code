require 'pry'
class World
  @board = nil
  @bw = nil
  @bh = nil

  @gd_vec = nil
  @gd_pos = nil

  @stepped = []
  @has_loop = nil
  @visited_coords = nil
  @guard_start_coord = nil
  @guard_start_vec = nil
  @loop_steps = 0
  @hits = {}

  attr_reader :guard_start_coord, :board, :hits

  def vec(dir)
    case dir
    when :up
      [-1, 0]
    when :right
      [0, 1]
    when :down
      [1, 0]
    when :left
      [0, -1]
    else
      raise Exception
    end
   
  end

  def initialize(input)
    @board = input
    input.each_with_index do |line, row|
      line.each_char.with_index do |ch, col|
        if ch == "^"
          @gd_pos = [row, col, :up]
          @guard_start_coord = [row, col, :up]
        end
      end
    end
    raise "weird.. #{input}" unless @gd_pos
    @bh = input.length
    @bw = input.first.length
    @finished = false
    @stepped = []
    @has_loop = false
    @hits = Hash.new(0)
    #puts "new world"
    #puts @board
    # puts "starting: #{@gd_pos.inspect}"
  end

  def turn_right(face)
    case face
    when :up
      :right
    when :right
      :down
    when :down
      :left
    when :left
      :up
    else
      raise "WTF"
    end
  end

  def move_guard # -> new pos
    # if there's something directly in front of you, turn right 90 degrees
    # otherwise take step forward

    (row, col, face) = @gd_pos
    # puts @gd_pos.inspect
    d_vec = vec(face)
    next_row = row + d_vec[0]
    next_col = col + d_vec[1]

    if next_row >= @bh || next_row < 0 || next_col >= @bw || next_col < 0
      # out of bounds
      #puts "OOB: #{next_row} #{next_col} #{@bh} #{@bw}"
      return finish
    end

    if @board[next_row][next_col] == '#'
      # puts "hit!"
      face = turn_right(face)

      @hits[[row,col,face]] += 1
      if @hits[[row,col,face]] > 1
        puts "loop found on #{[row,col,face].inspect}"
        return has_loop
      end
      next_row = row
      next_col = col
    end




    @gd_pos = [next_row, next_col, face]
    @stepped << @gd_pos
  end

  def print
    puts @board
  end

  def finished?
    @finished
  end

  def has_loop?
    @has_loop
  end

  def run()
    while !finished?
      move_guard
    end
  end

  #def guard_visited
  #  return @visited_coords if @visited_coords
  #  @visited_coords = []
  #  @board.each_with_index do |line, row|
  #    line.each_char.with_index do |c, col|
  #      @visited_coords << [row, col] if c == "X"
  #    end
  #  end
  #  @visited_coords
  #end

  def has_loop()
    @finished = true
    @has_loop = true
    #puts "has a loop"
  end

  def finish()
    @finished = true
    #puts guard_visited.count
  end

  def show
    out = []
    @board.each_with_index do |line, row|
      l = []
      line.each_char.with_index do |ch, col|
        if @hits[[row, col, :up]] > 0
          l << '^'
        elsif @hits[[row, col, :right]] > 0
          l << '>'
        elsif @hits[[row, col, :down]] > 0
          l << 'v'
        elsif @hits[[row, col, :left]] > 0
          l << '<'
        else
          l << ch
        end
      end
      out << l.join
    end
    out.join
  end
end

looping_obstructions = []
initial = File.readlines('d6')
first_board = initial.map(&:dup)
wi = World.new(first_board)
wi.run

#wi.guard_visited.each do |(row,col)|
initial.each_with_index do |line,row|
  line.each_char.with_index do |ch, col|

  next if [row,col] == wi.guard_start_coord || ch == '#' || ch == '^'

  mod = initial.map(&:dup)
  mod[row][col] = '#'
  w = World.new(mod)
  w.run
  if w.has_loop?
    puts "has loop, #{row}, #{col}"
    #puts w.board
    #puts w.show
    looping_obstructions << [row, col]
  else
    # puts w.hits.inspect
    # puts "no loop for #{row}, #{col}, #{w.hits.keys.count} steps"
  end
  end
end

puts looping_obstructions.count
#binding.pry