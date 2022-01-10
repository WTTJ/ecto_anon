defmodule EctoAnon.Comment do
  use Ecto.Schema
  use EctoAnon.Schema

  alias EctoAnon.User

  anon_schema([
    :content
  ])

  schema "comments" do
    field(:content, :string)
    field(:tag, :string)

    embeds_one(:quote, EctoAnon.Comment.Quote)

    belongs_to(:users, User, foreign_key: :author_id)
  end
end

defmodule EctoAnon.Comment.Quote do
  use Ecto.Schema
  use EctoAnon.Schema

  import Ecto.Changeset

  embedded_schema do
    anon_field(:quote, :string)
  end

  def changeset(changeset, attrs), do: cast(changeset, attrs, [:quote])
end
