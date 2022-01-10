defmodule EctoAnon.Repo.Migrations.CreateUsersAssociations do
  use Ecto.Migration
  import EctoAnon.Migration

  def change do
    create table(:comments) do
      add(:content, :string)
      add(:tag, :string)
      add(:quote, :map)
      add(:author_id, references(:users))

      anonymized()
    end

    create table(:followers) do
      add(:follower_id, references(:users))
      add(:followee_id, references(:users))
      timestamps()
    end
  end
end
