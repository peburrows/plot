defmodule PlotArgTest do
  use ExUnit.Case

  test "single arg" do
    assert [
      %Plot.Arg{key: :id, value: {:number, 4}}
    ] = [id: {:number, 4}] |> Plot.Arg.new
  end

  test "list of args from parsed args" do
    list = [{:number, 4}, {:string, "phil"}, {:variable, :whatever}]
    assert [
      %Plot.Arg{key: :things, value: ^list}
    ] = [things: list] |> Plot.Arg.new
  end
end