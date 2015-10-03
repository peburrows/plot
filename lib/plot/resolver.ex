defprotocol Plot.Resolution do
  @doc "returns the resolved graphql"
  @fallback_to_any true
  def resolve(obj, parent)
end

defimpl Plot.Resolution, for: Any do
  def resolve(%Plot.Field{}=field, parent, context \\ %{}) do
    context |> Dict.put(field.name, parent[field.name])
  end
end

defmodule Plot.Resolver do
  alias Plot.Object
  alias Plot.Field
  alias Plot.Resolution

  def resolve(query) do
    # loop through all the objects in the query, and resolve them
    _resolve_objects(query.objects, [], query)
  end

  # defp new_resolve_objs([], _query, acc), do: acc
  # defp new_resolve_objs([head|tail], query, acc) do
  #   new_resolve_objs(tail, query, [_resolve(head, query)|acc])
  # end

  defp _resolve_objects([], acc, _query), do: acc
  defp _resolve_objects([head|tail], acc, query) do
    _resolve_objects(tail, [_resolve(head, Resolution.resolve(head, query))|acc], query)
  end

  defp _resolve(%Object{} = object, context) do
    %{} |> Map.put(object.alias || object.name, _resolve_fields(object.fields, context, %{}))
  end

  defp _resolve_fields([], _context, acc), do: acc
  defp _resolve_fields([head|tail], context, acc) do
    _resolve_fields(tail, context, Dict.merge(acc, Resolution.resolve(head, context)))
  end
end
