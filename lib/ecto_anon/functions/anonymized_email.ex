defmodule EctoAnon.Functions.AnonymizedEmail do
  @moduledoc """
  Anonymizing module for an email
  """
  alias EctoAnon.Functions.Helpers

  @behaviour EctoAnon.Functions
  @impl EctoAnon.Functions

  @doc """
  Returns an anonymized email with hashes while keeping the email format

  ## Options

    * `:partial` - When set to `true`, it keeps the first character of each part and hides the rest

  ## Example
      AnonymizedEmail.run(:string, "john.doe@email.com", [])
      "5d526ea414@a717679b0f.com"

      AnonymizedEmail.run(:string, "not_an_email", [])
      "c2fd076ad9@c2fd076ad9.com"

      AnonymizedEmail.run(:string, "john.doe@email.com", partial: true)
      "j******@e******.com"

  """
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
