Definitions.

INT        = [0-9]+
FLOAT      = [0-9]+(\.[0-9]+)?
STRING     = [_A-Za-z][_0-9A-Za-z]*
VARIABLE   = \$[_A-Za-z][_0-9A-Za-z]*
% this isn't quite right, unfortunately
QUOTEDSTRING = "([^\\"]|\\\\|\\")*"
VARIABLE   = \$[_A-Za-z][_0-9A-Za-z]*
WHITESPACE = [\s\t\n\r]

Rules.

{INT}         : {token, {number,TokenLine, list_to_integer(TokenChars)}}.
{FLOAT}       : {token, {number,TokenLine, list_to_float(TokenChars)}}.
query         : {token, {query, TokenLine, list_to_atom(TokenChars)}}.
mutation      : {token, {mutation, TokenLine, list_to_atom(TokenChars)}}.
schema        : {token, {schema, TokenLine, list_to_atom(TokenChars)}}.
true          : {token, {boolean, TokenLine, true}}.
false         : {token, {boolean, TokenLine, false}}.
{STRING}      : {token, {string,TokenLine, list_to_atom(TokenChars)}}.
{VARIABLE}    : {token, {variable, TokenLine, list_to_atom(TokenChars)}}.
% {QUOTEDSTRING}: {token, {quoted_string, TokenLine, list_to_atom(TokenChars)}}.
{VARIABLE}    : {token, {variable, TokenLine, list_to_atom(TokenChars)}}.
:             : {token, {':',   TokenLine}}.
\(            : {token, {'(',   TokenLine}}.
\)            : {token, {')',   TokenLine}}.
{             : {token, {'{',   TokenLine}}.
}             : {token, {'}',   TokenLine}}.
,             : {token, {',',   TokenLine}}.
\.            : {token, {'.',   TokenLine}}.
{WHITESPACE}+ : skip_token.

Erlang code.
