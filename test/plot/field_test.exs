defmodule PlotFieldTest do
  use ExUnit.Case
  test "simple tuple" do
    assert [%Plot.Field{name: :firstName}] = {:field, :firstName, nil, []} |> Plot.Field.new
  end

  test "multiple args" do
    # keep in mind that attrs get reversed because of head|tail concats
    assert [
      %Plot.Field{name: :middleName},
      %Plot.Field{name: :lastName},
      %Plot.Field{name: :firstName}
    ] = [{:field, :firstName, nil, []}, {:field, :lastName, nil, []}, {:field, :middleName, nil, []}] |> Plot.Field.new
  end

  test "with alias" do
    assert [
      %Plot.Field{alias: :pic, name: :profilePic}
    ] = [{:field, :profilePic, :pic, []}] |> Plot.Field.new
  end

  test "with args" do
    assert [
      %Plot.Field{name: :profilePic,
                  args: [%Plot.Arg{key: :height, value: {:number, 400}},
                         %Plot.Arg{key: :width, value: {:number, 200}}]}
      ] = [{:field, :profilePic, nil, [width: {:number, 200}, height: {:number, 400}]}] |> Plot.Field.new
  end
end
