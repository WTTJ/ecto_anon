defmodule EctoAnon.Functions.AnonymizedPhone do
  @moduledoc """
  Anonymizing module for a phone number

  Currently only returns with french format
  """
  @behaviour EctoAnon.Functions
  @impl EctoAnon.Functions

  @doc """
  Returns a phone number anonymized with french format


  ## Example
      AnonymizedPhone.run(:string, "0601020304", [])
      "xx xx xx xx xx"

  """
  def run(:string, _value, _opts), do: "xx xx xx xx xx"
end
