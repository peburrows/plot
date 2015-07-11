defmodule PlotTest do
  use ExUnit.Case

  defp read_fixture(name) do
    Path.expand("test/fixtures/" <> name <> ".gql") |> File.read!
  end

  test "empty doc" do
    assert {:ok, []} = Plot.parse("{}")
  end

  test "{user}" do
    assert {:ok,
      [ {:user, nil, [], []} ]
    } = Plot.parse("{user}")
  end

  test "{user(id: 4)}" do
    assert {:ok,
      [ {:user, nil, [id: 4], []} ]
    } = Plot.parse("{user(id: 4)}")
  end

  test "{user {name}}" do
    assert {:ok,
      [{:user, nil, [], [{:name, nil, [], []}]}]
    } = "{user {name}}" |> Plot.parse
  end

  test "basic user with field" do
    assert {:ok,
      [ {:user, nil, [id: 4], [{:name, nil, [], []}]} ]
    } = read_fixture("user") |> Plot.parse
  end

  test "{user, loser, jim}" do
    assert {:ok,
      [
        {:user,  nil, [], []},
        {:loser, nil, [], []},
        {:jim,   nil, [], []}
      ]
    } = "{user, loser, jim}" |> Plot.parse
  end

  test "user with field with args" do
    assert {:ok,
      [
        {:user, nil, [id: 4], [
          {:id, nil, [], []},
          {:name, nil, [], []},
          {:profilePic, nil, [width: 100, height: 50], []}
        ]}
      ]
    } = read_fixture("user-with-field-args") |> Plot.parse
  end

  test "user with nested field" do
    assert {:ok,
      [
        {
          :user, nil, [id: 4], [
            {:id, nil, [], []},
            {:firstName, nil, [], []},
            {:lastName,  nil, [], []},
            {:birthday,  nil, [], [
                {:month, nil, [], []},
                {:day,   nil, [], []}
              ]
            }
          ]
        }
      ]
    } = read_fixture("user-with-bday") |> Plot.parse
  end

  test "user with top level alias" do
    assert {:ok,
      [
        {:user, :phil, [id: 4], [
          {:id,   nil, [], []},
          {:name, nil, [], []}
        ]}
      ]
    } = read_fixture("user-with-top-level-alias") |> Plot.parse
  end

  test "user with field aliases" do
    assert {:ok,
      [
        {:user, nil, [id: 4], [
          {:id, nil, [], []},
          {:name, nil, [], []},
          {:profilePic, :smallPic, [size: 64], []},
          {:profilePic, :bigPic, [size: 1024], []}
        ]}
      ]
    } = read_fixture("user-with-field-aliases") |> Plot.parse
  end
end