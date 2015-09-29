defprotocol Plot.Resolution do
  @doc "returns the resolved graphql"
  @fallback_to_any true
  def resolve(obj, parent)
end

defimpl Plot.Resolution, for: Any do
  # we only want to allow this for fields, I think
  def resolve(field, parent) do
    Dict.put(%{}, field.name, parent[field.name])
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

  defp _resolve_objects([], acc, query), do: acc
  defp _resolve_objects([head|tail], acc, query) do
    # we should resolve each object at a time, here
    _resolve_objects(tail, [_resolve(head, Resolution.resolve(head, query))|acc], query)
  end

  defp _resolve(%Object{} = object, context) do
    # do what query things you need to do here
    _resolve_fields(object.fields, context, %{})
  end

  # defp _resolve(%Field{} = field, parent) do
  #   parent[field.name]
  # end

  defp _resolve_fields([], context, acc), do: acc
  defp _resolve_fields([head|tail], context, acc) do
    # _resolve_fields(tail, [_resolve(head, obj)|acc], obj)
    _resolve_fields(tail, context, Dict.merge(acc, Resolution.resolve(head, context)))
  end
end
