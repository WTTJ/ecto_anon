defmodule EctoAnon.User do
  use Ecto.Schema
  use EctoAnon.Schema

  schema "users" do
    field(:firstname, :string)
    anon_field(:lastname, :string)
    anon_field(:email, :string)
  end
end
