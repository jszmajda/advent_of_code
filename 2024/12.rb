require 'pry'
require 'pp'
data = File.readlines('d12').map(&:chomp)

# returns the delta (truthy) or nil (falsy)
def adjacent_to(p1, p2)
  (r,c) = p1
  # 2
  # 1   1   21   12
  #     2
  dt = [[-1, 0],
   [1,  0],
   [0, -1],
   [0,  1]].find do |(dr, dc)|
     p2[0] == r + dr && p2[1] == c + dc
   end
end

# does g1 enclose g2?
#def group_contained_in_group(g1, g2)
#  return false if g1 == g2
#  # t, l, b, and r of g1 are more than t, l, b, r of g2
#  g1_top = g1.keys.min {|a,b| a[0] <=> b[0] }[0]
#  g1_bot = g1.keys.max {|a,b| a[0] <=> b[0] }[0]
#  g1_lef = g1.keys.min {|a,b| a[1] <=> b[1] }[1]
#  g1_rig = g1.keys.max {|a,b| a[1] <=> b[1] }[1]

#  g2_top = g2.keys.min {|a,b| a[0] <=> b[0] }[0]
#  g2_bot = g2.keys.max {|a,b| a[0] <=> b[0] }[0]
#  g2_lef = g2.keys.min {|a,b| a[1] <=> b[1] }[1]
#  g2_rig = g2.keys.max {|a,b| a[1] <=> b[1] }[1]
#  # puts "T: #{g1.inspect} #{g1_top} v #{g2_top} #{g2.inspect}"
#  # puts "R: #{g1_rig} v #{g2_rig}"
#  # puts "B: #{g1_bot} v #{g2_bot}"
#  # puts "L: #{g1_lef} v #{g2_lef}"

#  g1_top < g2_top && g1_bot > g2_bot && g1_lef < g2_lef && g1_rig > g2_rig
#end

def group_contained_in_group(g1, g2, max_wid, max_hei)
  # all points of g2, when projected out in each direction encounter a point from g1
  g2.keys.all? do |(r, c)|
    [[-1, 0],
     [ 1, 0],
     [0, -1],
     [0,  1]].all? do |vec|
       encountered_g1 = false
       ptr = [r,c]
       loop do
         ptr = pa(ptr, vec)
         break if ptr[0] < 0 || ptr[1] < 0 || ptr[0] >= max_hei || ptr[1] >= max_wid
         if g1[ptr]
           encountered_g1 = true
           break
         end
       end
       encountered_g1
     end
  end
end

def add_to_group(groups, pos, type)
  groups[type] ||= []
  #puts "pos: #{pos.inspect}" if type == "I"
  matched_group = groups[type].find do |group|
    adj = group.keys.find{|p| adjacent_to(p, pos) }
    #puts "adj: #{adj.inspect}" if type == "I"
    adj
  end

  groups[type].delete(matched_group)
  matched_group ||= {} # if no match
  #puts "matched #{matched_group.keys.length}" if type == "I"

  matched_group[pos] = 1
  groups[type] << matched_group
end

def coalesce_groups(groups)
  groups.each do |type, type_groups|
    next if type_groups.length < 2
    #puts "checking #{type}..."
    type_groups.each do |g|
      #puts "    checking #{g.inspect}"
      (type_groups - [g]).each do |og|
        if g.keys.find { |g_p| og.keys.find { |og_p| adjacent_to(g_p, og_p) } }
          #puts "        adjacent: #{og.inspect}"
          g.merge!(og)
        else
          #puts "        not adjacent: #{og.inspect}"
        end
      end
    end
    type_groups.uniq!
  end
end

def area_of(group)
  group.keys.length
end

def turn_left(face)
  case face
  when :up
    :left
  when :left
    :down
  when :down
    :right
  when :right
    :up
  end
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

def pa(pos, vec)
  [pos[0] + vec[0], pos[1] + vec[1]]
end


def perimeter_length(group)
  # walk boundary
  fst = group.keys.min {|a,b| a[0] + a[1] <=> b[0] + b[1] }
  #puts "fst is #{fst.inspect}"
  search_d = :up
  search_v = vec(search_d)
  ptr = fst.clone
  steps = 0
  loop do
    test_ptr = pa(ptr, search_v)
    #puts "+ step: #{search_d} @ #{ptr.inspect}"
    steps += 1

    left_dir = turn_left(search_d)
    left_vec = vec(left_dir)

    if group[pa(ptr, left_vec)] # try left
      #puts "- step: #{ptr} have left! #{left_dir}"
      search_d = left_dir
      search_v = left_vec
      steps -= 1
      ptr = pa(ptr, left_vec)
    elsif group[test_ptr] # in set
      #puts "in set #{test_ptr.inspect}"
      ptr = test_ptr
    else
      search_d = turn_right(search_d)
      #puts "turn right: #{search_d}"
      search_v = vec(search_d)
    end
    break if ptr == fst && search_d == :up
  end

  #puts "found #{steps} steps"

  steps
end

groups = {}
data.each_with_index do |line, row|
  line.chars.each_with_index do |ch, col|
    add_to_group(groups, [row, col], ch)
  end
end
max_height = data.length
max_width = data.first.length
#binding.pry
coalesce_groups(groups)

puts perimeter_length(groups['C'].first)
#exit


pp groups
total_cost = 0
groups.each do |(type, type_groups)|
  type_groups.each do |g|
    area = area_of(g)
    per = perimeter_length(g)
    #puts "per_0: #{per}"
    #binding.pry
    groups.values.flatten.each do |other_group|
      if group_contained_in_group(g, other_group, max_width, max_height)
        puts "group contained in group!\ng: #{g.inspect}\nog: #{other_group.inspect}"
        per += perimeter_length(other_group)
      end
    end
    puts "#{type}: #{area} * #{per}"
    total_cost += area * per
  end
end


#pp groups
puts total_cost
