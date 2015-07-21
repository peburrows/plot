Nonterminals document objects object arglist args arg value.
Terminals '{' '}' '(' ')' ',' ':' key number boolean query mutation variable string.
Rootsymbol document.

document -> '{' '}'                             : #query{}.
document -> query key '{' objects '}'           : #query{name=value('$2'), objects='$4'}.
document -> '{' objects '}'                     : #query{objects='$2'}.

document -> mutation key '{' objects '}'        : #mutation{name=value('$2'), objects='$4'}.

objects -> object                               : ['$1'].
objects -> object ',' objects                   : ['$1'|'$3'].

% without aliases
object  -> key                                  : #attr{name=value('$1')}.
object  -> key arglist                          : #attr{name=value('$1'), args='$2'}.
object  -> key '{' objects '}'                  : #object{name=value('$1'), children='$3'}.
object  -> key arglist '{' objects '}'          : #object{name=value('$1'), args='$2', children='$4'}.

% with aliases
object  -> key ':' value                        : #attr{name=value('$3'), alias=value('$1')}.
object  -> key ':' key arglist                  : #attr{name=value('$3'), alias=value('$1'), args='$4'}.
object  -> key ':' key '{' objects '}'          : #object{name=value('$3'), alias=value('$1'), children='$5'}.
object  -> key ':' key arglist '{' objects '}'  : #object{name=value('$3'), alias=value('$1'), args='$4', children='$6' }.

% frag_ref-> '.' '.' '.' key                      : {frag_ref, }

arglist  -> '(' ')'                             : [].
arglist  -> '(' args ')'                        : '$2'.

args     -> arg                                 : ['$1'].
args     -> arg ',' args                        : ['$1'|'$3'].

arg      -> key ':' value                       : {value('$1'), '$3'}.

value -> variable                               : {variable, value('$1')}.
value -> string                                 : {string,   value('$1')}.
value -> number                                 : {number,   value('$1')}.
value -> boolean                                : {boolean,  value('$1')}.

Erlang code.

value({_Token, _Line, Value}) -> Value.
token({Token, _Line, _Value}) -> Token.

% this seems like a nice idea, but I'm not sure I want to deal with it...
-record(query,    {name=nil, objects=[]}).
-record(mutation, {name=nil, objects=[]}).
-record(object,   {name=nil, alias=nil, args=[], children=[]}).
-record(attr,     {name=nil, alias=nil, args=[]}).
-record(arg,      {key=nil,  value=nil}).
-record(frag_ref, {name=nil}).