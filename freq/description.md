Frequency Detection
===================

One common technique when analyzing encryped data is to look for common
sequences of characters. You are given a string of a certain length, and your
task is to output a brief summary containing the *three* most frequent
2-character pairs found in the string and how many times it was found occuring.
If two or more are tied for the same frequency, sort them alphabetically.
Separate the output between each case with three hyphens.

Single input
------------
    <string length>
    <encrypted string>

Single output
-------------
    <first sequence> <number of occurrences>
    <second sequence> <number of occurrences>
    <third sequence> <number of occurrences>
    ---

Sample input
------------
    2
    19
    ABCDABGHRPIJABDNRPI
    22
    OPOPOPOPPAGANGNAMSTYLE (I am so, so sorry)

Expected output
---------------
    AB 3
    PI 2
    RP 2
    ---
    OP 4
    PO 3
    AG 1
    ---
