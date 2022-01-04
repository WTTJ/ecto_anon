defmodule EctoAnonTest do
  use ExUnit.Case, async: true
  alias EctoAnon.{Repo, User}

  defmodule UnknownStruct do
    defstruct name: "John", age: 27
  end

  describe "run/3" do
    setup do
      user =
        %User{
          email: "john.doe@email.com",
          firstname: "John",
          lastname: "Doe",
          last_sign_in_at: ~U[2022-05-04 00:00:00Z]
        }
        |> Repo.insert!()

      {:ok, user: user}
    end

    test "with struct with anonymizable fields, should return anonymized struct", %{user: user} do
      assert {:ok, updated_user} = EctoAnon.run(user, Repo)

      assert updated_user.email == "redacted"
      assert updated_user.firstname == "John"
      assert updated_user.lastname == "redacted"
      assert updated_user.last_sign_in_at == ~U[2022-01-01 00:00:00Z]
    end

    test "with non-ecto struct, should return an error" do
      assert {:error, _error} = EctoAnon.run(%UnknownStruct{}, Repo)
    end
  end
end
