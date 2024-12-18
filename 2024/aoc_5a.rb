def valid_job?(pages, rules)
  rules.each do |bef, aft|
    pages.each_with_index do |pg, i|
      if pg == bef
        # if aft is in pages it must be after
        return false if pages[0..i].include?(aft)
      elsif pg == aft
        # if bef is in pages it must be before
        return false if pages[i..].include?(bef)
      end
    end
  end
end

def middle_page(order)
  order[(order.length - 1) / 2]
end

rules = []
valid_orders = []
parsing_reqs = true

File.readlines('day_5_input').each do |line|
  if line == "\n"
    parsing_reqs = false
    next
  end

  if parsing_reqs
    rules << line.split('|').map(&:to_i)
  else
    pages = line.split(",").map(&:to_i)
    valid_orders << pages if valid_job?(pages, rules)
  end
end

result = 0
valid_orders.each do |order|
  result += middle_page(order)
end

puts result
