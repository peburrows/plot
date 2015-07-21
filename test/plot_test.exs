defmodule PlotTest do
  use ExUnit.Case

  defp read_fixture(name) do
    Path.expand("test/fixtures/" <> name <> ".gql") |> File.read!
  end

  test "empty doc" do
    assert {:ok, {:query, nil, []}} = Plot.parse("{}")
  end

  test "{user}" do
    assert {:ok,
      {:query, nil, [ {:attr, :user, nil, []} ]}
    } = Plot.parse("{user}")
  end

  test "{user(id: 4)}" do
    assert {:ok,
      {:query, nil, [ {:attr, :user, nil, [id: {:number, 4}]} ] }
    } = Plot.parse("{user(id: 4)}")
  end

  test "{user {name}}" do
    assert {:ok,
      {:query, nil, [{:object, :user, nil, [], [{:attr, :name, nil, []}]}] }
    } = "{user {name}}" |> Plot.parse
  end

  test "basic user with field" do
    assert {:ok,
      {:query, nil,
        [ {:object, :user, nil, [id: {:number, 4}], [{:attr, :name, nil, []}]} ]
      }
    } = read_fixture("user") |> Plot.parse
  end

  test "{user, loser, jim}" do
    assert {:ok,
      {:query, nil,
        [
          {:attr, :user,  nil, []},
          {:attr, :loser, nil, []},
          {:attr, :jim,   nil, []}
        ]
      }
    } = "{user, loser, jim}" |> Plot.parse
  end

  test "user with field with args" do
    assert {:ok,
      {:query, nil,
        [
          {:object, :user, nil, [id: {:number, 4}], [
            {:attr, :id, nil, []},
            {:attr, :name, nil, []},
            {:attr, :profilePic, nil, [width: {:number, 100}, height: {:number, 50}]}
          ]}
        ]
      }
    } = read_fixture("user-with-field-args") |> Plot.parse
  end

  test "user with nested field" do
    assert {:ok,
      {:query, nil,
        [
          {
            :object, :user, nil, [id: {:number, 4}], [
              {:attr, :id, nil, []},
              {:attr, :firstName, nil, []},
              {:attr, :lastName,  nil, []},
              {:object, :birthday,  nil, [], [
                  {:attr, :month, nil, []},
                  {:attr, :day,   nil, []}
                ]
              }
            ]
          }
        ]
      }
    } = read_fixture("user-with-bday") |> Plot.parse
  end

  test "user with top level alias" do
    assert {:ok,
      {:query, nil, [
        {:object, :user, :phil, [id: {:number, 4}], [
          {:attr, :id,   nil, []},
          {:attr, :name, nil, []}
        ]}
      ]}
    } = read_fixture("user-with-top-level-alias") |> Plot.parse
  end

  test "user with field aliases" do
    assert {:ok,
      {:query, nil,
        [
          {:object, :user, nil, [id: {:number, 4}], [
            {:attr, :id, nil, []},
            {:attr, :name, nil, []},
            {:attr, :profilePic, :smallPic, [size: {:number, 64}]},
            {:attr, :profilePic, :bigPic, [size: {:number, 1024}]}
          ]}
        ]
      }
    } = read_fixture("user-with-field-aliases") |> Plot.parse
  end

  test "user with query" do
    assert {:ok,
      {:query, :userQuery,
        [ {:attr, :user, nil, []} ]
      }
    } = "query userQuery {user}" |> Plot.parse
  end
end