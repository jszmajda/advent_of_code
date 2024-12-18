data = File.read('d9').chomp
#data = "12345"

disk_map = []
data.chars.each_slice(2).with_index do |(length, free), id|
  puts "ID#{id}: len: #{length}, free: #{free}"
  length.to_i.times { disk_map << id }
  free.to_i.times { disk_map << '.' }
end

def more_defrag?(disk)
  seen_free = false
  disk.each_with_index do |ch, i|
    if ch == '.'
      seen_free = true
    elsif seen_free
      return true
    end
  end
  false
end

while more_defrag?(disk_map)
  last_block_idx = disk_map.rindex {|e| e != '.' }
  last_block = disk_map[last_block_idx]
  first_free = disk_map.index('.')
  disk_map[first_free] = last_block
  disk_map[last_block_idx] = '.'
  #puts disk_map.join
end

#puts disk_map.join

checksum = 0
disk_map.each_with_index do |val, idx|
  break if val == '.'
  checksum += val * idx
end

puts checksum