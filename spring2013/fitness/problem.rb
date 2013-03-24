require_relative '../../lib/problem'

# Note: the wording was changed on this one after the solution was written, so
# the variable names might be confusing

module ProgComp
  class Fitness < Problem
    def generate args
      depth = 3..6
      breadth = 2..3
      value = 50..10000

      talents = {}
      talents[1] = [0, 0]

      count = 1
      leaf = 0
      gen = lambda do |root, level|
        if rand(depth) < level
          leaf += 1
          return
        end

        rand(breadth).times do
          count += 1
          talents[count] = [root, rand(value)]

          gen.call(count, level + 1)
        end
      end

      gen.call(1, 1)

      yield "%d %d" % [talents.size, rand(3..leaf/2)]
      talents.each do |id, data|
        yield "%d %d %d" % [id, *data]
      end
    end

    def brute stdin
    end

    class Talent
      attr_accessor :picked, :ultimate
      def initialize req, value
        @req = req
        @value = value
        @ultimate = true
        @req.ultimate = false if @req
      end

      def effective_value
        if @picked
          0
        elsif @req
          @value + @req.effective_value
        else
          @value
        end
      end

      def pick
        @picked = true
        @req.pick if @req
      end
    end

    def solve stdin
      problems = stdin.readline.to_i

      problems.times do
        ct, max = stdin.readline.split(' ').map(&:to_i)

        talents = {}
        ct.times do
          id, req, value = stdin.readline.split(' ').map(&:to_i)
          talents[id] = Talent.new talents[req], value
        end

        pick = []
        max.times do
          contending_values = talents.select{|id, t|t.ultimate && !t.picked}.sort_by{|id,t| -t.effective_value}

          if contending_values.first(2).map {|id, t| t.effective_value}.reduce(:==)
            # Can't tie
            raise GenerationError, "Ambiguous value after #{pick.length}/#{max} with #{contending_values.length} ultimates"
          end

          pick << contending_values.first.first
          talents[pick.last].pick
        end

        yield pick.sort.join ' '
      end
      raise "Too much file" unless stdin.eof?
    end
  end
end

if __FILE__ == $0
  ProgComp::Talent.new do |p|
    p.solve(DATA) do |s|
      puts s
    end
  end
end
__END__
1
7 2
1 0 0
2 1 10
3 1 10
4 2 30
5 2 25
6 3 20
7 3 20
