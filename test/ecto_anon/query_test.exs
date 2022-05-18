defmodule EctoAnon.QueryTest do
  use ExUnit.Case, async: false

  import EctoAnon.Query
  import Ecto.Query
  alias EctoAnon.{Repo, User}

  setup do
    user =
      %User{email: "john@doe.com", firstname: "John", lastname: "Doe"}
      |> Repo.insert!()

    {:ok, user: user}
  end

  describe "apply/3" do
    test "updates user in database with given fields", %{user: user} do
      EctoAnon.Query.apply([email: "redacted"], Repo, user)

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

  describe "not_anonymized/1" do
    test "not_anonymized returns a resources not anonymized" do
      Repo.insert!(%User{email: "user@email.com", anonymized: false})

      Repo.insert!(%User{
        email: "redacted@email.com",
        anonymized: true
      })

      query =
        from(u in User, select: u)
        |> not_anonymized()

      emails =
        Repo.all(query)
        |> Enum.map(& &1.email)

      assert emails
             |> Enum.member?("user@email.com")

      refute emails
             |> Enum.member?("redacted@email.com")
    end
  end
end
