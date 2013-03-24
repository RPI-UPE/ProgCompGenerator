You are given a sequence of `n > 0` positive integers. Your goal is to organize
these numbers into sets such that the sum of the numbers in each set is equal
across all sets. A set can only consist of numbers that are adjacent to each
other. Not all numbers must be part of a set.

Your input will be first an integer telling you how many numbers to read, and
then a new number on each line. Your output will be a single integer
representing how many sets of equal sum were formed.

Example

The sequence "3 4 5 1 1 7" can be split into three groups: "3 4", "5 1 1", and
"7", which each total 7.

Example input

```
2
6
3
4
5
1
1
7
3
9
7
9
```

Example output

```
3
2
```

