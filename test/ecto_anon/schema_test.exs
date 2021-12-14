defmodule EctoAnon.SchemaTest do
  use ExUnit.Case, async: true
  alias EctoAnon.User

  defmodule CustomUser do
    use Ecto.Schema
    use EctoAnon.Schema

    schema "users" do
      field(:firstname, :string)
      anon_field(:lastname, :string)
      anon_field(:email, :string, anon_with: :anonymized_email)
    end
  end

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

    test "returns associated anon_with function otherwise default function" do
      assert [
               {:email, &EctoAnon.Functions.AnonymizedEmail.run/1},
               {:lastname, &EctoAnon.Functions.Default.run/1}
             ] == CustomUser.__anon_fields__()
    end
  end
end
