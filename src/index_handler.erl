-module(index_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    {Login, Repl0} = session_utils:is_authenticated(Req),
    {ok, Body} = index_dtl:render([{application_name, "DevOPSimus"},{login, Login}]),
    Repl = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>}, Body, Repl0),
    {ok, Repl, State}.
