defmodule EctoAnon.Functions.RandomUuidTest do
  use ExUnit.Case, async: true
  alias EctoAnon.Functions.RandomUuid

  describe "run/3" do
    test "returns random uuid if type is :string" do
      random_uuid = RandomUuid.run(:string, "0601020304", [])

      assert Regex.match?(
               ~r/^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i,
               random_uuid
             )

      assert String.length(random_uuid) == 36
    end

    test "raise an exception if type is not :string" do
      assert_raise FunctionClauseError, ~r/^no function clause matching/, fn ->
        RandomUuid.run(:binary, "0601020304", [])
      end
    end
  end
end
