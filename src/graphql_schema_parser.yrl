Nonterminals declarations declaration typelist typedef arglist args arg.
Terminals '{' '}' '[' ']' '(' ')' ':' '!' ',' type key builtin interface.
Rootsymbol declarations.

declarations -> declaration                   : ['$1'].
declarations -> declaration declarations      : ['$1'|'$2'].

declaration  -> type key '{' typelist '}'     : #type{name=value('$2'), fields='$4'}.
declaration  -> interface key '{' typelist '}': #interface{name=value('$2'), fields='$4'}.

typelist     -> typedef                       : ['$1'].
typelist     -> typedef typelist              : ['$1'|'$2'].

arglist      -> '(' ')'                       : [].
arglist      -> '(' args ')'                  : '$2'.

args         -> arg                           : ['$1'].
args         -> arg ',' args                  : ['$1'|'$3'].

arg          -> key ':' builtin               : {value('$3'), value('$1')}.

% builtins
typedef      -> key ':' '[' builtin ']'       : {value('$1'), [], list,   {builtin, value('$4')}, false}.
typedef      -> key ':' builtin '!'           : {value('$1'), [], scalar, {builtin, value('$3')}, true}.
typedef      -> key ':' builtin               : {value('$1'), [], scalar, {builtin, value('$3')}, false}.

% builtins w/args
typedef      -> key arglist ':' '[' builtin ']': {value('$1'), '$2', list,   {builtin, value('$5')}, false}.
typedef      -> key arglist ':' builtin '!'    : {value('$1'), '$2', scalar, {builtin, value('$4')}, true}.
typedef      -> key arglist ':' builtin        : {value('$1'), '$2', scalar, {builtin, value('$4')}, false}.

% custom types
typedef      -> key ':' '[' key ']'           : {value('$1'), [], list,   {custom, value('$4')}, false}.
typedef      -> key ':' key '!'               : {value('$1'), [], object, {custom, value('$3')}, true}.
typedef      -> key ':' key                   : {value('$1'), [], object, {custom, value('$3')}, false}.

% custom types w/args
typedef      -> key arglist ':' '[' key ']'   : {value('$1'), '$2', list,   {custom, value('$5')}, false}.
typedef      -> key arglist ':' key '!'       : {value('$1'), '$2', object, {custom, value('$4')}, true}.
typedef      -> key arglist ':' key           : {value('$1'), '$2', object, {custom, value('$4')}, false}.

Erlang code.
value({_Token, _Line, Value}) -> Value.

-record(type,        {name=nil, interface=nil, fields=[]}).
-record(interface,   {name=nil, fields=[]}).
-record(field,       {name=nil, type=nil, required=false}).