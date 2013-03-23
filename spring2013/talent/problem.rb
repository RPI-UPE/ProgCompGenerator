require_relative '../../lib/problem'

module ProgComp
  class Talent < Problem
    def generate args
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

        p talents.values.map(&:effective_value)

        pick = []
        max.times do
          pick << talents.sort_by{|id,t| -t.effective_value}.first.first
          talents[pick.last].pick
        end

        puts pick.join ' '
      end
    end
  end
end

if __FILE__ == $0
  ProgComp::Talent.new do |p|
    p.solve(DATA)
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
