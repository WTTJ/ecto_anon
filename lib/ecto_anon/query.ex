defmodule EctoAnon.Query do
  @spec run(keyword(), Ecto.Repo.t(), struct()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def run(data, repo, struct) do
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
end
