result = 0
exec = true
input = []
File.readlines('day_3_input').each do |line|
  input << line
end

line = input.join('')

line.scan(/(mul\((\d+),(\d+)\)|do\(\)|don't\(\))/) do |instruction, ls, rs|
  puts "#{instruction.inspect}, exec: #{exec}"
  if instruction =~ /mul/
    if exec
      l = ls.to_i
      r = rs.to_i

      result += l * r
    end
  elsif instruction =~ /don't/
    exec = false
  else # do
    exec = true
  end
end
puts result