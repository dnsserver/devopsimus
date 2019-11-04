-module(devopsimus_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
    Routes = [
              {'_',[
                    {"/login/saml", saml_handler,[]},
                    {"/tools", tools_handler, []},
                    {"/",index_handler,[]}
                   ]
              }
             ],
    Dispatch = cowboy_router:compile(Routes),
    PrivDir = code:priv_dir(devopsimus),
	{ok, _} = cowboy:start_tls(my_https_listener, [
            {port, 8443},
            {cacertfile, PrivDir ++ "/ssl/ca.crt"},
            {certfile, PrivDir ++ "/ssl/server.crt"},
            {keyfile, PrivDir ++ "/ssl/server.key"}
        ],
        #{env => #{dispatch => Dispatch}}
    ),
    session_utils:start(),
    %cowboy_session:start(),
	devopsimus_sup:start_link().

stop(_State) ->
    ok = cowboy:stop_listener(my_https_listener).
