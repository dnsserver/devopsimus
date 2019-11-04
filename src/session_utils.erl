-module(session_utils).

-export([get_session/1, store/3, read/2, start/0, is_authenticated/1]).

get_session(Req) ->
    Cookies = cowboy_req:parse_cookies(Req),
    
    SessionID = case lists:keyfind(<<"sessionid">>, 1, Cookies) of
                     false ->
                         generate_session_id();
                     {_, SID} ->
                         SID
                 end,
    Repl0 = cowboy_req:set_resp_cookie(<<"sessionid">>, SessionID, Req),
    {SessionID, Repl0}.

generate_session_id() ->
    base64:encode(crypto:strong_rand_bytes(32)).

start() ->
    session = ets:new(session, [set, named_table, public]).

store(Key, Data, Req) ->
    {SessionID, Repl0} = session_utils:get_session(Req),
    true = ets:insert(session, {{SessionID,Key}, Data}),
    {ok, Repl0}.

read(Key, Req) ->
    {SessionID, Repl0} = session_utils:get_session(Req),
    D = ets:lookup(session, {SessionID,Key}),
    {D, Repl0}.

is_authenticated(Req) ->
    case read(login, Req) of 
        {[], Repl0} -> Login = false;
        {[_], Repl0} -> Login = true
    end,
    {Login, Repl0}.