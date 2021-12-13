defmodule EctoAnon.User do
  use Ecto.Schema
  use EctoAnon.Schema

  schema "users" do
    anon_field(:email)
    field(:firstname)
    anon_field(:lastname)
  end
end
