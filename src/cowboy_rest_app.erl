%%%-------------------------------------------------------------------
%% @doc cowboy_rest public API
%% @end
%%%-------------------------------------------------------------------

-module(cowboy_rest_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            %% All files
            {"/metadata", metadata_rest_handler, []},
            %% Get metadata for a specific filename
            {"/metadata/:filename", metadata_rest_handler, []},
            % Get metdata for a file from a certain node
            {"/metdata/:node/:filename", metadata_rest_handler, []},

            {"/all/files", metadata_rest_handler, []},
            %
            {"/all/files/:filename", file_rest_handler, []}
        ]}
    ]),

    {ok, _} = cowboy:start_clear(rest_http_listener, [{port, 8092}], #{env => #{dispatch => Dispatch}})

    cowboy_rest_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
