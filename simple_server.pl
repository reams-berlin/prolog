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
:- http_handler(root(hello_world), setlists_handler, []).		% (1)

% start server
server(Port) :-						% (2)
        http_server(http_dispatch, [port(Port)]).

%endpoint handler functions.

setup_request_term(Request, Term) :-
    cors_enable(Request,
                  [ methods([get,post,delete])
                  ]),
    http_parameters(Request, [ query(Query, []) ]), % Query to execute
    term_string(Term, Query).

setlists_handler(Request) :-
    setup_request_term(Request, Term),
	findall(
	    setlist(I,V,D,S),
	    (
            call(Term),
            Term = setlist(I, V, D, S)
	    ),
	    Setlists),
	prolog_to_json(Setlists, JSON),
	reply_json(json([setlists= JSON]), []).

