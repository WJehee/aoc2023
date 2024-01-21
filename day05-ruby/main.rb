f = File.open("input.txt", "r")

Thing = Struct.new(:lower, :upper, :type)

seeds = f.readline
seeds.slice!("seeds: ")
seeds = seeds
  .strip()
  .split(" ", -1)
  .map{|str| Integer(str)}
  # .map{|i| Thing.new(i, i, "seed")}
f.readline


# Solution 2
seeds = seeds
  .each_slice(2)
  .map{|x, y| Thing.new(x, x+y-1, "seed")}


def transform(thing, dst_start, src_start, range, src, dst)
  lower = thing.lower
  upper = thing.upper

  if lower >= src_start and upper <= src_start+range
    return [
      Thing.new(dst_start+lower-src_start, dst_start+upper-src_start, dst)
    ]
  elsif lower >= src_start+range
    return [
      Thing.new([lower, src_start+range].max, upper, src)
    ]
  elsif upper <= src_start
    return [
      Thing.new(lower, upper, src)
    ]
  elsif lower < src_start and upper > src_start+range
    return [
      Thing.new(lower, src_start-1, src),
      Thing.new(dst_start, dst_start+range-1, dst),
      Thing.new(src_start+range, upper, src)
    ]
  elsif upper <= src_start+range
    return [
      Thing.new(
        lower,
        [upper, src_start-1].min,
        src),
      Thing.new(
        dst_start,
        dst_start-(src_start-upper),
        dst),
    ]
  else
    return [
      Thing.new(
        dst_start+(lower-src_start),
        dst_start+range,
        dst),
      Thing.new(
        src_start+range,
        upper,
        src),
    ]
  end
end

src = ""
dst = ""
f.each_line do |line|
  if line.strip() == ""
  elsif line .include? ":"
    line.slice!(" map:")
    map = line
      .strip()
      .split("-to-", 2)
    src = map[0]
    dst = map[1]
    puts src + " to " + dst + " map"
    # Set type of each seed correctly
    seeds = seeds.map do |thing|
      Thing.new(thing.lower, thing.upper, src)
    end
  else
    (dst_start, src_start, range) = line
      .strip()
      .split(" ", -1)
      .map{|str| Integer(str)}

    seeds = seeds.map do |thing|
      if thing.type == src
        transform(thing, dst_start, src_start, range, src, dst)
      else 
        [thing]
      end
    end
    seeds = seeds.flatten()
  end
end

seeds = seeds.map do |thing|
  msg = "%d, %d, %s" % [thing.lower, thing.upper, dst]
  puts msg
  thing.lower
end

puts seeds.min

