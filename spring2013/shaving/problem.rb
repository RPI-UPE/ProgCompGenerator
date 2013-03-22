require '../lib/problem'

class Shaving < Problem
  def brute stdin
  end

  def solve stdin
    problems = stdin.readline.to_i

    problems.times do
      n, m, obs = stdin.readline.split(' ').map(&:to_i)
      obligations = Hash.new(0)
      obs.times do
        day, c = stdin.readline.split(' ').map(&:to_i)
        obligations[day-1] += c
      end

      # Calculating the value
      # unhappiness = Array.new(n+1){ Array.new(n+1) { 0 }}
      # (n-1).downto(0).each do |i|
      #   # Small optimization: can never have more than i days growth
      #   i.downto(0).each do |j|
      #     unhappiness[i][j] = [
      #       unhappiness[i+1][1] + m * [0, 7 - j].max, # Shaved
      #       unhappiness[i+1][j+1] + obligations[i] * j # Did not shave
      #     ].min
      #   end
      # end
      # puts unhappiness[0][0]

      # Calculating the sequence
      unhappiness = Array.new(n+1){ Array.new(n+1) { nil }}
      shave_days = []
      shave = lambda do |day, growth|
        unless unhappiness[day][growth]
          # Base case
          return (unhappiness[day][growth] = 0) if day == n

          # Pick the higher
          to_shave = shave.call(day+1, 1) + m * [0, 7 - growth].max
          not_to_shave = shave.call(day+1, growth+1) + obligations[day] * growth

          if to_shave < not_to_shave or day == 0
            shave_days << day + 1
          end
          unhappiness[day][growth] = [to_shave, not_to_shave].min
        end

        return unhappiness[day][growth]
      end

      shave.call(0, 0)
      puts shave_days.sort.uniq.join ' '
    end
  end
end

if __FILE__ == $0
  Shaving.new do |p|
    p.solve(DATA)
  end
end
__END__
2
6 5 2
2 15
5 5
3 4 2
2 25
3 100