Nonterminals document fragments fragment arglist args arg field.
Terminals '{' '}' '(' ')' ',' ':' string int.
Rootsymbol document.

document -> '{' '}'           : [].
document -> '{' fragments '}' : '$2'.

fragments -> fragment               : ['$1'].
fragments -> fragment ',' fragments : ['$1'|'$3'].

% without aliases
fragment  -> string                 : {value('$1'), nil, [], []}.
fragment  -> string arglist         : {value('$1'), nil, '$2', []}.
fragment  -> string document        : {value('$1'), nil, [], '$2'}.
fragment  -> string arglist document: {value('$1'), nil, '$2', '$3'}.

% with aliases
fragment  -> string ':' string             : {value('$3'), value('$1'), [], []}.
fragment  -> string ':' string arglist     : {value('$3'), value('$1'), '$4', []}.
fragment  -> string ':' string document    : {value('$3'), value('$1'), [], '$4'}.
fragment  -> string ':' string arglist document : {value('$3'), value('$1'), '$4', '$5'}.

arglist  -> '(' ')'         : [].
arglist  -> '(' args ')'    : '$2'.

args     -> arg             : ['$1'].
args     -> arg ',' args    : ['$1'|'$3'].

arg      -> string ':' field : {value('$1'), '$3'}.

field -> string : value('$1').
field -> int    : value('$1').


% {}
% document -> '{' '}'                             : [].
% document -> '{' fieldlist '}'                   : [{'$2', [], []}].
% document -> '{' fieldlist document '}'          : [{'$2', [], '$3'}].
% document -> '{' fieldlist arglist '}'           : [{'$2', '$3', []}].
% document -> '{' fieldlist arglist document '}'  : [{'$2', '$3', '$4'}].

% fieldlist -> field                              : value('$1').
% fieldlist -> field ',' fieldlist                : ['$1'|'$3'].

% arglist  -> '(' ')'                 : [].
% arglist  -> '(' arg ')'             : ['$2'].
% arglist  -> '(' arg ',' arglist ')' : ['$2'|'$4'].

% arg      -> field ':' field         : {value('$1'), value('$3')}.
% arg      -> field ':' int           : {value('$1'), value('$3')}.
% arg      -> field                   : {value('$1')}.
% arg      -> int                     : {value('$1')}.

Erlang code.

value({_Token, _Line, Value}) -> Value.

% we might want to eventually create a selection set similar to this
% the problem, though, is that it seems to come to Elixir as a tuple
-record(selection_set, {name, args=[], fields=[]}).

% Nonterminals list elems elem.
% Terminals '[' ']' ',' int atom.
% Rootsymbol list.

% list -> '[' ']'       : [].
% list -> '[' elems ']' : '$2'.

% elems -> elem           : ['$1'].
% elems -> elem ',' elems : ['$1'|'$3'].

% elem -> int  : extract_token('$1').
% elem -> atom : extract_token('$1').
% elem -> list : '$1'.

% Erlang code.

% extract_token({_Token, _Line, Value}) -> Value.