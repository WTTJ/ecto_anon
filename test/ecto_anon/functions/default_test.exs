defmodule EctoAnon.Functions.DefaultTest do
  use ExUnit.Case, async: true

  @fixed_value_types [
    integer: 0,
    float: 0.0,
    string: "redacted",
    map: %{},
    decimal: Decimal.new("0.0"),
    date: ~D[1970-01-01],
    utc_datetime: ~U[1970-01-01 00:00:00Z],
    utc_datetime_usec: ~U[1970-01-01 00:00:00.000000Z],
    naive_datetime: ~N[1970-01-01 00:00:00],
    naive_datetime_usec: ~N[1970-01-01 00:00:00.000000],
    time: ~T[00:00:00],
    time_usec: ~T[00:00:00.000000]
  ]

  @same_value_types [:boolean, :id, :binary_id, :binary]

  describe "run/1" do
    test "returns fixed value type when appropriate" do
      matches =
        Enum.map(@fixed_value_types, fn {type, value} ->
          EctoAnon.Functions.Default.run(type, "value", []) == value
        end)

      assert Enum.all?(matches)
    end

    test "returns the same value when appropriate" do
      matches =
        Enum.map(@same_value_types, fn type ->
          EctoAnon.Functions.Default.run(type, "value", []) == "value"
        end)

      assert Enum.all?(matches)
    end
  end
end
