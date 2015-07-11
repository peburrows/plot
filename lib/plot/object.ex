defmodule Plot.Object do
  defstruct name: nil, alias: nil, fields: [], args: []

  def from_doc(doc), do: _from_doc(doc, [])

  defp _from_doc([], acc), do: acc
  defp _from_doc([head|tail], acc) do
    case elem(head, 3) do
      # if it has no fields, it's not object
      []      -> _from_doc(tail, [Plot.Field.from_field_tuple(head) | acc])
      _fields -> _from_doc(tail, [from_object_tuple(head) | acc])
    end
  end

  def from_object_tuple(t) do
    %Plot.Object{
      name:   elem(t, 0),
      alias:  elem(t, 1),
      args:   elem(t, 2),
      fields: from_doc( elem(t, 3) )
    }
  end
end