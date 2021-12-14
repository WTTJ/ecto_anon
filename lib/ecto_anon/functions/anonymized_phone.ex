defmodule EctoAnon.Functions.AnonymizedPhone do
  @moduledoc """
  Anonymizing module for a phone number
  Currently only return french format
  """
  @behaviour EctoAnon.Functions

  @impl EctoAnon.Functions
  def run({:string, _value}), do: "xx xx xx xx xx"
end
