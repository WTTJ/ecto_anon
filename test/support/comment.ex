defmodule EctoAnon.Comment do
  use Ecto.Schema
  use EctoAnon.Schema

  alias EctoAnon.User

  schema "comments" do
    anon_field(:content, :string)
    field(:tag, :string)
    belongs_to(:users, User, foreign_key: :author_id)
  end
end
