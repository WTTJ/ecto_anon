defmodule EctoAnon.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string)
      add(:firstname, :string)
    end
  end
end
