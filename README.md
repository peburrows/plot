Plot
====
A GraphQL lexer and parser for Elixir.

This project is still a work in progress, but the eventual goal is to support the full GraphQL spec.

### Basic Usage

*Build a basic AST from a doc*
```elixir
"{
  user {
    id,
    firstName,
    lastName
  }
}" |> Plot.parse
# {:ok,
# [{:query, nil,
#   [{:object, "user", nil, [],
#     [{:field, "id", nil, []},
#      {:field, "firstName", nil, []},
#      {:field, "lastName", nil, []}]}]}]}
```

*Build Plot objects from a doc*
```elixir
"{
  user {
    id,
    firstName,
    lastName
  }
}" |> Plot.parse_and_generate
# %Plot.Document{fragments: [],
#  operations: [%Plot.Query{name: nil,
#  objects:    [%Plot.Object{alias: nil, args: [], name: "user",
#               fields: [%Plot.Field{alias: nil, args: [], name: "lastName"},
#                        %Plot.Field{alias: nil, args: [], name: "firstName"},
#                        %Plot.Field{alias: nil, args: [], name: "id"}]}]}],
# variables:   []}
```
