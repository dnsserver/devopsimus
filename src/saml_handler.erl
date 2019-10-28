-module(saml_handler).
-behavior(cowboy_handler).

-export([init/2]).


init(Req, State) ->
    case cowboy_req:method(Req) of 
        <<"GET">> ->
            send_response({login, Req, State});
        <<"POST">> ->
            % Check for the code in the params submitted
            {ok, Body, _Req} = cowboy_req:read_urlencoded_body(Req),
            {_, C} = lists:keyfind(<<"SAMLResponse">>, 1, Body),
            send_response({response,C, Req, State})
    end.
            

send_response({login, Req, State}) ->
    Repl = cowboy_req:reply(303, 
                            #{<<"location">> => saml_utils:get_auth_url()},
                            Req),
        {ok, Repl, State};

send_response({response, SAMLResponse, Req, State}) ->
    {_AwsConf, Resp} = saml_utils:try_aws_saml(SAMLResponse),
    {ok, Body} = loginsaml_dtl:render(Resp),
    page_utils:show_page(Body, Req, State).
    




    

