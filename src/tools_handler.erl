-module(tools_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    {Data, Repl0} = session_utils:read(aws, Req),
    {ok, Body} = tools_dtl:render([{data, Data}]),
    Repl = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>}, Body, Repl0),
    {ok, Repl, State}.


