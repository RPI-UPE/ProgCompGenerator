require_relative '../../lib/problem'

module ProgComp
  class Talent < Problem
    def generate args
      depth = 3..5
      breadth = 1..3
      value = 5..10

      talents = {}
      talents[1] = [0, 0]

      count = 1
      gen = lambda do |root, level|
        return if rand(depth) < level

        rand(breadth).times do
          count += 1
          talents[count] = [root, level * rand(value)]

          gen.call(count, level + 1)
        end
      end

      gen.call(1, 0)

      talents.each do |id, data|
        yield "%d %d %d" % [id, *data]
      end
    end

    def brute stdin
    end

    class Talent
      attr_accessor :picked
      def initialize req, value
        @req = req
        @value = value
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
          pick << talents.sort_by{|id,t| -t.effective_value}.first.first
          talents[pick.last].pick
        end

        yield pick.join ' '
      end
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
