require 'yaml'

config = YAML.load_file('config.yml')
env = 'devel'

slug_dir = lambda do |slug, rest|
  File.join('.', config['semester'], slug, rest)
end

task :default => [:test]

task :build => [:gen, :test]

def read_edge_file(edge_path)
  edge = File.open(edge_path).read.gsub(/^# .*/, '').gsub(/^\s*$\n/, '') rescue nil
  if edge
    count = edge.lines.first.to_i
    edge = edge.lines.drop(1).join
  end
  return edge, count
end

task :gen, :slug do |t, args|
  puts "Generating #{ config['test_files'] } files each with #{ config['test_cases'][env] } cases"
  config['problems'].each do |slug, _|
    if !args[:slug] || args[:slug] == slug
      require slug_dir.call(slug, 'problem.rb')
      cls = ProgComp.const_get(slug.capitalize)
      problem = cls.new
      # Read the edge file
      edge, count = read_edge_file(slug_dir.call(slug, 'edge.in'))

      # Make the destination folder
      prefix = "grader/#{ slug }/"
      mkpath prefix

      print "Generating files for #{ slug }"
      config['test_files'].times do |i|
        print "."
        while true
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
          begin
            File.open("#{ file }.out", 'w+') do |output|
              problem.solve(File.open("#{ file }.in")) do |line|
                output.puts line
              end
            end
          rescue Problem::GenerationError => e
            # If our solution rejects the generated file, retry
            next
          end

          # Break infinite loop
          break
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
  config['problems'].each do |slug, cfg|
    if !args[:slug] || args[:slug] == slug
      # Testing :slug
      puts "Testing #{ slug }"

      # Try out brute and solve on edge.in and compare with edge.out
      require 'stringio'
      require slug_dir.call(slug, 'problem.rb')
      cls = ProgComp.const_get(slug.capitalize)
      problem = cls.new
      edge, count = read_edge_file(slug_dir.call(slug, 'edge.in'))
      stdin = StringIO.new("%s\n%s" % [count, edge])

      expected = File.open(slug_dir.call(slug, 'edge.out')).read.strip
      brute = problem.enum_for(:brute, stdin).to_a.join("\n").strip
      stdin.rewind
      solve = problem.enum_for(:solve, stdin).to_a.join("\n").strip

      # We may not have implemented a brute
      if brute.length == 0 
        puts "  Brute tests skipped"
      elsif brute != expected
        puts "  Brute mismatch with expected"
        puts brute
        exit
      end

      if solve != expected
        puts "  Solve mismatch with expected"
        puts solve
        exit
      end

      puts "  Edge tests passed"

      # Try out other solutions - iterate over each runner
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

task :brute, :slug do |t, args|
  config['problems'].each do |slug, cfg|
    if !args[:slug] || args[:slug] == slug
      print "Brute-forcing #{ slug }"
      require slug_dir.call(slug, 'problem.rb')
      cls = ProgComp.const_get(slug.capitalize)
      problem = cls.new

      unless problem.respond_to?(:brute)
        puts "...skipped"
      end

      require 'stringio'
      input = StringIO.new("1\n" + problem.enum_for(:generate, {}).to_a.join("\n"))

      require 'timeout'
      begin
        Timeout::timeout(5) do
          problem.brute(input){}
        end

        # It... finished.
        puts
        raise Problem::GenerationError, "#{ slug.capitalize } finished a brute-force. Bad."
      rescue Timeout::Error
        # Good, it failed! Let's check how badly
        if problem.bruted * 24 > 0.25
          # It would have gotten a quarter of the way on this one; that's not a good sign
          puts
          raise Problem::GenerationError, "#{ slug.capitalize } needs more umph!"
        end
        puts "...success (#{problem.bruted * 24})"
      end
    end
  end
end

task :solve, :slug do |t, args|
  raise "Slug required" unless args[:slug]
  require slug_dir.call(args[:slug], 'problem.rb')
  cls = ProgComp.const_get(args[:slug].capitalize)
  problem = cls.new

  problem.solve(STDIN) do |s|
    puts s
  end
end
