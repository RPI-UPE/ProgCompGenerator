"""
Solution to the fitness problem in UPE's Spring 2013 programming competition

@Author Andrew Karnani
@Version 3/24/13
"""


import sys


def readProblem():
    tree = {}
    leaves = set()

    skills, choose = map(int, sys.stdin.readline().split(" "))


    for i in range(skills):
        skill = sys.stdin.readline()[:-1].split(" ")

        tree[skill[0]] = (skill[1], int(skill[2]))
        leaves.add(skill[0])
        leaves.discard(skill[1])


    return tree, leaves, choose

def solve(tree, leaves, choose, used):

    chosen = []

    for i in range(choose):
        result = []
        for leaf in leaves:
            result.append((leaf, value(leaf,tree, used)))

        skill = max(result, key=lambda x: x[1])[0]

        chosen.append(skill)

        while skill != '0':
            used.add(skill)
            skill = tree[skill][0]

    return chosen


def value(skill, tree, used):
    if skill not in tree:
        return 0

    if tree[skill][0] == 0:
        return 0 if skill in used else tree[skill][1]

    return (0 if skill in used else tree[skill][1]) + value(tree[skill][0], tree, used)





num = int(sys.stdin.readline())

for i in range(num):
    tree, leaves, choose = readProblem()
    chosen = solve(tree, leaves, choose, set())
    print " ".join(sorted(chosen, key=lambda x: int(x)))


