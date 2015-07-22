defmodule Plot.Object do
  defstruct name: nil, alias: nil, args: [], fields: []

  def new(objs) when is_list(objs), do: _from_list(objs, [])
  def new(objs), do: _from_list([objs], [])

  defp _from_list([], acc), do: acc
  defp _from_list([head|tail], acc) do
    _from_list(tail, [_from_tuple(head) | acc])
  end

  defp _from_tuple(t) do
    {:object, name, al, args, attrs} = t
    %Plot.Object{
      name:   name,
      alias:  al,
      args:   Plot.Arg.new(args),
      fields: Plot.Field.new(attrs)
    }
  end
end