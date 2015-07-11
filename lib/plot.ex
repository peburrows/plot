defmodule Plot do
  def parse(string) do
    lexed = string |> lex |> :graphql_parser.parse
    # IO.inspect lexed
    # lexed
  end

  def lex(string) do
    {:ok, lexed, _} = string |> String.to_char_list |> :graphql_lexer.string
    lexed
  end
end
