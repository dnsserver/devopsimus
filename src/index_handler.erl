-module(index_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    {ok, Body} = index_dtl:render([{application_name, "DevOPSimus"}]),
    Repl = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>}, Body, Req),
    {ok, Repl, State}.
