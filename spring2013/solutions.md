# UPE Programming Competition Spring 2013 Solutions

These are the solutions that I wrote to the problems. They are by no means
definitive nor perfectly optimized, but I'll try to talk briefly about the
methods used and pitfalls to avoid. All of the provided code is written in Ruby
with detailed comments.

## 1. Adjacent Number Sets

In this problem we need to split up a stream of adjacent numbers into sets, or
buckets of equal sum. We're looking to get as many buckets as possible. You do
not need to use every number, and any number can belong to at most one bucket.
The naive approach is to think about it in terms of where you are placing a
divider.  So the numbers `1 2 3` can be divided four ways:

    1 2 3
    1|2 3
    1 2|3
    1|2|3

While this does get you a solution, the runtime is exponential, and this will
fail on large sets. Instead, I tried to look for the most buckets I could create
of sum `i`, iterating from 1 up to the sum of the entire set. For a given `i`, I
continued to add numbers to a bucket sequentially until it was over-full, at
which point I would drop the earliest numbers until it was below `i`.  If I
filled the bucket up to meet `i` exactly, I would start a new bucket on the next
number. This repeats until you cannot possibly improve your best result with any
higher `i`.

```ruby
def solve stdin
  problems = stdin.readline.to_i

  problems.times do
    # Read in the numbers for this problem
    n = stdin.readline.to_i
    nums = n.times.map { stdin.readline.to_i }

    # max is our current best
    max = 0
    # total_size is the sum of the whole set, which is the largest size bucket
    # we can create
    total_size = nums.reduce(:+)

    # Start at 1 and work our way up
    (1..total_size).each do |target|
      # We're trying to make chunks of size target; we can do a shortcut
      # optimization here and say that if we can't theoretically divide the
      # entire bucket in more ways than our current max, there's no point in
      # continuing.
      break if total_size / target < max

      # Start with an empty set and a counter of 0 sets found
      current = []
      chunks = 0

      # Add each number to the current set, one by one
      nums.each do |i|
        current << i

        # If we filled the set more than our target, remove elements from the
        # front (old ones) until we are in good shape. This creates a sliding
        # window of size < target.
        while current.reduce(0, :+) > target
          current.shift
        end

        # If we made a set of our target size, great. Count it and clean up so
        # that we can start over with the next number.
        if current.reduce(:+) == target
          chunks += 1
          current = []
        end
      end

      # Record our result
      max = [max, chunks].max
    end

    puts max
  end
end
```

## 2. Secret Destination

Here we were given a graph with a few different edge types and rules for
traversing the graph. We know where to start and which edges to take, but the
problem is that if we do it recursively, things can get out of hand quickly.
Consider this situation:

      B
     / \
    A   D
     \ /
      C

If you start at `A`, then the first hop will take you to either `B` or `C`. The
second hop will take you to either `D` from `B`, or it will take you to `D` from
`C`. Now, it makes no difference how you got to `D` on hop 2, since the solution
just looks for the ending destination. If we do this recursively, each branch
will explore where to go from `D`, which, given a large graph, will explode
exponentially and become unsolvable. Alternatively, we can keep a running set of
cities we can possibly visit at any given iteration and update it.

    Iteration 0: [A]
    Iteration 1: [B, C]
    Iteration 2: [D]

Each iteration, you create a clean set and make sure not to add duplicates. You
may need to know the path cost to break a tie at the end, so storing the most
expensive cost only will be sufficient.

```ruby
def solve stdin
  problems = stdin.readline.to_i

  problems.times do
    # Number of routes of travel
    edge_count = stdin.readline.to_i
    # This is just a simple way to allow us to assign to a deep hash without
    # writing checks for initial values.
    tree = proc { Hash.new { |h, k| h[k] = tree.call } }
    # map will store our information about routes
    map = tree.call

    # Read in the edges
    edge_count.times do
      a, b, method, len = stdin.readline.split(' ')
      # Remember, it's bi-directional
      map[a][method.to_sym][b] = len.to_i
      map[b][method.to_sym][a] = len.to_i
    end

    # Read in our starting city and number of hops
    start, hop_count = stdin.readline.split(' ')
    # Read in the actual hops into an array
    hops = hop_count.to_i.times.map { stdin.readline.strip.to_sym }

    # Setup our possible locations as a hash with city as the key and cost as
    # the value
    possible_locations = {}
    possible_locations[start] = 0

    # Iterate over each hop so that we can progress
    hops.each do |method|
      # Create a fresh hash to store our possible locations in; default empty
      # keys to 0
      next_locations = Hash.new(0)

      # Using all the possible places we could be right now, find out where we
      # can get to assuming we are using the method given in the loop
      possible_locations.each do |source, route_cost|
        # Iterate over the list of possible sources to find possible
        # destinations
        map[source][method].each do |dest, hop_cost|
          # Pick the more expensive one if it exists already
          next_locations[dest] = [next_locations[dest], hop_cost + route_cost].max
        end
      end

      # Now that we've finished this iteration, replace the whole possible
      # locations with our newly-calculated set
      possible_locations = next_locations
    end

    # The solutions are sorted most expensive first
    solutions = possible_locations.sort_by {|dest, cost| -cost}
    # Pick the first and print the city name
    puts solutions.first.first
  end
end
```

## 3. Fitness Program

We are given information that basically boils down to a rooted tree. Each node
has 2-3 children. After this realization, I think it's more difficult to write a
brute-force solution than a workable one. Iterate for the number of days in the
exercise routine, and each day select your best workout. To do this, simply
start at each leaf node, and calculate its effective value by summing the values
of all nodes up to the root, ignoring any that have been used already. Then,
when you pick a leaf node, mark it and all of its ancestors as used before
continuing with the next iteration.

```ruby
# I use a class here to represent the nodes
class Workout
  attr_accessor :picked, :final

  def initialize req, value
    # Req is a reference to the node that is its direct ancestor
    # Note that req is nil for the root node
    @req = req
    # The value for just this node
    @value = value
    # Every node starts as a leaf, but when something requires it...
    @leaf = true
    # ...it becomes a parent node
    @req.leaf = false if @req
  end

  def effective_value
    # Like I said, we're not very efficient here! We recalculate the effective
    # value each time; that is, our value if unpicked, and the effective value
    # of our parent node, recursing up to the root.
    if @picked
      # Already picked
      0
    elsif @req
      # Available node
      @value + @req.effective_value
    else
      # Root node
      @value
    end
  end

  def pick
    # Mark ourself and all ancestors as picked
    @picked = true
    @req.pick if @req
  end
end

def solve stdin
  problems = stdin.readline.to_i

  problems.times do
    workout_count, days = stdin.readline.split(' ').map(&:to_i)

    # Read in our workouts into a hash mapping its id to object
    workouts = {}
    workout_count.times do
      id, req, value = stdin.readline.split(' ').map(&:to_i)
      # We should have already read in our parent node, so pass that to the
      # constructor
      workouts[id] = Workout.new workouts[req], value
    end

    # Make a list of our picked leaf nodes
    pick = []
    days.times do
      # Each day, we look at every leaf node that hasn't been picked and sort
      # them by their effective values
      contending_values = workouts
                          .select {|id, n| n.leaf && !n.picked }
                          .sort_by {|id, n| -n.effective_value }

      # Push the workout id to the list of answers
      id, workout = contending_values.first
      pick << id
      workout.pick
    end

    # Sort the answers and print
    puts pick.sort.join ' '
  end
end
```

## 4. A Hairy Situation

This was a very straight-forward dynamic programming problem, though that might
not be apparent if you have not dealt with them a good amount. As shown in the
example, a greedy algorithm will not suffice, since sometimes it is better to
shave once before two close obligations even if there is not an immediate
benefit. You can solve this problem by making the choice each day depend on what
could happen in the future. Start at `day = 0` with `growth = 0`. At each day,
you either:

1. Shave, pay the cost of `m`, and then move on to `day + 1` with `growth = 1`
2. Do not shave, pay the cost of `c*g` (where `c` may be zero), and then move on
   to `day + 1` with `growth + 1`

Although you don't immediately know how good `(day + 1, 1)` is compared to
`(day + 1, growth + 1)`, if you always select the best of the two choices above,
you will have the optimal result. If you try to solve this recursively while
recalculating each time, you will have an exponential solution that will not
finish. I used memoization for any given `(day, growth)` pair so that it ran in
polynomial time.

Unfortunately, the solution calls for the list of days, so we have to juggle
both that and the amount of unhappiness with the same algorithm. I use a class
to store both, so I can just pass instances of that around and keep all the
information in one place.

```ruby
# A combination of unhappiness value and the related list of days he shaves
class Solution
  attr_accessor :unhappiness, :shave_days

  def initialize
    @unhappiness = 0
    @shave_days = []
  end

  # Comparator for [].min based on unhappiness
  def <=>(other)
    unhappiness <=> other.unhappiness
  end

  # Adds unhappiness and potentially pushes a day onto a copy of self
  def add(cost, day=nil)
    self.dup.tap do |new|
      new.unhappiness += cost
      # Don't just concatenate here since shave_days does not get duped
      new.shave_days = [day, *@shave_days] if day
    end
  end
end

def solve stdin
  problems = stdin.readline.to_i

  problems.times do
    n, m, obligation_count = stdin.readline.split(' ').map(&:to_i)
    obligations = Hash.new(0)
    # Read in obligations from each day
    obligation_count.times do
      day, c = stdin.readline.split(' ').map(&:to_i)
      # There might be more than one for the same day, so we just add to the
      # default value of 0. Note we're converting to 0-indexed day.
      obligations[day - 1] += c
    end

    # The solution is a matrix of subproblem solutions
    solutions = Array.new(n + 1){ Array.new(n + 1) { nil }}
    # Our recursive function that takes a day and theoretical growth value
    solution_at = lambda do |day, growth|
      # This block will be skipped if we already calculated this (day, growth) pair
      unless solutions[day][growth]
        # Base case: we have passed the number of days (0-indexed)
        return (solutions[day][growth] = Solution.new) if day == n

        # We want to pick the lower of the two and set it to ours
        # This is where the recursion is
        solutions[day][growth] = [
          # Do shave: add the m cost and the current day to the list
          solution_at.call(day+1, 1).add(m, day + 1),
          # Do not shave: just add the cost
          solution_at.call(day+1, growth+1).add(obligations[day] * growth, nil)
        ].min
      end

      # Return this subproblem solution to the caller
      return solutions[day][growth]
    end

    # Call the recursive and print the days after we tack on the [1]
    puts [1, *solution_at.call(0, 0).shave_days.sort.uniq].join ' '
  end
end
```

## Conclusion

And that's all of them. Like I said, these are certainly not the most absolutely
efficient solutions. Consider that I am solving them in Ruby (MRI), which pales
in comparison to any compiled language, and I was able to solve 50 input files
worth of problems in under a minute. The way I design the input files, at least,
if you use a non-exponential algorithm, you really shouldn't have to worry about
the run time.
