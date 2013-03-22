require 'stringio'

class Problem
  class Trial
    def initialize vars
      # If we are given a file or string io object, we want the input as a
      # string for now
      vars[:args] = vars[:args].read if vars.respond_to? :read
      @args = vars[:args]
      @brute = vars[:brute]
      @solve = vars[:solve]
      @expected = vars[:expected]
    end
    
    def to_s
      <<-eos.gsub(/^\s+/, '').strip
        Args:
        #{ @args }

        Brute force solution:
        #{ @brute }

        Attempted solution:
        #{ @solve }

        #{ if @expected; "Expected:\n#{ @expected }"; end }
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
  
  def initialize
    yield self if block_given?
  end

  def dispatch(method, input)
    # Wrap our input string in a StringIO object so it can be read
    self.send(method, StringIO.new(input))
  end

  def trial(input, expected=nil)
    b, s = dispatch(:brute, input), dispatch(:solve, input)
    run = Trial.new({args:input, brute:b, solve:s, expected:expected})
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
