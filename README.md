Penny
=====

penelopefree for iOS, Penny v2.0 if you will. v3.0 will come out for Android as soon as the Nexus6 comes in.

Penny v2.0 is a basic iOS app (rosywriter) with shaders brought shared from PenelopeFree for Android (Penny v1.0). Penny was never released with an active Julia Dream on Android. As presale status resumes $10/month steady. => 6,000 install, and 400 active users, ~= 60 owners of PenelopeFull.

Projected sales for 2015 18,000 iOS installs, 1,200 active users, and 1,800 owners of PenelopeFull = $100/month.

Swift Tutorial 101 for advanced users:

PennyViewController.swift replaces RosyWriterViewController.m

1:1 mapping with lots of interesting concepts. You may find the Obj-C syntax you are trying to convert in the RosyWriterViewController.m and find the same line in PennyViewController.swift. 

High level Programming Concept.

We have archetypes instead of objects. Archetypes are more important than objects as they exist above the thread pool, or the waters of the collective unconcious. We deal in contexts. And an object may be shared between two contexts. We use optionals as a way of defining references. If the object has reference to an optional it will use it, eitherwise fail and reinitiallized and try try again.

try {a;} catch {if a == nil {a = aClass();}; if b == nill... init all that are missing and try again.

Each thread has a set of objects that need to be in context for thread to run. If any one is out of context we break and bring all optionals back into context. If they can be migrated in great, if not we reinitiallize them. 

Now each class is of it's own thread. And if holds reference to higher archetypes it needs to run (methods). If any of these archetypes (optionals) are nil, then we must reach up to the higher context and pull these down. When we do this they hold refernce to the higher context. Which may contain unsettled dependencies which are waiting for subcontext thread to run. Which are trigger by catch on a, i.e. if b of SuperContext is synced to a, once a is used, and possibly changed in SubContext, b must run, i.e. b?.updateA();




