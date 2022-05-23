defmodule EctoAnon.Query do
  import Ecto.Query

  @spec apply(keyword(), Ecto.Repo.t(), struct()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def apply(data, repo, struct) do
    struct
    |> Ecto.Changeset.change(data)
    |> repo.update()
  end

  @spec set_anonymized(Ecto.Repo.t(), struct()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def set_anonymized(repo, struct) do
    struct
    |> Ecto.Changeset.change(anonymized: true)
    |> repo.update()
  end

  @doc """
  Returns a query that searches resources excluding anonymized ones

      query = from(u in User, select: u)
      |> not_anonymized

      results = Repo.all(query)

  """
  @spec not_anonymized(Ecto.Queryable.t()) :: Ecto.Queryable.t()
  def not_anonymized(query) do
    query
    |> where([t], t.anonymized == false)
  end
end
