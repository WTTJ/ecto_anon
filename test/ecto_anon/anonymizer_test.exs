defmodule EctoAnon.AnonymizerTest do
  use ExUnit.Case, async: true

  defmodule TestUser do
    use Ecto.Schema
    use EctoAnon.Schema

    schema "users" do
      anon_field(:email)
      anon_field(:phone)
      anon_field(:age, :integer)
    end
  end

  setup do
    user = %TestUser{email: "john.doe@example.com", phone: "0102030405", age: 33}

    {:ok, user: user}
  end

  describe "anonymized_data/1" do
    test "returns the struct with anonymized fields", %{user: user} do
      assert {:ok, [email: "redacted", phone: "redacted", age: 0]} =
               EctoAnon.Anonymizer.anonymized_data(user)
    end
  end
end
