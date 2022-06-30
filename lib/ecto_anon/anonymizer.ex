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

  defp get_anonymized_data(struct) do
    fields = anonymize_fields(struct)
    embeds = anonymize_embeds(struct)

    %{fields: fields, embeds: embeds}
  end

  defp anonymize_fields(%module{} = struct) do
    module.__anon_fields__()
    |> Enum.reject(fn {field, _} ->
      is_association?(module, field) or is_embed?(module, field)
    end)
    |> Enum.reduce([], fn {field, {func, opts}}, acc ->
      type = module.__schema__(:type, field)

      value =
        case Map.get(struct, field) do
          nil ->
            nil

          value ->
            func.(type, value, opts)
        end

      Keyword.put(acc, field, value)
    end)
  end

  defp anonymize_embeds(%module{} = struct) do
    module.__anon_fields__()
    |> Enum.filter(fn {field, _} -> is_embed?(module, field) end)
    |> Enum.reduce([], fn {field, _}, acc ->
      case Map.get(struct, field) do
        nil -> acc
        value -> Keyword.put(acc, field, anonymize_embed(value))
      end
    end)
  end

  defp anonymize_embed(field) when is_list(field) do
    field
    |> Enum.map(&anonymize_embed/1)
  end

  defp anonymize_embed(field) do
    data = anonymize_fields(field)

    field
    |> Ecto.Changeset.change(data)
  end

  def is_association?(mod, association) do
    with association <- mod.__schema__(:association, association),
         false <- is_nil(association) do
      association.__struct__ in [
        Ecto.Association.Has,
        Ecto.Association.ManyToMany,
        Ecto.Association.HasThrough
      ]
    else
      _ -> false
    end
  end

  def is_embed?(mod, field) do
    case mod.__schema__(:type, field) do
      {_, Ecto.Embedded, %Ecto.Embedded{}} ->
        true

      {_, {_, Ecto.Embedded, %Ecto.Embedded{}}} ->
        true

      _ ->
        false
    end
  end
end
