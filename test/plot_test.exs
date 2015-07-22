defmodule PlotTest do
  use ExUnit.Case

  defp read_fixture(name) do
    Path.expand("test/fixtures/" <> name <> ".gql") |> File.read!
  end

  test "empty doc" do
    assert {:ok, [{:query, nil, []}]} = Plot.parse("{}")
  end

  test "{user}" do
    assert {:ok,
      [{:query, nil, [ {:field, :user, nil, []} ]}]
    } = Plot.parse("{user}")
  end

  test "{user(id: 4)}" do
    assert {:ok,
      [{:query, nil, [ {:field, :user, nil, [id: {:number, 4}]} ] }]
    } = Plot.parse("{user(id: 4)}")
  end

  test "{user {name}}" do
    assert {:ok,
      [{:query, nil, [{:object, :user, nil, [], [{:field, :name, nil, []}]}] }]
    } = "{user {name}}" |> Plot.parse
  end

  test "basic user with field" do
    assert {:ok,
      [{:query, nil,
        [ {:object, :user, nil, [id: {:number, 4}], [{:field, :name, nil, []}]} ]
      }]
    } = read_fixture("user") |> Plot.parse
  end

  test "{user, loser, jim}" do
    assert {:ok,
      [{:query, nil,
        [
          {:field, :user,  nil, []},
          {:field, :loser, nil, []},
          {:field, :jim,   nil, []}
        ]
      }]
    } = "{user, loser, jim}" |> Plot.parse
  end

  test "user with field with args" do
    assert {:ok,
      [{:query, nil,
        [
          {:object, :user, nil, [id: {:number, 4}], [
            {:field, :id, nil, []},
            {:field, :name, nil, []},
            {:field, :profilePic, nil, [width: {:number, 100}, height: {:number, 50}]}
          ]}
        ]
      }]
    } = read_fixture("user-with-field-args") |> Plot.parse
  end

  test "user with nested field" do
    assert {:ok,
      [{:query, nil,
        [
          {
            :object, :user, nil, [id: {:number, 4}], [
              {:field, :id, nil, []},
              {:field, :firstName, nil, []},
              {:field, :lastName,  nil, []},
              {:object, :birthday,  nil, [], [
                  {:field, :month, nil, []},
                  {:field, :day,   nil, []}
                ]
              }
            ]
          }
        ]
      }]
    } = read_fixture("user-with-bday") |> Plot.parse
  end

  test "user with top level alias" do
    assert {:ok,
      [{:query, nil, [
        {:object, :user, :phil, [id: {:number, 4}], [
          {:field, :id,   nil, []},
          {:field, :name, nil, []}
        ]}
      ]}]
    } = read_fixture("user-with-top-level-alias") |> Plot.parse
  end

  test "user with field aliases" do
    assert {:ok,
      [{:query, nil,
        [
          {:object, :user, nil, [id: {:number, 4}], [
            {:field, :id, nil, []},
            {:field, :name, nil, []},
            {:field, :profilePic, :smallPic, [size: {:number, 64}]},
            {:field, :profilePic, :bigPic, [size: {:number, 1024}]}
          ]}
        ]
      }]
    } = read_fixture("user-with-field-aliases") |> Plot.parse
  end

  test "user with query" do
    assert {:ok,
      [{:query, :userQuery,
        [ {:field, :user, nil, []} ]
      }]
    } = "query userQuery {user}" |> Plot.parse
  end

  test "simple fragment ref" do
    assert {:ok,
      [{:query, nil,
        [{:object, :user, nil, [], [
          {:fragref, :myFrag}
        ]}]
      }]
    } = "{user { ...myFrag }}" |> Plot.parse
  end

  test "simple fragment" do
    assert {:ok,
      [{:fragment, :userName, :User,
        [
          {:field, :firstName, nil, []},
          {:field, :lastName,  nil, []}
        ]
      }]
    } = "fragment userName on User { firstName, lastName }" |> Plot.parse
  end

  test "inline fragment" do
    assert {:ok,
      [{:query, nil,
        [
          {:object, :user, nil, [],
            [
              {:fragment, nil, :User, [
                {:field, :firstName, nil, []},
                {:field, :lastName,  nil, []}
              ]}
            ]
          }
        ]
      }]
    } = "{user { ... on User {firstName, lastName} }}" |> Plot.parse
  end

  test "doc and fragment" do
    assert {:ok,
      [
        {:query, nil,
          [
            {:object, :user, nil, [], [
              {:field, :firstName, nil, []},
              {:field, :lastName,  nil, []},
              {:fragref, :otherFields}
            ]}
          ]
        },
        {:fragment, :otherFields, :User, [
            {:field, :id,         nil, []},
            {:field, :birthdate,  nil, []}
        ]}
      ]
    } = read_fixture("user-with-fragment") |> Plot.parse
  end
end