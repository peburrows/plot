Definitions.

INT        = [0-9]+
FLOAT      = [0-9]+(\.[0-9]+)?
KEY        = [_A-Za-z][_0-9A-Za-z]*
VARIABLE   = \$[_A-Za-z][_0-9A-Za-z]*
WHITESPACE = [\s\t\n\r]

Rules.

% double-quoted string
"[^"\\]*(\\.[^"\\]*)*" : {token, {string,   TokenLine, strip(TokenChars,TokenLen)}}.
{INT}                  : {token, {number,   TokenLine, list_to_integer(TokenChars)}}.
{FLOAT}                : {token, {number,   TokenLine, list_to_float(TokenChars)}}.
query                  : {token, {query,    TokenLine, list_to_atom(TokenChars)}}.
mutation               : {token, {mutation, TokenLine, list_to_atom(TokenChars)}}.
schema                 : {token, {schema,   TokenLine, list_to_atom(TokenChars)}}.
fragment               : {token, {fragment, TokenLine, list_to_atom(TokenChars)}}.
on                     : {token, {on,       TokenLine, list_to_atom(TokenChars)}}.
true                   : {token, {boolean,  TokenLine, true}}.
false                  : {token, {boolean,  TokenLine, false}}.
% {KEY}                  : {token, {key,      TokenLine, list_to_atom(TokenChars)}}.
% {VARIABLE}             : {token, {variable, TokenLine, variable_to_atom(TokenChars)}}.
{KEY}                  : {token, {key,      TokenLine, list_to_binary(TokenChars)}}.
{VARIABLE}             : {token, {variable, TokenLine, variable_to_binary(TokenChars)}}.
:                      : {token, {':',      TokenLine}}.
\(                     : {token, {'(',      TokenLine}}.
\)                     : {token, {')',      TokenLine}}.
{                      : {token, {'{',      TokenLine}}.
}                      : {token, {'}',      TokenLine}}.
,                      : {token, {',',      TokenLine}}.
\.                     : {token, {'.',      TokenLine}}.
\[                     : {token, {'[',      TokenLine}}.
\]                     : {token, {']',      TokenLine}}.
{WHITESPACE}+          : skip_token.

Erlang code.

variable_to_binary([$$|Chars]) -> list_to_binary(Chars).
strip(TokenChars,TokenLen)   -> lists:sublist(TokenChars, 2, TokenLen - 2).
