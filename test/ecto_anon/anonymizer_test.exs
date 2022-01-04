defmodule EctoAnon.AnonymizerTest do
  use ExUnit.Case, async: true
  alias EctoAnon.User

  describe "anonymized_data/1" do
    test "returns the struct with anonymized fields" do
      user = %User{email: "john.doe@example.com", firstname: "John", lastname: "Doe"}

      assert {:ok, [lastname: "redacted", email: "redacted", last_sign_in_at: nil]} =
               EctoAnon.Anonymizer.anonymized_data(user)
    end

    test "returns anonymized fields only for non-nil fields" do
      user = %User{email: "john.doe@example.com", lastname: nil}

      assert {:ok, [lastname: nil, email: "redacted", last_sign_in_at: nil]} =
               EctoAnon.Anonymizer.anonymized_data(user)
    end
  end
end
