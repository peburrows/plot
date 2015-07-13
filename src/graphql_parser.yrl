Nonterminals document objects object arglist args arg value.
Terminals '{' '}' '(' ')' ',' ':' key number boolean query mutation variable.
Rootsymbol document.

document -> '{' '}'                             : {'query', nil, []}.
document -> query key '{' objects '}'        : {'query', value('$2'), '$4'}.
document -> '{' objects '}'                     : {'query', nil, '$2'}.

document -> mutation key '{' objects '}'     : {mutation, value('$2'), '$4'}.

objects -> object                               : ['$1'].
objects -> object ',' objects                   : ['$1'|'$3'].

% without aliases
object  -> key                               : {value('$1'), nil, [], []}.
object  -> key arglist                       : {value('$1'), nil, '$2', []}.
object  -> key '{' objects '}'               : {value('$1'), nil, [], '$3'}.
object  -> key arglist '{' objects '}'       : {value('$1'), nil, '$2', '$4'}.

% with aliases
object  -> key ':' value                     : {value('$3'), value('$1'), [], []}.
% object  -> key ':' variable                  : {value('$3'), value('$1'), [], []}.
object  -> key ':' key arglist            : {value('$3'), value('$1'), '$4', []}.
object  -> key ':' key '{' objects '}'    : {value('$3'), value('$1'), [], '$5'}.
object  -> key ':' key arglist '{' objects '}' : {value('$3'), value('$1'), '$4', '$6'}.

arglist  -> '(' ')'                             : [].
arglist  -> '(' args ')'                        : '$2'.

args     -> arg                                 : ['$1'].
args     -> arg ',' args                        : ['$1'|'$3'].

arg      -> key ':' value                    : {value('$1'), '$3'}.

% value -> variable                               : value('$1').
% value -> number                                 : value('$1').
% value -> boolean                                : value('$1').

value -> variable                               : {variable, value('$1')}.
value -> number                                 : {number,   value('$1')}.
value -> boolean                                : {boolean,  value('$1')}.

Erlang code.

value({_Token, _Line, Value}) -> Value.
token({Token, _Line, _Value}) -> Token.

% this seems like a nice idea, but I'm not sure I want to deal with it...
-record(field, {name, alias=nil, args=[], fields=[]}).