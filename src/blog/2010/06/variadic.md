title=Non-POD to variadic functions
date=2010-06-18
tags=gcc, cpp
%%%%%

Recently I ran into some strange behavior in gcc that caused some
minor confusion for me for a few hours until I figured out exactly
what was wrong. I'm going to attempt to explain it here, so that maybe
someone else will benefit from my lack of understanding about how
computers work :-). The problem was exacerbated by the fact that I am
compiling a system which has literally *thousands* of compiler
warnings, and without going through and fixing them, there's really
no way to manually read them. Since gcc only warns (although I really
think this should be an error), this is a miss-able thing that *will*
cause problems if it is ignored. Our working example will be the
following code:

    #include <stdio.h>

    class Foo
    {
      public:
        Foo() {}
    };

    int main()
    {
      printf("%s\n", Foo());
      return 0;
    }

First, some background. C++ has things which C compilers (and
libraries) don't understand, and one of them happens to be non-POD.
POD stands for Plain Old Data, and it is basically things without
constructors, destructors and methods (in the above example, `Foo`
serves this purpose). `printf()` is what's known as a variadic
function (i.e. a function which can take a variable number of
arguments). In C, these functions are written using the `stdargs.h`
header and associated macros. Naturally, the macros in `stdargs.h`
know nothing about non-POD, and thus it is not valid to pass non-POD
to a variadic function. What gcc does when you do, though, is rather
strange. Consider the following terminal output:

    tycho@mittens:~/playground$ g++ variadic.cpp -o variadic
    variadic.cpp: In function 'int main()':
    variadic.cpp:11: warning: cannot pass objects of non-POD type
    'class Foo' through '...'; call will abort at runtime
    variadic.cpp:11: warning: format '%s' expects type 'char*', but
    argument 2 has type 'int'
    tycho@mittens:~/playground$ ./variadic 
    Illegal instruction

What's going on here? My first thought was that it was some 32/64-bit nuance
that I didn't understand but it turns out that isn't the case.  When gcc
encounters a variadic function which has been passed non-POD, it generates a
warning and a `ud2` instruction in place of the call. If (like me) you're
forced to ignore all compiler warnings due to the sheer number, you wouldn't
see the above warning. Then when you run your binary, it crashes with SIGILL!
Why does it crash? From the Intel x86 manual:

> [ud2] Generates an invalid opcode. This instruction is provided for
> software testing to explicitly generate an invalid opcode. The
> opcode for this instruction is reserved for this purpose. Other than
> raising the invalid opcode exception, this instruction is the same
> as the NOP instruction. This instruction's operation is the same in
> non-64-bit modes and 64-bit mode.

So, the generated binary has a `ud2` sitting in it, which guarantees
that it will crash with a SIGILL. Why does gcc do this instead of
aborting compilation? I have no idea, but it's good to know that this
behavior exists so that if you come across it you don't have to spend
several hours hunting down what's going on.

Lastly, I'd like to make a plug for
[IDAPro](http://www.hex-rays.com/idapro/). I have used it fairly
extensively while at UW, and it works very well. It handles large
(300MB) binaries well (things are naturally slower, but it's not
unbearable), and models the re-writing of static and dynamic linkers
for a variety of formats very well. I used it to help me track down
this bug.
