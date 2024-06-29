:- ensure_loaded(gratefuldead).

% needs work

% Id, From, To
:- dynamic transition/3.

% Helper predicate to generate transitions
generate_transitions(_, []).
generate_transitions(_, [_]).
generate_transitions(Id, [From, To | Rest]) :-
    assertz(transition(Id, From, To)),
    generate_transitions(Id, [To | Rest]).

% Initialize transitions for all setlists
initialize_transitions :-
    forall(setlist(Id, _, _, Songs),
           generate_transitions(Id, Songs)).

% Initialize the transition facts
:- initialize_transitions.

find_transitions_except(From, Except) :-
    transition(Id, song(From), NextSong),
    dif(NextSong, song(Except)),
    setlist(Id, Venue, Date, Songs),
    print([Date, NextSong]), nl,
    fail. % Force backtracking to find all solutions

find_transitions(From, To) :-
    transition(Id, song(From), To),
    setlist(Id, Venue, Date, Songs),
    print([Date]), nl,
    fail. % Force backtracking to find all solutions

%problems with more than one return
returns_to(Song) :-
    transition(Id, One, song(Song)),
    transition(Id, Two, song(Song)),
    setlist(Id, Venue, Date, Songs),
    dif(One, Two),
    path(Id, One, Two, Path),
    print([Date, Song, Path]), nl,
    fail. % Force backtracking to find all solutions


get_path(Id, From, To, Path) :-
    dif(From, To),
    setlist(Id, Venue, Date, Songs),
    path(Id, song(From), song(To), Path),
    print([Date, Path]), nl, nl,
    fail. % Force backtracking to find all solutions

path(Id, From, To, Path) :- % we can walk from A to B
    path(Id, From, To, [], Path). % - initialize visitied, if we can walk from one to the other.

path(Id, Start,Start,_,[Start]).

path(Id, From, To, Visited, [From|Nodes] ) :-      
    dif(From, To),
    transition(Id, From, X),      
    not(member(X, Visited)),   
    path(Id, X, To, [X|Visited], Nodes).  
