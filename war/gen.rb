# Random range of territories
TERRITORIES = 3000..5000
# Random range of territory values
VALUES = 1..1000

class Generator
  def self.generate iterations, opts = {}
    yield iterations unless opts[:without_leader]
    iterations.times do
      # Same as freq, just a bunch of random values
      yield rand(TERRITORIES).tap{|i| yield i}.times.map{ rand(VALUES) }.join "\n"
    end
  end
end

if __FILE__ == $0
  Generator.generate((ARGV[0] || 1).to_i) do |line|
    puts line
  end
end
