defmodule EctoAnon.Functions.AnonymizedEmail do
  @moduledoc """
  Anonymizing module for an email
  """
  @behaviour EctoAnon.Functions
  alias EctoAnon.Functions.Helpers

  @impl EctoAnon.Functions
  def run({:string, value}) do
    ~r/(?<username>.+)@(?<domain>.+)\.(?<tld>.+)/i
    |> Regex.named_captures(value)
    |> case do
      %{"username" => username, "domain" => domain, "tld" => _tld} ->
        Helpers.generate_hash(username) <> "@" <> Helpers.generate_hash(domain) <> ".com"

      _ ->
        Helpers.generate_hash() <> "@" <> Helpers.generate_hash() <> ".com"
    end
  end
end
