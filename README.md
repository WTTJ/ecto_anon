# ecto_anon

[![Module Version](https://img.shields.io/hexpm/v/ecto_anon.svg)](https://hex.pm/packages/ecto_anon)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/ecto_anon/)
[![Total Download](https://img.shields.io/hexpm/dt/ecto_anon.svg)](https://hex.pm/packages/ecto_anon)
[![License](https://img.shields.io/hexpm/l/ecto_anon)](https://github.com/WTTJ/ecto_anon/blob/main/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/WTTJ/ecto_anon.svg)](https://github.com/WTTJ/ecto_anon/commits/main)

Simple way to handle data anonymization directly in your [Ecto](https://github.com/elixir-ecto/ecto) schemas

---

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Options](#options)
  - [Default values](#default-values)
  - [Native functions](#native-functions)
  - [Custom functions](#custom-functions)
  - [Migrations](#migrations)
  - [Filtering](#filtering)
- [License](#copyright-and-license)

# Installation

Add `:ecto_anon` to your `mix.exs` dependencies:

```elixir
def deps do
  [
    {:ecto_anon, "~> 0.6.0"}
  ]
end
```

# Usage

Define an `anon_schema` in your schema module and specify every fields you want to anonymize (regular fields, associations, embeds):

```elixir
defmodule User do
  use Ecto.Schema
  use EctoAnon.Schema

  anon_schema [
    :name,
    :email
  ]

  schema "users" do
    field :name, :string
    field :age, :integer
    field :email, :string

    anonymized()
  end
end
```

Then use `EctoAnon.run` to apply anonymization on desired resource

```elixir
user = Repo.get(User, id)
%User{name: "jane", age: 24, email: "jane@email.com"}

EctoAnon.run(user, Repo)
{:ok, %User{name: "redacted", age: 24, email: "redacted"}}
```

## Options

### `cascade`

When set to `true`, it allows `ecto_anon` to preload and anonymize
all associations (and associations of these associations) automatically in cascade.
Could be used to anonymize all data related to a struct in a single call.

Note that this won't traverse `belongs_to` associations.

Default: `false`

```elixir
defmodule User do
  use Ecto.Schema
  use EctoAnon.Schema

  anon_schema [
    :lastname,
    :email,
    :followers,
    :favorite_quote,
    :quotes,
    last_sign_in_at: [:anonymized_date, options: [:only_year]]
  ]

  schema "users" do
    field(:firstname, :string)
    field(:lastname, :string)
    field(:email, :string)
    field(:last_sign_in_at, :utc_datetime)

    has_many(:comments, Comment, foreign_key: :author_id, references: :id)
    embeds_one(:favorite_quote, Quote)
    embeds_many(:quotes, Quote)

    many_to_many(
      :followers,
      __MODULE__,
      join_through: Follower,
      join_keys: [follower_id: :id, followee_id: :id]
    )

    anonymized()
  end
end

defmodule Quote do
  use Ecto.Schema
  use EctoAnon.Schema

  anon_schema([
    :quote,
    :author
  ])

  embedded_schema do
    field(:quote, :string)
    field(:author, :string)
  end
end

defmodule Follower do
  use Ecto.Schema

  schema "followers" do
    field(:follower_id, :id)
    field(:followee_id, :id)
    timestamps()
  end
end
```

```elixir
Repo.get(User, id)
|> EctoAnon.run(Repo, cascade: true)

{:ok,
   %User{
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
   }
 }
```

### `log`

When set to `true`, it will set `anonymized` field accordingly when `EctoAnon.run` is called on a ressource.

Default: `true`

## Default values

By default, a field will be anonymized with those valuee, based on its type:

| type                | value                             |
| ------------------- | --------------------------------- |
| integer             | 0                                 |
| float               | 0.0                               |
| string              | redacted                          |
| map                 | %{}                               |
| decimal             | Decimal . new ( " 0.0 " )         |
| date                | ~D[ 1970-01-01 ]                  |
| datetime            | ~U[ 1970-01-01 00:00:00Z ]        |
| datetime_usec       | ~U[ 1970-01-01 00:00:00.000000Z ] |
| naive_datetime      | ~N[ 1970-01-01 00:00:00 ]         |
| naive_datetime_usec | ~N[ 1970-01-01 00:00:00.000000 ]  |
| time                | ~T[ 00:00:00 ]                    |
| time_usec           | ~T[ 00:00:00.000000 ]             |
| boolean             | no change                         |
| id                  | no change                         |
| binary_id           | no change                         |
| binary              | no change                         |

## Native functions

```elixir
anon_schema([
  email: :anonymized_email,
  birthdate: [:anonymized_date, options: [:only_year]]
])
```

Natively, `ecto_anon` embeds differents functions to suit your needs

| function          | role                                               | options    |
| ----------------- | -------------------------------------------------- | ---------- |
| :anonymized_date  | Anonymizes partially or completely a date/datetime | :only_year |
| :anonymized_email | Anonymizes partially or completely an email        | :partial   |
| :anonymized_phone | Anonymizes a phone number (currently only FR)      |            |
| :random_uuid      | Returns a random UUID                              |            |

## Custom functions

```elixir
anon_schema([
    address: &__MODULE__.anonymized_address/3
])

def anonymized_address(:map, %{} = address, _opts \\ []) do
  address
  |> Map.drop(["street"])
end
```

You can also pass custom functions with the following signature: `function(type, value, options)`

## Migrations

By importing `EctoAnon.Migration` in your ecto migration file, you can add an `anonymized()` macro that will generate an `anonymized` boolean field in your table:

```elixir
defmodule MyApp.Repo.Migrations.CreateUser do
  use Ecto.Migration
  import EctoAnon.Migration

  def change do
    create table(:users) do
      add :firstname, :string
      add :lastname, :string
      timestamps()
      anonymized()
    end
  end
end
```

Combined with `log` option when executing the anonymization, it will allow you to identify anonymized rows and exclude them in your queries with `EctoAnon.Query.not_anonymized/1`.

## Filtering

As you can create an [anonymized field in your migration](#migrations), you can add `anonymized()` in your schema, just like `timestamps()`.

By adding this field, you can use it to filter your resources and exclude anonymized data easily:

```elixir
import EctoAnon.Query
import Ecto.Query

from(u in User, select: u)
|> not_anonymized()
|> Repo.all()
```

# Copyright and License

_Copyright (c) 2022 CORUSCANT (Welcome to the Jungle) - https://www.welcometothejungle.com_

_This library is licensed under the [MIT](LICENSE.md)_
