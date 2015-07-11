Definitions.

INT        = [0-9]+
STRING     = [_A-Za-z][_0-9A-Za-z]*
WHITESPACE = [\s\t\n\r]

Rules.

{STRING}      : {token, {string,TokenLine, list_to_atom(TokenChars)}}.
{INT}         : {token, {int,   TokenLine, list_to_integer(TokenChars)}}.
:             : {token, {':',   TokenLine}}.
\(            : {token, {'(',   TokenLine}}.
\)            : {token, {')',   TokenLine}}.
{             : {token, {'{',   TokenLine}}.
}             : {token, {'}',   TokenLine}}.
,             : {token, {',',   TokenLine}}.
{WHITESPACE}+ : skip_token.

Erlang code.
