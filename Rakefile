# Lazy hard-coding of problem slugs
SLUGS = %w{freq streets war password}
# Number of files to be generated for the server
TEST_FILES = 50
# Number of test cases to include per file (including edge cases)
# We set this to 200 for the competition
TEST_CASES = 20

task :default => [:test]

task :build => [:gen, :test]

task :gen, :slug do |t, args|
  puts "Generating #{ TEST_FILES } files each with #{ TEST_CASES } cases"
  SLUGS.each do |slug|
    if !args[:slug] || args[:slug] == slug
      # Read the edge file
      # We had a problem here where the edge file was not being updated to
      # include the correct number of inputs (aka human error), so people who
      # ignored the number of inputs line got too many solutions.  We need to
      # foolproof this more.
      edge = File.open("#{ slug }/edge.in").read.gsub(/^# .*/, '').gsub(/^\s*$\n/, '')
      count = edge.lines.first.to_i
      edge = edge.lines.drop(1).join

      # Make the destination folder
      prefix = "grader/#{ slug }/"
      mkpath prefix
      require "./#{ slug }/gen.rb"

      print "Generating files for #{ slug }"
      TEST_FILES.times do |i|
        print "."
        file = "#{ prefix }/#{ i }"
        # Generate the input file
        File.open("#{ file }.in", 'w+') do |input|
          # Write the count
          input.puts TEST_CASES

          # Write the edge cases
          input.write edge

          # Add in our own from gen.rb
          Generator.generate(TEST_CASES - count, :without_leader => true) do |line|
            input.puts line
          end
        end

        # Generate the corresponding output file
        File.open("#{ file }.out", 'w+') do |output|
          # Get our solution
          require "./#{ slug }/solution.rb"

          Solver.solve(File.open("#{ file }.in")) do |line|
            output.puts line
          end
        end
      end
      puts "done"
    end
  end
end

require 'open3'
module Open3
  # A more encapsulated function that takes a command, optional file to be
  # written to stdin, and a block that stdout is read and passed to.
  def self.piped_input cmd, file=nil, &block
    popen3(cmd) do |stdin, stdout, stderr|
      stdin.write File.open(file).read if file rescue nil
      # stderr raises an exception and prints an error. This could be reworked,
      # since if you rescue the exception you wouldn't want the extra printing.
      unless stderr.eof?
        puts "Error in `#{ cmd } < #{ file }`:"
        print stderr.read
        raise :stderr
      end
      yield stdout.read if block
    end
  end
end

module Tester
  TESTS = {
    'freq'     => 'freq_Varun.py',
    'war'      => '1DWar_Varun.py',
    'password' => 'Main.java',
    'streets'  => 'Main.java',
  }

  class Base
    def test input
      Open3.piped_input("#{ @cmd } #{ @file }", input) do |output|
        # Write output to temp file
        File.open('.test.diff', 'w+') do |tmp|
          tmp.write output
        end

        # Diff with given output
        Open3.piped_input("colordiff -u #{ input.gsub(/in$/, 'out') } .test.diff") do |diffout|
          unless diffout.empty?
            # Diff error! Same thing here with the printing and raising.
            print diffout
            raise "Test failed on #{ input }"
          end
        end
      end
    end
  end

  class Java < Base
    def initialize file
      # This is a hacky way to change the directory into the classpath and the
      # file name sans extension into the class name.
      @file = [File.dirname(file), File.basename(file, '.java')].join ' '
      @cmd = 'java -cp'
      # Compile the java file before the tests run
      Open3.piped_input("javac #{ file }")
    end
  end

  class Python < Base
    def initialize file
      @file = file
      @cmd = 'python'
    end
  end
end

task :test, :slug do |t, args|
  # Try out Varun's solutions
  SLUGS.each do |slug|
    if !args[:slug] || args[:slug] == slug
      # Testing :slug
      print "Testing #{ slug }"
      # Make sure there is a test defined
      test = Tester::TESTS[slug]
      next unless test

      # Check file type
      ext = File.extname(test)
      case ext
      when '.java'
        tester = Tester::Java.new("#{ slug }/#{ test }")
      when '.py'
        tester = Tester::Python.new("#{ slug }/#{ test }")
      end

      # Do for each file
      TEST_FILES.times do |i|
        tester.test "grader/#{ slug }/#{ i }.in"
        print "."
      end
      puts "done"
    end
  end

  # If we get this far, everything succeeded and we can delete this temp file.
  # We don't really want to delete otherwise, since it can be useful for
  # debugging.
  rm '.test.diff'
end
