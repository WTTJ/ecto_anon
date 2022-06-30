defmodule EctoAnon.SchemaTest do
  use ExUnit.Case, async: true
  alias EctoAnon.User

  defmodule CustomUser do
    use Ecto.Schema
    use EctoAnon.Schema

    anon_schema([
      :lastname,
      email: :anonymized_email,
      phone: &__MODULE__.custom_phone/3
    ])

    schema "users" do
      field(:firstname, :string)
      field(:lastname, :string)
      field(:email, :string)
      field(:phone, :string, virtual: true)

      anonymized()
    end

    def custom_phone(_type, _value, _opts) do
      "XXX-XXX-XXX"
    end
  end

  describe "using/1" do
    test "defines an __anon_fields__ function on the using module" do
      assert Enum.find(User.__info__(:functions), &(&1 == {:__anon_fields__, 0}))
    end

    test "defines an anonymized macro returning a boolean anonymized field" do
      assert :anonymized in User.__schema__(:fields)
      assert User.__schema__(:type, :anonymized) == :boolean
    end
  end

  describe "__anon_fields__/0" do
    test "returns a list of {field, function} tuples" do
      assert [
               last_sign_in_at: {&EctoAnon.Functions.AnonymizedDate.run/3, [:only_year]},
               quotes: {&EctoAnon.Functions.Default.run/3, []},
               favorite_quote: {&EctoAnon.Functions.Default.run/3, []},
               followers: {&EctoAnon.Functions.Default.run/3, []},
               email: {&EctoAnon.Functions.Default.run/3, []},
               lastname: {&EctoAnon.Functions.Default.run/3, []}
             ] == User.__anon_fields__()
    end

    test "returns associated anon_with function otherwise default function" do
      assert [
               phone: {&EctoAnon.SchemaTest.CustomUser.custom_phone/3, []},
               email: {&EctoAnon.Functions.AnonymizedEmail.run/3, []},
               lastname: {&EctoAnon.Functions.Default.run/3, []}
             ] == CustomUser.__anon_fields__()
    end
  end
end
