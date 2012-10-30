Password Fragments
==================

An online site for storing bitcoins has been hacked (big surprise), and some
interesting details were revealed about their security setup. Firstly, their
users were not allowed to use any duplicate characters in their passwords.  Not
only that, but when logging in, the user only had to input a certain number of
characters from their password as long as they kept them in order.

For example, if a user with the password `asdfjkl;` is told to input 3
characters, they may input `asd`, `afl`, `aj;`, etc. As long as the letters are
kept in the same order of the password, it will be accepted.

To add to the poor security, all successful logins were recorded to a text file
for each user. You happen to stumble upon one such file and wonder if it is
possible to reconstruct the actual password with the given fragments. Given a
number of login attempts, try to piece them together to restore the full
password.

Single input
------------
    <number of fragments> <size of each fragment>
    <fragment>
    <fragment>
    ...

Single output
-------------
    <password>

Sample input
------------
    2
    5 3
    123
    abc
    1b3
    1c2
    1ac
    6 4
    OGco
    ROom
    POco
    PRop
    POGp
    Gcmp

Expected output
---------------
    1abc23
    PROGcomp
