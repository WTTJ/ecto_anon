defmodule EctoAnon.User do
  use Ecto.Schema
  use EctoAnon.Schema

  schema "users" do
    field(:firstname)
    anon_field(:lastname)
    anon_field(:email)
  end
end
