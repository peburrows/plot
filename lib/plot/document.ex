defmodule Plot.Document do
  defstruct operations: [], variables: [], fragments: []

  def new(doc) do
    # %Plot.Document{operations: _extract_objs(doc, [])}
    {opts, vars, frags} = _extract_objs(doc, [], [], [])
    %Plot.Document{
      operations: opts,
      variables:  vars,
      fragments:  frags
    }
  end

  defp _extract_objs([], opts, vars, frags), do: {opts, vars, frags}

  defp _extract_objs([head|tail], opts, vars, frags) do
    # okay, so the accumulator is a Document
    case head do
      {:query,    _name, _objects} -> _extract_objs(tail, [Plot.Query.new(head) | opts], vars, frags)
      {:mutation, _name, _objects} -> _extract_objs(tail, [Plot.Mutation.new(head) | opts], vars, frags)
      {:variable, _name, _value}   -> _extract_objs(tail, opts, [Plot.Variable.new(head) | vars], frags)
      {:fragment, _name, _type, _objects} -> _extract_objs(tail, opts, vars, [Plot.Fragment.new(head) | frags])
    end
  end
end
