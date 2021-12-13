defmodule EctoAnon.Query do
  import Ecto.Query

  @spec run(Keyword, Ecto.Repo, Module, Integer) :: nil
  def run(data, repo, mod, id) do
    from(m in mod, where: m.id == ^id, update: [set: ^data])
    |> repo.update_all([])
  end
end
