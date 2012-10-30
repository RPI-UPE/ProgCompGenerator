# Random range of characters for one input string
CHARS = 5000..8000

class Generator
  def self.generate iterations, opts = {}
    yield iterations unless opts[:without_leader]
    iterations.times do
      # First the line noting how many characters, then that many random
      # characters from A-Z as a string
      yield rand(CHARS).tap{|i| yield i}.times.map { (rand(26)+65).chr }.join
    end
  end
end

if __FILE__ == $0
  Generator.generate((ARGV[0] || 1).to_i) do |line|
    puts line
  end
end
