defmodule EctoAnonTest do
  use ExUnit.Case, async: true
  alias EctoAnon.{Repo, User, Comment, User.Quote}

  defmodule UnknownStruct do
    defstruct name: "John", age: 27
  end

  describe "run/3" do
    setup do
      mick =
        %User{
          email: "mick.rogers@email.com",
          firstname: "Mick",
          lastname: "Rogers",
          last_sign_in_at: ~U[2021-01-03 00:00:00Z],
          followers: [],
          favorite_quote: %Quote{
            quote: "this is a quote",
            author: "author"
          },
          quotes: [
            %Quote{
              quote: "this is a quote",
              author: "author"
            },
            %Quote{
              quote: "this is a quote",
              author: "author"
            }
          ]
        }
        |> Repo.insert!()

      fred =
        %User{
          email: "fred.duncan@email.com",
          firstname: "Fred",
          lastname: "Duncan",
          last_sign_in_at: ~U[2023-03-20 00:00:00Z],
          followers: [],
          favorite_quote: nil,
          quotes: []
        }
        |> Repo.insert!()

      emilie =
        %User{
          email: "emilie.duncan@email.com",
          firstname: "Emilie",
          lastname: "Duncan",
          last_sign_in_at: ~U[2018-09-04 00:00:00Z],
          followers: [fred],
          favorite_quote: %Quote{
            quote: "this is a quote",
            author: "author"
          },
          quotes: [
            %Quote{
              quote: "this is a quote",
              author: "author"
            },
            %Quote{
              quote: "this is a quote",
              author: "author"
            }
          ]
        }
        |> Repo.insert!()

      user =
        %User{
          email: "john.doe@email.com",
          firstname: "John",
          lastname: "Doe",
          last_sign_in_at: ~U[2022-05-04 00:00:00Z],
          followers: [mick, emilie],
          favorite_quote: %Quote{
            quote: "this is a quote",
            author: "author"
          },
          quotes: [
            %Quote{
              quote: "this is a quote",
              author: "author"
            },
            %Quote{
              quote: "this is a quote",
              author: "author"
            }
          ]
        }
        |> Repo.insert!()

      %Comment{
        content: "this is a comment",
        tag: "tag",
        author_id: user.id
      }
      |> Repo.insert!()

      {:ok, user: user, mick: mick, emilie: emilie}
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

    test "with cascade option, should anonymize struct and associations", %{
      user: user,
      mick: mick,
      emilie: emilie
    } do
      assert {:ok, updated_user} = EctoAnon.run(user, Repo, cascade: true)

      assert %User{
               email: "redacted",
               firstname: "John",
               last_sign_in_at: ~U[2022-01-01 00:00:00Z],
               lastname: "redacted",
               favorite_quote: %Quote{
                 quote: "redacted",
                 author: "redacted"
               },
               quotes: [
                 %Quote{
                   quote: "redacted",
                   author: "redacted"
                 },
                 %Quote{
                   quote: "redacted",
                   author: "redacted"
                 }
               ]
             } = updated_user

      assert %Comment{
               content: "this is a comment",
               tag: "tag"
             } = Repo.get_by(Comment, author_id: user.id)

      assert %User{
               email: "redacted",
               firstname: "Mick",
               last_sign_in_at: ~U[2021-01-01 00:00:00Z],
               lastname: "redacted",
               followers: [],
               favorite_quote: %Quote{
                 quote: "redacted",
                 author: "redacted"
               },
               quotes: [
                 %Quote{
                   quote: "redacted",
                   author: "redacted"
                 },
                 %Quote{
                   quote: "redacted",
                   author: "redacted"
                 }
               ]
             } = Repo.get(User, mick.id) |> Repo.preload(:followers)

      assert %User{
               email: "redacted",
               firstname: "Emilie",
               last_sign_in_at: ~U[2018-01-01 00:00:00Z],
               lastname: "redacted",
               favorite_quote: %Quote{
                 quote: "redacted",
                 author: "redacted"
               },
               followers: [
                 %User{
                   email: "redacted",
                   firstname: "Fred",
                   last_sign_in_at: ~U[2023-01-01 00:00:00Z],
                   lastname: "redacted",
                   favorite_quote: nil,
                   quotes: []
                 }
               ],
               quotes: [
                 %Quote{
                   quote: "redacted",
                   author: "redacted"
                 },
                 %Quote{
                   quote: "redacted",
                   author: "redacted"
                 }
               ]
             } = Repo.get(User, emilie.id) |> Repo.preload(:followers)
    end
  end
end
