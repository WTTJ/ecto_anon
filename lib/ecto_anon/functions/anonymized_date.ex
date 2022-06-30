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

  @doc """
  Returns an anonymized date/datetime

  ## Options

    * `:only_year` - When set to `true`, it keeps the year while anonymizing the rest

  ## Example
      {:ok, date} = Date.new(2019, 02, 04)

      AnonymizedDate.run(:date, date, [:only_year])
      ~D[2019-01-01]

      AnonymizedDate.run(:utc_datetime, date, [:only_year])
      ~U[2019-01-01 00:00:00Z]

      AnonymizedDate.run(:utc_datetime_usec, date, [:only_year])
      ~U[2019-01-01 00:00:00.000000Z]

      AnonymizedDate.run(:naive_datetime, date, [:only_year])
      ~N[2019-01-01 00:00:00]

      AnonymizedDate.run(:naive_datetime_usec, date, [:only_year])
      ~N[2019-01-01 00:00:00.000000]

      AnonymizedDate.run(:date, date)
      ~D[1970-01-01]

  """
  def run(type, value, [:only_year] = opts), do: do_run(type, value, opts)
  def run(type, value, opts), do: EctoAnon.Functions.Default.run(type, value, opts)

  defp do_run(:date, value, _opts), do: Date.new!(value.year, 01, 01)

  defp do_run(:utc_datetime, value, _opts),
    do: DateTime.new!(Date.new!(value.year, 01, 01), ~T[00:00:00])

  defp do_run(:utc_datetime_usec, value, _opts),
    do: DateTime.new!(Date.new!(value.year, 01, 01), ~T[00:00:00.000000])

  defp do_run(:naive_datetime, value, _opts), do: NaiveDateTime.new!(value.year, 1, 1, 0, 0, 0)

  defp do_run(:naive_datetime_usec, value, _opts),
    do: NaiveDateTime.new!(value.year, 1, 1, 0, 0, 0, {0, 6})
end
