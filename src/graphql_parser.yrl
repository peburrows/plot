Nonterminals documents document objects object arglist args arg value fragref array list.
Terminals '{' '}' '(' ')' '[' ']' ',' ':' '.' key number boolean query mutation variable string fragment on.
Rootsymbol documents.

documents -> document                           : ['$1'].
documents -> document documents                 : ['$1'|'$2'].

document -> '{' '}'                             : #query{}.
document -> query key '{' objects '}'           : #query{name=value('$2'), objects='$4'}.
document -> '{' objects '}'                     : #query{objects='$2'}.

document -> mutation key '{' objects '}'        : #mutation{name=value('$2'), objects='$4'}.

document -> fragment key on key '{' objects '}' : #fragment{name=value('$2'), type=value('$4'), objects='$6'}.

objects  -> object                               : ['$1'].
objects  -> object ',' objects                   : ['$1'|'$3'].

% without aliases
object   -> fragref                              : '$1'.
object   -> key                                  : #field{name=value('$1')}.
object   -> key arglist                          : #field{name=value('$1'), args='$2'}.
object   -> key '{' objects '}'                  : #object{name=value('$1'), children='$3'}.
object   -> key arglist '{' objects '}'          : #object{name=value('$1'), args='$2', children='$4'}.
object   -> '.' '.' '.' on key '{' objects '}'   : #fragment{type=value('$5'), objects='$7'}.

% with aliases
object   -> key ':' value                        : #field{name=value('$3'), alias=value('$1')}.
object   -> key ':' key arglist                  : #field{name=value('$3'), alias=value('$1'), args='$4'}.
object   -> key ':' key '{' objects '}'          : #object{name=value('$3'), alias=value('$1'), children='$5'}.
object   -> key ':' key arglist '{' objects '}'  : #object{name=value('$3'), alias=value('$1'), args='$4', children='$6' }.

fragref  -> '.' '.' '.' key                      : #fragref{name=value('$4')}.

arglist  -> '(' ')'                              : [].
arglist  -> '(' args ')'                         : '$2'.

args     -> arg                                  : ['$1'].
args     -> arg ',' args                         : ['$1'|'$3'].

% arg      -> key ':' value                        : {value('$1'), '$3'}.
% insert the key as the first element of the tuple returned via the value
arg      -> key ':' value                        : erlang:insert_element(1, '$3', value('$1')).

array    -> '[' ']'                              : [].
array    -> '[' list ']'                         : '$2'.

list     -> value                                : ['$1'].
list     -> value ',' list                       : ['$1'|'$3'].

value    -> array                                : {array, '$1'}.
value    -> variable                             : {variable, value('$1')}.
value    -> string                               : {string,   stringvalue('$1')}.
value    -> number                               : {number,   value('$1')}.
value    -> boolean                              : {boolean,  value('$1')}.

Erlang code.

value({_Token, _Line, Value}) -> Value.
stringvalue({_Token, _Line, Value}) -> list_to_binary(Value).
% token({Token, _Line, _Value}) -> Token.

% this seems like a nice idea, but I'm not sure I want to deal with it...
-record(query,    {name=nil, objects=[]}).
-record(mutation, {name=nil, objects=[]}).
-record(object,   {name=nil, alias=nil, args=[], children=[]}).
-record(field,    {name=nil, alias=nil, args=[]}).
-record(arg,      {key=nil,  value=nil, type=nil}).
-record(fragref,  {name=nil}).
-record(fragment, {name=nil, type=nil, objects=[]}).
