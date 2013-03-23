require 'yaml'

config = YAML.load_file('config.yml')
env = 'devel'

slug_dir = lambda do |slug, rest|
  File.join('.', config['semester'], slug, rest)
end

task :default => [:test]

task :build => [:gen, :test]

task :gen, :slug do |t, args|
  puts "Generating #{ config['test_files'] } files each with #{ config['test_cases'][env] } cases"
  config['problems'].each do |slug, _|
    if !args[:slug] || args[:slug] == slug
      require slug_dir.call(slug, 'problem.rb')
      cls = ProgComp.const_get(slug.capitalize)
      problem = cls.new
      # Read the edge file
      # We had a problem here where the edge file was not being updated to
      # include the correct number of inputs (aka human error), so people who
      # ignored the number of inputs line got too many solutions.  We need to
      # foolproof this more.
      edge = File.open(slug_dir.call(slug, 'edge.in')).read.gsub(/^# .*/, '').gsub(/^\s*$\n/, '') rescue nil
      if edge
        count = edge.lines.first.to_i
        edge = edge.lines.drop(1).join
      end

      # Make the destination folder
      prefix = "grader/#{ slug }/"
      mkpath prefix

      print "Generating files for #{ slug }"
      config['test_files'].times do |i|
        print "."
        file = "#{ prefix }/#{ i }"
        # Generate the input file
        File.open("#{ file }.in", 'w+') do |input|
          # Write the count
          input.puts config['test_cases'][env]

          # Write the edge cases
          input.write edge if edge

          # Add in our own from gen.rb
          problem.input_file(config['test_cases'][env] - (count or 0)) do |line|
            input.puts line
          end
        end

        # Generate the corresponding output file
        File.open("#{ file }.out", 'w+') do |output|
          problem.solve(File.open("#{ file }.in")) do |line|
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
  def self.piped_input cmd, file=nil
    popen3(cmd) do |stdin, stdout, stderr|
      stdin.write File.open(file).read if file rescue nil
      unless stderr.eof?
        raise Tester::TestError, "Error in `#{ cmd } < #{ file }`:\n#{ stderr.read }"
      end
      yield stdout.read if block_given?
    end
  end
end

module Tester
  class DriverError < RuntimeError; end
  class TestError < RuntimeError; end

  def self.make(runner)
    driver = constants.map{|c| const_get c }.find{|cls| cls.respond_to? :test_on? and cls.test_on? runner }
    raise DriverError, "No driver available" unless driver
    driver.new runner
  end

  class Base
    def test input
      Open3.piped_input("#{ @cmd } #{ @file }", input) do |output|
        # Write output to temp file
        File.open('.test.diff', 'w+') do |tmp|
          tmp.write output
        end

        # Diff with given output
        Open3.piped_input("diff -u #{ input.gsub(/in$/, 'out') } .test.diff") do |diffout|
          unless diffout.empty?
            # Diff error!
            raise TestError, "Test failed on #{ input }\n#{ diffout }"
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

    def self.test_on? filename
      filename =~ /\.java$/
    end
  end

  class Python < Base
    def initialize file
      @file = file
      @cmd = 'python'
    end

    def self.test_on? filename
      filename =~ /\.py$/
    end
  end
end

task :test, :slug do |t, args|
  # Try out other solutions
  config['problems'].each do |slug, cfg|
    if !args[:slug] || args[:slug] == slug
      # Testing :slug
      puts "Testing #{ slug }"

      # Iterate over each runner
      runners = cfg['runners']
      next unless runners
      runners.each do |runner|
        begin
          print "  #{ runner } "
          tester = Tester::make slug_dir.call(slug, runner)

          # Do for each file
          config['test_files'].times do |i|
            tester.test "grader/#{ slug }/#{ i }.in"
            print "."
          end
          puts "done"
        rescue Tester::DriverError => e
          puts e
          next
        rescue Tester::TestError => e
          # Exit cleanly
          puts e
          exit
        end
      end
    end
  end

  # If we get this far, everything succeeded and we can delete this temp file.
  # We don't really want to delete otherwise, since it can be useful for
  # debugging.
  rm '.test.diff' if File.exists? '.test.diff'
end
