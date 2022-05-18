defmodule EctoAnon.QueryTest do
  use ExUnit.Case, async: false

  alias EctoAnon.{Repo, User}

  setup do
    user =
      %User{email: "john@doe.com", firstname: "John", lastname: "Doe"}
      |> Repo.insert!()

    {:ok, user: user}
  end

  describe "run/3" do
    test "updates user in database with given fields", %{user: user} do
      EctoAnon.Query.run([email: "redacted"], Repo, user)

      updated_user = Repo.get(User, user.id)

      assert updated_user.email == "redacted"
      assert updated_user.firstname == user.firstname
      assert updated_user.lastname == user.lastname
    end
  end

  describe "set_anonymized/2" do
    test "updates anonymized field to true", %{user: user} do
      EctoAnon.Query.set_anonymized(Repo, user)
      updated_user = Repo.get(User, user.id)

      assert updated_user.anonymized == true
    end
  end
end
