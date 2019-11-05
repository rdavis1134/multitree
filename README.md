# multitree
Prototypes for a multitree (working title). Desired result is a tree with children that
can have multiple parents, and possibly links to siblings. Intended use is to reduce 
computation in certain types of stacking problems, where I need to know characteristics 
of other elements at the same display level. Feel free to drop me a line if there are 
existing data types that meet that need without me needing to go through the hassle.

Usage:
To compile an executable that just does boring tests, open a terminal session to the 
local folder, and execute "dub run", which compiles /source/app.d

To use in a more interesting project, copy the multitree class into your project and 
give it a try.

Requirements:
Currently based in D2, with no major library requirements at the moment. I might 
migrate to a different language eventually, but these are meant to be very simple 
prototypes to investigate usages, so you could just modify a class yourself.

Approaches:
- Maintain siblings list externally
- Broadcast calls through tree elements
- Maintain siblings list internally