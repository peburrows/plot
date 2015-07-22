defmodule Plot do
  def parse(string) do
    string |> lex |> :graphql_parser.parse
  end

  def lex(string) do
    {:ok, lexed, _} = string |> String.to_char_list |> :graphql_lexer.string
    lexed
  end

  def fields(string) do
    string |> lex |> parse |> Plot.Field.from_doc
  end

  def parse_and_generate(doc) do
    case parse(doc) do
      {:ok, ast} -> Plot.Document.new(ast)
      err        -> err
    end
  end
end
