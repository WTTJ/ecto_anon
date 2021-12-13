defmodule EctoAnon.User do
  use Ecto.Schema
  use EctoAnon.Schema

  schema "users" do
    anon_field(:email)
    anon_field(:firstname)
  end
end
