PROJECT = devopsimus
PROJECT_DESCRIPTION = Simple Web Application for AWS Temp credentials with SAML.
PROJECT_VERSION = 0.2.0

DEPS = cowboy jsx erlydtl erlcloud
dep_erlydtl = git https://github.com/erlydtl/erlydtl 0.12.1
dep_erlcloud = git https://github.com/dnsserver/erlcloud.git master
#dep_erlcloud = ln $PATH_TO_ERLCLOUD/erlcloud
dep_cowboy = git https://github.com/ninenines/cowboy 2.7.0
dep_jsx = git https://github.com/talentdeficit/jsx v2.8.0

DEP_PLUGINS = cowboy

# used for debugging; needs to be installed before
LOCAL_DEPS = debugger wx

ERLC_OPTS = +debug_info
include erlang.mk
