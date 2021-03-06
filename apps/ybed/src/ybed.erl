-module(ybed).
-export([start/0, start/2, run/0]).
-include("yaws_api.hrl").
		
start() ->
    {ok, spawn(?MODULE, run, [])}.

start(_, Args) ->
    {ok, spawn(?MODULE, run, Args)}.

run() ->
    Id = "embedded",
    GconfList = [{id, Id}],
    Docroot = "/tmp",
    SconfList = [{port, 8888},
                 {servername, "foobar"},
                 {listen, {0,0,0,0}},
                 {docroot, Docroot}],
    {ok, SCList, GC, ChildSpecs} =
        yaws_api:embedded_start_conf(Docroot, SconfList, GconfList, Id),
    [supervisor:start_child(ybed_sup, Ch) || Ch <- ChildSpecs],
    yaws_api:setconf(GC, SCList),
    {ok, self()}.
