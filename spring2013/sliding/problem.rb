require_relative '../../lib/problem'

module ProgComp
  class Sliding < Problem
    def generate *a
    end

    class Point
      attr_accessor :x, :y

      def initialize x, y
        @x, @y = x.to_i, y.to_i
      end

      def == other
        @x == other.x && @y == other.y
      end

      def + other
        Point.new @x + other.x, @y + other.y
      end

      def - other
        Point.new @x - other.x, @y - other.y
      end

      def * other
        other = Point.new(*other) unless other.respond_to? :x
        Point.new @x * other.x, @y * other.y
      end

      def sign
        x = @x / @x.abs unless @x == 0
        y = @y / @y.abs unless @y == 0
        Point.new x || @x, y || @y
      end

      def manhattan_dist_to other
        (@x - other.x).abs + (@y - other.y).abs
      end

      def to_s
        "(#{ @x }, #{ @y })"
      end
    end

    def brute stdin
      # Brute force is like solve, but try both paths in recursion
      problems = stdin.readline.to_i

      problems.times.map do
        # Width/height unecessary?
        stdin.readline
        red = Point.new(*stdin.readline.split(' '))
        empty = Point.new(*stdin.readline.split(' '))
        target = Point.new(*stdin.readline.split(' '))

        moves = 0
        single_move = lambda do |red, empty|
          return 0 if red == target
          direction = (target - red).sign

          # Pick whichever is easy to get to
          best = []
          unless direction.x == 0
            move = red + direction * [1, 0]
            best << empty.manhattan_dist_to(move) + single_move.call(move, red) + 1
          end
          unless direction.y == 0
            move = red + direction * [0, 1]
            best << empty.manhattan_dist_to(move) + single_move.call(move, red) + 1
          end

          return best.min
        end

        single_move.call(red, empty)
      end
    end

    def solve stdin
      problems = stdin.readline.to_i

      problems.times.map do
        # Width/height unecessary?
        stdin.readline
        red = Point.new(*stdin.readline.split(' '))
        empty = Point.new(*stdin.readline.split(' '))
        target = Point.new(*stdin.readline.split(' '))

        moves = 0
        until red == target
          direction = (target - red).sign

          # Pick whichever is easy to get to
          x_move = empty.manhattan_dist_to(red + direction * [1, 0])
          y_move = empty.manhattan_dist_to(red + direction * [0, 1])

          if (x_move < y_move && direction.x != 0) || direction.y == 0
            empty = red
            red = red + direction * [1, 0]
            moves += x_move + 1
          else
            empty = red
            red = red + direction * [0, 1]
            moves += y_move + 1
          end
        end

        moves
      end
    end
  end
end

if __FILE__ == $0
  ProgComp::Sliding.new do |p|
    # p.solve(DATA)
    # p.brute(DATA)
    
    # Exhaust all possible 3x3 and 4x4 grids (odd and even dims)
    # Ugly, but I wanted to be explicit to make sure I didn't miss anything.
    # Might rewrite later.
    # require 'stringio'
    # parts = ["1\n"]
    # [[3,3], [4,4], [3,4], [2,2], [5,5], [2,3], [1,5]].each do |dimx, dimy|
    #   count = 0
    #   print "%d,%d" % [dimx, dimy]
    #   parts << "%d %d\n" % [dimx, dimy]
    #   (0...dimx).each do |rx|
    #     parts << "%d " % rx
    #     (0...dimy).each do |ry|
    #       parts << "%d\n" % ry
    #       (0...dimx).each do |ex|
    #         parts << "%d " % ex
    #         (0...dimy).each do |ey|
    #           next if ex == rx && ey == ry
    #           parts << "%d\n" % ey
    #           (dimx-1).downto(0).each do |tx|
    #             parts << "%d " % tx
    #             (dimy-1).downto(0).each do |ty|
    #               parts << "%d\n" % ty

    #               solve = p.solve(StringIO.new(parts.join))
    #               brute = p.brute(StringIO.new(parts.join))
    #               count += 1

    #               if brute != solve
    #                 puts parts.join, brute, solve
    #                 exit
    #               end
    #               print '.'
    #               parts.pop
    #             end
    #             parts.pop
    #           end
    #           parts.pop
    #         end
    #         parts.pop
    #       end
    #       parts.pop
    #     end
    #     parts.pop
    #   end
    #   parts.pop
    #   puts count
    # end
  end
  puts
end
__END__
1
3 3
0 0
1 1
1 1
1
3 3
0 0
0 1
2 2
