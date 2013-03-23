require_relative '../../lib/problem'
require 'set'

module ProgComp
  class Travel < Problem
    PLACES = %w{Albuquerque Arlington Atlanta Austin Bakersfield Baltimore Boston Charlotte Chicago Cleveland Columbus Dallas Denver Detroit Fresno Houston Indianapolis Jacksonville Louisville Memphis Mesa Miami Milwaukee Minneapolis Nashville Oakland Omaha Philadelphia Phoenix Portland Raleigh Sacramento Seattle Tucson Tulsa Washington Wichita}
    METHODS = %w{bus plane taxi train}

    def key a, b, method
      "%s %s %s" % [a, b, method]
    end

    def generate args
      places = rand(4..8)
      paths = places ** 2 + rand(1..places)
      cities = PLACES.sample(places)
      yield "%d" % paths

      existing = Set.new

      paths.times do
        while true
          source = cities.sample
          dest = cities.sample
          next if source == dest
          method = METHODS.sample

          edge = key source, dest, method
          next if existing.include? edge
          existing << edge

          yield "%s %d" % [edge, rand(100..1000)]
          break
        end
      end

      # Now do the routes
      name = -> key, other=nil { key.split(' ').first(2).select {|i| i != other }.first }

      start = name.call(existing.to_a.sample)
      hops = rand(3..10)
      yield "%d %s" % [hops, start]
      hops.times do
        key = existing.grep(/#{ start }/).sample
        start = name.call(key, start)
        method = key.split(' ')[2]

        yield method
      end
    end

    def brute stdin
    end

    class Destination
      attr_accessor :loc, :cost
      def initialize loc, cost
        @loc = loc
        @cost = cost
      end

      def + cost
        @cost += cost
        self
      end

      def to_s
        @loc
      end
    end

    def solve stdin
      problems = stdin.readline.to_i

      problems.times do
        edges = stdin.readline.to_i
        tree = proc { Hash.new { |h, k| h[k] = tree.call } }
        map = tree.call

        edges.times do
          a, b, method, len = stdin.readline.split(' ')
          map[a][method.to_sym][b] = len.to_i
        end

        h, start = stdin.readline.split(' ')
        hops = h.to_i.times.map { stdin.readline.strip.to_sym }
        # Iterate through list
        find_loc = lambda do |from, left|
          now, *rest = left

          return [Destination.new(from, 0)] unless now
          map[from][now].map do |loc, len|
            find_loc.call(loc, rest).map {|dest| dest+len}
          end.flatten
        end

        yield find_loc.call(start, hops).sort_by {|dest| -dest.cost}.first
      end
    end
  end
end

if __FILE__ == $0
  ProgComp::Travel.new do |p|
    p.solve(DATA) do |s|
      puts s
    end
  end
end
__END__
1
4 4
Phoenix NYC plane 400
Phoenix Miami plane 300
Miami NYC bus 200
NYC Redmond train 800
3 Phoenix
plane
bus
train
