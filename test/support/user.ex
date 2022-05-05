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
      :followers,
      __MODULE__,
      join_through: EctoAnon.User.Follower,
      join_keys: [follower_id: :id, followee_id: :id]
    )
  end
end

defmodule EctoAnon.User.Follower do
  use Ecto.Schema

  schema "followers" do
    field(:follower_id, :id)
    field(:followee_id, :id)
    timestamps()
  end
end
