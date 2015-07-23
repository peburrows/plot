Definitions.

WHITESPACE = [\s\t\n\r]
KEY        = [_A-Za-z][_0-9A-Za-z]*
BUILTINS   = (String|Int|Float|Boolean|ID|Url)
KEY        = [_A-Za-z][_0-9A-Za-z]*

Rules.

type              : {token, {type,      TokenLine}}.
interface         : {token, {interface, TokenLine}}.
union             : {token, {union,     TokenLine}}.
enum              : {token, {enum,      TokenLine}}.
{BUILTINS}        : {token, {builtin,   TokenLine, list_to_atom(TokenChars)}}.
{KEY}             : {token, {key,       TokenLine, list_to_atom(TokenChars)}}.
:                 : {token, {':',       TokenLine}}.
!                 : {token, {'!',       TokenLine}}.
\(                : {token, {'(',       TokenLine}}.
\)                : {token, {')',       TokenLine}}.
{                 : {token, {'{',       TokenLine}}.
}                 : {token, {'}',       TokenLine}}.
,                 : {token, {',',       TokenLine}}.
\.                : {token, {'.',       TokenLine}}.
\[                : {token, {'[',       TokenLine}}.
\]                : {token, {']',       TokenLine}}.
{WHITESPACE}+     : skip_token.

Erlang code.
