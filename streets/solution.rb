require 'set'

class Integer
  # Return 1 if > 0, -1 if < 0, and 0 if == 0
  def sign
    return 0 if self == 0
    self / self.abs
  end
end

class Solver
  def self.solve stdin
    n = stdin.readline.to_i
    n.times do |iter|
      # Parse vars
      width, height = stdin.readline.strip.split(' ').map(&:to_i)
      sx, sy, tx, ty = stdin.readline.strip.split(' ').map(&:to_i)
      # Set up street intersections as hash map of x, y coords
      grid = Hash.new {|hash, key| hash[key] = Hash.new(-1)}
      obstructions = Set.new
      # Set initial point as distance of 1
      grid[sx][sy] = 1

      # Read in obstructions to lookup hash
      obs = stdin.readline.to_i
      obs.times do
        loc = stdin.readline.strip.split(' ').map(&:to_i)
        # Store as both o_start, o_end and vice-versa for easier lookup
        obstructions << loc
        obstructions << loc[2..3] + loc[0..1]
      end

      # Compute direction of search
      dx = (sx - tx).sign
      dy = (sy - ty).sign

      # Throw these in a method
      # This was written before I made the solver static class for the Rakefile
      # framework, so it looks really shitty. I will make sure this is better
      # organized for next time.
      count = Solver.new(grid, width, height, obstructions, dx, dy).lookup(tx, ty)
      raise "Uh oh, count is too high on #{ iter }: #{ count }" if count > 2**64
      yield count
    end
  end

  def initialize grid, width, height, obs, dx, dy
    @grid = grid
    @obs = obs
    @dx = dx
    @dy = dy
    @width = width
    @height = height
  end
  
  def lookup tx, ty
    return 0 if tx < 0 or ty < 0 or tx > @width or ty > @height
    unless @grid[tx][ty] >= 0
      # First time looking up this coordinate; we want to look up its two adjacent neighbors
      x = if @obs.include? [tx, ty, tx+@dx, ty] or @dx == 0 then 0 else self.lookup(tx + @dx, ty) end
      y = if @obs.include? [tx, ty, tx, ty+@dy] or @dy == 0 then 0 else self.lookup(tx, ty + @dy) end
      # However many paths could be taken to either of them combined is how many
      # paths could have been taken to get here
      @grid[tx][ty] = x + y
    end

    return @grid[tx][ty]
  end

  # A visualization function for debugging
  def inspect sx, sy, tx, ty
    grid = (@height+2).times.map{ (@width+2).times.map{'-'} }
    grid[sy][sx] = 'S'
    grid[ty][tx] = 'T'
    grid.each_with_index do |row, i|
      row.each_with_index do |node, j|
        if i == sy and j == sx
          print "S"
        elsif i == ty and j == tx
          print "T"
        else
          print "+"
        end
        if @obs[[j, i, j+1, i]]
          print " x "
        else
          print "---" 
        end
      end
      puts
      row.each_with_index do |node, j|
        if @obs[[j, i, j, i+1]]
          print "x"
        else
          print "|" 
        end
        print "   "
      end
      puts
    end
  end
end

if __FILE__ == $0
  Solver.solve STDIN do |line|
    puts line
  end
end
