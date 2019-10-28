-module(page_utils).
-export([show_page/3,show_error/3]).

show_page(Body, Req, State) ->
    Repl = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>}, Body, Req),
    {ok, Repl, State}.


show_error(#{<<"error">> := Error, <<"error_description">> := ErrorDescription}, 
            Req, State) ->
    Repl = cowboy_req:reply(200,
        #{<<"content-type">> => <<"text/plain">>},
        ["Error page! ",Error, " ",ErrorDescription], Req),
    {ok, Repl, State};
show_error(Msg, Req, State) when is_list(Msg) ->
    Repl = cowboy_req:reply(200,
        #{<<"content-type">> => <<"text/plain">>},
        ["Error page: ",Msg], Req),
    {ok, Repl, State}.