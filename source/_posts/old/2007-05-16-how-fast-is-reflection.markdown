---
layout: post
title: "How fast is reflection?"
date: 2007-05-16 21:30:00 +0100
comments: true
categories: .NET General
---
Most .NET developers have an affinity to using reflection for things
like configuration, inversion of control, dependency injection etc, but
I was wondering today just how fast IS reflection - what overhead does
it bring? So I wrote a (far from exhaustive) test;

The test consisted of code that would simulate 500,000 cycles of loading
9 different objects from an external assembly, create an instance of
each of those objects and then invoke a method on it.

The method itself then resolves and creates 5 instances of 5 different
objects before returning. In total this activity equates to 3 million
reflection resolutions by type and 3 million object constructions
followed by 500,000 method calls.

The results? The total time from start to finish on my laptop was 19.7
seconds. That seems pretty quick to me.

For refernce my laptop is an Intel Centrino duo core, 2Ghz with 2Gb of
memory.
