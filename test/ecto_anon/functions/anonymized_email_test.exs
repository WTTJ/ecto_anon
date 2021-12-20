defmodule EctoAnon.Functions.AnonymizedEmailTest do
  use ExUnit.Case, async: true
  alias EctoAnon.Functions.AnonymizedEmail

  describe "run/3" do
    test "returns anonymized email if type is string and matches an email pattern" do
      anonymized_email = AnonymizedEmail.run(:string, "john.doe@email.com", [])
      assert Regex.match?(~r/.+@.+\.com/, anonymized_email)
    end

    test "returns a fake email if type is string and doesn't matches an email pattern" do
      anonymized_email = AnonymizedEmail.run(:string, "not_an_email", [])
      assert Regex.match?(~r/.+@.+\.com/, anonymized_email)
    end

    test "raise an exception if type is not :string" do
      assert_raise FunctionClauseError, ~r/^no function clause matching/, fn ->
        AnonymizedEmail.run(:binary, "john.doe@email.com", [])
      end
    end

    test "with partial option, returns a partial email" do
      assert AnonymizedEmail.run(:string, "john.doe@email.com", partial: true) ==
               "j******@e******.com"
    end
  end
end
