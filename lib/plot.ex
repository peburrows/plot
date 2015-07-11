defmodule Plot do
  def parse(list) do
    {:ok, lexed, _} = list |> String.to_char_list |> :graphql_lexer.string
    # IO.inspect lexed
    parsed = lexed |> :graphql_parser.parse
    # IO.inspect parsed
    parsed
  end
end
