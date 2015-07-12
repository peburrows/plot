defmodule Plot.Mutation do
  defstruct name: nil, objects: []

  def new(doc) do
    {:mutation, name, objects} = doc
    %Plot.Mutation{
      name:    name,
      objects: Plot.Object.from_doc(objects)
    }
  end
end