
def is_safe?(levels)
  #puts levels.inspect
  return true if levels.empty?
  mode = nil
  levels.each_cons(2) do |(last, cur)|
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

    if mode == :increasing && (delta < 1 || delta > 3)
      return false
    elsif mode == :decreasing && (delta > -1 || delta < -3)
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