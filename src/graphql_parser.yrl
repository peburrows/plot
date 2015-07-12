Nonterminals document objects object arglist args arg field.
Terminals '{' '}' '(' ')' ',' ':' string number boolean query mutation.
Rootsymbol document.

document -> '{' '}'                             : {'query', nil, []}.
document -> query string '{' objects '}'        : {'query', value('$2'), '$4'}.
document -> '{' objects '}'                     : {'query', nil, '$2'}.

document -> mutation string '{' objects '}'     : {mutation, value('$2'), '$4'}.

objects -> object                               : ['$1'].
objects -> object ',' objects                   : ['$1'|'$3'].

% without aliases
object  -> string                               : {value('$1'), nil, [], []}.
object  -> string arglist                       : {value('$1'), nil, '$2', []}.
object  -> string '{' objects '}'               : {value('$1'), nil, [], '$3'}.
object  -> string arglist '{' objects '}'       : {value('$1'), nil, '$2', '$4'}.

% with aliases
object  -> string ':' string                    : {value('$3'), value('$1'), [], []}.
object  -> string ':' string arglist            : {value('$3'), value('$1'), '$4', []}.
object  -> string ':' string '{' objects '}'    : {value('$3'), value('$1'), [], '$5'}.
object  -> string ':' string arglist '{' objects '}' : {value('$3'), value('$1'), '$4', '$6'}.

arglist  -> '(' ')'                             : [].
arglist  -> '(' args ')'                        : '$2'.

args     -> arg                                 : ['$1'].
args     -> arg ',' args                        : ['$1'|'$3'].

arg      -> string ':' field                    : {value('$1'), '$3'}.

field -> string                                 : value('$1').
field -> number                                 : value('$1').
field -> boolean                                : value('$1').

Erlang code.

value({_Token, _Line, Value}) -> Value.

% this seems like a nice idea, but I'm not sure I want to deal with it...
-record(field, {name, alias=nil, args=[], fields=[]}).