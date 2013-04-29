-module(presence).

-export([create/2, delete/1]).

-define(RPOOL, {global, redispool}).

create(Username, UserProcess)->
    redis_pool:set(?RPOOL, "presence:"++Username, UserProcess),
    redis_pool:set(?RPOOL, "process:"++UserProcess, Username).

delete(UserProcess) ->
	Del = "process:" ++ UserProcess,
	{ok, Username} = redis_pool:get(?RPOOL, Del),
	redis_pool:del(?RPOOL, Del),
	redis_pool:del(?RPOOL, "presence:" ++ Username),
	ok.
