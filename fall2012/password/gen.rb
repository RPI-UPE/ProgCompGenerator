# Master character set to choose from
MASTER = (33..126).map(&:chr).to_a
# Random range of passwords
LENGTH = 90..MASTER.size
# Random range of given samples
GIVEN = 30..50
# Random extra sets given aside from the required ones
EXTRA = 200..300

class Array
  # Sample multiple items from an array but maintain their order
  def seq_sample(n)
    self.each_with_index.to_a.sample(n).sort_by{|i| i.last}.map{|i| i.first}
  end
end

class Generator
  def self.filler given, conn, prefix, suffix
    # Randomly split the filler between prefix and suffix
    pre_ct = 0
    suf_ct = 0
    (given - conn.size).times do
      pre_size = prefix.size - pre_ct
      suf_size = suffix.size - suf_ct
      if rand(pre_size + suf_size) < pre_size
        pre_ct += 1
      else
        suf_ct +=1
      end
    end

    prefix.seq_sample(pre_ct) + conn + suffix.seq_sample(suf_ct)
  end

  def self.generate iterations, opts = {}
    yield iterations unless opts[:without_leader]

    iterations.times do
      password = MASTER.shuffle.slice(0..rand(LENGTH))
      extra = rand(EXTRA)
      given = rand(GIVEN)
      yield "#{ extra + (password.size - 1) } #{ given }"
      # Outputting the actual password
      # STDERR.puts password.join

      samples = []
      # First handle constraints
      # If you make a graph as a list 1 -> 2 -> 3 -> 4 ...
      # You need to include every connection above in the input
      0.upto(password.size - 2) do |i|
        # Take our connected pair
        conn = password[i..i+1]
        # Set up the other two pairs
        prefix = password[0...i]
        suffix = password[i+2..-1]

        samples << filler(given, conn, prefix, suffix).join
      end

      # Now throw in random picks
      extra.times do
        part = rand(password.size)
        samples << filler(given, [password[part]], password[0...part], password[part+1..-1]).join
      end

      yield samples.shuffle.join "\n"
    end
  end
end

if __FILE__ == $0
  Generator.generate((ARGV[0] || 1).to_i) do |line|
    puts line
  end
end
