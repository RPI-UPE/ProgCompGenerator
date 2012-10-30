# Random size of grid dimension
SIZE = 50..100

class Generator
  def self.generate iterations, opts = {}
    yield iterations unless opts[:without_leader]
    iterations.times do
      width = rand(SIZE)
      height = rand(SIZE)

      # Make sure source and destination aren't the same
      begin
        # Limit so that they aren't on the edge for sake of obstructions
        sx = rand(1...width-1)
        sy = rand(1...height-1)
        tx = rand(1...width-1)
        ty = rand(1...height-1)
      end while sx == tx and sy == ty

      yield "#{width} #{height}"
      yield "#{sx} #{sy} #{tx} #{ty}"

      # Number of obstructions depends on area of S-T rectangle
      # This randomness is kind of lazy. There are quite a few 0s and a _chance_
      # that the solution will overflow a 64-bit integer. But this minimizes
      # those chances greatly.
      obstructions = ((sx - tx) * (sy - ty)).abs * 0.80
      obstructions += (rand(2)*2 - 1) * obstructions * rand() * 0.15
      obstructions = obstructions.round

      yield obstructions
      obstructions.times do
        # Pick starting point within source and destination rectangle
        ox = rand(Range.new(*[sx, tx].sort))
        oy = rand(Range.new(*[sy, ty].sort))
        # Pick random axis and direction
        rxy = rand(2)
        rdir = rand(2)*2 - 1
        yield "#{ox} #{oy} #{ox + rxy*rdir} #{oy + (1-rxy)*rdir}"
      end
    end
  end
end

if __FILE__ == $0
  Generator.generate((ARGV[0] || 1).to_i) do |line|
    puts line
  end
end
