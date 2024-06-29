:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_cors)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_json)).
:- use_module(library(pcre)).
:- use_module(library(settings)).

:- set_setting_default(http:cors, [*]).

:- json_object venue(name:string, city:string, state:string).
:- json_object date(month:string, day:string, year:string).
:- json_object song(title:string).
:- json_object setlist(id:integer, venue:venue/3, date:date/3, songs:list(song/1)).

:- ensure_loaded(gratefuldead).


% write an http_handler for each endpoint
:- http_handler(root(setlists), setlists_handler, []).		% (1)
:- http_handler(root(years), years_handler, []).	
:- http_handler(root(months), months_handler, []).	
:- http_handler(root(days), days_handler, []).	
:- http_handler(root(cities), cities_handler, []).	
:- http_handler(root(states), states_handler, []).
:- http_handler(root(countries), countries_handler, []).		
:- http_handler(root(venues), venues_handler, []).	
:- http_handler(root(songs), setlists_handler, []).	
:- http_handler(root(performers), setlists_handler, []).	
:- http_handler(root(covers), setlists_handler, []).
:- http_handler(root(tours), setlists_handler, []).		

:- initialization(main, main).

main :-
    getenv('PORT', PortStr),
    atom_number(PortStr, Port),
    http_server(http_dispatch, [port(Port)]),
    prolog.



server(Port) :-						% (2)
        http_server(http_dispatch, [port(Port)]).

%endpoint handler functions.


setlists_handler(Request) :-
    cors_enable(Request,
                  [ methods([get,post,delete])
                  ]),
    http_parameters(Request, [ query(Query, []) ]), % Query to execute
    term_string(Term, Query),
	findall(
	    setlist(ID,venue(NAME,CITY,STATE),date(MONTH, DAY, YEAR),SONGS),
	    (
            call(Term),
            Term = setlist(ID,venue(NAME,CITY,STATE),date(MONTH, DAY, YEAR),SONGS)
	    ),
	    Setlists),
	prolog_to_json(Setlists, JSON),
	reply_json(json([setlists= JSON]), []).





