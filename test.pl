:- use_module(library(clpfd)).
list_length([], 0).
list_length([_|Ls], N) :-
        N #> 0,
        N #= N0 + 1,
        list_length(Ls, N0).

member([A], A).
member([A | _], A).
member([_|Ls], A) :-
    member(Ls, A).

notIn([], A).
notIn([A], A0) :-
    A \= A0.
notIn([A | Ls], A0) :-
    A \= A0,
    notIn(Ls, A0).

set([]).
set([A]).
set([A|Ls]) :-
    set(Ls),
    notIn(Ls, A).

natnum(0).
natnum(s(X)) :- natnum(X).



