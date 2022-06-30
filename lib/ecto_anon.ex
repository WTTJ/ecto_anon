defmodule EctoAnon do
  @moduledoc """
  `EctoAnon` provides a simple way to handle data anonymization directly in your Ecto schemas.
  """

  @doc """
  Updates an Ecto struct with anonymized data based on its anon_schema declaration.
  It also updates any embedded schema declared in anon_schema.

      defmodule User do
        use Ecto.Schema
        use EctoAnon.Schema

        anon_schema [
          :firstname,
          email: &__MODULE__.anonymized_email/3
          birthdate: [:anonymized_date, options: [:only_year]]
        ]

        schema "user" do
          field :fistname, :string
          field :email, :string
          field :birthdate, :utc_datetime
        end

        def anonymized_email(_type, _value, _opts) do
          "xxx@xxx.com"
        end
      end

  It returns `{:ok, struct}` if the struct has been successfully updated or `{:error, :non_anonymizable_struct}` if the struct has no anonymizable fields.

  ## Options

    * `:cascade` - When set to `true`, allows ecto_anon to preload and anonymize
    all associations (and associations of these associations) automatically in cascade.
    Could be used to anonymize all data related a struct in a single call.
    Note that this won't traverse `belongs_to` associations to avoid infinite and cyclic anonymizations.
    Default: false

    * `:log`- When set to `true`, it will set `anonymized` field when EctoAnon.run
    applies anonymization on a ressource.
    Default: true

  ## Example

      defmodule User do
        use Ecto.Schema
        use EctoAnon.Schema

        anon_schema [
          :email
        ]

        schema "users" do
          field :name, :string
          field :age, :integer, default: 0
          field :email, :string
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
    anon_fields = mod.__anon_fields__() |> Enum.map(fn {field, _} -> field end)

    associations =
      mod.__schema__(:associations)
      |> Enum.filter(&(&1 in anon_fields and EctoAnon.Anonymizer.is_association?(mod, &1)))

    struct = repo.preload(struct, associations)

    associations
    |> Enum.each(&run(Map.get(struct, &1), repo, cascade: true))

    run(struct, repo)
  end

  def run(struct, repo, opts) do
    with {:ok, data} <- EctoAnon.Anonymizer.anonymized_data(struct),
         {:ok, anonymized_data} <- EctoAnon.Query.apply(data, repo, struct) do
      if set_anonymized?(struct, opts) do
        EctoAnon.Query.set_anonymized(repo, anonymized_data)
      else
        {:ok, anonymized_data}
      end
    else
      {:error, error} -> {:error, error}
    end
  end

  defp set_anonymized?(%mod{} = _struct, opts) do
    Keyword.get(opts, :log, true) and :anonymized in mod.__schema__(:fields)
  end
end
