defmodule EctoAnon.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :ecto_anon,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, ">= 3.7.1"}
    ]
  end
end
