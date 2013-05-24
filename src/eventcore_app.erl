-module(eventcore_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    {ok, PID} = eventcore_sup:start_link(),
	gen_event:add_handler({global, presence_handler}, presence_handler, []),
	gen_event:add_handler({global, channel_handler}, channel_handler, []),
	{ok, PID}.

stop(_State) ->
    ok.
