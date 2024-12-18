result = 0
File.readlines('day_3_input').each do |line|
  line.scan(/mul\((\d+),(\d+)\)/) do |(ls,rs)| 
    l = ls.to_i
    r = rs.to_i

    result += l * r
  end
end
puts result