A sliding puzzle is a rectangular grid with square pieces that fit evenly into
the grid. There is one missing piece, so that you may slide the pieces around to
move them.

You are given a puzzle that consists of mostly black blocks, a single red block,
a single open space, and a single goal spot. Your job is to determine how to
move the red block onto the open space in the least possible number of moves.

Input will be the size of the grid `width height`, the starting location of the red block
`x y`, the starting location of the open space `x y`, and the location of the
goal spot `x y`.

Example input
```
1
3 3
0 0
0 1
2 2
```

Example output
```
10
```

Personal notes:
- There is a version that includes multiple fixed blocks that cannot be moved,
  which I believe severely increases the complexity.
- 0-indexed or 1-indexed
- I'm still a bit troubled about the possibility that the red square won't take
  *A* shortest path. If that is not always the case, we either need to remove
  those possibilities or I need to figure out an algorithm that works for it and
  see if it is too hard.
- Basically, if you can't solve this with a greedy algorithm, it probably is too
  hard.

- Update: I wrote a greedy solution and a brute-force solution, and then ran
  both against every possible input for a 3x3 grid, 4x4 grid, and a bunch of
  others, and it all checks out.
