Plot
====
A GraphQL parser and resolver for Elixir.

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
# returns:
{:ok,
[{:query, nil,
  [{:object, "user", nil, [],
    [{:field, "id", nil, []},
     {:field, "firstName", nil, []},
     {:field, "lastName", nil, []}]}]}]}
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
# returns:
%Plot.Document{fragments: [],
 operations: [%Plot.Query{name: nil,
 objects:    [%Plot.Object{alias: nil, args: [], name: "user",
              fields: [%Plot.Field{alias: nil, args: [], name: "lastName"},
                       %Plot.Field{alias: nil, args: [], name: "firstName"},
                       %Plot.Field{alias: nil, args: [], name: "id"}]}]}],
variables:   []}
```

### Query resolution

Query resolution works via Elixir protocols. Implement the `Resolution` protocol for the various nodes of your queries.

```elixir
# Implementation
defimpl Plot.Resolution, for: Plot.Object do
  def resolve(%Plot.Object{name: "user"} = _obj, _context) do
    %{"firstName" => "Phil", "lastName" => "Burrows", dontInclude: "this"}
  end

  def resolve(%Plot.Object{name: "birthday"}, _context) do
    %{"day" => 15, "month" => 12, "year" => 2015}
  end
end

# Resolution
doc = "{user {firstName, lastName, birthday {month, year}}}" |> Plot.parse_and_generate
doc.operations |> Enum.at(0) |> Plot.Resolver.resolve
# returns:
[%{"user" => %{"birthday" => %{"month" => 12, "year" => 2015},
   "firstName" => "Phil", "lastName" => "Burrows"}}]
```
