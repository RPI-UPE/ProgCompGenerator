You decide to try out a new fitness program. Instead of following a different
step each day, this program lets you create your routine to fit your personal
needs. The program offers `n` different workouts, and you have evaluated each
workout for how valuable it would be to your fitness. The catch is, each workout
requires you to complete one other specific workout first. The one exception to
this is the warm-up, which is where you start your day. Some workouts do not
lead into anything else, and that is because that is where you end your day.
While you are free to complete a workout more than once, it will never
contribute any value towards your fitness after the first time.

You have `M` days to boost your fitness, and you want to select the best workout
schedule each day to do so. The first line of input consists of two integers:
first the number of workouts to choose from, and second the number of days your
program lasts. Each line after consists of three integers: the id of the workout
(1 through `n`), the id of the workout that must be done first (or 0 if none),
and the fitness value for that workout. You must output a list of the final
workout from each day that you plan to do over the entire program, ordered by
increasing id.

Example

    Workout 1 is your warm-up and has value 10
    Workout 2 requires workout 1 and has value 10
    Workout 3 requires workout 1 and has value 10
    Workout 4 requires workout 2 and has value 30
    Workout 5 requires workout 2 and has value 25
    Workout 6 requires workout 3 and has value 20
    Workout 7 requires workout 3 and has value 20

If we had to plan two days, for the first day, we would select workouts 1, 2,
and 4. For the second day, we would select 1, 3, and 6. The total fitness from
these two days is 50 from the first day and 30 from the second. We would output

    4 6

Example input

2
7 2
1 0 10
2 1 10
3 1 10
4 2 30
5 2 25
6 3 20
7 3 15
5 2
1 0 10
2 1 10
3 1 50
4 3 5
5 3 15

Example output

4 6
2 5
