-module(rev_eval).

-export([eval/1,expr/2, exprs/1]).

eval(StrExp) ->
  {ok, ParsedExps, _} = erl_scan:string(StrExp),
  {ok, TypedExps} = erl_parse:parse_exprs(ParsedExps),
  %eval:expr(TypedExp, orddict:new()).
  EvPid = spawn(rev_eval, exprs, [TypedExps]),
  register(ev, EvPid).

exprs(Es) ->
  F = fun (E, Bs) -> expr(E,Bs) end,
  lists:foldl(F, orddict:new(), Es).

expr(E, Bs) ->
  % RefId = make_ref(),
  % tracer ! {RefId, E, Bs},
  io:format("~p ~p~n",[E, Bs]),
  receive
    cont ->
      case (catch eval:expr(E, Bs)) of
        {value, NE, NBs} -> expr(NE, NBs);
        _ -> Bs
      end
  end.