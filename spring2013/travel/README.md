You need to meet up with a friend at a secret location. You don't know the
location, but he gave you clues as to how to find it. You are given a list of
pairs of cities, and each pair has a method of travel (bus, plane, taxi,
train), along with a distance. Not every method of travel between every city is
possible. The message your friend has sent you is simply a starting city and
then a list of various methods of travel.

You must figure out which city you will end up in if you take those methods of
travel in their given order starting from your original city. If there are
multiple cities that could be the destination, you are instructed to choose the
one that took the longest path.

You will first be given an integer (`n`) describing how many location pairs are
available along with another integer describing how many different locations
there are. The next `n` lines will list two cities, a method of travel, and a
distance as an integer.  Note that you can travel *either direction* using this
method of travel (i.e., A to B or B to A). Then you will be given an integer
stating how many hops will take place along with the starting city.

You can assume there will only ever be one unique length for any given two
cities and method of travel (e.g., you can't bus from NYC to Miami two different
ways)

Example Input

```
1
4 4
Phoenix NYC plane 400
Phoenix Miami plane 300
Miami NYC bus 200
NYC Redmond train 800
3 Phoenix
plane
bus
train
```

Example output

```
Redmond
```


Personal notes:
- Not a huge deal, but I'll tweak these numbers (at least in the example
  problems) to make sense.
- I might change "distance" to "time", since "distance" is kind of weird. Just a
  description change.
- There should be no ambiguous solutions (two distances with equal tie-breaker
  number)
- To solve the above three, I might just change it to alphabetical first
  solution. It makes it a bit cumbersome to keep track of every distance, though
  recursion probably works well (but can't let it stack overflow).
- I might do multiple problems for a single graph so as to reduce input file
  size (but increase problem comprehension complexity)
