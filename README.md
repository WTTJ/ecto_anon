<h1 align="center">
  <br>
  <strong>ecto_anon</strong>
  <br>
</h1>

<div align="center">
  <strong>Simple way to handle data anonymization directly in your Ecto schemas</strong>
</div>

---

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Migrations](#migrations)
  - [Options](#options)
- [Contributing](#contributing)
  - [Testing](#testing)
- [License](#license)

---

</br>

## Installation

Add `:ecto_anon` to your `mix.exs` dependencies:

```elixir
def deps do
  [
    {:ecto_anon, "~> 0.1.0"}
  ]
end
```

## Usage

Define an `anon_schema` with all fields you want to be anonymized in your schema module

```elixir
defmodule User do
  use Ecto.Schema
  use EctoAnon.Schema

  anon_schema [
    :email
  ]

  schema "users" do
    field :name, :string
    field :age, :integer
    field :email, :string
  end
end
```

Then use `EctoAnon.run` to apply anonymization on desired resource

```elixir
user = Repo.get(User, id)
%User{name: "jane", age: 0, email: "jane@email.com"}

EctoAnon.run(user, Repo)
{:ok, %User{name: "jane", age: 0, email: "redacted"}}
```

### Schema

Declare an `anon_schema` with all fields you want to anonymize (regular fields, associations, embeds)

```elixir
defmodule User do
  use Ecto.Schema
  use EctoAnon.Schema

  anon_schema [
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

By adding a [anonymized field in your migration](#migrations), you can add `anonymized()` in your schema just like `timestamps()`.

#### Default values

By default, a field will be anonymized with a default value based on its type

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

#### Native anonymization functions

Natively, `ecto_anon` embeds differents functions to suit your needs

| function          | role                                                                                                                         | options    |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------------- | ---------- |
| :anonymized_date  | Accepts all type of dates By default, returns default anonymized date With :only_year, will save only the year               | :only_year |
| :anonymized_email | Accepts string type By default, returns [hash]@[hash].com With :partial, returns [first_letter]xxxx@[first_letter]xxxx.[tld] | :partial   |
| :anonymized_phone | Accepts string type By default, returns xx xx xx xx xx                                                                       |            |
| :random_uuid      | Accepts string type By default, returns a random UUID                                                                        |            |

### Migrations

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

### Options

#### cascade

When set to `true`, allows ecto-anon to preload and anonymize
all associations (and associations of these associations) automatically in cascade.
Could be used to anonymize all data related a struct in a single call.
Note that this won't traverse `belongs_to` associations.

Default: `false`

#### log

When set to `true`, it will set `anonymized` field when EctoAnon.run
applies anonymization on a ressource.

Default: `true`

### License

TBD
