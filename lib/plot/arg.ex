defmodule Plot.Arg do
  defstruct key: nil, value: nil

  def new(arg_list) when is_list(arg_list), do: _from_arg_list(arg_list, [])
  def new(arg_list), do: _from_arg_list([arg_list], [])

  defp _from_arg_list([], acc), do: acc
  defp _from_arg_list([head|tail], acc) do
    _from_arg_list(tail, [_from_tuple(head) | acc])
  end

  defp _from_tuple(t) do
    {name, value} = t
    %Plot.Arg{
      key:   name,
      value: value
    }
  end
end