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

#def repair_job(pages, rules)
#  # for each before, take the offending page and put it immediately before the pivot
#  # same with after
#  rules.each do |(bef, aft)|
#    bix = pages.index(bef)  # 1
#    aix = pages.index(aft)  # 0
#    if bix && aix && bix > aix
#                               # 75,97,47,61,53
#      v = pages.delete_at(aix) # 97,47,61,53
#      pages.insert(bix, v)
#    end
#  end
#  pages
#end

def repair_job(pages, rules)
  relevant_rules = []
  rules.each do |(bef, aft)|
    if pages.include?(bef) && pages.include?(aft)
      relevant_rules << [bef, aft]
    end
  end
  pages.sort do |a, b|
    outcomes = []
    relevant_rules.each do |(bef, aft)|
      if a == bef && b == aft
        outcomes << -1
      elsif b == bef && a == aft
        outcomes << 1
      end
    end
    if outcomes.any?
      outcomes.first
    else
      0
    end
  end
end

def middle_page(order)
  order[(order.length - 1) / 2]
end

rules = []
valid_orders = []
invalid_orders = []
must_be_after = {}
must_be_before = {}
parsing_reqs = true

File.readlines('day_5_input').each do |line|
#File.readlines('d5t').each do |line|
  if line == "\n"
    parsing_reqs = false
    next
  end

  if parsing_reqs
    rule = line.split('|').map(&:to_i)
    must_be_before[rule[0]] ||= []
    must_be_before[rule[0]] << rule[1]
    must_be_after[rule[1]] ||= []
    must_be_after[rule[1]] << rule[0]

    rules << rule
  else
    pages = line.split(",").map(&:to_i)
    if valid_job?(pages, rules)
      valid_orders << pages 
    else
      invalid_orders << pages
    end
  end
end

result = 0
invalid_orders.each do |order|
  repaired = repair_job(order.dup, rules)
  puts "#{order.inspect} -> #{repaired.inspect}"
  result += middle_page(repaired)
end

puts result
