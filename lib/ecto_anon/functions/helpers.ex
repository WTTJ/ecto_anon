defmodule EctoAnon.Functions.Helpers do
  def generate_hash(value \\ "") do
    :crypto.hash(:md5, Integer.to_string(:os.system_time(:milli_seconds)) <> value)
    |> Base.encode16()
    |> String.downcase()
    |> String.slice(0, 10)
  end
end
