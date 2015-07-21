defmodule PlotAttrTest do
  use ExUnit.Case
  test "simple tuple" do
    assert [%Plot.Attr{name: :firstName}] = {:attr, :firstName, nil, []} |> Plot.Attr.new
  end

  test "multiple args" do
    # keep in mind that attrs get reversed because of head|tail concats
    assert [
      %Plot.Attr{name: :middleName},
      %Plot.Attr{name: :lastName},
      %Plot.Attr{name: :firstName}
    ] = [{:attr, :firstName, nil, []}, {:attr, :lastName, nil, []}, {:attr, :middleName, nil, []}] |> Plot.Attr.new
  end

  test "with alias" do
    assert [
      %Plot.Attr{alias: :pic, name: :profilePic}
    ] = [{:attr, :profilePic, :pic, []}] |> Plot.Attr.new
  end
end