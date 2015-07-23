defmodule Plot.Schema do
  def parse(string) do
    string |> lex |> :graphql_schema_parser.parse
  end

  def lex(string) do
    {:ok, lexed, _} = string |> String.to_char_list |> :graphql_schema_lexer.string
    lexed
  end
end