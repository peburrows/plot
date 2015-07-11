defmodule PlotTest do
  use ExUnit.Case

  defp read_fixture(name) do
    Path.expand("test/fixtures/" <> name <> ".gql") |> File.read!
  end

  test "empty doc" do
    assert {:ok, []} =
      Plot.parse("{}")
  end

  test "{user}" do
    assert {:ok,
      [{:user, [], []}]
    } = Plot.parse("{user}")
  end

  test "{user(id: 4)}" do
    assert {:ok,
      [ {:user, [id: 4], []} ]
    } = Plot.parse("{user(id: 4)}")
  end

  test "{user {name}}" do
    assert {:ok,
      [{:user, [], [{:name, [], []}]}]
    } = "{user {name}}" |> Plot.parse
  end

  test "basic user with field" do
    assert {:ok,
      [ {:user, [id: 4], [{:name, [], []}]} ]
    } = read_fixture("user") |> Plot.parse
  end

  test "{user, loser, jim}" do
    assert {:ok,
      [
        {:user,  [], []},
        {:loser, [], []},
        {:jim,   [], []}
      ]
    } = "{user, loser, jim}" |> Plot.parse
  end

  test "user with field with args" do
    assert {:ok,
      [
        {:user, [id: 4], [
          {:id, [], []},
          {:name, [], []},
          {:profilePic, [width: 100, height: 50], []}
        ]}
      ]
    } = read_fixture("user-with-field-args") |> Plot.parse
  end

  test "user with nested field" do
    assert {:ok,
      [
        {
          :user, [id: 4], [
            {:id, [], []},
            {:firstName, [], []},
            {:lastName,  [], []},
            {:birthday,  [], [
                {:month, [], []},
                {:day,   [], []}
              ]
            }
          ]
        }
      ]
    } = read_fixture("user-with-bday") |> Plot.parse
  end
end