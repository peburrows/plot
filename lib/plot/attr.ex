defmodule Plot.Attr do
  defstruct name: nil, alias: nil, args: []

  def new(attr_list) when is_list(attr_list), do: _from_attr_list(attr_list, [])
  def new(attr_list), do: _from_attr_list([attr_list], [])

  defp _from_attr_list([], acc), do: acc
  defp _from_attr_list([head|tail], acc) do
    _from_attr_list(tail, [_from_tuple(head) |acc])
  end

  defp _from_tuple(attr) do
    {:attr, name, al, args} = attr
    %Plot.Attr{
      name:  name,
      alias: al,
      args:  args
    }
  end
end