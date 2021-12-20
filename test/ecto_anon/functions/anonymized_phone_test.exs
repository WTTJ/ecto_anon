defmodule EctoAnon.Functions.AnonymizedPhoneTest do
  use ExUnit.Case, async: true
  alias EctoAnon.Functions.AnonymizedPhone

  describe "run/3" do
    test "returns anonymized phone if type is string and value is not nil" do
      anonymized_phone = AnonymizedPhone.run(:string, "0601020304", [])
      assert anonymized_phone == "xx xx xx xx xx"
    end

    test "raise an exception if type is not :string" do
      assert_raise FunctionClauseError, ~r/^no function clause matching/, fn ->
        AnonymizedPhone.run(:binary, "0601020304", [])
      end
    end
  end
end
