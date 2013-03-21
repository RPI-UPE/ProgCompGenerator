class Solver
  def self.solve stdin
    n = stdin.readline.to_i
    n.times do
      freq = Hash.new 0
      # Read extra line for string size (not needed)
      stdin.readline
      input = stdin.readline.strip
      # Tally pairs of consecutive letters
      input.chars.each_cons(2) do |seq|
        freq[seq.join] += 1
      end
      # Sort by highest count and alphabetically
      freq = freq.to_a.sort do |a, b|
        if a.last == b.last
          a.first <=> b.first
        else
          b.last <=> a.last
        end
      end
      # Format for output
      yield freq.first(3).map{|f| f.join(' ')}.join("\n")
      yield "---"
    end
  end
end

if __FILE__ == $0
  Solver.solve STDIN do |line|
    puts line
  end
end
