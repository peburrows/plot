Nonterminals document objects object arglist args arg value.
Terminals '{' '}' '(' ')' ',' ':' key number boolean query mutation variable.
Rootsymbol document.

% might want to consider building maps here instead of plain tuples. Maybe.
% document -> '{' '}'                             : #{kind=>'query', alias=>nil, fields=>[]}.
% document -> '{' '}'                             : {'query', nil, []}.
document -> '{' '}'                             : #query{}.
% document -> query key '{' objects '}'           : {'query', value('$2'), '$4'}.
document -> query key '{' objects '}'           : #query{name=value('$2'), objects='$4'}.
% document -> '{' objects '}'                     : {'query', nil, '$2'}.
document -> '{' objects '}'                     : #query{objects='$2'}.

% document -> mutation key '{' objects '}'        : {mutation, value('$2'), '$4'}.
document -> mutation key '{' objects '}'        : #mutation{name=value('$2'), objects='$4'}.

objects -> object                               : ['$1'].
objects -> object ',' objects                   : ['$1'|'$3'].

% without aliases
% we might want to get rid of the first object in the tuple
% object  -> key                                  : {field, value('$1'), nil, [], []}.
object  -> key                                  : #attr{name=value('$1')}.
% object  -> key arglist                          : {field, value('$1'), nil, '$2', []}.
object  -> key arglist                          : #attr{name=value('$1'), args='$2'}.
% object  -> key '{' objects '}'                  : {object, value('$1'), nil, [], '$3'}.
object  -> key '{' objects '}'                  : #object{name=value('$1'), children='$3'}.
% object  -> key arglist '{' objects '}'          : {object, value('$1'), nil, '$2', '$4'}.
object  -> key arglist '{' objects '}'          : #object{name=value('$1'), args='$2', children='$4'}.

% with aliases
% object  -> key ':' value                        : {object, value('$3'), value('$1'), [], []}.
object  -> key ':' value                        : #object{name=value('$3'), alias=value('$1')}.
% object  -> key ':' key arglist                  : {object, value('$3'), value('$1'), '$4', []}.
object  -> key ':' key arglist                  : #object{name=value('$3'), alias=value('$1'), args='$4'}.
% object  -> key ':' key '{' objects '}'          : {object, value('$3'), value('$1'), [], '$5'}.
object  -> key ':' key '{' objects '}'          : #object{name=value('$3'), alias=value('$1'), children='$5'}.
% object  -> key ':' key arglist '{' objects '}'  : {object, value('$3'), value('$1'), '$4', '$6'}.
object  -> key ':' key arglist '{' objects '}'  : #object{name=value('$3'), alias=value('$1'), args='$4', children='$6' }.

% frag_ref-> '.' '.' '.' key                      : {frag_ref, }

arglist  -> '(' ')'                             : [].
arglist  -> '(' args ')'                        : '$2'.

args     -> arg                                 : ['$1'].
args     -> arg ',' args                        : ['$1'|'$3'].

arg      -> key ':' value                       : {value('$1'), '$3'}.

value -> variable                               : {variable, value('$1')}.
value -> number                                 : {number,   value('$1')}.
value -> boolean                                : {boolean,  value('$1')}.

Erlang code.

value({_Token, _Line, Value}) -> Value.
token({Token, _Line, _Value}) -> Token.

% this seems like a nice idea, but I'm not sure I want to deal with it...
-record(query,    {name=nil, objects=[]}).
-record(mutation, {name=nil, objects=[]}).
-record(object,   {name=nil, alias=nil, args=[], children=[]}).
-record(attr,     {name=nil, args=[]}).
-record(arg,      {key=nil,  value=nil}).
-record(frag_ref, {name=nil}).