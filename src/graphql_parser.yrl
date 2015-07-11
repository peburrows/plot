Nonterminals document fragments fragment arglist args arg field.
Terminals '{' '}' '(' ')' ',' ':' string int.
Rootsymbol document.

document -> '{' '}'                             : [].
document -> '{' fragments '}'                   : '$2'.

fragments -> fragment                           : ['$1'].
fragments -> fragment ',' fragments             : ['$1'|'$3'].

% without aliases
fragment  -> string                             : {value('$1'), nil, [], []}.
fragment  -> string arglist                     : {value('$1'), nil, '$2', []}.
fragment  -> string document                    : {value('$1'), nil, [], '$2'}.
fragment  -> string arglist document            : {value('$1'), nil, '$2', '$3'}.

% with aliases
fragment  -> string ':' string                  : {value('$3'), value('$1'), [], []}.
fragment  -> string ':' string arglist          : {value('$3'), value('$1'), '$4', []}.
fragment  -> string ':' string document         : {value('$3'), value('$1'), [], '$4'}.
fragment  -> string ':' string arglist document : {value('$3'), value('$1'), '$4', '$5'}.

arglist  -> '(' ')'                             : [].
arglist  -> '(' args ')'                        : '$2'.

args     -> arg                                 : ['$1'].
args     -> arg ',' args                        : ['$1'|'$3'].

arg      -> string ':' field                    : {value('$1'), '$3'}.

field -> string                                 : value('$1').
field -> int                                    : value('$1').


Erlang code.

value({_Token, _Line, Value}) -> Value.

% this seems like a nice idea, but I'm not sure I want to deal with it...
-record(field, {name, alias=nil, args=[], fields=[]}).