(The story for this one sucks, so I might change it. Suggestions welcome.)

You are playing a video game and you need to select skills for your character.
Each skill depends on exactly one other skill, with the exception of the
starting skill, which you get. Any given skill may, however, have multiple
skills dependent on it. We define an "ultimate" skill as a skill that no other
skill depends on. You are allowed to select M ultimate skills, and when you do
select one, you automatically receive the benefits of every skill needed to get
that skill. You cannot receive the benefits of any skill more than once,
however. 

The first line consists of two integers, first the number of skills and second
the number of skills you can choose. Each line after consists of three integers:
the skill id (1 through `n`), the skill requirement (or 0 if none), and the
skill value. You must output a list of skills ordered by increasing id.

Example

    Skill 1 depends on 0 and has value 0
    Skill 2 depends on 1 and has value 10
    Skill 3 depends on 1 and has value 10
    Skill 4 depends on 2 and has value 30
    Skill 5 depends on 2 and has value 25
    Skill 6 depends on 3 and has value 20
    Skill 7 depends on 3 and has value 20

We would select ultimate skills 4 and 6, which would in total give us 1, 2, 3,
4, and 6 for a total of 70 points. Choosing 4 and 5, however, would give us only
1, 2, 4, and 5 for a total of 65 points.

    4 6

Example input
1
7 2
1 0 0
2 1 10
3 1 10
4 2 30
5 2 25
6 3 20
7 3 20

Example output
4 6
