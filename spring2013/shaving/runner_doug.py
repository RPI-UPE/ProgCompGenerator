import sys
from collections import defaultdict

problems = int(sys.stdin.readline())

for problem in range(0, problems):
  n, m, obs = map(lambda x: int(x), sys.stdin.readline().split(' '))

  obligations = defaultdict(lambda: 0)
  for o in range(0, obs):
    day, c = map(lambda x: int(x), sys.stdin.readline().split(' '))
    obligations[day - 1] += c

  unhappiness = [[0 for j in range(0,n+1)] for i in range(0,n+1)]
  days = [[[] for j in range(0,n+1)] for i in range(0,n+1)]

  for i in range(n-1, -1, -1):
    for j in range(i, -1, -1):
      shave = unhappiness[i+1][1] + m
      no_shave = unhappiness[i+1][j+1] + obligations[i] * j

      if shave == no_shave:
        raise Exception("Ambiguous solution")
      elif shave < no_shave or i == 0:
        unhappiness[i][j] = shave
        days[i][j] = [i+1] + days[i+1][1]
      else:
        unhappiness[i][j] = no_shave
        days[i][j] = days[i+1][j+1]

  print ' '.join(map(lambda x: str(x), days[0][0]))
