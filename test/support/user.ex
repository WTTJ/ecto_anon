defmodule EctoAnon.User do
  use Ecto.Schema
  use EctoAnon.Schema

  alias EctoAnon.Comment

  anon_schema([
    :lastname,
    :email,
    :followers,
    last_sign_in_at: [:anonymized_date, options: [:only_year]]
  ])

  schema "users" do
    field(:firstname, :string)
    field(:lastname, :string)
    field(:email, :string)
    field(:last_sign_in_at, :utc_datetime)

    has_many(:comments, Comment, foreign_key: :author_id, references: :id)

    many_to_many(
      :followers,
      __MODULE__,
      join_through: EctoAnon.User.Follower,
      join_keys: [follower_id: :id, followee_id: :id]
    )

    anonymized()
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
