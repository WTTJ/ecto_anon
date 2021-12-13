defmodule EctoAnon.Anonymizer do
  def anonymized_data(struct) do
    case anonymizable_struct?(struct) do
      true -> {:ok, get_anonymized_data(struct)}
      false -> {:error, :non_anonymizable_struct}
    end
  end

  defp anonymizable_struct?(%module{}), do: {:__anon_fields__, 0} in module.__info__(:functions)

  defp get_anonymized_data(%module{} = struct) do
    module.__anon_fields__()
    |> Enum.reduce([], fn {field, func}, acc ->
      type = module.__schema__(:type, field)
      value = Map.get(struct, field)

      Keyword.put(acc, field, func.({type, value}))
    end)
  end
end
