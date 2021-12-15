defmodule EctoAnon.Functions.AnonymizedEmail do
  @moduledoc """
  Anonymizing module for an email
  """
  @behaviour EctoAnon.Functions
  alias EctoAnon.Functions.Helpers

  @impl EctoAnon.Functions

  def run(:string, value, opts) do
    ~r/(?<username>.*)@(?<domain>.*)(?<tld>\..*)/i
    |> Regex.named_captures(value)
    |> case do
      %{"username" => username, "domain" => domain, "tld" => tld} ->
        if opts[:partial] do
          String.first(username) <> "******@" <> String.first(domain) <> "******" <> tld
        else
          Helpers.generate_hash(username) <> "@" <> Helpers.generate_hash(domain) <> ".com"
        end

      _ ->
        Helpers.generate_hash() <> "@" <> Helpers.generate_hash() <> ".com"
    end
  end
end
