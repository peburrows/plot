defprotocol Plot.Resolution do
  @doc "returns the resolved graphql"
  @fallback_to_any true
  def resolve(obj, parent)
end

defimpl Plot.Resolution, for: Any do
  def resolve(%Plot.Field{}=field, parent, _context \\ %{}) do
    parent[field.name]
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

  defp _resolve_objects([], acc, _query), do: acc
  defp _resolve_objects([head|tail], acc, query) do
    _resolve_objects(tail, [_resolve(head, Resolution.resolve(head, query))|acc], query)
  end

  defp _resolve(%Object{} = object, context) do
    %{} |> Map.put(object.alias || object.name, _resolve_fields(object.fields, context, %{}))
  end

  defp _resolve_fields([], _context, acc), do: acc
  defp _resolve_fields([head|tail], context, acc) do
    case head do
      %Object{} -> _resolve_fields(tail, context, Dict.merge(acc, _resolve(head, Resolution.resolve(head, context))))
      _field    -> _resolve_fields(tail, context, Dict.put(acc, head.alias || head.name, Resolution.resolve(head, context)))
    end
  end
end
