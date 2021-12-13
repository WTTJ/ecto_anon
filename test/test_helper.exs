ExUnit.start()

{:ok, _} = Ecto.Adapters.SQLite3.ensure_all_started(EctoAnon.Repo, :temporary)
# Start a process ONLY for our test run.
{:ok, _pid} = EctoAnon.Repo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(EctoAnon.Repo, :auto)
