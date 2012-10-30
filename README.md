UPE ProgComp Problem Generator
==============================

This is a simple framework for generating and verifying a progcomp problem from
multiple sources. It can generate test files and their output given a generator
and solution in ruby, and it can verify a solution using either java or python
(and can be extended for other languages, too). Generation of a problem input
can take into account a given set of edge cases that it should include in every
input file.

How to use
----------

If you want to examine a problem individually, you may use `ruby problem/gen.rb
[n]` to generate `n` input sets (default 1) to `STDOUT`. You can also verify a
set from `STDIN` using `ruby problem/solution.rb < input`. You can also pipe the
above two together for a one line generate and solve to make sure everything is
sane, as such:

    $ ruby gen.rb 100 | ruby solution.rb

For generating data, use the `rake` command in the project root directory with
the `gen` command to generate the input files. If you specify the problem slug
in square brackets, only that problem will be generated, as such:

    $ rake gen[streets]

For testing data, use `rake` by itself, or `rake test[problem]` to test a
specific problem. Execution will be stopped once an error finds a discrepency in
the two output files. All generated and tested data will be placed in a `grader`
directory in the project root that acts as a direct drop in to the progcomp
server.
