:- use_module(library(clpfd)).

hailstone(N, N).
hailstone(N0, N) :-
    N0 #= 2*N1,
    hailstone(N1, N).
hailstone(N0, N) :-
    N0 #= 2*_ + 1,
    N1 #= 3*N0 + 1,
    hailstone(N1, N).


collatz_next(N0, N) :-
    N0 = 2*N.
collatz_next(N0, N) :-
    N0 #= 2*_ + 1,
    N #= 3*N0 + 1.

collatz_reaches(N, N).
collatz_reachs(N0, N) :-
    collatz_next(N0, N1),
    collatz_reaches(N1, N).



transitions_to(red, 1, blue).
transitions_to(blue, 0, green).
transitions_to(blue, 3, red).
transitions_to(green, 4, red).
transitions_to(red, 5, red).

path(N, N).
path(N0, N) :-
transitions_to(N1, C1, N),
C1 #> C,
transitions_to(N0, C, N1).
path(N0, N) :-
transitions_to(N1, C1, N2),
C1 #> C,
transitions_to(N0, C, N1),
path(N2, N).
