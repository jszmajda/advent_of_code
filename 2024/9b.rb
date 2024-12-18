data = File.read('d9').chomp
#data = "12345"

disk_map = []
file_map = {}
free_map = []
files = []
data.chars.each_slice(2).with_index do |(length, free), id|
  puts "ID#{id}: len: #{length}, free: #{free}"
  file = { id: id, len: length.to_i }
  file_map[id] = file
  files << id
  disk_map << file
  #length.to_i.times { disk_map << id }
  if free.to_i > 0
    free_map << {pos: disk_map.length, len: free.to_i}
    #disk_map << free
    free.to_i.times { disk_map << '.' }
  end
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

p file_map
p free_map
#puts disk_map.join

def update_free_map(disk_map)
  map = []
  in_free = false
  n_free = 0
  disk_map.each_with_index do |e, i|
    if e == '.'
      in_free = true
      n_free += 1
    else
      map << {pos: i - n_free, len: n_free}
      n_free = 0
      in_free = false
    end
  end
  map
end

def show(disk_map)
  r = []
  disk_map.each do |e|
    if e == '.'
      r << e
    else
      e[:len].times { r << e[:id] }
    end
  end
  r
end

#puts "start"
#puts show(disk_map).join

files.reverse.each do |file_id|
  file = file_map[file_id]
  first_free_block = free_map.find{|f| f[:len] >= file[:len] }

  if first_free_block
    #puts "#{file_id} - found free: #{first_free_block.inspect}"

    file_index = disk_map.index(file)
    if first_free_block[:pos] < file_index

      deleted = disk_map.delete(file)
      file[:len].times do |fix|
        disk_map.insert(file_index, '.')
      end

      file[:len].times do |fix|
        disk_map.delete_at(first_free_block[:pos])
      end
      disk_map.insert(first_free_block[:pos], file)

      free_map = update_free_map(disk_map)
    end
  end
  #puts show(disk_map).join
end

checksum = 0
show(disk_map).each_with_index do |val, idx|
  next if val == '.'
  checksum += val * idx
end

puts checksum