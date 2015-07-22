defmodule Plot.Fragment do
  defstruct name: nil, on: nil, fields: []

  def new(frag) do
    {:fragment, name, on, fields} = frag
    %Plot.Fragment{
      name:   name,
      on:     on,
      fields: fields
    }
  end

end