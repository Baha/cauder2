-module(rev_eval).

-export([eval/1]).

eval(StrExp) ->
  {ok, ParsedExp, _} = erl_scan:string(StrExp),
  {ok, [TypedExp]} = erl_parse:parse_exprs(ParsedExp),
  eval:expr(TypedExp, orddict:new()).

% expr(E, Bs) ->
%   RefId = make_ref()
%   tracer ! {RefId, E, Bs},
%   Res =
%     receive
%       continue ->
%         eval:expr(E, Bs);
%       {continue, Val} ->
%         Val
%     end,
%   Res.