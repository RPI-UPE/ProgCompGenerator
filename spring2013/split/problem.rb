require_relative '../../lib/problem'

module ProgComp
  class Split < Problem
    def sum_set sum, range
      nums = []
      total = 0
      while total < sum
        nums << rand(range)
        total += nums.last
      end
      nums[-1] -= total - sum
      nums
    end

    def generate args
      sets = rand(1..10)
      target = rand(10..100)
      nums = []
      sets.times do
        nums += sum_set(target, 1..target)
      end
      yield nums.size
      nums.each do |n|
        yield n
      end
    end

    def brute stdin
    end

    def solve stdin
      problems = stdin.readline.to_i

      problems.times do
        n = stdin.readline.to_i
        nums = n.times.map { stdin.readline.to_i }
        (0...nums.length).each do |i|
          # Check the first chunk
          sum = nums[0..i].reduce(:+)
          # Test the remaining
          current = 0
          groups = 1
          nums[i+1..-1].each do |j|
            current += j
            if current > sum
              break
            elsif current == sum
              current = 0
              groups += 1
            end
          end and begin
            puts groups
            break
          end
          # else, next i
        end
      end
    end
  end
end

if __FILE__ == $0
  ProgComp::Split.new do |p|
    p.solve(DATA)
  end
end
__END__
2
5
1
3
2
1
5
3
9
7
14
