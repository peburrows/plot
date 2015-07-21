defmodule Plot.Query do
  defstruct name: nil, objects: []

  def new(query) do
    {:query, name, objects} = query
    %Plot.Query{
      name:    name,
      objects: Plot.Object.new(objects)
    }
  end
end