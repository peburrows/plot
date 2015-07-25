Nonterminals declarations declaration typelist typedef.
Terminals '{' '}' '[' ']' ':' '!' type key builtin.
Rootsymbol declarations.

declarations -> declaration                   : ['$1'].
declarations -> declaration declarations      : ['$1'|'$2'].

declaration  -> type key '{' typelist '}'     : #type{name=value('$2'), fields='$4'}.

typelist     -> typedef                       : ['$1'].
typelist     -> typedef typelist              : ['$1'|'$2'].

% built-ins
typedef      -> key ':' '[' builtin ']'       : {value('$1'), list,   {builtin, value('$4')}, false}.
typedef      -> key ':' builtin '!'           : {value('$1'), scalar, {builtin, value('$3')}, true}.
typedef      -> key ':' builtin               : {value('$1'), scalar, {builtin, value('$3')}, false}.

% custom types
typedef      -> key ':' '[' key ']'           : {value('$1'), list,   {custom, value('$4')}, false}.
typedef      -> key ':' key '!'               : {value('$1'), object, {custom, value('$3')}, true}.
typedef      -> key ':' key                   : {value('$1'), object, {custom, value('$3')}, false}.

Erlang code.
value({_Token, _Line, Value}) -> Value.

-record(type,        {name=nil, interface=nil, fields=[]}).
-record(field,       {name=nil, type=nil, required=false}).