defmodule EctoAnon.QueryTest do
  use ExUnit.Case, async: false

  alias EctoAnon.{Repo, User}

  setup do
    Repo.start_link()
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    user = %User{id: 1, email: "john@doe.com", firstname: "John"}

    Repo.insert!(user)

    {:ok, user: user}
  end

  describe "run/4" do
    test "updates user in database", %{user: user} do
      EctoAnon.Query.run([email: "redacted"], Repo, User, 1)

      updated_user = Repo.get(User, 1)

      assert %User{id: 1, email: "redacted", firstname: "John"} = updated_user
    end
  end
end
