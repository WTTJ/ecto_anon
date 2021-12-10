defmodule EctoAnon.SchemaTest do
  use ExUnit.Case, async: true

  defmodule TestUser do
    use Ecto.Schema
    use EctoAnon.Schema

    schema "users" do
      anon_field(:email)
      anon_field(:phone)
    end
  end

  describe "using/1" do
    test "delegates to Ecto.Schema.__field__ to define a standard Ecto field on the schema" do
      assert TestUser.__schema__(:fields) == [:id, :email, :phone]
    end

    test "defines an __anon_fields__ function on the using module" do
      assert Enum.find(TestUser.__info__(:functions), &(&1 == {:__anon_fields__, 0}))
    end
  end

  describe "__anon_fields__/0" do
    test "returns a list of {field, function} tuples" do
      assert [{:phone, :default}, {:email, :default}] == TestUser.__anon_fields__()
    end
  end
end
