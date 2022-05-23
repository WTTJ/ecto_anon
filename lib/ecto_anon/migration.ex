defmodule EctoAnon.Migration do
  use Ecto.Migration

  @doc """
  Adds anonymized column (boolean) to a table. This column can be used to track if the resource has be anonymized or not.

      defmodule MyApp.Repo.Migrations.CreateUser do
        use Ecto.Migration
        import EctoAnon.Migration

        def change do
          create table(:users) do
            add :firstname, :string
            add :lastname, :string
            timestamps()
            anonymized()
          end
        end
      end

  """
  def anonymized do
    add(:anonymized, :boolean, default: false)
  end
end
