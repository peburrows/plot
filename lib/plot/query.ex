defmodule Plot.Query do
  defstruct name: nil, objects: [] #, variables: []

  def new(doc) do
    {:query, name, objects} = doc
    %Plot.Query{
      name:    name,
      objects: Plot.Object.from_doc(objects)
    }
  end

end