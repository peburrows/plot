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

  def fields(string) do
    string |> lex |> parse |> Plot.Field.from_doc
  end

  def parse_and_generate(doc) do
    case doc do
      {:query,    _name, _doc} -> Plot.Query.new(doc)
      {:mutation, _name, _doc} -> Plot.Mutation.new(doc)
    end
  end

end
