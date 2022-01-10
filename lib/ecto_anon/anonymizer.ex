defmodule EctoAnon.Anonymizer do
  def anonymized_data(struct) do
    case anonymizable_struct?(struct) do
      true -> {:ok, get_anonymized_data(struct)}
      false -> {:error, :non_anonymizable_struct}
    end
  end

  defp anonymizable_struct?(%module{}) do
    {:__anon_fields__, 0} in module.__info__(:functions)
  end

  defp get_anonymized_data(%module{} = struct) do
    # embeds =
    #   module.__schema__(:embeds)
    #   |> Enum.reduce([], fn embed, acc ->
    #     %mod{} = Map.get(struct, embed)
    #     mod.__anon_fields__() ++ acc
    #   end)

    module.__anon_fields__()
    |> Enum.reject(fn {field, _} -> is_association?(module, field) end)
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

  def is_association?(mod, association) do
    with association <- mod.__schema__(:association, association),
         false <- is_nil(association) do
      association.__struct__ in [
        Ecto.Association.Has,
        Ecto.Association.ManyToMany,
        Ecto.Association.HasThrough,
        Ecto.Embedded
      ]
    else
      _ -> false
    end
  end
end
