defmodule EctoAnon.Repo.Migrations.CreateUsersAssociations do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add(:content, :string)
      add(:tag, :string)
      add(:author_id, references(:users))
    end

    create table(:relationships) do
      add(:person_id, references(:users))
      add(:relation_id, references(:users))
      timestamps()
    end
  end
end
