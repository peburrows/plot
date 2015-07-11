defmodule Plot.Field do
  defstruct name: nil, alias: nil, attrs: [], args: []

  def from_doc(doc), do: _from_doc(doc, [])

  defp _from_doc([], acc), do: acc
  defp _from_doc([head|tail], acc) do
    _from_doc(tail, [from_field_tuple(head) | acc])
  end

  defp from_field_tuple(f) do
    %Plot.Field{
      name:  elem(f, 0),
      alias: elem(f, 1),
      args:  elem(f, 2),
      attrs: from_doc( elem(f, 3) )
    }
  end
end