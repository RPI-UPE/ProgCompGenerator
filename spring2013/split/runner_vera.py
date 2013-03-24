# Solution to 2013 Prog. Comp. split problem
# ONLY GUARANTEED TO WORK IF LIST HAS NONNEGATIVE NUMBERS
#
# usage: python splitNonnegative.py list.txt
# 
# Author: Vera Axelrod
# Date: March 21, 2013

import fileinput
import sys

def parseList():
    A = []
    n = int(sys.stdin.readline())
    for i in range(0, n):
      A.append(int(sys.stdin.readline()))

    return A


def split(A):
    n = len(A)

    # maximum number of bins so far
    maxBins = 1

    # create a target sum from a bin with size of binStartSize
    for binStartSize in range(1, n):
        
        # end the target bin at index targetEndIndex
        for targetEndIndex in range(binStartSize-1, n):
            
            # determine the target sum
            targetSum = 0
            for ind in range(targetEndIndex, targetEndIndex-binStartSize, -1):
                targetSum = targetSum + A[ind]
            
            numBins = 1
            originalIndex = targetEndIndex+1
            startIndex = originalIndex
            sumSoFar = 0

            # look for bins to the right of the target bin
            # that have the target sum
            for i in range(originalIndex, n):
                sumSoFar = sumSoFar + A[i]

                #if too big, try removing the first element
                # (if there are negative entries this is not
                #  necessarily the right approach)
                while (sumSoFar > targetSum):
                    sumSoFar = sumSoFar - A[startIndex]
                    startIndex = startIndex + 1

                # if exactly right, add a new bin
                if ( sumSoFar == targetSum):	
                    numBins = numBins + 1
                    sumSoFar = 0
                    startIndex = i+1
            
            maxBins = max(maxBins, numBins)

    return maxBins

for i in range(0, int(sys.stdin.readline())):
  A = parseList()
  maxBins = split(A)
  #print A
  print maxBins
