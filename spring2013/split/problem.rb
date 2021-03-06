require_relative '../../lib/problem'

module ProgComp
  class Split < Problem
    # Fancy generator for a previous problem
    # def sum_set sum, range
    #   nums = []
    #   total = 0
    #   while total < sum
    #     nums << rand(range)
    #     total += nums.last
    #   end
    #   nums[-1] -= total - sum
    #   nums
    # end

    # def generate args
    #   sets = rand(100..1000)
    #   target = rand(100..1000)
    #   nums = []
    #   sets.times do
    #     nums += sum_set(target, 1..target)
    #   end
    #   yield nums.size
    #   nums.each do |n|
    #     yield n
    #   end
    # end

    def generate args
      nums = rand(50..100)
      yield nums
      yield nums.times.map { rand(1..10) }.join("\n")
    end

    def partitions(list)
      return enum_for(:partitions, list) unless block_given?

      yield [list]
      (1...list.size).each do |i|
        partitions(list[i..-1]) do |rest|
          yield [list[0,i]] + rest
        end
      end
    end

    def brute stdin
      problems = stdin.readline.to_i

      problems.times do
        n = stdin.readline.to_i
        nums = n.times.map { stdin.readline.to_i }

        best = 0
        count = 2**(nums.length - 1)
        partitions(nums).each_with_index.map do |part, i|
          # Return number if all equal parts, or 0 otherwise
          sums = part.map{|s| s.reduce(:+)}

          best = [best, *sums.map{|s| sums.count(s)}].max
          @bruted = i.to_f / count
        end
        yield best
      end
    end

    def solve stdin
      problems = stdin.readline.to_i

      problems.times do
        n = stdin.readline.to_i
        nums = n.times.map { stdin.readline.to_i }
        max = 0
        total_size = nums.reduce(:+)
        (1..total_size).each do |target|
          # We're trying to make chunks of size target; see if it is feasible
          break if total_size / target < max

          # Start with an empty chunk and 0 count
          current = []
          chunks = 0

          # Add each block one by one
          nums.each do |i|
            current << i

            # If we overshot, shift until we are in good shape
            while current.reduce(0, :+) > target
              current.shift
            end

            # If we made a chunk, great
            if current.reduce(:+) == target
              chunks += 1
              current = []
            else
            end
          end

          # Record our result
          max = [max, chunks].max
        end

        yield max
      end
      raise "Too much file" unless stdin.eof?
    end
  end
end

if __FILE__ == $0
  ProgComp::Split.new do |p|
    p.brute(DATA) do |s|
      puts s
    end
  end
end
__END__
2
6
3
4
5
1
1
7
3
9
7
9
