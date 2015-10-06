defmodule Plot.Field do
  defstruct name: nil, alias: nil, args: []

  def new(attr_list) when is_list(attr_list), do: _from_attr_list(attr_list, [])
  def new(attr_list), do: _from_attr_list([attr_list], [])

  defp _from_attr_list([], acc), do: acc
  defp _from_attr_list([head|tail], acc) do
    _from_attr_list(tail, [_from_tuple(head) |acc])
  end

  defp _from_tuple(attr) do
    case attr do
      {:object, _name, _al, _args, _fields} ->
        Enum.at(Plot.Object.new(attr), 0)
      {:field, name, al, args} ->
        %Plot.Field{
          name:  name,
          alias: al,
          args:  Plot.Arg.new(args)
        }
    end

  end
end
