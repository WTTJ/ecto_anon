use Mix.Config

config :ecto_anon, ecto_repos: [EctoAnon.Repo]

config :ecto_anon, EctoAnon.Repo,
  adapter: Ecto.Adapters.SQLite3,
  database: "test/db/priv/db/test.db",
  priv: "test/db/priv/repo/",
  pool: Ecto.Adapters.SQL.Sandbox
