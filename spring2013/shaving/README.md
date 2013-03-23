The last thing that Gilbert wants to worry about is shaving. He can spend his
time doing so many better things, so a little facial hair doesn't bother him.
However, he still has obligations throughout the week (meetings, interviews,
etc.) and sometimes people are disappointed if he is not clean-shaven. When
other people are disappointed, Gilbert is disappointed.

Gilbert wants to plan out when he shaves to maximize his happiness. Every time
he shaves, he loses `M` hapiness, where M is a constant. On a given date, if he
has an obligation, his happiness decreases by `c*g`, where `g` is the number of
full days of hair growth, and `c` is an integer how clean-shaven he is expected
to be. Gilbert always shaves in the morning, so shaving on the day of any
obligation would mean `g` has a value of 0. If he did not shave the next day,
`g` would increase to 1.  Figure out which days Gilbert should shave.

Days are labeled starting at day 1 and increasing through day `n`. The first
line of input in a problem will contain three integers. First, the number of
days that you need to plan out (`n`). Second, the `M` constant for this problem,
and third, how many obligations are coming up in this time period. Then each
line after lists a day with an obligation and a `c` value for that obligation.
Assume he always shaves on the first day (*DO* include this in your output).

Example

Assume Gilbert loses 30 happiness for shaving (`M = 30`), and you need to plan
out only the next three days of shaving. His obligations are as follows:

    Day 2: Disapproval of facial hair with a weight of 17
    Day 3: Disapproval of facial hair with a weight of 16

If Gilbert shaves both days, his happiness decreases by `2*30 = 60`. If he shaves
neither day, his happiness decreases by `17*1 + 16*2 = 49`. If he only shaves on
day 2, his happiness decreases by `30 + 16*1 = 46`. And finally, if he only
shaves on day 3, his happiness decreases by `17*1 + 30 = 47`. The best choice
here is to shave on day 2 (in addition to the implicit shave on day 1), so your
output would be

    1 2

Example input

```
2
3 30 2
2 17
3 16
3 50 3
1 10
2 10
3 10
```

Example output

```
1 2
1
```

Personal notes:
- Make sure there are no ambiguities (on a given day, it should not be a tie
  between not shaving and shaving).
- Update: I had to update this since it was solveable with a greedy algorithm.
  Instead of shaving costing a constant `M`, it is now based on when he last
  shaved, which means you get penalized for shaving too often.
- Double update: I was wrong, reverted for simplicity.
