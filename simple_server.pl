:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_cors)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_json)).
:- use_module(library(pcre)).
:- use_module(library(settings)).
:- use_module(library(broadcast)).

:- set_setting_default(http:cors, [*]).

:- json_object venue(name:string, city:string, state:string).
:- json_object date(month:string, day:string, year:string).
:- json_object song(title:string).
:- json_object setlist(id:integer, venue:venue/3, date:date/3, songs:list(song/1)).

:- ensure_loaded(gratefuldead).
:- ensure_loaded(helpers).


% write an http_handler for each endpoint
:- http_handler(root(.), home_handler, []).
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

%:- initialization(main, main).

main :-
    getenv('PORT', PortStr),
    atom_number(PortStr, Port),
	http_server(http_dispatch, [port(Port)]),
    thread_get_message(stop).

server(Port) :-						% (2)
        http_server(http_dispatch, [port(Port)]).

%endpoint handler functions.

home_handler(Request) :-
    cors(Request),
    format('Content-type: application/json~n~n', []),
    format('Ladies and Gentlemen, the Grateful Dead.').

setlists_handler(Request) :-
    request_setlists(Request, Setlists),
	prolog_to_json(Setlists, JSON),
	reply_json(json([setlists= JSON]), []).

venues_handler(Request) :-
    request_setlists(Request, Setlists),
    setlists_venues(Setlists, Venues),
    venues_names(Venues, Names),
    reply_json(json([venues= Names])).
    
cities_handler(Request) :-
    request_setlists(Request, Setlists),
    setlists_venues(Setlists, Venues),
    venues_cities(Venues, Cities),
    reply_json(json([cities= Cities])).

states_handler(Request) :-
    request_setlists(Request, Setlists),
    setlists_venues(Setlists, Venues),
    venues_states(Venues, States),
    reply_json(json([states= States])).

months_handler(Request) :-
    request_setlists(Request, Setlists),
    setlists_dates(Setlists, Dates),
    dates_months(Dates, Months),
    reply_json(json([months= Months])).

days_handler(Request) :-
    request_setlists(Request, Setlists),
    setlists_dates(Setlists, Dates),
    dates_days(Dates, Days),
    reply_json(json([days= Days])).

years_handler(Request) :-
    request_setlists(Request, Setlists),
    setlists_dates(Setlists, Dates),
    dates_years(Dates, Years),
    reply_json(json([years= Years])).


request_setlists(Request, Setlists) :-
cors(Request),
    http_parameters(Request, [venue(Name, [default("NAME")]),
                                city(City, [default("CITY")]),
                                state(State, [default("STATE")]),
                                month(Month, [default("MONTH")]),
                                day(Day, [default("DAY")]),
                                year(Year, [default("YEAR")])]),
                                term_string(StateTerm, State),
                                term_string(NameTerm, Name),
                                term_string(CityTerm, City),
                                term_string(MonthTerm, Month),
                                term_string(DayTerm, Day),
                                term_string(YearTerm, Year),

    findall(
	    setlist(ID,venue(NAME,CITY,STATE),date(MONTH, DAY, YEAR),SONGS),
        (
                setlist(ID, venue(NAME, CITY, STATE), date(MONTH, DAY, YEAR), SONGS),
                STATE = StateTerm,
                NAME = NameTerm,
                CITY = CityTerm,
                MONTH = MonthTerm,
                DAY = DayTerm,
                YEAR = YearTerm
	    ),
	    Setlists).


cors(Request) :-
    cors_enable(Request,
                  [ methods([get,post,delete])
                  ]).





