defmodule EctoAnon.Functions.AnonymizedDate do
  @moduledoc """
  Anonymizing module for a date, accepting types:
    - date
    - utc_datetime
    - utc_datetime_usec
    - naive_datetime
    - naive_datetime_usec
  """
  @behaviour EctoAnon.Functions

  @impl EctoAnon.Functions
  def run(type, value, [:only_year] = opts), do: do_run(type, value, opts)
  def run(type, value, opts), do: EctoAnon.Functions.Default.run(type, value, opts)

  defp do_run(:date, value, _opts), do: Date.new!(value.year, 01, 01)

  defp do_run(:utc_datetime, value, _opts),
    do: DateTime.new!(Date.new!(value.year, 01, 01), ~T[00:00:00])

  defp do_run(:utc_datetime_usec, value, _opts),
    do: DateTime.new!(Date.new!(value.year, 01, 01), ~T[00:00:00.000])

  defp do_run(:naive_datetime, value, _opts), do: NaiveDateTime.new!(value.year, 1, 1, 0, 0, 0)

  defp do_run(:naive_datetime_usec, value, _opts),
    do: NaiveDateTime.new!(value.year, 1, 1, 0, 0, 0, {0, 3})
end
