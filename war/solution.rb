class Solver
  def self.solve stdin
    n = stdin.readline.to_i
    n.times do
      terr = stdin.readline.to_i
      # Store the territories in an array
      terrs = []
      terr.times do
        terrs << stdin.readline.to_i
      end
      # Weights is similar array for how many troops we deploy
      weights = terrs.map{0}

      # Evaluate the territory with the least amount of resources first and
      # increase from there
      terrs.each_with_index.sort_by{|i| i.first}.each do |weight, i|
        lowers = []
        # Here we check the left and right neighbors, and if it both has one and
        # said neighbor has less resources, then we need to consider the number
        # of troops placed there already.
        if i > 0 and terrs[i-1] < terrs[i]
          lowers << weights[i-1]
        end
        if i < terrs.size - 1 and terrs[i+1] < terrs[i]
          lowers << weights[i+1]
        end
        # Take the highest of our weaker neighbors and beat it by 1. If we had
        # no neighbors, then we just set ourself to 1.
        weights[i] = (lowers.max || 0) + 1
      end

      # Add up the troops for the final result
      yield weights.reduce(:+)
    end
  end
end

if __FILE__ == $0
  Solver.solve STDIN do |line|
    puts line
  end
end
