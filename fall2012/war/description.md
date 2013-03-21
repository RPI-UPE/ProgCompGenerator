1D War
======

We're dealing with the imaginary univerise of dimenionsia, where the entire
world is one dimensional. One planet in this universe is in an unstable
environment, as all the territories are about to go to war over resources unless
you put together a peacekeeping force that can maintain the peace.

There are N territories on the planet, and every territory must have at least 1
peacekeeping force placed on it. Since funding is tight, you'd like to allocate
as few troops as possible while still ensuring that no territory will go to war
with another.

Each territory has a certain amount of resources, represented as an integer. A
territory will only go to war with a neighboring territory, but only if its
neighbor has more resources than it has. To prevent this, you simple need to
place more peacekeeping forces on the higher-resource territory than you placed
on its greedy neighbor.

Hence if two territories are adjacent and have the same amount of resources,
then one can have more troops than the other without reason for concern, however
if one territory has more resources, it must have more troops.

Calculate the minimum number of troops needed to maintain the peace.

Single input
------------
    <number of territories>
    <rank of territory>
    <rank of territory>
    ...

Single output
-------------
    <number of troops deployed>

Sample input
------------
    2
    3
    10
    100
    50
    6
    13
    15
    12
    8
    7
    19

Expected output
---------------
    4
    13
