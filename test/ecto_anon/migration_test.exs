defmodule EctoAnon.MigrationTest do
  use ExUnit.Case, async: true
  use Ecto.Migration
  import EctoAnon.Migration
  alias Ecto.Migration.Runner

  describe "anonymized/0" do
    setup meta do
      config = Application.get_env(:ecto_sql, EctoAnon.Repo, [])

      Application.put_env(
        :ecto_sql,
        EctoAnon.Repo,
        Keyword.merge(config, meta[:repo_config] || [])
      )

      on_exit(fn -> Application.put_env(:ecto_sql, EctoAnon.Repo, config) end)
    end

    setup meta do
      direction = meta[:direction] || :forward
      log = %{level: false, sql: false}
      args = {self(), EctoAnon.Repo, EctoAnon.Repo.config(), __MODULE__, direction, :up, log}
      {:ok, runner} = Runner.start_link(args)
      Runner.metadata(runner, meta)
      {:ok, runner: runner}
    end

    test "adds an anonymized column", %{runner: runner} do
      create table(:credentials, primary_key: false) do
        anonymized()
      end

      [anonymized] = Agent.get(runner, & &1.commands)

      flush()

      assert {:create, _, [{:add, :anonymized, :boolean, [default: false]}]} = anonymized
    end
  end
end
