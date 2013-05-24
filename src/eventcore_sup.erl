
-module(eventcore_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(Name, I, Type, Options), {Name, {I, start_link, [Options]}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
	PresenceHandler = ?CHILD(gen_event_presence,
							 gen_event,
							 worker,
							 {global, presence_handler}),
	ChannelHandler = ?CHILD(gen_event_channel,
							gen_event,
							worker,
							{global, channel_handler}),
    {ok, { {one_for_one, 5, 10}, [PresenceHandler, ChannelHandler]}}.
