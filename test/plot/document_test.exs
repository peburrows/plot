defmodule DocumentTest do
  use ExUnit.Case
  test "Plot.Document.new creates a Plot.Document with nil default name" do
    {:ok, doc} = "{user{firstName, lastName}}" |> Plot.parse
    assert %Plot.Document{operations: objs} = Plot.Document.new(doc)
    assert 1 = length(objs)
  end

  test "Plot.Query.new creates a Plot.Query with the right name" do
    {:ok, doc} = "query userQuery {user{firstname}}" |> Plot.parse
    assert %Plot.Document{operations: objs} = Plot.Document.new(doc)
    assert 1 = length(objs)
  end
end
