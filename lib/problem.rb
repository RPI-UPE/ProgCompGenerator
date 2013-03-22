# This was just yanked from some framework I wrote for some homework. Needs a
# bit of a touch-up to be specific for this competition
class Problem
  class Args
    @labels = (1..10).map{|i| "arg#{i}"}
    class << self; attr_accessor :labels; end

    def initialize args
      @args = args
    end

    def to_s
      @args.zip(Args.labels).map do |arg, label|
        "- #{ label }: #{ arg }"
      end.join "\n"
    end
  end

  class Trial
    def initialize vars
      @args = Args.new vars[:args]
      @brute = vars[:brute]
      @solve = vars[:solve]
      @expected = vars[:expected]
    end
    
    def to_s
      <<-eos.gsub(/^\s+/, '').strip
        Args:
        #{ @args }
        Brute force solution: #{ @brute }
        Attempted solution: #{ @solve }
        #{ if @expected; "Expected: #{ @expected }"; end }
      eos
    end
  end

  class Error < RuntimeError
    def initialize trial
      super "Evaluation mismatch error"
      @trial = trial
    end

    def backtrace
      []
    end

    def to_s
      "#{ super }\n#{ @trial }"
    end
  end

  class << self
    # Allow you to define arguments for the class
    # The drawback is that this means each time you inherit from Problem and
    # define_arguments you overwrite the arguments in the Args class
    def define_arguments labels
      Args.labels = labels
    end
  end
  
  def initialize
    yield self if block_given?
  end

  def trial(input, expected=nil)
    b, s = brute(input), solve(input)
    run = Trial.new({args:input, brute:b, solve:s, expected:expected})
    if ARGV[0] == '-v'
      puts run
      puts
    end
    raise Problem::Error, run unless b
    raise Problem::Error, run unless b == s
    raise Problem::Error, run if expected && s != expected
  end

  def test(n=1)
    n.times do
      trial(generate)
    end
    puts "#{ n } random trials succeeded"
  end

  def generate *a
    raise "generate() not implemented"
  end

  def brute *a
    raise "brute() not implemented"
  end

  def solve *a
    raise "solve() not implemented"
  end
end
