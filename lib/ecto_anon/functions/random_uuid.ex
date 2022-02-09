defmodule EctoAnon.Functions.RandomUUID do
  @moduledoc """
  Genererates a random uuid version 4
  """
  @behaviour EctoAnon.Functions

  @impl EctoAnon.Functions
  def run(:string, _value, _opts), do: Ecto.UUID.generate()
end
