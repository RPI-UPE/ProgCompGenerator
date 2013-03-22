The last thing that Gilbert wants to worry about is shaving. He can spend his
time doing so many better things, so a little facial hair doesn't bother him.
However, he still has obligations throughout the week (meetings, interviews,
etc.) and sometimes people are disappointed if he is not clean-shaven.

Gilbert wants to plan out when he shaves to maximize his happiness. Every time
he shaves, he loses `(7 - g)*M` hapiness, where `g` is the number of full days
of hair growth, and M is constant. This can never be negative; Gilbert never
takes pleasure in shaving. On a given date, if he has an obligation, his
happiness decreases by `c*g`, where `c` is how clean-shaven he is expected to
be. Gilbert always shaves in the morning, so shaving on the day of any
obligation would have a `g` value of 0. If he did not shave the next day, `g`
would be 1.  Figure out which days Gilbert should shave, and print them out on a
different line.

Days are represented relatively starting at day 1 and increasing through day
`n`. The first line of input in a problem will contain three integers. First,
the number of days considered (`n`). Second, the `M` value for this problem, and
third, how many obligations are coming up in those days. Then each line after
lists a day with an obligation and a `c` for that obligation. Assume he always
shaves on the first day (*DO* include this in your output).

Example input

```
2
6 5 2
2 15
5 5
3 4 2
2 25
3 100
```

Example output

```
1 5
1 3
```

Personal notes:
- Make sure there are no ambiguities (on a given day, it should not be a tie
  between not shaving and shaving).
- Possibly a bit too "typical dynamic programming" type of problem. Maybe can be
  solved with other methods though.

- Update: I had to update this since it was solveable with a greedy algorithm.
  Instead of shaving costing a constant `M`, it is now based on when he last
  shaved, which means you get penalized for shaving too often.
