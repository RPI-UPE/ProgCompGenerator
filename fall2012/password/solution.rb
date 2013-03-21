require 'set'

class Node
  attr_accessor :id, :next, :marked, :in

  @marked = false

  def initialize id
    @id = id
    @next = Set.new
    @marked = false
    @in = false
  end
end

class Solver
  # Depth-first search
  def self.dfs(cur, nodes)
    order = []
    cur.marked = true
    cur.next.each do |node|
      order = dfs(node, nodes) + order unless node.marked
    end
    [cur.id] + order
  end

  def self.solve stdin
    n = stdin.readline.to_i

    n.times do |iter|
      sets = stdin.readline.split(' ').first.to_i
      nodes = {}

      # Create nodes
      sets.times do
        path = stdin.readline.strip
        path.chars.each_cons(2) do |p, q|
          from = (nodes[p] ||= Node.new p)
          to   = (nodes[q] ||= Node.new q)
          from.next << to
          to.in = true
        end
      end

      # Find source
      source = nodes.select{|i, node| !node.in}
      if source.size > 1 or source.size < 1
        # Detect bad input
        raise "Uh oh, #{ source.size } sources on #{ iter }: [#{ source.keys.join ',' }]"
      end
      order = dfs(source.values.first, nodes)
      yield order.join
    end
  end
end

if __FILE__ == $0
  Solver.solve STDIN do |line|
    puts line
  end
end
