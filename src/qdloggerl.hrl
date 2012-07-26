%% LOG LEVEL.
-ifdef(DEBUG).
-define(LOG_LEVEL, 4).
-else.
-ifndef(LOG_LEVEL).
-define(LOG_LEVEL, 3).
-endif.
-endif.

%% Log levels
-define(LOG_LEVEL_DEBUG, 4).	%% D: All log information is printed.
-define(LOG_LEVEL_INFO, 3).	%% I: Errors, warnings, information.
-define(LOG_LEVEL_WARN, 2).	%% W: Errors and warnings are printed
-define(LOG_LEVEL_ERROR, 1).	%% E: Only errors are printed
-define(LOG_LEVEL_FATAL, 0).	%% F: Only fatal error are printed

%% Logging utilities
-ifndef(NOLOG). %% If NOLOG is defined, no logs will be generated, regardless of LOG_LEVEL.
%% Function is enclosed to avoid variable name collisions
-define(LOG_(Level, Tag, Msg),
	(fun(___Level, ___Tag, ___Msg, ___Loc) ->
		if ___Level =< ?LOG_LEVEL ->
			___PrintableLevel = (case ___Level of ?LOG_LEVEL_FATAL -> "F"; ?LOG_LEVEL_ERROR -> "E"; ?LOG_LEVEL_WARN -> "W"; ?LOG_LEVEL_INFO -> "I"; ?LOG_LEVEL_DEBUG -> "D" end),
	        	{{___Y, ___M, ___D}, {___h, ___m, ___s}} = calendar:now_to_local_time(now()),
			{current_function, {___Mod, ___Fun, _}} = ___Loc,
		        ___MsgH = io_lib:format("[~s][~b/~2..0b/~2..0b-~2..0b:~2..0b:~2..0b][~w:~w:~w] ~s :: ", [___PrintableLevel, ___Y, ___M, ___D, ___h, ___m, ___s, ___Mod, ___Fun, ?LINE, ___Tag]),
			io:format("~s~s~n", [___MsgH, string:join(string:tokens(lists:flatten(___Msg), "\r\n"), io_lib:format("~n~s", [___MsgH]))]);
		true ->
			ok
		end
	end)(Level, Tag, Msg, process_info(self(), current_function))).
-define(LOG_(Level, Tag, Format, Data), ?LOG_(Level, Tag, io_lib:format(Format, Data))).
-else.
-define(LOG_(A,B,C), ok).
-define(LOG_(A,B,C,D), ok).
-endif.
-define(LOG_D(Tag, Msg), ?LOG_(?LOG_LEVEL_DEBUG, Tag, Msg)).
-define(LOG_D(Tag, Format, Data), ?LOG_(?LOG_LEVEL_DEBUG, Tag, Format, Data)).
-define(LOG_I(Tag, Msg), ?LOG_(?LOG_LEVEL_INFO, Tag, Msg)).
-define(LOG_I(Tag, Format, Data), ?LOG_(?LOG_LEVEL_INFO, Tag, Format, Data)).
-define(LOG_W(Tag, Msg), ?LOG_(?LOG_LEVEL_WARN, Tag, Msg)).
-define(LOG_W(Tag, Format, Data), ?LOG_(?LOG_LEVEL_WARN, Tag, Format, Data)).
-define(LOG_E(Tag, Msg), ?LOG_(?LOG_LEVEL_ERROR, Tag, Msg)).
-define(LOG_E(Tag, Format, Data), ?LOG_(?LOG_LEVEL_ERROR, Tag, Format, Data)).
-define(LOG_F(Tag, Msg), ?LOG_(?LOG_LEVEL_FATAL, Tag, Msg)).
-define(LOG_F(Tag, Format, Data), ?LOG_(?LOG_LEVEL_FATAL, Tag, Format, Data)).

%% Log defaults to info
-define(LOG(Tag, Msg), ?LOG_I(Tag, Msg)).
-define(LOG(Tag, Format, Data), ?LOG_I(Tag, Format, Data)).
