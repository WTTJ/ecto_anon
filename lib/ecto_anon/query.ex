defmodule EctoAnon.Query do
  @spec run(keyword(), Ecto.Repo.t(), struct()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def run(data, repo, struct) do
    struct
    |> Ecto.Changeset.change(data)
    |> repo.update()
  end
end
