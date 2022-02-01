defmodule EctoAnon.Functions.AnonymizedDateTest do
  use ExUnit.Case, async: true
  alias EctoAnon.Functions.AnonymizedDate

  describe "run/3" do
    test "when opts is not [:only_year] it returns default anonymized data" do
      {:ok, date} = Date.new(2022, 02, 04)

      assert AnonymizedDate.run(:date, date, []) == ~D[1970-01-01]
      assert AnonymizedDate.run(:utc_datetime, date, []) == ~U[1970-01-01 00:00:00Z]
      assert AnonymizedDate.run(:utc_datetime_usec, date, []) == ~U[1970-01-01 00:00:00.000Z]
      assert AnonymizedDate.run(:naive_datetime, date, []) == ~N[1970-01-01 00:00:00]

      assert AnonymizedDate.run(:naive_datetime_usec, date, []) ==
               ~N[1970-01-01 00:00:00.000]
    end

    test "when opts is [:only_year] it returns the date at the beginning of the date's year" do
      {:ok, date} = Date.new(2019, 02, 04)

      assert AnonymizedDate.run(:date, date, [:only_year]) == ~D[2019-01-01]
      assert AnonymizedDate.run(:utc_datetime, date, [:only_year]) == ~U[2019-01-01 00:00:00Z]

      assert AnonymizedDate.run(:utc_datetime_usec, date, [:only_year]) ==
               ~U[2019-01-01 00:00:00.000Z]

      assert AnonymizedDate.run(:naive_datetime, date, [:only_year]) == ~N[2019-01-01 00:00:00]

      assert AnonymizedDate.run(:naive_datetime_usec, date, [:only_year]) ==
               ~N[2019-01-01 00:00:00.000]
    end
  end
end
