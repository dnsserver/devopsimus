-module(saml_utils).
-export([get_auth_url/0, try_aws_saml/1]).

-define(APPNAME, devopsimus).

get_auth_url() ->
    {ok, BaseUrl} = application:get_env(?APPNAME,base_url),
    {ok, Callback} = application:get_env(?APPNAME,callback),
    {ok, Issuer} = application:get_env(?APPNAME,issuer),

    {{Year, Month, Day}, {Hour, Min, Sec}} = calendar:universal_time(),
    Date = list_to_binary(io_lib:format("~.4.0w-~.2.0w-~.2.0wT~.2.0w:~.2.0w:~.2.0w.0+00:00", 
                                [Year, Month, Day, Hour, Min, Sec])),
    SamlRequest = ["<samlp:AuthnRequest xmlns=\"urn:oasis:names:tc:SAML:2.0:metadata\" ",
                    "ID=\"F84D888AA3B44C1B844375A4E8210D9E\" Version=\"2.0\" IssueInstant=\"",
                    Date,"\" IsPassive=\"false\" AssertionConsumerServiceURL=\"",Callback,
                    "\" xmlns:samlp=\"urn:oasis:names:tc:SAML:2.0:protocol\" ForceAuthn=\"false\">",
                    "<Issuer xmlns=\"urn:oasis:names:tc:SAML:2.0:assertion\">",Issuer,
                    "</Issuer></samlp:AuthnRequest>"],
    
    Base64String = base64:encode(zlib:zip(SamlRequest)),
    U = http_uri:encode(Base64String),
    [BaseUrl|["?SAMLRequest="|U]].

try_aws_saml(SAMLResponse) ->
    {ok, IdpARN} = application:get_env(?APPNAME,idp_arn),
    {ok, RoleARN} = application:get_env(?APPNAME,role_arn),
    {ok, DurationSeconds} = application:get_env(?APPNAME, duration_seconds),
    {ok, Conf} = erlcloud_aws:profile(),
    erlcloud_sts:assume_role_with_saml(Conf,
        IdpARN,
        RoleARN, 
        "devopsimus", DurationSeconds, SAMLResponse).