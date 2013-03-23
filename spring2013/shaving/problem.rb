require_relative '../../lib/problem'

module ProgComp
  class Shaving < Problem

    def generate args
      days = rand(10..100)
      obs = days * 5 / 6 + rand(1..10)
      const = rand(1000..3000)
      #  require 'prime'
      # const = Prime.take(20)[10..-1].sample

      yield "%d %d %d" % [days, const, obs]
      obs.times.map { [rand(2..days), rand(100..const)] }.sort_by(&:first).each do |d, h|
        yield "%d %d" % [d, h]
      end
    end

    def brute stdin
    end

    def greedy stdin
      problems = stdin.readline.to_i

      problems.times do
        n, m, obs = stdin.readline.split(' ').map(&:to_i)
        obligations = Hash.new(0)
        obs.times do
          day, c = stdin.readline.split(' ').map(&:to_i)
          obligations[day-1] += c
        end

        last = 0
        shaves = []
        unhappiness = 0
        n.times do |day|
          # puts [day, (day - last)*obligations[day]].join ' '
          if day == 0 or (day - last)*obligations[day] > m
            shaves << day + 1
            last = day
            unhappiness += m
          else
            unhappiness += (day - last)*obligations[day]
          end
        end
        yield [unhappiness, '|', *shaves].join ' '
      end
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
        shave_days = Array.new(n+1){ Array.new(n+1) { nil }}
        shave = lambda do |day, growth|
          unless unhappiness[day][growth]
            # Base case
            return (unhappiness[day][growth] = 0) if day == n

            # Pick the higher
            to_shave = shave.call(day+1, 1) + m
            not_to_shave = shave.call(day+1, growth+1) + obligations[day] * growth

            raise GenerationError, "Ambiguous solution #{ to_shave }" if to_shave == not_to_shave
            if to_shave < not_to_shave or day == 0
              # Shave
              shave_days[day][growth] = [day + 1] + (shave_days[day+1][1] or [])
            else
              shave_days[day][growth] = shave_days[day+1][growth+1]
            end
            unhappiness[day][growth] = [to_shave, not_to_shave].min
          end

          return unhappiness[day][growth]
        end

        shave.call(0, 0)
        if __FILE__ == $0
          yield [unhappiness[0][0]+m, '|', *shave_days[0][0].sort.uniq].join ' ' # Comparison to greedy
        else
          yield shave_days[0][0].sort.uniq.join ' ' # Actual solution
        end
      end
      raise "Too much file" unless stdin.eof?
    end
  end
end

if __FILE__ == $0
  ProgComp::Shaving.new do |p|
    puts "solve"
    pos = DATA.pos
    p.solve(DATA) do |s|
      puts s
    end

    puts
    puts "greedy"
    DATA.pos = pos
    p.greedy(DATA) do |s|
      puts s
    end
  end
end
__END__
2
3 30 2
2 17
3 16
3 50 3
1 10
2 10
3 10
