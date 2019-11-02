-module(index_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    Cookies = cowboy_req:parse_cookies(Req),
    
    SessionID = case lists:keyfind(<<"sessionid">>, 1, Cookies) of
                     false ->
                         generate_session_id();
                     {_, SID} ->
                         SID
                 end,
    Repl0 = cowboy_req:set_resp_cookie(<<"sessionid">>, SessionID, Req),

    {ok, Body} = index_dtl:render([{application_name, "DevOPSimus"},
                                   {session_id, SessionID}]),
    Repl = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>}, Body, Repl0),
    {ok, Repl, State}.

generate_session_id() ->
    base64:encode(crypto:strong_rand_bytes(32)).
