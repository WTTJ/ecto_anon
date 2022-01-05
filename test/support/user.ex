defmodule EctoAnon.User do
  use Ecto.Schema
  use EctoAnon.Schema

  alias EctoAnon.Comment

  schema "users" do
    field(:firstname, :string)
    anon_field(:lastname, :string)
    anon_field(:email, :string)
    anon_field(:last_sign_in_at, :utc_datetime, anon_with: {:anonymized_date, [:only_year]})

    has_many(:comments, Comment, foreign_key: :author_id, references: :id)

    many_to_many(
      :relationships,
      __MODULE__,
      join_through: EctoAnon.User.Relationship,
      join_keys: [person_id: :id, relation_id: :id]
    )
  end
end

defmodule EctoAnon.User.Relationship do
  use Ecto.Schema

  schema "relationships" do
    field(:person_id, :id)
    field(:relation_id, :id)
    timestamps()
  end
end
