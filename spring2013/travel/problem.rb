require_relative '../../lib/problem'
require 'set'

module ProgComp
  class Travel < Problem
    # PLACES = %w{Albuquerque Arlington Atlanta Austin Bakersfield Baltimore Boston Charlotte Chicago Cleveland Columbus Dallas Denver Detroit Fresno Houston Indianapolis Jacksonville Louisville Memphis Mesa Miami Milwaukee Minneapolis Nashville Oakland Omaha Philadelphia Phoenix Portland Raleigh Sacramento Seattle Tucson Tulsa Washington Wichita}
    PLACES = 26.times.map {|i| (65+i).chr}
    METHODS = %w{bus plane taxi train}

    def key a, b, method
      "%s %s %s" % [a, b, method]
    end

    def generate args
      places = rand(8..10)
      paths = places ** 2 / 2 + rand(1..places)
      cities = PLACES.sample(places)
      yield "%d" % paths

      existing = Set.new

      paths.times do
        while true
          source = cities.sample
          dest = cities.sample
          next if source == dest
          method = METHODS.sample

          # No double edges
          next if [source, dest, method].reduce(existing){|acc,s| acc.grep(/#{s}/)}.length > 0

          edge = key source, dest, method
          existing << edge

          yield "%s %d" % [edge, rand(100..10000)]
          break
        end
      end

      # Now do the routes
      name = -> key, other=nil { key.split(' ').first(2).select {|i| i != other }.first }

      start = name.call(existing.to_a.sample)
      hops = rand(20..40)
      yield "%s %d" % [start, hops]
      hops.times do
        key = existing.grep(/#{ start }/).sample
        start = name.call(key, start)
        method = key.split(' ')[2]

        yield method
      end
    end

    def brute stdin
      problems = stdin.readline.to_i

      problems.times do
        edges = stdin.readline.to_i
        tree = proc { Hash.new { |h, k| h[k] = tree.call } }
        map = tree.call

        edges.times do
          a, b, method, len = stdin.readline.split(' ')
          map[a][method.to_sym][b] = len.to_i
          map[b][method.to_sym][a] = len.to_i
        end

        start, h = stdin.readline.split(' ')
        hops = h.to_i.times.map { stdin.readline.strip.to_sym }
        # Iterate through list
        find_loc = lambda do |from, left|
          now, *rest = left

          return [Destination.new(from, 0)] unless now
          map[from][now].map do |loc, len|
            find_loc.call(loc, rest).map {|dest| dest+len}
          end.flatten
        end

        solutions = find_loc.call(start, hops).sort_by {|dest| -dest.cost}
        raise GenerationError, "Ambiguous solution: #{ solutions.first.cost }" if solutions.length > 1 && solutions[0].cost == solutions[1].cost
        yield solutions.first
      end
      raise "Too much file" unless stdin.eof?
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

      def hash
        @loc
      end

      def eql? other
        other.loc == @loc
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
          map[b][method.to_sym][a] = len.to_i
        end

        start, h = stdin.readline.split(' ')
        hops = h.to_i.times.map { stdin.readline.strip.to_sym }
        # Iterate through list
        loc = {}
        loc[start] = 0

        while hops.length > 0
          now = hops.shift

          temp = {}
          loc.each do |dest, cost|
            map[dest][now].each do |step, len|
              temp[step] = [(temp[step] or 0), cost+len].max
            end
          end
          loc = temp
        end

        solutions = loc.sort_by {|dest, cost| -cost}
        if solutions.length > 1 && solutions[0].first != solutions[1].first && solutions[0].last == solutions[1].last
          raise GenerationError, "Ambiguous solution: #{ solutions.first.last }" 
        end
        yield solutions.first.first
      end
      raise "Too much file" unless stdin.eof?
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
2
4
Phoenix NYC plane 400
Phoenix Miami plane 300
Miami NYC bus 200
NYC Redmond train 800
Phoenix 3
plane
bus
train
2
Alburquerque Washington plane 200
Omaha Washington taxi 100
Omaha 5
taxi
plane
plane
taxi
taxi
