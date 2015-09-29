defimpl Plot.Resolution, for: Plot.Object do
  def resolve(%Plot.Object{name: "user"} = _obj, _context) do
    %{"firstName" => "Phil", "lastName" => "Burrows", dontInclude: "this"}
  end
end

defmodule Plot.ResolverTest do
  use ExUnit.Case
  alias Plot.Resolver

  test "resolution of a simple user query" do
    doc = "{user { firstName, lastName }}" |> Plot.parse_and_generate

    assert [%{"firstName" => "Phil", "lastName" => "Burrows"}] == Resolver.resolve(Enum.at(doc.operations, 0))
  end
end
