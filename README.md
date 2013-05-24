# Eventcore

Eventcore is the core notification application of the Simple Real Time
Notification System. It is a simple implementation of publish/subscribe pattern
over the WebSocket protocol.


## Getting Started

You need to have a redis server running on the default port for this to work.

If you do not have redis on your system:

    git clone https://github.com/antirez/redis
	cd redis
	make
	make test
	./src/redis-server

You should have a redis server running by now. Now we will fetch the application
and all its dependencies:

    git clone https://github.com/swvist/eventcore
	cd eventcore/
	wget http://cloud.github.com/downloads/basho/rebar/rebar && chmod u+x rebar
	./rebar get-deps

Now we are ready to compile and execute the eventcore application:

    ./rebar compile
	erl -s crypto -pa ebin/ deps/*/ebin/


## I got the application running. Now what? (Client Quickstart)

If you do not see any weird error messages, you have the server running.
Congrats! But where is the client? All the communication happens over the
WebSocket protocol so all you need is a WebSocket client. Fire up the latest
version of Chrome and start the console (ctrl+shift+i). In the console:

    var ws = new WebSocket("ws://127.0.0.1:8080/websocket");
	ws.onmessage  = function(d){console.log(d.data);};
	ws.send("register:testclient");
	ws.send("subscribe:testchannel");

Congrats, you have got the client running as well. Now to see some pub/sub
action, go to the terminal where the eventcore application is running and hit
enter till you receive the prompt. Once you have that, you can publish messages
to the *testchannel* and the chrome client, subscribed to that channel, should
receive the message:

    channel:publish("testchannel", <<"Test Message for the Chrome cleint">>).

Now go check the Chrome console. Voila! You get the message and everything is
working fine. If not, ping me.


## How it works?

The clients connect to the WebSocket server and registers online with a
username. There is no authorization and no client can reserve a username (This
works more or less like IRC). Any client is free to register with any available
username which is a string of characters. Once registered the client can
subscribe to different channels.

Whenever the publisher publishes a message to a channel, all online clients
subscribed to that channel will receive the message. Currently the clients
cannot publish to a channel. There is an Erlang API which can be used to publish
to the channel. In the near future publishing support will be added to the
communication protocol and a RESTful API is also in the pipeline. See
**Roadmap** for more details. All the data like presence information and channel
subscription information is stored in the Redis data store.


## (Client) Communication Protocol

The (websocket) client talks to the server with a simple text protocol that is
described below:

Register a client on the server
    register:<USERNAME>

Subscribe to a channel (Only a registered client can do this)
    subscribe:<CHANNEL_NAME>


## Erlang API

The Erlang API allows publishers to publish messages to different channels.

Publish API
    channel:publish(<CHANNEL_NAME>, <MESSAGE>).

*Note*: CHANNEL_NAME is a string and the MESSAGE is a binary term.


## Future Roadmap

* Extending the comm protocol to allow the client to publish and unsubscribe.
 * Adding a HTTP API to publish messages.
 * Tests, tests & more tests!
 * Get a new name. This one was a code name and is not very intutive.
 * Release! (That should make this 0.1)
 * Allow different backends. Probably one simple ets/mensia to begin with.
 * Think about what can be added to this list!

## Contribute

Fork & send a pull request. Be descriptive :)

## Authors

Vipin Nair (swvist) <swvist@gmail.com>

## License

Eventcore is available under MIT License. Eventcore uses Poolboy which is in public domain and Eredis which is under the MIT License.
