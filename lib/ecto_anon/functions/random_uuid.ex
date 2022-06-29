defmodule EctoAnon.Functions.RandomUuid do
  @moduledoc """
  Genererates a random uuid version 4
  """
  @behaviour EctoAnon.Functions
  @impl EctoAnon.Functions

  @doc """
  Returns a random version 4 UUID

  ## Example
      RandomUuid.run(:string, "0601020304", [])
      "71d8ed69-31ca-4b9d-826b-f355ea7fb128"

  """
  def run(:string, _value, _opts), do: Ecto.UUID.generate()
end
