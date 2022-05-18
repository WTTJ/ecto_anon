defmodule EctoAnon.Repo.Migrations.CreateUsers do
  use Ecto.Migration
  import EctoAnon.Migration

  def change do
    create table(:users) do
      add(:email, :string)
      add(:firstname, :string)
      add(:lastname, :string)
      add(:last_sign_in_at, :utc_datetime)

      anonymized()
    end
  end
end
