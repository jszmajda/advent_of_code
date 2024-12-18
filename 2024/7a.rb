class Node
  attr_accessor :val, :children
  def initialize(val)
    @val = val
    @children = []
  end
end

#def reduce(path)
#  puts "? #{path.inspect}"
#  # combine combines first
#  new_path = [path.first]
#  (2...path.length).step(2).each do |i|
#    op = path[i - 1]
#    rhs = path[i]
#    if op == :combine
#      lhs = new_path.pop
#      new_path << "#{lhs}#{rhs}".to_i
#    else
#      new_path << op
#      new_path << rhs
#    end

#  end
#  puts ". #{new_path.inspect}"
#  (carry, *rest) = new_path
#  rest.each_slice(2) do |(op, num)|
#    carry = carry.send(op, num)
#  end
#  carry
#end

def reduce(path)
  (carry, *rest) = path
  rest.each_slice(2) do |(op, num)|
    if op == :combine
      carry = "#{carry}#{num}".to_i
    else
      carry = carry.send(op, num)
    end
  end
  carry
end

def dfs_test(node, search, carry=0, path=[])
  return nil if node.nil?
  #puts "#{node.val}, #{node.children.length}"
  node.children.each do |op|
    op.children.each do |child|

      next_path = path + [op.val, child.val]
      if child.children.count == 0

        trial = reduce(next_path)

        #puts "? #{next_path.inspect}"
        #puts "search: #{search}; carry: #{carry} trial: #{trial}; try: #{op.val} #{child.val}; rest: #{child.children.count}"
        return next_path if trial == search
      end

      result = dfs_test(child, search, trial, next_path)
      return result if result
    end
  end
  nil
end

def build_tree(root, nums, ops)
  return if nums.empty?
  (num, *rest) = nums
  root.children = ops.map do |op|
    op_node = Node.new(op)
    num_node = Node.new(num)
    op_node.children = [num_node]
    build_tree(num_node, rest, ops)
    op_node
  end
end

def determine_ops(test_value, numbers)
  puts "#{test_value}: #{numbers.join(" ")}"
  return nil if numbers.empty?
  ops = [:+, :*, :combine]
  #ops = [:+, :*]
  #ops = [:+ ]

  root = Node.new(numbers.shift)
  build_tree(root, numbers, ops)

  #puts root.inspect
  path = dfs_test(root, test_value, root.val, [root.val])
  if path
    puts path.inspect
    #puts test_value
    test_value
  else
    nil
  end
end

sum = 0
File.readlines('d7').each do |line|
  (l,r) = line.split(':')
  test_value = l.to_i
  #next unless test_value == 7290
  numbers = r.split.map(&:to_i)
  result = determine_ops(test_value, numbers)
  if result
    sum += result
  end
end
puts sum