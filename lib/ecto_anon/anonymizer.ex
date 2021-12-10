defmodule EctoAnon.Anonymizer do
  def anonymized_data(%mod{} = struct) do
    anon_fields = mod.__anon_fields__()

    for {field, func} <- anon_fields, into: %{} do
      type = mod.__schema__(:type, field)
      value = Map.get(struct, field)

      {field, func.({type, value})}
    end
  end
end
