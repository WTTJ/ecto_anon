defmodule EctoAnonTest do
  use ExUnit.Case, async: true

  defmodule UnknownStruct do
    defstruct name: "John", age: 27
  end

  describe "run/3" do
    setup do
      user =
        %EctoAnon.User{email: "john.doe@email.com", firstname: "John", lastname: "Doe"}
        |> EctoAnon.Repo.insert!()

      {:ok, user: user}
    end

    test "with struct with anonymizable fields, should return anonymized struct", %{user: user} do
      assert {:ok, updated_user} = EctoAnon.run(user, EctoAnon.Repo)

      assert updated_user.email == "redacted"
      assert updated_user.firstname == "John"
      assert updated_user.lastname == "redacted"
    end

    test "with non-ecto struct, should return an error" do
      assert {:error, _error} = EctoAnon.run(%UnknownStruct{}, EctoAnon.Repo)
    end
  end
end
