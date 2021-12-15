defmodule EctoAnon.FunctionsTest do
  use ExUnit.Case, async: true

  describe "get_module/1" do
    test "returns Default module when given :default" do
      assert EctoAnon.Functions.get_module(:default) == EctoAnon.Functions.Default
    end

    test "raises when passing an atom not matching any module" do
      assert_raise ArgumentError, fn ->
        EctoAnon.Functions.get_module(:bad_atom)
      end
    end
  end

  describe "get_function/1" do
    test "returns &EctoAnon.Functions.Default.run/1 when given :default" do
      assert EctoAnon.Functions.get_function(:default) == (&EctoAnon.Functions.Default.run/3)
    end
  end
end
