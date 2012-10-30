City Navigation
===============

You live in a city with a street grid, and you need to get across town for
class. However, many streets are under construction at this time of the year.
Given that it's *only* a humanities class, you decide that you only want to
bother leaving if there is a path between you and the classroom with the
shortest manhattan distance possible.

Given your starting position, your destination, and some road blocks, find the
number of routes you can take that are the smallest manhattan distance to your
destination which do not involve taking a street that has construction on it.
The location of the starting and ending position is an intersection of two
streets as a coordinate pair. A road block is the street between two
intersections, which is represented as two coordinate pairs.

Single input
------------
    <width> <height>
    <start x> <start y> <end x> <end y>
    <number of zones>
    <zone x1> <zone y1> <zone x2> <zone y2>
    <zone x1> <zone y1> <zone x2> <zone y2>
    ...

Single output
-------------
    <number of paths>

Sample input
------------
    2
    5 5
    0 0 4 3
    3
    3 0 3 1
    1 1 1 2
    2 2 2 3
    5 5
    4 4 3 1
    4
    2 1 3 1
    4 1 4 2
    1 3 2 3
    3 4 4 4


Expected output
---------------
    20
    2
