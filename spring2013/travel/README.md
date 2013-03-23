You need to meet up with a friend at a secret location. You don't know the
location, but he gave you clues as to how to find it. You are given a list of
pairs of cities, and each pair has a method of travel (`bus`, `plane`, `taxi`,
or `train`), along with a cost. Not every method of travel between every city is
possible.

The clues your friend has given you consist of simply a starting city and then a
list of various methods of travel. You must figure out which city you will end
up in if you begin at the starting city and take those methods of travel in
their given order. If there are multiple cities that could be the destination,
you are instructed to choose the one that had the route with the highest cost.

You will first be given an integer (`n`) describing how many location pairs are
available. The next `n` lines will list two cities, a method of travel, and a
cost as an integer. Note that you can travel *either direction* using this
method of travel (i.e., A to B or B to A). Then you will be given the starting
city and an integer on the same line that describes how many lines, each with
one method of travel, will proceed.

You can assume there will only ever be one unique length for any given two
cities and method of travel (e.g., you can't bus from NYC to Miami two different
ways).

Example

If your possible routes are:

    Phoenix <-> NYC via plane for cost 400
    Phoenix <-> Miami via plane for cost 300
    Miami <-> NYC via bus for cost 200

And your instructions say: `Phoenix plane bus`

Then your possible secret locations are either:

    Phoenix -> NYC -> Miami (total cost 600)
    Phoenix -> Miami -> NYC (total cost 500)

And you would print `Miami` as your solution.

Example Input

```
2
4
Phoenix NYC plane 400
Phoenix Miami plane 300
Miami NYC bus 200
NYC Redmond train 800
Phoenix 3
plane
bus
train
2
Alburquerque Washington plane 200
Omaha Washington taxi 100
Omaha 5
taxi
plane
plane
taxi
taxi
```

Example output

```
Redmond
Washington
```


Personal notes:
- Not a huge deal, but I'll tweak these numbers (at least in the example
  problems) to make sense.
- There should be no ambiguous solutions (two distances with equal tie-breaker
  number)
- To solve the above three, I might just change it to alphabetical first
  solution. It makes it a bit cumbersome to keep track of every distance, though
  recursion probably works well (but can't let it stack overflow).
- I might do multiple problems for a single graph so as to reduce input file
  size (but increase problem comprehension complexity)
