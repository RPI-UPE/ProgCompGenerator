(The story for this one sucks, so I might change it).
You are playing a video game and you need to select skills for your character.
Each skill depends on exactly one other skill, with the exception of the
starting skill, which does not depend on any. Any given skill may however have
multiple skills dependent on it. The best skills are the ones at the end: no
skills depend on them. You are allowed to select M best skills, and when you do,
you automatically receive the benefits of all the skills needed to get that
skill. You cannot receive the benefits of any skill more than once, however.
Given a list of skills, their values, and which skills they depend on, list the
5 skills (ordered by value) that should be selected to maximize your character.

Input is <id> <depends on> <value>

Example input
1
7 2 (<number>, <M>)
1 0 0
2 1 10
3 1 10
4 2 30
5 2 25
6 3 20
7 3 20

Example output
4 6

