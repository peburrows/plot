defimpl Plot.Resolution, for: Plot.Object do
  def resolve(%Plot.Object{name: "user"} = _obj, _context) do
    %{"firstName" => "Phil", "lastName" => "Burrows", dontInclude: "this"}
  end

  def resolve(%Plot.Object{name: "birthday"}, _context) do
    %{"day" => 15, "month" => 12, "year" => 2015}
  end
end

defmodule Plot.ResolverTest do
  use ExUnit.Case
  alias Plot.Resolver

  test "resolution of a simple user query" do
    doc = "{user { firstName, lastName }}" |> Plot.parse_and_generate

    assert [%{"user" => %{"firstName" => "Phil", "lastName" => "Burrows"}}] == Resolver.resolve(Enum.at(doc.operations, 0))
  end

  test "resolution of a user with a birthday" do
    doc = "{user {firstName, lastName, birthday {month, year}}}" |> Plot.parse_and_generate
    assert [%{"user" => %{"firstName" => "Phil", "lastName" => "Burrows", "birthday" => %{"month" => 12, "year" => 2015}}}] ==
            Resolver.resolve(Enum.at(doc.operations, 0))
  end
end
