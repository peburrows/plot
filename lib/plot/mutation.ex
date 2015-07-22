defmodule Plot.Mutation do
  defstruct name: nil, objects: [] #, variables: []

  def new(mutation) do
    {:mutation, name, objects} = mutation
    %Plot.Mutation{
      name:    name,
      objects: Plot.Object.new(objects)
    }
  end
end