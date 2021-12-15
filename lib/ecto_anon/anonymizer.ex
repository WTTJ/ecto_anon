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
    |> Enum.reduce([], fn {field, {func, opts}}, acc ->
      type = module.__schema__(:type, field)

      value =
        case Map.get(struct, field) do
          nil -> nil
          value -> func.(type, value, opts)
        end

      Keyword.put(acc, field, value)
    end)
  end
end
