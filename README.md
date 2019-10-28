# DevOPSimus

## How to use

1. Install erlang, make, rebar3
2. Generate certs using `scripts/gen_ssl.sh` and place them in `priv/ssl`
3. Add config in `config/sys.conf` as follows:
    ```
        {devopsimus,[
        {base_url,"https://login.microsoftonline.com/<tenant id>/saml2"},
        {issuer,"<app name>"},
        {callback, "https://localhost:8443/login/saml"},
        {idp_arn, "arn:aws:iam::<aws account id>:saml-provider/<provider name>"},
        {role_arn, "arn:aws:iam::<aws account id>:role/<role name>"},
        {duration_seconds, 3600}
    ]}
    ```
4. Run `make run`
5. Navigate to `https://localhost:8443/`
