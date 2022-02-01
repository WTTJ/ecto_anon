defmodule EctoAnon.Functions.Default do
  @moduledoc """
  Default anonymizing functions for basic Ecto types.
  """
  @behaviour EctoAnon.Functions

  @default_integer 0
  @default_float 0.0
  @default_string "redacted"
  @default_map %{}
  @default_decimal Decimal.new("0.0")
  @default_date ~D[1970-01-01]
  @default_datetime ~U[1970-01-01 00:00:00Z]
  @default_datetime_usec ~U[1970-01-01 00:00:00.000Z]
  @default_naive_datetime ~N[1970-01-01 00:00:00]
  @default_naive_datetime_usec ~N[1970-01-01 00:00:00.000]
  @default_time ~T[00:00:00.000]
  @default_time_usec ~T[00:00:00.000]

  @doc """
  Apply default anonymizing function based on field type.
  """
  @impl EctoAnon.Functions
  def run(type, value, _opts), do: do_run(type, value)

  defp do_run(:integer, _value), do: @default_integer
  defp do_run(:float, _value), do: @default_float
  defp do_run(:string, _value), do: @default_string
  defp do_run(:map, _value), do: @default_map
  defp do_run(:decimal, _value), do: @default_decimal
  defp do_run(:date, _value), do: @default_date
  defp do_run(:utc_datetime, _value), do: @default_datetime
  defp do_run(:utc_datetime_usec, _value), do: @default_datetime_usec
  defp do_run(:naive_datetime, _value), do: @default_naive_datetime
  defp do_run(:naive_datetime_usec, _value), do: @default_naive_datetime_usec
  defp do_run(:time, _value), do: @default_time
  defp do_run(:time_usec, _value), do: @default_time_usec

  defp do_run(:boolean, value), do: value
  defp do_run(:id, value), do: value
  defp do_run(:binary_id, value), do: value
  defp do_run(:binary, value), do: value
end
