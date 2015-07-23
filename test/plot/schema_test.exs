defmodule PlotSchemaTest do
  use ExUnit.Case

  defp read_fixture(name) do
    Path.expand("test/fixtures/" <> name <> ".gql") |> File.read!
  end

  test "basic type declaration" do
    assert {:ok,
      [{:type, :User, nil,
        [
          {:firstName, :String, false},
          {:lastName,  :String, false}
        ]
      }]
    } = read_fixture("schema/user") |> Plot.Schema.parse
  end

  test "required fields" do
    assert {:ok,
      [{:type, :User, nil,
        [
          {:guid, :ID, true},
          {:nickname, :String, false}
        ]
      }]
    } = read_fixture("schema/user-with-required-fields") |> Plot.Schema.parse
  end

  test "type with non-builtin type" do
    assert {:ok,
      [{:type, :User, nil,
        [
          {:guid, :ID, true},
          {:address, :Address, false}
        ]
      }]
    } = read_fixture("schema/user-with-address") |> Plot.Schema.parse
  end

  test "type with list field" do
    assert {:ok,
      [{:type, :User, nil,
        [
          {:guid,  :ID, true},
          # I don't know if this is actually how we want to do this...
          {:books, [:Book], false}
        ]
      }]
    } = read_fixture("schema/user-with-books") |> Plot.Schema.parse
  end
end