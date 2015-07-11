Definitions.

INT        = [0-9]+
FLOAT      = [0-9]+(\.[0-9]+)?
STRING     = [_A-Za-z][_0-9A-Za-z]*
WHITESPACE = [\s\t\n\r]

Rules.

{INT}         : {token, {number,TokenLine, list_to_integer(TokenChars)}}.
{FLOAT}       : {token, {number,TokenLine, list_to_float(TokenChars)}}.
{STRING}      : {token, {string,TokenLine, list_to_atom(TokenChars)}}.
:             : {token, {':',   TokenLine}}.
\(            : {token, {'(',   TokenLine}}.
\)            : {token, {')',   TokenLine}}.
{             : {token, {'{',   TokenLine}}.
}             : {token, {'}',   TokenLine}}.
,             : {token, {',',   TokenLine}}.
{WHITESPACE}+ : skip_token.

Erlang code.
