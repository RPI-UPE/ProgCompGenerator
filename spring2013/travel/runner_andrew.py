"""
A solution to the travel problem in UPE's Spring 2013 programming competition
@author Andrew Karnani
@version 3/23/13
"""

import sys

def readFile(fn):
    cities = {}
    start = ''
    actions = []

    num = int(sys.stdin.readline().split(" ")[0])

    for i in range(num):

        s = sys.stdin.readline()[:-1].split(" ")
        addCities(s[0], s[1], s[2], int(s[3]), cities)
        addCities(s[1], s[0], s[2], int(s[3]), cities)

    start, num = sys.stdin.readline()[:-1].split(" ")
    num = int(num)

    for i in range(num):
        actions.append(sys.stdin.readline()[:-1])

    return start, actions, cities


def addCities(c1, c2, method, dist, cities):
    if c1 not in cities:
        t = {method: [(c2, dist)]}
        cities[c1] = t
    else:
        if method not in cities[c1]:
            cities[c1][method] = [(c2, dist)]
        else:
            cities[c1][method].append((c2, dist))


def solve(loc, actions, cities):
    if not actions:
        return loc, 0

    try:
        options = cities[loc][actions[0]]
    except KeyError:
        return None, None

    results = []

    for option in options:
        city, dist = solve(option[0], actions[1:], cities)
        if city:
            results.append((city, dist + option[1]))

    if not results:
        return None, None

    return max(results, key=lambda x: x[1])


num = int(sys.stdin.readline())

for i in range(0, num):
  city, actions, cities = readFile('problem.txt')
  print solve(city, actions, cities)[0]
