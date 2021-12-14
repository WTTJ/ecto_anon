defmodule EctoAnon.SchemaTest do
  use ExUnit.Case, async: true
  alias EctoAnon.User

  describe "using/1" do
    test "delegates to Ecto.Schema.__field__ to define a standard Ecto field on the schema" do
      assert User.__schema__(:fields) == [:id, :firstname, :lastname, :email]
    end

    test "defines an __anon_fields__ function on the using module" do
      assert Enum.find(User.__info__(:functions), &(&1 == {:__anon_fields__, 0}))
    end
  end

  describe "__anon_fields__/0" do
    test "returns a list of {field, function} tuples" do
      assert [
               {:email, &EctoAnon.Functions.Default.run/1},
               {:lastname, &EctoAnon.Functions.Default.run/1}
             ] == User.__anon_fields__()
    end
  end
end
