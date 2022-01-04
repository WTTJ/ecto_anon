defmodule EctoAnon.User do
  use Ecto.Schema
  use EctoAnon.Schema

  schema "users" do
    field(:firstname, :string)
    anon_field(:lastname, :string)
    anon_field(:email, :string)
    anon_field(:last_sign_in_at, :utc_datetime, anon_with: {:anonymized_date, [:only_year]})
  end
end
