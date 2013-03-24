"""
 Solution to 2013 Prog. Comp. shave problem
 Brute force solution, checks every possibility
 Days are indexed from 1

 usage: python shave.py input.txt

 Author: Vera Axelrod
 Date: March 23, 2013
"""

import fileinput
import sys
from collections import defaultdict

# read in the information
def readInput():
    result = []
    obligations = defaultdict(lambda: 0)
    seenInfo = False
    M = -1
    n = -1

    probs = int(sys.stdin.readline())
    for i in range(0, probs):
        line = sys.stdin.readline()
        L = line.rstrip('\n').split(' ')

        if(len(L) == 3):
            # add the old stuff
            if (seenInfo):
                result.append([n, M, obligations])
                obligations = defaultdict(lambda: 0)

            n = int(L[0])
            M = int(L[1])
            obs = int(L[2])
            #ignore L[2] which is the number of obligations
            seenInfo = True

            for j in range(0, obs):
              line = sys.stdin.readline()
              L = line.rstrip('\n').split(' ')

              if(len(L) == 2):
                  obligations[int(L[0])] += int(L[1])

    # add the last input if there was any input at all
    if(seenInfo):
        result.append([n, M, obligations])

    return result



def shave(n, M, obligations):
    # create the set of all binary strings
    binaryStrings = [];
    upper = pow(2, n-1)

    for i in range(0, upper):
        binary = bin(i)
        x = binary[2:len(binary)]

        # need to pad the front with zeros
        while ( len(x) < (n-1) ):
            x = '0' + x

        # we ignore the zeroth day so put an 'x' there
        x = 'x1' + x
        binaryStrings.append(x)

    # python can actually go smaller than this, but lets assume the problem wont
    bestHappiness = -sys.maxint

    # try all possible combinations of shaving/not shaving
    for x in binaryStrings:
        happiness = 0
        hairLength = 0
        # skip the first day (1)
        for d in range(2,n+1):
            # shave today
            if (x[d] == '1'):
                happiness -= M
                hairLength = 0
            else:
                hairLength = hairLength + 1

            if ( d in obligations ):
                happiness -= obligations[d] * hairLength

        if (happiness >= bestHappiness):
            bestHappiness = happiness
            bestStrategy = x

    # print out the best strategy
    output = ''
    for day in range(1,n+1):
        if (bestStrategy[day] == '1'):
            output = output + str(day)
            output += ' '

    print output.strip()



result = readInput()
for problem in result:
    shave(problem[0], problem[1], problem[2])
