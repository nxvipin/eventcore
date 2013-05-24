-module(channel).

%% Subscription API

-export([create/2,
		 get_owner/1,
		 exists/1]).

%% Channel Data API

-export([subscribe/2,
		 is_subscribed/2,
		 unsubscribe/2,
		 publish/2
		]).

-define(RPOOL, {global, redispool}).

%% Channel Data API Definitions

												% Channel API

create(Channel, User) ->
    redis_pool:set(?RPOOL, "owner:"++Channel, User).

get_owner(Channel) ->
    redis_pool:get(?RPOOL, "owner:"++Channel).

exists(Channel) ->
    case get_owner(Channel) of
		{ok, undefined} ->
			false;
		{ok, _Owner} ->
			true;
		{_, _} ->
			{error, "channel:exist/2, Unknown Error"}
    end.


												% Subscription API

subscribe(Channel, User) ->
    redis_pool:sadd(?RPOOL, "subscribe:"++Channel, User).

is_subscribed(Channel, User) ->
    redis_pool:sismember(?RPOOL, "subscribe:"++Channel, User).

unsubscribe(Channel, User)->
    redis_pool:srem(?RPOOL, "subscribe:"++Channel, User).

publish(Channel, Message) ->
	{ok, Subscribers} = redis_pool:smembers(?RPOOL, "subscribe:"++Channel),
	Subscriber_Process =
		lists:map(
		  fun(S) ->
				  {ok, UserProcess} = redis_pool:get(?RPOOL, "presence:"++S),
				  UserProcess
		  end,
		  Subscribers),
	Online_Subscribers =
		lists:filter(
		  fun(P) ->
				  case P of
					  undefined ->
						  false;
					  _ ->
						  true
				  end
		  end,
		  Subscriber_Process),
	lists:map(
	  fun(P) ->
			  PID = list_to_pid(binary_to_list(P)),
			  PID ! Message
	  end,
	  Online_Subscribers).
