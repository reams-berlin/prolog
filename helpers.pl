:- module(helpers, [
    setlist_venue/2,
    setlist_date/2,
    setlist_songs/2,
    venue_name/2,
    venue_city/2,
    venue_state/2,
    date_month/2,
    date_day/2,
    date_year/2,
    setlists_venues/2,
    setlists_dates/2,
    venues_names/2,
    venues_cities/2,
    venues_states/2,
    dates_months/2,
    dates_days/2,
    dates_years/2
]).

setlist_venue(setlist(_, Venue, _, _), Venue).

setlist_date(setlist(_, _, Date, _), Date).

setlist_songs(setlist(_, _, _, Songs), Songs).

venue_name(venue(Name, _, _), Name).

venue_city(venue(_, City, _), City).

venue_state(venue(_, _, State), State).

date_month(date(Month, _, _), Month).

date_day(date(_, Day, _), Day).

date_year(date(_, _, Year), Year).

setlists_venues(Setlists, Unique_Venues) :-
    maplist(setlist_venue, Setlists, Venues),
    sort(Venues, Unique_Venues).

setlists_dates(Setlists, Unique_Dates) :-
    maplist(setlist_date, Setlists, Dates),
    sort(Dates, Unique_Dates).

venues_names(Venues, Unique_Names) :-
    maplist(venue_name, Venues, Names),
    sort(Names, Unique_Names).

venues_cities(Venues, Unique_Cities) :-
    maplist(venue_city, Venues, Cities),
    sort(Cities, Unique_Cities).

venues_states(Venues, Unique_States) :-
    maplist(venue_state, Venues, States),
    sort(States, Unique_States).

dates_months(Dates, Unique_Months) :-
    maplist(date_month, Dates, Months),
    sort(Months, Unique_Months).

dates_days(Dates, Unique_Days) :-
    maplist(date_day, Dates, Days),
    sort(Days, Unique_Days).

dates_years(Dates, Unique_Years) :-
    maplist(date_year, Dates, Years),
    sort(Years, Unique_Years).
