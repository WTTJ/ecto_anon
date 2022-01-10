defmodule EctoAnon do
  @moduledoc """
  `EctoAnon` provides a simple way to handle data anonymization directly in your Ecto schemas.
  """

  @doc """
  Updates an Ecto struct with anonymized data based on its anon_fields declared in the struct schema.

      defmodule User do
        use Ecto.Schema
        use EctoAnon

        schema "user" do
          # ... fields ...
          anon_field :email, :string
        end
      end

  It returns `{:ok, struct}` if the struct has been successfully updated or `{:error, :non_anonymizable_struct}` if the struct has no anonymizable fields.

  ## Options

    * `:cascade` - When set to `true`, allows ecto-anon to preload and anonymize
    all associations (and associations of these associations) automatically in cascade.
    Could be used to anonymize all data related a struct in a single call.
    Note that this won't traverse `belongs_to` associations.

  ## Example

      defmodule User do
        use Ecto.Schema
        use EctoAnon

        schema "users" do
          field :name, :string
          field :age, :integer, default: 0
          anon_field :email, :string
        end
      end

  By default, an anon_field will be anonymized with a default value based on its type:

      iex> user = Repo.get(User, id)
      %User{name: "jane", age: 0, email: "jane@email.com"}

      iex> EctoAnon.run(user, Repo)
      {:ok, %User{name: "jane", age: 0, email: "redacted"}}

  """
  @spec run(struct(), Ecto.Repo.t(), keyword()) ::
          {:ok, Ecto.Schema.t()} | {:error, :non_anonymizable_struct}

  def run(struct, repo, _opts \\ [])

  def run(struct, _repo, _opts) when struct in [[], nil], do: {:error, :non_anonymizable_struct}
  def run(struct, repo, opts) when is_list(struct), do: Enum.each(struct, &run(&1, repo, opts))

  def run(%mod{} = struct, repo, cascade: true) do
    associations = mod.__schema__(:associations)
    struct = repo.preload(struct, associations)

    associations
    |> Enum.filter(&is_children?(mod, &1))
    |> Enum.each(&run(Map.get(struct, &1), repo, cascade: true))

    run(struct, repo)
  end

  def run(struct, repo, _opts) do
    case EctoAnon.Anonymizer.anonymized_data(struct) do
      {:ok, data} -> EctoAnon.Query.run(data, repo, struct)
      {:error, error} -> {:error, error}
    end
  end

  defp is_children?(mod, association) do
    mod.__schema__(:association, association).__struct__ in [
      Ecto.Association.Has,
      Ecto.Association.ManyToMany,
      Ecto.Association.HasThrough
    ]
  end
end
