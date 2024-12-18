
def is_safe?(levels, dampened = false)
  #puts levels.inspect
  return true if levels.empty?
  mode = nil
  (levels.length - 1).times.each do |i|
    last = levels[i]
    cur = levels[i + 1]

    delta = cur - last
    #puts "delta is #{delta} from #{cur} - #{last}"
    if mode.nil?
      if delta > 0
        mode = :increasing
      else
        mode = :decreasing
      end
    end
    #puts "mode is #{mode}"

    if (mode == :increasing && (delta < 1 || delta > 3)) || (mode == :decreasing && (delta > -1 || delta < -3))
      if !dampened
        # try every removal
        levels.length.times do |di|
          dampened = levels.dup
          dampened.delete_at(di)
          result = is_safe?(dampened, true)
          return true if result
        end
      end

      return false
    end
  end

  #puts "safe"

  true
end

safe_reports = 0
File.readlines('day_2_input').each do |line|
  inp = line.split
  levels = inp.map(&:to_i)
  safe_reports +=1 if is_safe?(levels)
end

puts safe_reports