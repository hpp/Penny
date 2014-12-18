Penny
=====

penelopefree for iOS, Penny v2.0 if you will. v3.0 will come out for Android as soon as the Nexus6 comes in.

Penny v2.0 is a basic iOS app (rosywriter) with shaders brought shared from PenelopeFree for Android (Penny v1.0). Penny was never released with an active Julia Dream on Android. As presale status resumes $10/month steady. => 6,000 install, and 400 active users, ~= 60 owners of PenelopeFull.

Projected sales for 2015 18,000 iOS installs, 1,200 active users, and 1,800 owners of PenelopeFull = $300/month.

Swift Tutorial 101 for advanced users:

PennyViewController.swift replaces RosyWriterViewController.m

1:1 mapping with lots of interesting concepts. You may find the Obj-C syntax you are trying to convert in the RosyWriterViewController.m and find the same line in PennyViewController.swift. 

High level Programming Concept.

We have archetypes instead of objects. Archetypes are more important than objects as they exist above the thread pool, or the waters of the collective unconcious. We deal in contexts. And an object may be shared between two contexts. We use optionals as a way of defining references. If the object has reference to an optional it will use it, eitherwise fail and reinitiallized and try try again.

try {a;} catch {if a == nil {a = aClass();}; if b == nill... init all that are missing and try again.

Each thread has a set of objects that need to be in context for thread to run. If any one is out of context we break and bring all optionals back into context. If they can be migrated in great, if not we reinitiallize them. 

Now each class is of it's own thread. And if holds reference to higher archetypes it needs to run (methods). If any of these archetypes (optionals) are nil, then we must reach up to the higher context and pull these down. When we do this they hold refernce to the higher context. Which may contain unsettled dependencies which are waiting for subcontext thread to run. Which are trigger by catch on a, i.e. if b of SuperContext is synced to a, once a is used, and possibly changed in SubContext, b must run, i.e. b?.updateA();

This is why b? fails when b==nil; the highest context is poised to catch first. Which may need to recreate everything depending on what is and is not cached. So makes more sense to have a fall through which checks all archetypes which may hold reference to an object before recreating any objects. 

try {a?.method();} catch {if a == nil {if b != nil {a = b?.refA; tryAgain();} else initAll();}

This offeres a way up and out. In XML this means two objects of similar depth can keep reference of each other if they posess a similar parent which can pass the current ref of each. This creates an oscilation if a changes b, and b changes a. For if the parent thread runs threadA and threadA changes b, then threadParent must run threadB which may change b...

This is called winding up. If threadParent is a stable system a changing b and vice versa will go to zero at infinity. The rate of decay in the signal (oscilating created by a vs. b) can be measured in a few iterations and eigen value calculated for steady state value. e^-llambdaA

This branches out for complex signals a and b. Track in a IIM. IIM is the inverse interative method used in tracking Julia fractals. This is very high lever digital signaling processing concepts. Imagine zooming in on a Julia Fractal. Well the information gathered on the last frame can be used to calculate the information for the new frame. But there is a change in pixel density because we are zooming in. 

To simplify we will use two points on a line, x and y. And these two points are going to give us a new point j. Now j lies between x and y. We know where on the Julia set x and y fail. But we have to work backwards to level where x and y co-exist and then move forward to find j.

x is calculated by iterating f(z) = z^2 + C, x number of times until f(z) > threshold where it is consider to have blown up. And C is the location of x on an xy plane. y is calculate the same as x only at a differnt C (location). 

In practice the new point j would a combination of four points {one up and two the left, up right, lowleft, lr}. Which is a common problem in shader land for zooming in on three demensional objects.

Lets put in #s for x and y, say 500 and 600. We know 500 iterations of f(z) = z^2 + C at Cx explodes, and at Cy explodes after 600 iterations. We can run IIM on y 100 times to find how close to blowing up Cy is after 500 iterations, then interpulate between x and y to find Cj after 500 iteration. Then sub in the interpulated value for z and interate until we blow our threshold (catch BLOCK). 

The problem is the inverse iterative method blows up as squareRoot(f(z)-c) has two solutions [z=squareRoot(f(z)-c), and z=-squareRoot(f(z)-c), so to calculate y after 500 itereations would generate 2^100 # of solutions. Not to mention how many calculations (2^100)*100!. So for large differences in x and y we calculate j from f(z)=z^2+Cj;

There is another solution. If we know we are zooming in between x and y we can save z for x at Cy when y = x. Hence y can hold a reference to x which is more important to j then the current x.

Anyway we are looping back into ourselves here. And it is very important, because these solutions have very wide bearing impacts on sound and music perception. When measuring a signal in terms of roughness. Roughness being a measure of how much change there is in the signal. Take the coase line of Britain as an example. When measured with a yard stick the coast line is measured to be shorter then if it is measured with a foot ruler. Similarly songs have more bits of information if they are measrued at higher sampling frequencies. If we quantify a song as a measure of roughness or a series of roughness measurements we can calculate compression optimizations and clasification of rifts and tracks into bpm, genre, instumentation, etc.






